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
