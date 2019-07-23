
using Student1.ParentPortal.Models.Alert;
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Models.Types;
using Student1.ParentPortal.Models.User;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Data.Models
{
    public interface ISpotlightIntegrationRepository
    {
        Task<List<StudentExternalLink>> GetStudentExternalLinks(string studentUniqueId);
    }
}
