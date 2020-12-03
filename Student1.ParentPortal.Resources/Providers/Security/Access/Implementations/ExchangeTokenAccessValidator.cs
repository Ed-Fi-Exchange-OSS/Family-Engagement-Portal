using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.Security.Access.Implementations
{
    public class ExchangeTokenAccessValidator : IRoleResourceAccessValidator
    {
        public bool CanAccess(SecurityContext securityContext)
        {
            return true;
        }

        public bool CanHandle(SecurityContext securityContext)
        {
            return securityContext.ResourceName.Equals("OAuth", StringComparison.InvariantCultureIgnoreCase);
        }
    }
}
