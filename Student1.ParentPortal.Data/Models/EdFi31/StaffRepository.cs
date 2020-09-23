// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Shared;

namespace Student1.ParentPortal.Data.Models.EdFi31
{
    public class StaffRepository : IStaffRepository
    {
        private readonly EdFi31Context _edFiDb;

        public StaffRepository(EdFi31Context edFiDb)
        {
            _edFiDb = edFiDb;
        }

        public async Task<List<PersonIdentityModel>> GetStaffIdentityByEmailAsync(string email)
        {
            var identity = await (from s in _edFiDb.Staffs
                                  join sa in _edFiDb.StaffElectronicMails on s.StaffUsi equals sa.StaffUsi
                                  where sa.ElectronicMailAddress == email
                                  select new PersonIdentityModel
                                  {
                                      Usi = s.StaffUsi,
                                      UniqueId = s.StaffUniqueId,
                                      PersonTypeId = ChatLogPersonTypeEnum.Staff.Value,
                                      FirstName = s.FirstName,
                                      LastSurname = s.LastSurname,
                                      Email = sa.ElectronicMailAddress
                                  }).ToListAsync();

            return identity;
        }

        public async Task<List<PersonIdentityModel>> GetStaffIdentityByProfileEmailAsync(string email)
        {
            var identity = await (from s in _edFiDb.Staffs
                                  join sa in _edFiDb.StaffProfileElectronicMails on s.StaffUniqueId equals sa.StaffUniqueId
                                  where sa.ElectronicMailAddress == email
                                  select new PersonIdentityModel
                                  {
                                      Usi = s.StaffUsi,
                                      UniqueId = s.StaffUniqueId,
                                      PersonTypeId = ChatLogPersonTypeEnum.Staff.Value,
                                      FirstName = s.FirstName,
                                      LastSurname = s.LastSurname,
                                      Email = sa.ElectronicMailAddress
                                  }).ToListAsync();

            return identity;
        }

        public bool HasAccessToStudent(int staffUsi, int studentUsi)
        {
            // Only Teacher and Student associated to same section.
            return (from studSec in _edFiDb.StudentSectionAssociations
                    join staffSec in _edFiDb.StaffSectionAssociations
                        on new { studSec.LocalCourseCode, studSec.SchoolId, studSec.SchoolYear, studSec.SectionIdentifier, studSec.SessionName }
                    equals new { staffSec.LocalCourseCode, staffSec.SchoolId, staffSec.SchoolYear, staffSec.SectionIdentifier, staffSec.SessionName }
                    where staffSec.StaffUsi == staffUsi && studSec.StudentUsi == studentUsi
                    select studSec.StudentUsi).Any();
        }
    }
}
