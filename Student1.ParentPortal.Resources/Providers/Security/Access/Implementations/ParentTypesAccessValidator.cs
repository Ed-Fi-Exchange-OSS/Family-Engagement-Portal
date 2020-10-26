using System;

namespace Student1.ParentPortal.Resources.Providers.Security.Access
{
    public class ParentTypesAccessValidator : IRoleResourceAccessValidator
    {
        public bool CanHandle(SecurityContext securityContext)
        {
            return securityContext.UserRoleAccessingResource.Equals("parent", StringComparison.InvariantCultureIgnoreCase)
                && securityContext.ResourceName.Equals("types", StringComparison.InvariantCultureIgnoreCase);
        }

        public bool CanAccess(SecurityContext securityContext)
        {
            // As of now this validator returns true because:
            // Access to Types does not require authorization
            return true;
        }
    }
}
