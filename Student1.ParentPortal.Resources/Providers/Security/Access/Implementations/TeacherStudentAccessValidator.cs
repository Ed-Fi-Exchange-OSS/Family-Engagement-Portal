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
            int studentUsi = 0;

            if (securityContext.ActionName == "AddStudentGoal" || securityContext.ActionName == "UpdateStudentGoal")
            {
                Student1.ParentPortal.Models.Student.StudentGoal aux = (Student1.ParentPortal.Models.Student.StudentGoal)securityContext.ActionParameters.FirstOrDefault().Value;
                studentUsi = aux.StudentUsi;
            }
            else if (securityContext.ActionName == "AddStudentAllAbout" || securityContext.ActionName == "UpdateStudentAllAbout")
            {
                Student1.ParentPortal.Models.Student.StudentAllAbout aux = (Student1.ParentPortal.Models.Student.StudentAllAbout)securityContext.ActionParameters.FirstOrDefault().Value;
                studentUsi = aux.StudentUsi;
            }
            else if (securityContext.ActionName == "UpdateStudentGoalIntervention")
            {
                Student1.ParentPortal.Models.Student.StudentGoalIntervention aux = (Student1.ParentPortal.Models.Student.StudentGoalIntervention)securityContext.ActionParameters.FirstOrDefault().Value;
                studentUsi = aux.StudentUsi;
            }
            else if (securityContext.ActionName == "StudentLabels" || securityContext.ActionName == "UpdateStudentGoalStep")
            {
                return true;
            }
            else
            {
                studentUsi = Convert.ToInt32(securityContext.ActionParameters.Single(x => x.Key == "id").Value);
            }
            
            var staffUsi = securityContext.UserUSIAccessingResource;            
            return _staffRepository.HasAccessToStudent(staffUsi,studentUsi);
        }
    }
}
