using System.Collections.Generic;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Models.User;

namespace Student1.ParentPortal.Data.Models
{
    public interface IStaffRepository
    {
        Task<List<PersonIdentityModel>> GetStaffIdentityByEmailAsync(string email);
        Task<List<PersonIdentityModel>> GetStaffIdentityByProfileEmailAsync(string email);
        bool HasAccessToStudent(int staffUsi, int studentUsi);
    }
}
