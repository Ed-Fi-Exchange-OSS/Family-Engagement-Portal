using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.Security.Access.Implementations
{
    public class ParentNotificationsAccessValidator : IRoleResourceAccessValidator
    {
        public bool CanAccess(SecurityContext securityContext)
        {
            return true;
        }

        public bool CanHandle(SecurityContext securityContext)
        {
            return securityContext.UserRoleAccessingResource.Equals("parent", StringComparison.InvariantCultureIgnoreCase)
                 && securityContext.ResourceName.Equals("notifications", StringComparison.InvariantCultureIgnoreCase);
        }
    }
}
