// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System.Threading.Tasks;
using Student1.ParentPortal.Data.Models;

namespace Student1.ParentPortal.Resources.Services.Application
{
    public interface IApplicationService {
        Task<bool> IsApplicationOfflineAsync();
    }

    public class ApplicationService : IApplicationService
    {
        private readonly IApplicationRepository _applicationRepository;

        public ApplicationService(IApplicationRepository applicationRepository)
        {
            _applicationRepository = applicationRepository;
        }

        public async Task<bool> IsApplicationOfflineAsync()
        {
            return await _applicationRepository.IsApplicationOffline();
        }
    }
}
