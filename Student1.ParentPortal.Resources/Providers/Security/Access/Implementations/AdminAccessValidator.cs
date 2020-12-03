using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.Security.Access.Implementations
{
    public class AdminAccessValidator : IRoleResourceAccessValidator
    {
        public bool CanAccess(SecurityContext securityContext)
        {
            return true;
        }

        public bool CanHandle(SecurityContext securityContext)
        {
            if (securityContext.UserRoleAccessingResource.Equals("Admin", StringComparison.InvariantCultureIgnoreCase) &&
                securityContext.ResourceName.Equals("Admin", StringComparison.InvariantCultureIgnoreCase) &&
                securityContext.ActionName.Equals("SaveStudentDetailFeatures", StringComparison.InvariantCultureIgnoreCase))
                return true;

            if (securityContext.ResourceName.Equals("Admin", StringComparison.InvariantCultureIgnoreCase) &&
                securityContext.ActionName.Equals("GetStudentDetailFeatures", StringComparison.InvariantCultureIgnoreCase))
                return true;

            return false;
        }
    }
}
