// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using Student1.ParentPortal.Data.Models;
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
    public class CourseThresholdAlertProvider : IAlertProvider
    {
        private readonly IAlertRepository _alertRepository;
        private readonly ICustomParametersProvider _customParametersProvider;
        private readonly ITypesRepository _typesRepository;
        private readonly IMessagingProvider _messagingProvider;
        private readonly IUrlProvider _urlProvider;
        private readonly IImageProvider _imageUrlProvider;
        private readonly ISMSProvider _smsProvider;

        public CourseThresholdAlertProvider(IAlertRepository alertRepository, ICustomParametersProvider customParametersProvider, ITypesRepository typesRepository, IMessagingProvider messagingProvider, IUrlProvider urlProvider, IImageProvider imageUrlProvider, ISMSProvider smsProvider)
        {
            _alertRepository = alertRepository;
            _customParametersProvider = customParametersProvider;
            _messagingProvider = messagingProvider;
            _urlProvider = urlProvider;
            _imageUrlProvider = imageUrlProvider;
            _smsProvider = smsProvider;
            _typesRepository = typesRepository;
        }

        public async Task<int> SendAlerts()
        {
            var customParameters = _customParametersProvider.GetParameters();

            var alertTypes = await _typesRepository.GetAlertTypes();
            var alertCourse = alertTypes.Where(x => x.AlertTypeId == AlertTypeEnum.Course.Value).FirstOrDefault();

            var courseThreshold = alertCourse.Thresholds.Where(x => x.ThresholdTypeId == ThresholdTypeEnum.Course.Value).FirstOrDefault();

            var currentSchoolYear = await _alertRepository.getCurrentSchoolYear();

            // Find students that have surpassed the threshold.
            var studentsOverThreshold = await _alertRepository.studentsOverThresholdCourse(courseThreshold.ThresholdValue, customParameters.descriptors.gradeTypeGradingPeriodDescriptor);


            var alertCountSent = 0;

            // Send alerts to the parents of these students.
            foreach (var s in studentsOverThreshold)
            {
                var imageUrl = await _imageUrlProvider.GetStudentImageUrlForAlertsAsync(s.StudentUniqueId);
                // For each parent that wants to receive alerts
                foreach (var p in s.StudentParentAssociations)
                {
                    var parentAlert = p.Parent.ParentAlert;
                    var wasSentBefore = await _alertRepository.wasSentBefore(p.Parent.ParentUniqueId, s.StudentUniqueId, s.ValueCount.ToString(), currentSchoolYear, AlertTypeEnum.Course.Value);

                    if (parentAlert == null || parentAlert.AlertTypeIds == null || !parentAlert.AlertTypeIds.Contains(AlertTypeEnum.Course.Value) || wasSentBefore)
                        continue;

                    string to;
                    string template;

                    
                    if (parentAlert.PreferredMethodOfContactTypeId == MethodOfContactTypeEnum.SMS.Value && p.Parent.Telephone != null && p.Parent.SMSDomain != null)
                    {
                        to = p.Parent.Telephone + p.Parent.SMSDomain;
                        template = FillSMSTemplate(s);
                        await _smsProvider.SendMessageAsync(to, "Parent Portal: Course Alert", template);
                        alertCountSent++;
                    }
                    else if (p.Parent.Email != null)
                    {
                        to = p.Parent.Email;
                        template = FillEmailTemplate(s, courseThreshold, imageUrl);
                        await _messagingProvider.SendMessageAsync(to, null, null, "Parent Portal: Course Alert", template);
                        alertCountSent++;
                    }

                    // Save in log
                    await _alertRepository.AddAlertLog(currentSchoolYear, AlertTypeEnum.Course.Value, p.Parent.ParentUniqueId, s.StudentUniqueId, s.ValueCount.ToString());
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
            var filledTemplate = template.Replace("{{StudentAlertMessage}}", $"Your student has {s.ValueCount} grades below threshold.")
                                  .Replace("{{StudentFullName}}", $"{s.FirstName} {s.LastSurname}")
                                  .Replace("{{StudentLocalId}}", s.StudentUSI.ToString())
                                  .Replace("{{StudentImageUrl}}", imageUrl) 
                                  .Replace("{{MetricTitle}}", "")
                                  .Replace("{{MetricValue}}", $"{AddCoursesToMailTemplate(s.Courses)}")
                                  .Replace("{{StudentDetailUrl}}", _urlProvider.GetStudentDetailUrl(s.StudentUSI))
                                  .Replace("{{WhatCanParentDo}}", thresholdType.WhatCanParentDo);
            return filledTemplate;
        }

        private string AddCoursesToMailTemplate(ICollection<ParentAlertCourseModel> courses)
        {
            var s = String.Empty;
            s += "<ul>";
            foreach(var c in courses)
            {
                s += $"<li style='text-align:left'>{c.CourseTitle}: {c.GradeNumber}</li>";
            }
            s += "</ul>";
            return s;
        }

        private string AddCoursesToSMSTemplate(ICollection<ParentAlertCourseModel> courses)
        {
            var s = String.Empty;
            foreach (var c in courses)
            {
                s += $"\r\n - {c.CourseTitle}: {c.GradeNumber}";
            }
            return s;
        }

        private string FillSMSTemplate(StudentAlertModel s)
        {
            var template = loadSmsTemplate();
            var filledTemplate = template.Replace("{{AlertContent}}", $"has {s.ValueCount} grades below threshold:" + AddCoursesToSMSTemplate(s.Courses) +
                                        $"\r\nFor details visit the Parent Portal.")
                                  .Replace("{{StudentFullName}}", $"{s.FirstName} {s.LastSurname}");
            return filledTemplate;
        }
    }
}
