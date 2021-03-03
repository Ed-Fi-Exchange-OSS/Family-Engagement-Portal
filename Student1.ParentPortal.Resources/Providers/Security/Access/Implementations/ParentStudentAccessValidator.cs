using System;
using System.Linq;
using Student1.ParentPortal.Data.Models;

namespace Student1.ParentPortal.Resources.Providers.Security.Access
{
    public class ParentStudentAccessValidator : IRoleResourceAccessValidator
    {
        private readonly IParentRepository _parentRepository;

        public ParentStudentAccessValidator(IParentRepository parentRepository)
        {
            _parentRepository = parentRepository;
        }

        public bool CanHandle(SecurityContext securityContext)
        {
            return securityContext.UserRoleAccessingResource.Equals("parent", StringComparison.InvariantCultureIgnoreCase)
                && securityContext.ResourceName.Equals("students", StringComparison.InvariantCultureIgnoreCase);
        }

        public bool CanAccess(SecurityContext securityContext)
        {
            if (securityContext.ActionName.Equals("StudentLabels", StringComparison.InvariantCultureIgnoreCase)
                || securityContext.ActionName.Equals("UpdateStudentGoalStep", StringComparison.InvariantCultureIgnoreCase) 
                || securityContext.ActionName.Equals("AddStudentGoal", StringComparison.InvariantCultureIgnoreCase)
                )
            {
                return true;
            }

            var studentUsi = Convert.ToInt32(securityContext.ActionParameters.Single(x => x.Key == "id").Value);
            var parentUsi = securityContext.UserUSIAccessingResource;

            // Only direct Student Parent Associations.
            return _parentRepository.HasAccessToStudent(parentUsi,studentUsi);
        }
    }
}
