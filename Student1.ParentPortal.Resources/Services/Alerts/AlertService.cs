// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Data.Models.EdFi25;
using Student1.ParentPortal.Models.Alert;
using Student1.ParentPortal.Resources.Providers.Alerts;
using Student1.ParentPortal.Resources.Providers.Configuration;
using Student1.ParentPortal.Resources.Providers.Messaging;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace Student1.ParentPortal.Resources.Services.Alerts
{
    public class AlertService : IAlertService
    {
        private readonly ICollection<IAlertProvider> _alertProviders;

        private readonly IAlertRepository _alertRepository;

        private readonly ICustomParametersProvider _customParametersProvider;

        public AlertService(ICollection<IAlertProvider> alertProviders, IAlertRepository alertRepository, ICustomParametersProvider customParametersProvider)
        {
            _alertProviders = alertProviders;
            _alertRepository = alertRepository;
            _customParametersProvider = customParametersProvider;
        }

        public async Task<ParentAlertTypeModel> GetParentAlertTypes(int usi)
        {
            var customParams = _customParametersProvider.GetParameters();
            var parentTypeAlerts = await _alertRepository.GetParentAlertTypes(usi);

            return parentTypeAlerts;

        }

        public async Task<ParentAlertTypeModel> SaveParentAlertTypes(ParentAlertTypeModel parentAlertTypes, int usi)
        {
            return await _alertRepository.SaveParentAlertTypes(parentAlertTypes, usi);
        }

        public async Task<List<ParentStudentAlertLogModel>> GetParentStudentUnreadAlerts(string parentUniqueId, string studentUniqueId)
        {
            return await _alertRepository.GetParentStudentUnreadAlerts(parentUniqueId, studentUniqueId);
        }

        public async Task ParentHasReadStudentAlerts(string parentUniqueId, string studentUniqueId)
        {
            await _alertRepository.ParentHasReadStudentAlerts(parentUniqueId, studentUniqueId);
        }
        public async Task SendAlerts()
        {
            // Logic followed is:
            // 1) Get alerts that have to be sent right now. (Do not duplicate alerts)
            // 2) Send alerts
            // 3) Log alerts sent so that we don't send them again

            // Types of Alerts:
            // -- Threshold alerts  (i.e. If my student goes over a threshold. Attendance > 5)
            // -- New entry (new entry for a discipline incident. New entry STAAR EoC Math score just posted. New Absences. New GPA posting. New Grade book entry: Math score your student got an A congrats!)
            // -- Scheduled alerts (I.e. Every Friday send me my student's missing assignments)
            // -- Global/Institutional alerts (alert all parents on something. i.e. School closed because weather alert)
            // -- Others...?

            //Note: For now only threshold is implemented
            // The main alerts implemented are:
            //   - Attendance absence count greater or equal to threshold
            //   - Behavior count greater or equal to threshold
            //   - Missing assignment count > 1
            //   - Assignment grade below threshold
            //   - Course grade below threshold

            //await SendAttendanceAlerts();
            foreach (var alertProvider in _alertProviders)
            {
                await alertProvider.SendAlerts();
            }
        }
    }
}
