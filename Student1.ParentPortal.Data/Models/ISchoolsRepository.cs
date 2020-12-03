using Student1.ParentPortal.Models.Schools;
using Student1.ParentPortal.Models.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Data.Models
{
    public interface ISchoolsRepository
    {
        Task<List<GradeModel>> GetGradeLevelsBySchoolId(int schoolId);
        Task<List<ProgramsModel>> GetProgramsBySchoolId(int schoolId);
        Task<List<SchoolBriefDetailModel>> GetSchoolsByPrincipal(int staffUsi);
    }
}
