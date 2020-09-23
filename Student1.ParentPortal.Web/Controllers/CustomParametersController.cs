// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using Student1.ParentPortal.Resources.Providers.Configuration;
using System.Web.Http;

namespace Student1.ParentPortal.Web.Controllers
{
    public class CustomParametersController : ApiController
    {
        private readonly ICustomParametersProvider _customParametersProvider;

        public CustomParametersController(ICustomParametersProvider customParametersProvider)
        {
            _customParametersProvider = customParametersProvider;
        }

        // GET: api/CustomParameters
        public IHttpActionResult Get()
        {
            var model = _customParametersProvider.GetParameters();
            return Ok(model);
        }
    }
}
