// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Linq;
using Student1.ParentPortal.Data.Models;

namespace Student1.ParentPortal.Resources.Providers.Security.Access
{
    public class ParentStudentAccessValidator : IRoleResourceAccessValidator
    {
        private readonly IParentRepository _parentRepository;

        public ParentStudentAccessValidator(IParentRepository parentRepository)
        {
            _parentRepository = parentRepository;
        }

        public bool CanHandle(SecurityContext securityContext)
        {
            return securityContext.UserRoleAccessingResource.Equals("parent", StringComparison.InvariantCultureIgnoreCase)
                && securityContext.ResourceName.Equals("students", StringComparison.InvariantCultureIgnoreCase);
        }

        public bool CanAccess(SecurityContext securityContext)
        {
            var studentUsi = Convert.ToInt32(securityContext.ActionParameters.Single(x => x.Key == "id").Value);
            var parentUsi = securityContext.UserUSIAccessingResource;

            // Only direct Student Parent Associations.
            return _parentRepository.HasAccessToStudent(parentUsi,studentUsi);
        }
    }
}
