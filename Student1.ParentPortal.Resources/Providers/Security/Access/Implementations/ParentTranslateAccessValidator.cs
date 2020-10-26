using System;

namespace Student1.ParentPortal.Resources.Providers.Security.Access
{
    public class ParentTranslateAccessValidator : IRoleResourceAccessValidator
    {
        public bool CanHandle(SecurityContext securityContext)
        {
            return securityContext.UserRoleAccessingResource.Equals("parent", StringComparison.InvariantCultureIgnoreCase)
                && securityContext.ResourceName.Equals("translate", StringComparison.InvariantCultureIgnoreCase);
        }

        public bool CanAccess(SecurityContext securityContext)
        {
            // No need to validate translations as of time this was written.
            return true;
        }
    }
}
