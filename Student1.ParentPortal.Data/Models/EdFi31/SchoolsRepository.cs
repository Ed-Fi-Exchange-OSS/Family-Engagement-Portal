﻿using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Schools;
using Student1.ParentPortal.Models.Shared;

namespace Student1.ParentPortal.Data.Models.EdFi31
{
    public class SchoolsRepository : ISchoolsRepository
    {
        private readonly EdFi31Context _edFiDb;

        public SchoolsRepository(EdFi31Context edFiDb) 
        {
            _edFiDb = edFiDb;
        }
        public async Task<List<GradeModel>> GetGradeLevelsBySchoolId(int schoolId)
        {
            var data = await (from ssa in _edFiDb.StudentSchoolAssociations
                              join d in _edFiDb.Descriptors on ssa.EntryGradeLevelDescriptorId equals d.DescriptorId
                              where ssa.SchoolId == schoolId
                              group new { ssa, d } by new { ssa.EntryGradeLevelDescriptorId, d.CodeValue } into g
                              select new GradeModel
                              {
                                  Id = g.FirstOrDefault().ssa.EntryGradeLevelDescriptorId,
                                  Name = g.FirstOrDefault().d.CodeValue
                              }).ToListAsync();
            return data;
        }

        public async Task<List<ProgramsModel>> GetProgramsBySchoolId(int schoolId)
        {
            var data = await (from p in _edFiDb.StudentEducationOrganizationAssociationProgramParticipations
                              join d in _edFiDb.Descriptors on p.ProgramTypeDescriptorId equals d.DescriptorId
                              where p.EducationOrganizationId == schoolId
                              select new ProgramsModel
                              {
                                  Id = p.ProgramTypeDescriptorId,
                                  Name = d.CodeValue
                              }).Distinct().ToListAsync();
            return data;
        }
    }
}
