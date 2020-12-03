using Student1.ParentPortal.Models.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Data.Models
{
    public interface IAdminRepository
    {
        Task<List<PersonIdentityModel>> GetAdminIdentityByEmailAsync(string email);
        Task<AdminStudentDetailFeatureModel> GetStudentDetailFeatures();
        Task<AdminStudentDetailFeatureModel> SaveStudentDetailFeatures(AdminStudentDetailFeatureModel model);
    }
}
