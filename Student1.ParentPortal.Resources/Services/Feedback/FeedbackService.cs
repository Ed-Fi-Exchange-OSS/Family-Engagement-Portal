using Student1.ParentPortal.Resources.Providers.Image;
using Student1.ParentPortal.Resources.Services.Students;
using System.Collections.Generic;
using System.Threading.Tasks;
using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Models.User;
using System.Linq;
using Student1.ParentPortal.Resources.Providers.Configuration;
using Student1.ParentPortal.Resources.ExtensionMethods;
using System;
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Resources.Services.Communications;
using Student1.ParentPortal.Resources.Providers.Messaging;
using System.Configuration;
using System.Web;
using System.IO;

namespace Student1.ParentPortal.Resources.Services.Parents
{
    public interface IFeedbackService {
        Task<FeedbackLogModel> PersistFeedback(string uniqueId,int personTypeId, string firstName, string lastName, string email, FeedbackRequestModel model);
        Task<FeedbackLogModel> PersistFeedback(string uniqueId, int personTypeId, FeedbackRequestModel model);
    }

    public class FeedbackService : IFeedbackService
    {
        private readonly IFeedbackRepository _feedbackRepository;
        private readonly IStudentAttendanceService _studentAttendanceService;
        private readonly IStudentBehaviorService _studentBehaviorService;
        private readonly IStudentCourseGradesService _studentCourseGradesService;
        private readonly IImageProvider _imageProvider;
        private readonly IStudentAssignmentService _studentAssignmentService;
        private readonly ICustomParametersProvider _customParametersProvider;
        private readonly ICommunicationsService _communicationsService;
        private readonly IMessagingProvider _messagingProvider;

        public FeedbackService(IFeedbackRepository feedbackRepository, IStudentAttendanceService studentAttendanceService, IStudentBehaviorService studentBehaviorService, IStudentCourseGradesService studentCourseGradesService, IImageProvider imageProvider, IStudentAssignmentService studentAssignmentService, ICustomParametersProvider customParametersProvider, ICommunicationsService communicationsService, IMessagingProvider messagingProvider)
        {
            _feedbackRepository = feedbackRepository;
            _studentAttendanceService = studentAttendanceService;
            _studentBehaviorService = studentBehaviorService;
            _studentCourseGradesService = studentCourseGradesService;
            _imageProvider = imageProvider;
            _studentAssignmentService = studentAssignmentService;
            _customParametersProvider = customParametersProvider;
            _communicationsService = communicationsService;
            _messagingProvider = messagingProvider;
        }


        public async Task<FeedbackLogModel> PersistFeedback(string uniqueId, int personTypeId, string firstName, string lastName, string email, FeedbackRequestModel model)
        {
            var name = firstName + ' ' + lastName;
            var mails = ConfigurationManager.AppSettings["feedback.emails"].Split(';');
            var savedModel = await _feedbackRepository.SaveFeedback(uniqueId, personTypeId, name, email, model);

            var template = GenerateFeedbackTemplate(savedModel);

            await _messagingProvider.SendMessageAsync(mails, null, null, new []{email}, $"Family Portal Feedback: {model.Subject}", template);

            return savedModel;
        }

        public async Task<FeedbackLogModel> PersistFeedback(string uniqueId, int personTypeId, FeedbackRequestModel model)
        {
            var mails = ConfigurationManager.AppSettings["feedback.emails"].Split(';');
            var savedModel = await _feedbackRepository.SaveFeedback(uniqueId, personTypeId, model.Name, model.Email, model);

            var template = GenerateFeedbackTemplate(savedModel);

            await _messagingProvider.SendMessageAsync(mails, null, null, new[] { model.Email }, $"Family Portal Feedback: {model.Subject}", template);

            return savedModel;
        }

        private string GenerateFeedbackTemplate(FeedbackLogModel model)
        {
            var template = loadEmailTemplate();
            var personType = ChatLogPersonTypeEnum.GetAll().SingleOrDefault(x => x.Value == model.PersonTypeId).DisplayName;
            var filledTemplate = template.Replace("{{Issue}}", "Feedback: " + model.Issue)
                                         .Replace("{{Content}}", "<ul>" +
                                         $"<li>Name: {model.Name}</li>" +
                                         $"<li>Email: {model.Email}</li>" +
                                         $"<li>Current Url: {model.CurrentUrl}</li>" +
                                         $"<li>Subject: {model.Subject}</li>" +
                                         $"<li>Issue: {model.Issue}</li>" +
                                         $"<li>Person UniqueId: {model.PersonUniqueId}</li>" +
                                         $"<li>Person Type: {personType}</li>" +
                                         $"<li>Created Date: {model.CreatedDate}</li>" +
                                         $"<li>Detailed description: {model.Description}</li>" +
                                         "</ul>");
            return filledTemplate;
        }

        private string loadEmailTemplate()
        {
            // Get alert template
            var pathToTemplate = HttpContext.Current.Server.MapPath("~/Templates/Email/FeedbackEmailTemplate.html");
            var template = File.ReadAllText(pathToTemplate);

            return template;
        }
    }
}
