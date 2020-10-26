using Student1.ParentPortal.Data.Models.EdFi25;
using System;
using System.Linq;

namespace Student1.ParentPortal.Resources.Providers.Security.Access
{
    public class ParentCustomParametersAccessValidator : IRoleResourceAccessValidator
    {
        public bool CanHandle(SecurityContext securityContext)
        {
            return securityContext.UserRoleAccessingResource.Equals("parent", StringComparison.InvariantCultureIgnoreCase)
                && securityContext.ResourceName.Equals("customparameters", StringComparison.InvariantCultureIgnoreCase);
        }

        public bool CanAccess(SecurityContext securityContext)
        {
            // As of now this validator returns true because:
            // There is nothing to protect on the custom parameters. No sensitive data is being sent.
            return true;
        }
    }
}
