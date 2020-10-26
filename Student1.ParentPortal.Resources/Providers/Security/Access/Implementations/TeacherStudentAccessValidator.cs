using Student1.ParentPortal.Data.Models.EdFi25;
using System;
using System.Linq;
using Student1.ParentPortal.Data.Models;

namespace Student1.ParentPortal.Resources.Providers.Security.Access
{
    public class TeacherStudentAccessValidator : IRoleResourceAccessValidator
    {
        private readonly IStaffRepository _staffRepository;

        public TeacherStudentAccessValidator(IStaffRepository staffRepository)
        {
            _staffRepository = staffRepository;
        }

        public bool CanHandle(SecurityContext securityContext)
        {
            return securityContext.UserRoleAccessingResource.Equals("staff", StringComparison.InvariantCultureIgnoreCase)
                && securityContext.ResourceName.Equals("students", StringComparison.InvariantCultureIgnoreCase);
        }

        public bool CanAccess(SecurityContext securityContext)
        {
            var studentUsi = Convert.ToInt32(securityContext.ActionParameters.Single(x => x.Key == "id").Value);
            var staffUsi = securityContext.UserUSIAccessingResource;
            
            return _staffRepository.HasAccessToStudent(staffUsi,studentUsi);
        }
    }
}
