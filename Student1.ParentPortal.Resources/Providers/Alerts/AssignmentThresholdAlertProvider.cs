﻿using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Data.Models.EdFi25;
using Student1.ParentPortal.Models.Alert;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Resources.Providers.Configuration;
using Student1.ParentPortal.Resources.Providers.Image;
using Student1.ParentPortal.Resources.Providers.Messaging;
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
    public class AssignmentThresholdAlertProvider : IAlertProvider
    {
        private readonly IAlertRepository _alertRepository;
        private readonly ICustomParametersProvider _customParametersProvider;
        private readonly ITypesRepository _typesRepository;
        private readonly IMessagingProvider _messagingProvider;
        private readonly IUrlProvider _urlProvider;
        private readonly IImageProvider _imageProvider;
        private readonly ISMSProvider _smsProvider;

        public AssignmentThresholdAlertProvider(IAlertRepository alertRepository, ICustomParametersProvider customParametersProvider, ITypesRepository typesRepository, IMessagingProvider messagingProvider, IUrlProvider urlProvider, IImageProvider imageProvider, ISMSProvider smsProvider)
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
            var alertAssignment = alertTypes.Where(x => x.AlertTypeId == AlertTypeEnum.Assignment.Value).FirstOrDefault();

            var assignmentThreshold = alertAssignment.Thresholds.Where(x => x.ThresholdTypeId == ThresholdTypeEnum.Assignment.Value).FirstOrDefault();

            var currentSchoolYear = await _alertRepository.getCurrentSchoolYear();

            // Find students that have surpassed the threshold.
            var studentsOverThreshold = await _alertRepository.studentsOverThresholdAssignment(assignmentThreshold.ThresholdValue, customParameters.descriptors.gradeBookMissingAssignmentTypeDescriptors);

            var alertCountSent = 0;

            // Send alerts to the parents of these students.
            foreach (var s in studentsOverThreshold)
            {
                var imageUrl = await _imageProvider.GetStudentImageUrlForAlertsAsync(s.StudentUniqueId);
                // For each parent that wants to receive alerts
                foreach (var p in s.StudentParentAssociations)
                {
                    var parentAlert = p.Parent.ParentAlert;
                    var wasSentBefore = await _alertRepository.wasSentBefore(p.Parent.ParentUniqueId, s.StudentUniqueId, s.ValueCount.ToString(), currentSchoolYear, AlertTypeEnum.Assignment.Value);

                    if (parentAlert == null || parentAlert.AlertTypeIds == null || !parentAlert.AlertTypeIds.Contains(AlertTypeEnum.Assignment.Value) || wasSentBefore)
                        continue;

                    string to;
                    string template;

                    
                    if (parentAlert.PreferredMethodOfContactTypeId == MethodOfContactTypeEnum.SMS.Value && p.Parent.Telephone != null && p.Parent.SMSDomain != null)
                    {
                        to = p.Parent.Telephone + p.Parent.SMSDomain;
                        template = FillSMSTemplate(s);
                        await _smsProvider.SendMessageAsync(to, "Parent Portal: Missing Assignment Alert", template);
                        alertCountSent++;
                    }
                    else if (p.Parent.Email != null)
                    {
                        to = p.Parent.Email;
                        template = FillEmailTemplate(s, assignmentThreshold, imageUrl);
                        await _messagingProvider.SendMessageAsync(to, null, null, "Parent Portal: Missing Assignment Alert", template);
                        alertCountSent++;
                    }

                    // Save in log
                    await _alertRepository.AddAlertLog(currentSchoolYear, AlertTypeEnum.Assignment.Value, p.Parent.ParentUniqueId, s.StudentUniqueId, s.ValueCount.ToString());
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
            var filledTemplate = template.Replace("{{StudentAlertMessage}}", $"Your student has {s.ValueCount} missing assignments.")
                                  .Replace("{{StudentFullName}}", $"{s.FirstName} {s.LastSurname}")
                                  .Replace("{{StudentLocalId}}", s.StudentUSI.ToString())
                                  .Replace("{{StudentImageUrl}}", imageUrl)
                                  .Replace("{{MetricTitle}}", "Missing Assignments at or above threshold")
                                  .Replace("{{MetricValue}}", $"{s.ValueCount}/{thresholdType.ThresholdValue}")
                                  .Replace("{{StudentDetailUrl}}", _urlProvider.GetStudentDetailUrl(s.StudentUSI))
                                  .Replace("{{WhatCanParentDo}}", thresholdType.WhatCanParentDo);
            return filledTemplate;
        }

        private string FillSMSTemplate(StudentAlertModel s)
        {
            var template = loadSmsTemplate();
            var filledTemplate = template.Replace("{{AlertContent}}", $"has a new missing assignment, for a total of {s.ValueCount}." +
                                        $"\r\nFor details visit the Parent Portal.")
                                  .Replace("{{StudentFullName}}", $"{s.FirstName} {s.LastSurname}");
            return filledTemplate;
        }
    }
}
