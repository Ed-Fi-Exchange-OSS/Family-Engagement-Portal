using System;

namespace Student1.ParentPortal.Resources.Providers.Security.Access
{
    public class TeacherTeachersAccessValidator : IRoleResourceAccessValidator
    {
        public bool CanHandle(SecurityContext securityContext)
        {
            return securityContext.UserRoleAccessingResource.Equals("staff", StringComparison.InvariantCultureIgnoreCase)
                && securityContext.ResourceName.Equals("teachers", StringComparison.InvariantCultureIgnoreCase);
        }

        public bool CanAccess(SecurityContext securityContext)
        {
            // As of now this validator returns true because:
            // The simplistic design of this application does not require further complexity
            // This validator for a Staff looking at the Teacher resource which is it self.
            // There is no parameter to validate.
            // All data requests to get students have primary relationship joins to the staffUSI and/or teacherUSI who requested.
            // There is no implementation or requirement for Staff looking at other staff.
            return true;
        }
    }
}
