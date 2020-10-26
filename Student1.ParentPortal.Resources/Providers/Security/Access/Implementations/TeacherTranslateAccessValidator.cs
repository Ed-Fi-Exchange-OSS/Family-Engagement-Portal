using System;

namespace Student1.ParentPortal.Resources.Providers.Security.Access
{
    public class TeacherTranslateAccessValidator : IRoleResourceAccessValidator
    {
        public bool CanHandle(SecurityContext securityContext)
        {
            return securityContext.UserRoleAccessingResource.Equals("staff", StringComparison.InvariantCultureIgnoreCase)
                && securityContext.ResourceName.Equals("translate", StringComparison.InvariantCultureIgnoreCase);
        }

        public bool CanAccess(SecurityContext securityContext)
        {
            // No need to validate translations as of time this was written.
            return true;
        }
    }
}
