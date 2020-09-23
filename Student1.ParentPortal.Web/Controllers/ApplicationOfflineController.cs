// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Management;
using Student1.ParentPortal.Resources.Services.Application;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/ApplicationOffline")]
    public class ApplicationOfflineController : ApiController
    {
        private readonly IApplicationService _applicationService;

        public ApplicationOfflineController(IApplicationService applicationService)
        {
            _applicationService = applicationService;
        }

        [AllowAnonymous]
        [HttpGet]
        public async Task<IHttpActionResult> Get()
        {
            var model = await _applicationService.IsApplicationOfflineAsync();
            return Ok(model);
        }
    }
}