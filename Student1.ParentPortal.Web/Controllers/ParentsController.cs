// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System.Threading.Tasks;
using System.Web.Http;
using Student1.ParentPortal.Resources.Services.Parents;
using Student1.ParentPortal.Web.Security;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/parents")]
    public class ParentsController : ApiController
    {
        private readonly IParentsService _parentssService;

        public ParentsController(IParentsService parentService)
        {
            _parentssService = parentService;
        }

        [Route("students")]
        [HttpGet]
        public async Task<IHttpActionResult> GetStudentsAssociatedWithParent()
        {
            var parent = SecurityPrincipal.Current;
            var model = await _parentssService.GetStudentsAssociatedWithParentAsync(parent.PersonUSI, parent.PersonUniqueId, parent.PersonTypeId);

            if (model == null)
                return NotFound();

            return Ok(model);
        }
    }
}
