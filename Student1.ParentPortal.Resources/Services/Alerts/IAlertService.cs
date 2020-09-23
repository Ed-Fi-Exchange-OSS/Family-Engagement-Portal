// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using Student1.ParentPortal.Models.Alert;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Services.Alerts
{
    public interface IAlertService
    {
        Task SendAlerts();
        Task<ParentAlertTypeModel> GetParentAlertTypes(int usi);
        Task<ParentAlertTypeModel> SaveParentAlertTypes(ParentAlertTypeModel parentAlertTypes, int usi);
        Task<List<ParentStudentAlertLogModel>> GetParentStudentUnreadAlerts(string parentUniqueId, string studentUniqueId);
        Task ParentHasReadStudentAlerts(string parentUniqueId, string studentUniqueId);
    }
}