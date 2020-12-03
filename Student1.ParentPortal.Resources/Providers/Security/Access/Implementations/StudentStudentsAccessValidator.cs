using System;

namespace Student1.ParentPortal.Resources.Providers.Security.Access
{
    public class StudentStudentsAccessValidator : IRoleResourceAccessValidator
    {
        public bool CanHandle(SecurityContext securityContext)
        {
            return securityContext.UserRoleAccessingResource.Equals("student", StringComparison.InvariantCultureIgnoreCase)
                && securityContext.ResourceName.Equals("students", StringComparison.InvariantCultureIgnoreCase);
        }

        public bool CanAccess(SecurityContext securityContext)
        {
            // As of now this validator returns true because:
            // The simplistic design of this application does not require further complexity
            // All data requests to get students have primary relationship joins to the studentUsi who requested.
            // There is no implementation or requirement for students looking at himself.
            return true;
        }
    }
}
