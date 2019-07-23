using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Models.Alert;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Resources.Providers.Configuration;
using Student1.ParentPortal.Resources.Providers.Image;
using Student1.ParentPortal.Resources.Providers.Messaging;
using Student1.ParentPortal.Resources.Providers.Url;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace Student1.ParentPortal.Resources.Providers.Alerts
{
    public class UnreadMessagesAlertProvider : IAlertProvider
    {
        private readonly IAlertRepository _alertRepository;
        private readonly ICustomParametersProvider _customParametersProvider;
        private readonly ITypesRepository _typesRepository;
        private readonly IMessagingProvider _messagingProvider;
        private readonly IUrlProvider _urlProvider;
        private readonly IImageProvider _imageProvider;
        private readonly ISMSProvider _smsProvider;

        public UnreadMessagesAlertProvider(IAlertRepository alertRepository, ICustomParametersProvider customParametersProvider, ITypesRepository typesRepository, IMessagingProvider messagingProvider, IUrlProvider urlProvider, IImageProvider imageProvider, ISMSProvider smsProvider)
        {
            _alertRepository = alertRepository;
            _customParametersProvider = customParametersProvider;
            _messagingProvider = messagingProvider;
            _urlProvider = urlProvider;
            _imageProvider = imageProvider;
            _smsProvider = smsProvider;
            _typesRepository = typesRepository;
        }

        public async Task<int> SendAlerts()
        {
            var customParameters = _customParametersProvider.GetParameters();

            var alertTypes = await _typesRepository.GetAlertTypes();
            var alertAssignment = alertTypes.Where(x => x.AlertTypeId == AlertTypeEnum.Message.Value).FirstOrDefault();

            var currentSchoolYear = await _alertRepository.getCurrentSchoolYear();

            // Find students that have surpassed the threshold.
            var parentsAndStaffWithUnreadMessages = await _alertRepository.ParentsAndStaffWithUnreadMessages();

            var alertCountSent = 0;

            // Send alerts to the parents of these students.
            foreach (var p in parentsAndStaffWithUnreadMessages)
            {

                if (p.AlertTypeIds == null || !p.AlertTypeIds.Contains(AlertTypeEnum.Message.Value))
                        continue;

                    string to;
                    string template;

                   
                    if (p.PreferredMethodOfContactTypeId == MethodOfContactTypeEnum.SMS.Value && p.Telephone != null && p.SMSDomain != null)
                    {
                        to = p.Telephone + p.SMSDomain;
                        template = FillSMSTemplate(p);
                        await _smsProvider.SendMessageAsync(to, "Parent Portal: Unread Messages Alert", template);
                        alertCountSent++;
                    }
                    else if (p.Email != null)
                    {
                        to = p.Email;
                        template = FillEmailTemplate(p);
                        await _messagingProvider.SendMessageAsync(to, null, null, "Parent Portal: Unread Messages Alert", template);
                        alertCountSent++;
                    }

            }

            // Commit all log entries.
            await _alertRepository.SaveChanges();

            return alertCountSent;
        }

        private string loadEmailTemplate()
        {
            // Get alert template
            var pathToTemplate = HttpContext.Current.Server.MapPath("~/Templates/Email/UnreadMessageAlertEmailTemplate.html");
            var template = File.ReadAllText(pathToTemplate);

            return template;
        }

        private string loadSmsTemplate()
        {
            // Get alert template
            var pathToTemplate = HttpContext.Current.Server.MapPath("~/Templates/SMS/AlertSMSTemplate.txt");
            var template = File.ReadAllText(pathToTemplate);

            return template;
        }

        private string FillEmailTemplate(UnreadMessageAlertModel u)
        {
            var template = loadEmailTemplate();
            var filledTemplate = template.Replace("{{AlertMessage}}", $"You have {u.UnreadMessageCount} unread messages.")
                                  .Replace("{{LoginUrl}}", _urlProvider.GetLoginUrl());
            return filledTemplate;
        }

        private string FillSMSTemplate(UnreadMessageAlertModel u)
        {
            var template = loadSmsTemplate();
            var filledTemplate = template.Replace("{{AlertContent}}", $"you have {u.UnreadMessageCount} unread messages." +
                                        $"\r\nFor details visit the Parent Portal.")
                                  .Replace("{{StudentFullName}}", $"{u.FirstName} {u.LastSurname}");
            return filledTemplate;
        }
    }
}
