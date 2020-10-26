using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.Security.Access.Implementations
{
    public class CampusLeaderAccessValidator : IRoleResourceAccessValidator
    {
        public bool CanAccess(SecurityContext securityContext)
        {
            return securityContext.UserRoleAccessingResource.Equals("CampusLeader", StringComparison.InvariantCultureIgnoreCase);
        }

        public bool CanHandle(SecurityContext securityContext)
        {
            return securityContext.UserRoleAccessingResource.Equals("CampusLeader", StringComparison.InvariantCultureIgnoreCase);
        }
    }
}
