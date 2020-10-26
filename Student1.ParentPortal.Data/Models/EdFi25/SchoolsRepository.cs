using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Schools;
using Student1.ParentPortal.Models.Shared;

namespace Student1.ParentPortal.Data.Models.EdFi25
{
    public class SchoolsRepository : ISchoolsRepository
    {
        private readonly EdFi25Context _edFiDb;
        public SchoolsRepository(EdFi25Context edFiDb) 
        {
            _edFiDb = edFiDb;
        }
        public async Task<List<GradeModel>> GetGradeLevelsBySchoolId(int schoolId)
        {
            var data = await (from gld in _edFiDb.GradeLevelDescriptors
                             join d in _edFiDb.Descriptors on gld.GradeLevelDescriptorId equals d.DescriptorId
                             join s in _edFiDb.SchoolGradeLevels on gld.GradeLevelDescriptorId equals s.GradeLevelDescriptorId
                             where s.SchoolId == schoolId
                             select new GradeModel
                             {
                                 Id = gld.GradeLevelDescriptorId,
                                 Name = d.CodeValue
                             }).ToListAsync();
            return data;
        }

        public async Task<List<ProgramsModel>> GetProgramsBySchoolId(int schoolId)
        {
            var data = await (from p in _edFiDb.Programs
                              join eo in _edFiDb.EducationOrganizations on p.EducationOrganizationId equals eo.EducationOrganizationId
                              where eo.EducationOrganizationId == schoolId
                              select new ProgramsModel
                              {
                                  Id = Convert.ToInt32(p.ProgramId),
                                  Name = p.ProgramName
                              }).ToListAsync();
            return data;
        }

       
    }
}
