// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.Security.Access
{
    public interface IRoleResourceValidator
    {
        bool ValidateRequest(SecurityContext validationRequest);
    }

    public class RoleResourceValidator : IRoleResourceValidator
    {
        private readonly ICollection<IRoleResourceAccessValidator> _roleResourceAccessValidators;

        public RoleResourceValidator(ICollection<IRoleResourceAccessValidator> roleResourceAccessValidators)
        {
            _roleResourceAccessValidators = roleResourceAccessValidators;
        }

        public bool ValidateRequest(SecurityContext securityContext)
        {
            bool hasAccess = false;

            var validatorsThatApply = _roleResourceAccessValidators.Where(x => x.CanHandle(securityContext));

            if (!validatorsThatApply.Any())
                throw new NotImplementedException($"There is no implemented validator that can handle role: {securityContext.UserRoleAccessingResource} and resource: {securityContext.ResourceName}. Are you missing a validator?");

            foreach (var v in validatorsThatApply)
                if (v.CanAccess(securityContext))
                    hasAccess = true;

            return hasAccess;
        }
    }
}
