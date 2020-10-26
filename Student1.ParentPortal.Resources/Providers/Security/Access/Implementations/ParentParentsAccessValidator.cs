using System;

namespace Student1.ParentPortal.Resources.Providers.Security.Access
{
    public class ParentParentsAccessValidator : IRoleResourceAccessValidator
    {
        public bool CanHandle(SecurityContext securityContext)
        {
            return securityContext.UserRoleAccessingResource.Equals("parent", StringComparison.InvariantCultureIgnoreCase)
                && securityContext.ResourceName.Equals("parents", StringComparison.InvariantCultureIgnoreCase);
        }

        public bool CanAccess(SecurityContext securityContext)
        {
            // As of now this validator returns true because:
            // The simplistic design of this application does not require further complexity
            // All data requests to get students have primary relationship joins to the parentUSI who requested.
            // There is no implementation or requirement for parents looking at other parents.
            return true;
        }
    }
}
