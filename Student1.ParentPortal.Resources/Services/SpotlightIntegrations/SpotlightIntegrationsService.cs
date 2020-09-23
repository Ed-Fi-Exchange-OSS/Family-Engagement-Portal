// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Resources.Providers.Image;

namespace Student1.ParentPortal.Resources.Services.Communications
{
    public interface ISpotlightIntegrationsService
    {
        Task<List<StudentExternalLink>> GetStudentExternalLinks(string studentUniqueId);
    }

    public class SpotlightIntegrationsService : ISpotlightIntegrationsService
    {
        private readonly ISpotlightIntegrationRepository _spotlightIntegrationRepository;

        public SpotlightIntegrationsService(ISpotlightIntegrationRepository spotlightIntegrationRepository)
        {
            _spotlightIntegrationRepository = spotlightIntegrationRepository;
        }

        public async Task<List<StudentExternalLink>> GetStudentExternalLinks(string studentUniqueId)
        {
            return await  _spotlightIntegrationRepository.GetStudentExternalLinks(studentUniqueId);
        }
    }
}
