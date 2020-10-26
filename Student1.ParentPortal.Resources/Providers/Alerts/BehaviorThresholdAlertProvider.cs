using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Data.Models.EdFi25;
using Student1.ParentPortal.Models.Alert;
using Student1.ParentPortal.Models.Notifications;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Resources.Providers.Configuration;
using Student1.ParentPortal.Resources.Providers.Image;
using Student1.ParentPortal.Resources.Providers.Messaging;
using Student1.ParentPortal.Resources.Providers.Notifications;
using Student1.ParentPortal.Resources.Providers.Translation;
using Student1.ParentPortal.Resources.Providers.Url;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace Student1.ParentPortal.Resources.Providers.Alerts
{
    public class BehaviorThresholdAlertProvider : IAlertProvider
    {
        private readonly IAlertRepository _alertRepository;
        private readonly ICustomParametersProvider _customParametersProvider;
        private readonly ITypesRepository _typesRepository;
        private readonly IMessagingProvider _messagingProvider;
        private readonly IUrlProvider _urlProvider;
        private readonly ISMSProvider _smsProvider;
        private readonly IImageProvider _imageUrlProvider;
        private readonly IPushNotificationProvider _pushNotificationProvider;
        private readonly ITranslationProvider _translationProvider;

        public BehaviorThresholdAlertProvider(IAlertRepository alertRepository, 
                                              ICustomParametersProvider customParametersProvider,
                                              Data.Models.ITypesRepository typesRepository, 
                                              IMessagingProvider messagingProvider, 
                                              IUrlProvider urlProvider, 
                                              IImageProvider imageUrlProvider,
                                              ISMSProvider smsProvider, 
                                              IPushNotificationProvider pushNotificationProvider,
                                              ITranslationProvider translationProvider)
        {
            _alertRepository = alertRepository;
            _customParametersProvider = customParametersProvider;
            _messagingProvider = messagingProvider;
            _urlProvider = urlProvider;
            _imageUrlProvider = imageUrlProvider;
            _smsProvider = smsProvider;
            _typesRepository = typesRepository;
            _pushNotificationProvider = pushNotificationProvider;
            _translationProvider = translationProvider;
        }

        public async Task<int> SendAlerts()
        {
            var customParameters = _customParametersProvider.GetParameters();
            var enabledFeauter = customParameters.featureToggle.Select(x => x.features.Where(i => i.enabled && i.studentAbc != null)).FirstOrDefault().FirstOrDefault().studentAbc.behavior;
            if (!enabledFeauter)
                return 0;
            var alertTypes = await _typesRepository.GetAlertTypes();
            var alertBehavior = alertTypes.Where(x => x.AlertTypeId == AlertTypeEnum.Behavior.Value).FirstOrDefault();

            var behaviorThreshold = alertBehavior.Thresholds.Where(x => x.ThresholdTypeId == ThresholdTypeEnum.Behavior.Value).FirstOrDefault();

            var maxBehaviorThreshold = customParameters.behavior.maxDisciplineIncidentsCountThreshold;

            var currentSchoolYear = await _alertRepository.getCurrentSchoolYear();

            // Find students that have surpassed the threshold.
            var studentsOverThreshold = await _alertRepository.studentsOverThresholdBehavior(behaviorThreshold.ThresholdValue, customParameters.descriptors.disciplineIncidentDescriptor);


            var alertCountSent = 0;

            // Send alerts to the parents of these students.
            foreach (var s in studentsOverThreshold)
            {

                var imageUrl = await _imageUrlProvider.GetStudentImageUrlForAlertsAsync(s.StudentUniqueId);
                // For each parent that wants to receive alerts
                foreach (var p in s.StudentParentAssociations)
                {
                    var parentAlert = p.Parent.ParentAlert;
                    var wasSentBefore = await _alertRepository.wasSentBefore(p.Parent.ParentUniqueId, s.StudentUniqueId, s.ValueCount.ToString(), currentSchoolYear, AlertTypeEnum.Behavior.Value);
                    // If this parent doesn't have alerts configured skip.
                    if (parentAlert == null || parentAlert.AlertTypeIds == null || !parentAlert.AlertTypeIds.Contains(AlertTypeEnum.Behavior.Value) || wasSentBefore)
                        continue;

                    string to;
                    string template;
                    string subjectTemplate = "Family Portal: Behavior Alert";

                    if (parentAlert.PreferredMethodOfContactTypeId == MethodOfContactTypeEnum.SMS.Value && p.Parent.Telephone != null)
                    {
                        to = p.Parent.Telephone;
                        subjectTemplate = await TranslateText(p.Parent.LanguageCode, subjectTemplate);
                        template = FillSMSTemplate(s);
                        template = await TranslateText(p.Parent.LanguageCode, template);
                        await _smsProvider.SendMessageAsync(to, subjectTemplate, template);
                        alertCountSent++;
                    }
                    else if (parentAlert.PreferredMethodOfContactTypeId == MethodOfContactTypeEnum.Email.Value && p.Parent.Email != null)
                    {
                        to = p.Parent.Email;
                        subjectTemplate = await TranslateText(p.Parent.LanguageCode, subjectTemplate);
                        template = FillEmailTemplate(s, behaviorThreshold, imageUrl);
                        template = await TranslateText(p.Parent.LanguageCode, template);
                        await _messagingProvider.SendMessageAsync(to, null, null, subjectTemplate, template);
                        alertCountSent++;
                    }
                    else if (parentAlert.PreferredMethodOfContactTypeId == MethodOfContactTypeEnum.Notification.Value)
                    {
                        string pushNoSubjectTemplate = $"Behavior Alert: {s.FirstName} {s.LastSurname}";
                        string pushNoBodyTemplate = $"1 new discipline incident.";
                        pushNoSubjectTemplate = await TranslateText(p.Parent.LanguageCode, pushNoSubjectTemplate);
                        pushNoBodyTemplate = await TranslateText(p.Parent.LanguageCode, pushNoBodyTemplate);

                        await _pushNotificationProvider.SendNotificationAsync(new NotificationItemModel
                        {
                            personUniqueId = p.Parent.ParentUniqueId,
                            personType = "Parent",
                            notification = new Notification
                            {
                                title = pushNoSubjectTemplate,
                                body = pushNoBodyTemplate
                            }
                        });
                    }

                    // Save in log
                    await _alertRepository.AddAlertLog(currentSchoolYear, AlertTypeEnum.Behavior.Value, p.Parent.ParentUniqueId, s.StudentUniqueId, s.ValueCount.ToString());
                }
            }

            // Commit all log entries.
            await _alertRepository.SaveChanges();

            return alertCountSent;
        }

        private string loadEmailTemplate()
        {
            // Get alert template
            var pathToTemplate = HttpContext.Current.Server.MapPath("~/Templates/Email/AlertEmailTemplate.html");
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

        private string FillEmailTemplate(StudentAlertModel s, ThresholdTypeModel thresholdType, string imageUrl)
        {
            var template = loadEmailTemplate();
            var filledTemplate = template.Replace("{{StudentAlertMessage}}", $"Your student has {s.ValueCount} discipline incidents.")
                                  .Replace("{{StudentFullName}}", $"{s.FirstName} {s.LastSurname}")
                                  .Replace("{{StudentLocalId}}", s.StudentUSI.ToString())
                                  .Replace("{{StudentImageUrl}}", imageUrl)
                                  .Replace("{{MetricTitle}}", "Behavior at or above threshold")
                                  .Replace("{{MetricValue}}", $"{s.ValueCount}/{thresholdType.ThresholdValue}")
                                  .Replace("{{StudentDetailUrl}}", _urlProvider.GetStudentDetailUrl(s.StudentUSI))
                                  .Replace("{{WhatCanParentDo}}", thresholdType.WhatCanParentDo);
            return filledTemplate;
        }

        private string FillSMSTemplate(StudentAlertModel s)
        {
            var template = loadSmsTemplate();
            var filledTemplate = template.Replace("{{AlertContent}}", $"has a new discipline incident, for a total of {s.ValueCount}." +
                                        $"\r\nFor details visit the Parent Portal.")
                                  .Replace("{{StudentFullName}}", $"{s.FirstName} {s.LastSurname}");
            return filledTemplate;
        }

        private async Task<string> TranslateText(string languageCode, string template)
        {
            string textTranslated = string.Empty;
            if (!string.IsNullOrEmpty(languageCode) && languageCode != "en")
            {
                textTranslated = await _translationProvider.TranslateAsync(new TranslateRequest
                {
                    FromLangCode = "en",
                    TextToTranslate = template,
                    ToLangCode = languageCode
                });
            }
            else
                textTranslated = template;
            return textTranslated;
        }
    }
}
