using Student1.ParentPortal.Data.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.Security.Access.Implementations
{
    public class OAuthAccessValidator : IRoleResourceAccessValidator
    {
        private readonly IAdminRepository _adminRepository;
        public OAuthAccessValidator(IAdminRepository adminRepository) 
        {
            _adminRepository = adminRepository;
        }
        public bool CanAccess(SecurityContext securityContext)
        {
            return securityContext.UserRoleAccessingResource.Equals("Admin", StringComparison.InvariantCultureIgnoreCase);
        }

        public bool CanHandle(SecurityContext securityContext)
        {
            return securityContext.UserRoleAccessingResource.Equals("Admin", StringComparison.InvariantCultureIgnoreCase);
        }
    }
}
