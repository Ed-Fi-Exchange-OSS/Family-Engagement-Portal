using System;

namespace Student1.ParentPortal.Resources.Providers.Security.Access
{
    public class TeacherFeedbackAccessValidator : IRoleResourceAccessValidator
    {
        public bool CanHandle(SecurityContext securityContext)
        {
            return securityContext.UserRoleAccessingResource.Equals("staff", StringComparison.InvariantCultureIgnoreCase)
                && securityContext.ResourceName.Equals("feedback", StringComparison.InvariantCultureIgnoreCase);
        }

        public bool CanAccess(SecurityContext securityContext)
        {
            // As of now this validator returns true because:
            // The simplistic design of this application does not require further complexity
            // This validator if for a Staff looking at the Me resource which is it self.
            // A staff can see its own role information based on the current principal.
            // There is no parameter to validate.
            return true;
        }
    }
}
