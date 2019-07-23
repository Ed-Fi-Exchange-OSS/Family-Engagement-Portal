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
using System.Net.Http;
using Student1.ParentPortal.Resources.Services.Alerts;

namespace Student1.ParentPortal.Resources.Services.Parents
{
    public interface IParentsService {
        Task<List<StudentBriefModel>> GetStudentsAssociatedWithParentAsync(int parentUsi, string recipientUniqueId, int recipientTypeId);
        Task<UserProfileModel> GetParentProfileAsync(int parentUsi);
        Task<BriefProfileModel> GetBriefParentProfileAsync(int parentUsi);
        Task<UserProfileModel> SaveParentProfileAsync(int parentUsi, UserProfileModel model);
        Task UploadParentImageAsync(string parentUniqueId, byte[] image, string contentType);
    }

    public class ParentsService : IParentsService
    {
        private readonly IParentRepository _parentRepository;
        private readonly IStudentAttendanceService _studentAttendanceService;
        private readonly IStudentBehaviorService _studentBehaviorService;
        private readonly IStudentCourseGradesService _studentCourseGradesService;
        private readonly IImageProvider _imageProvider;
        private readonly IStudentAssignmentService _studentAssignmentService;
        private readonly ICustomParametersProvider _customParametersProvider;
        private readonly ICommunicationsService _communicationsService;
        private readonly IMessagingProvider _messagingProvider;
        private readonly ISpotlightIntegrationsService _spotlightIntegrationsService;
        private readonly IAlertService _alertService;
        private readonly IStudentsService _studentsService;

        public ParentsService(IParentRepository parentRepository, IStudentAttendanceService studentAttendanceService, IStudentBehaviorService studentBehaviorService, IStudentCourseGradesService studentCourseGradesService, IImageProvider imageProvider, IStudentAssignmentService studentAssignmentService, ICustomParametersProvider customParametersProvider, ICommunicationsService communicationsService, IMessagingProvider messagingProvider, ISpotlightIntegrationsService spotlightIntegrationsService, IAlertService alertService, IStudentsService studentsService)
        {
            _parentRepository = parentRepository;
            _studentAttendanceService = studentAttendanceService;
            _studentBehaviorService = studentBehaviorService;
            _studentCourseGradesService = studentCourseGradesService;
            _imageProvider = imageProvider;
            _studentAssignmentService = studentAssignmentService;
            _customParametersProvider = customParametersProvider;
            _communicationsService = communicationsService;
            _messagingProvider = messagingProvider;
            _spotlightIntegrationsService = spotlightIntegrationsService;
            _alertService = alertService;
            _studentsService = studentsService;
        }

        public async Task<List<StudentBriefModel>> GetStudentsAssociatedWithParentAsync(int parentUsi, string recipientUniqueId, int recipientTypeId)
        {
            var studentsAssociatedWithParent = await _parentRepository.GetStudentsAssociatedWithParent(parentUsi, recipientUniqueId, recipientTypeId);

            var studentsSummary = await _studentsService.GetStudentsSummary(studentsAssociatedWithParent.Select(x => x.StudentUsi).ToList());

            // Get other calculated fields.
            foreach (var student in studentsAssociatedWithParent)
            {

                var summary = studentsSummary.Find(x => x.StudentUsi == student.StudentUsi);

                student.StudentUniqueId = summary.StudentUniqueId;
                student.FirstName = summary.FirstName;
                student.MiddleName = summary.MiddleName;
                student.LastSurname = summary.LastSurname;
                student.GradeLevel = summary.GradeLevel;
                student.SexType = summary.SexType;
                student.YTDGPA = summary.Gpa;
                student.GPAInterpretation = summary.GpaInterpretation;
                student.AbsenceThresholdDays = _customParametersProvider.GetParameters().attendance.ADA.maxAbsencesCountThreshold;
                student.AdaAbsences = summary.AbsenceCount;
                student.AdaAbsentInterpretation = summary.AbsenceInterpretation;
                student.YTDDisciplineIncidentCount = summary.DisciplineIncidentCount;
                student.YTDDisciplineInterpretation = summary.DisciplineIncidentInterpretation;

                //student.ExcusedAbsences = attendance.ExcusedAttendanceEvents.Count();
                //student.ExcusedInterpretation = attendance.ExcusedInterpretation;
                //student.UnexcusedAbsences = attendance.UnexcusedAttendanceEvents.Count();
                //student.UnexcusedInterpretation = attendance.UnexcusedInterpretation;
                //student.TardyAbsences = attendance.TardyAttendanceEvents.Count();
                //student.TardyInterpretation = attendance.TardyInterpretation;

                student.MissingAssignments = summary.MissingassignmentCount;
                student.MissingAssignmentsInterpretation = summary.MissingAssigmentInterpretation;

                student.CourseAverage = new StudentCurrentGradeAverage { Evaluation = summary.CourseAverageInterpretation, GradeAverage = summary.CourseAverage };
                student.ImageUrl = await _imageProvider.GetStudentImageUrlAsync(student.StudentUniqueId);
                student.CourseAverage = new StudentCurrentGradeAverage { Evaluation = summary.CourseAverageInterpretation, GradeAverage = summary.CourseAverage };
                student.Alerts = await _alertService.GetParentStudentUnreadAlerts(recipientUniqueId, student.StudentUniqueId);
            }

            return studentsAssociatedWithParent;
        }
        
        public async Task<UserProfileModel> GetParentProfileAsync(int parentUsi)
        {
            var model = await _parentRepository.GetParentProfileAsync(parentUsi);
            model.ImageUrl = await _imageProvider.GetParentImageUrlAsync(model.UniqueId);
            return model;
        }

        public async Task<BriefProfileModel> GetBriefParentProfileAsync(int parentUsi)
        {
            var model = await _parentRepository.GetBriefParentProfileAsync(parentUsi);
            model.ImageUrl = await _imageProvider.GetParentImageUrlAsync(model.UniqueId);
            model.FeedbackExternalUrl = _customParametersProvider.GetParameters().feedbackExternalUrl;
            return model;
        }

        public async Task<UserProfileModel> SaveParentProfileAsync(int parentUsi, UserProfileModel model)
        {
            var response = await _parentRepository.SaveParentProfileAsync(parentUsi, model);
            response.ImageUrl = await _imageProvider.GetParentImageUrlAsync(model.UniqueId);
            return response;
        }

        private string InterpretMissingAssignmentCount(int missingAssignmentsCount)
        {
            return _customParametersProvider.GetParameters().assignments.thresholdRules.GetRuleThatApplies(missingAssignmentsCount).interpretation;
        }

        public async Task UploadParentImageAsync(string parentUniqueId, byte[] image, string contentType)
        {
            await _imageProvider.UploadParentImageAsync(parentUniqueId, image, contentType);
        }

        private string InterpretGPA(decimal gpa)
        {
            return _customParametersProvider.GetParameters()
                            .courseGrades.gpa.thresholdRules
                            .GetRuleThatApplies(gpa).interpretation;
        }
    }
}
