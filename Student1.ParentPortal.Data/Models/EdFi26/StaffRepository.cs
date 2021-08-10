using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Shared;

namespace Student1.ParentPortal.Data.Models.EdFi26
{
    public class StaffRepository : IStaffRepository
    {
        private readonly EdFi26Context _edFiDb;

        public StaffRepository(EdFi26Context edFiDb)
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

        public async Task<List<PersonIdentityModel>> GetStaffIdentityByEmailAsync(string email, string[] validStaffDescriptors)
        {
            var identity = await (from s in _edFiDb.Staffs
                                                .Include(x => x.StaffEducationOrganizationAssignmentAssociations.Select(seoa => seoa.StaffClassificationDescriptor.Descriptor))
                                  join sa in _edFiDb.StaffElectronicMails on s.StaffUsi equals sa.StaffUsi
                                  where sa.ElectronicMailAddress == email &&
                                             s.StaffEducationOrganizationAssignmentAssociations.Any(x => validStaffDescriptors.Contains(x.StaffClassificationDescriptor.Descriptor.CodeValue))
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
        public async Task<List<PersonIdentityModel>> GetStaffPrincipalIdentityByEmailAsync(string email, string[] validCampusLeaderDescriptors)
        {
            //return new List<PersonIdentityModel>();
            var identity = await (from s in _edFiDb.Staffs
                                  join seoaa in _edFiDb.StaffEducationOrganizationAssignmentAssociations on s.StaffUsi equals seoaa.StaffUsi
                                  join sch in _edFiDb.Schools on seoaa.EducationOrganizationId equals sch.LocalEducationAgencyId
                                  join sa in _edFiDb.StaffElectronicMails on s.StaffUsi equals sa.StaffUsi
                                  join scd in _edFiDb.Descriptors on seoaa.StaffClassificationDescriptorId equals scd.DescriptorId
                                  where sa.ElectronicMailAddress == email && validCampusLeaderDescriptors.Contains(scd.CodeValue)
                                  select new PersonIdentityModel
                                  {
                                      Usi = s.StaffUsi,
                                      UniqueId = s.StaffUniqueId,
                                      PersonTypeId = ChatLogPersonTypeEnum.Staff.Value,
                                      FirstName = s.FirstName,
                                      LastSurname = s.LastSurname,
                                      Email = sa.ElectronicMailAddress,
                                      SchoolId = sch.SchoolId
                                  }).ToListAsync();
            return identity;
        }
        public async Task<List<PersonIdentityModel>> GetStaffPrincipalIdentityByProfileEmailAsync(string email, string[] validCampusLeaderDescriptors)
        {
            var identity = await (from s in _edFiDb.Staffs
                                  join seoaa in _edFiDb.StaffEducationOrganizationAssignmentAssociations on s.StaffUsi equals seoaa.StaffUsi
                                  join sch in _edFiDb.Schools on seoaa.EducationOrganizationId equals sch.LocalEducationAgencyId
                                  join sa in _edFiDb.StaffProfileElectronicMails on s.StaffUniqueId equals sa.StaffUniqueId
                                  join scd in _edFiDb.Descriptors on seoaa.StaffClassificationDescriptorId equals scd.DescriptorId
                                  where sa.ElectronicMailAddress == email && validCampusLeaderDescriptors.Contains(scd.CodeValue)
                                  select new PersonIdentityModel
                                  {
                                      Usi = s.StaffUsi,
                                      UniqueId = s.StaffUniqueId,
                                      PersonTypeId = ChatLogPersonTypeEnum.Staff.Value,
                                      FirstName = s.FirstName,
                                      LastSurname = s.LastSurname,
                                      Email = sa.ElectronicMailAddress,
                                      SchoolId = sch.SchoolId
                                  }).ToListAsync();

            return identity;
        }
        public async Task<List<PersonIdentityModel>> GetStaffIdentityByProfileEmailAsync(string email, string[] validStaffDescriptors)
        {
            var identity = await (from s in _edFiDb.Staffs
                                               .Include(x => x.StaffEducationOrganizationAssignmentAssociations.Select(seoa => seoa.StaffClassificationDescriptor.Descriptor))
                                  join sa in _edFiDb.StaffProfileElectronicMails on s.StaffUniqueId equals sa.StaffUniqueId
                                  where sa.ElectronicMailAddress == email &&
                                             s.StaffEducationOrganizationAssignmentAssociations.Any(x => validStaffDescriptors.Contains(x.StaffClassificationDescriptor.Descriptor.CodeValue))
                                  select new PersonIdentityModel
                                  {
                                      Usi = s.StaffUsi,
                                      UniqueId = s.StaffUniqueId,
                                      PersonTypeId = ChatLogPersonTypeEnum.Staff.Value,
                                      FirstName = s.FirstName,
                                      LastSurname = s.LastSurname,
                                      Email = sa.ElectronicMailAddress,
                                      SchoolId = s.StaffEducationOrganizationAssignmentAssociations.FirstOrDefault().EducationOrganizationId
                                  }).ToListAsync();

            return identity;
        }
        public async Task<PersonIdentityModel> GetStaffIdentityByUniqueId(string staffUniqueId)
        {
            var identity = await (from s in _edFiDb.Staffs
                                  where s.StaffUniqueId == staffUniqueId
                                  select new PersonIdentityModel
                                  {
                                      Usi = s.StaffUsi,
                                      UniqueId = s.StaffUniqueId,
                                      PersonTypeId = ChatLogPersonTypeEnum.Staff.Value,
                                      FirstName = s.FirstName,
                                      LastSurname = s.LastSurname
                                  }).FirstOrDefaultAsync();

            return identity;
        }
        public bool HasAccessToStudent(int staffUsi, int studentUsi)
        {
            // Only Teacher and Student associated to same section.
            return (from studSec in _edFiDb.StudentSectionAssociations
                    join staffSec in _edFiDb.StaffSectionAssociations
                        on new { studSec.SchoolId, studSec.ClassPeriodName, studSec.ClassroomIdentificationCode, studSec.LocalCourseCode, studSec.TermDescriptorId, studSec.SchoolYear, studSec.UniqueSectionCode, studSec.SequenceOfCourse }
                        equals new { staffSec.SchoolId, staffSec.ClassPeriodName, staffSec.ClassroomIdentificationCode, staffSec.LocalCourseCode, staffSec.TermDescriptorId, staffSec.SchoolYear, staffSec.UniqueSectionCode, staffSec.SequenceOfCourse }
                    where staffSec.StaffUsi == staffUsi && studSec.StudentUsi == studentUsi
                    select studSec.StudentUsi).Any();
        }

        public Task<List<PersonIdentityModel>> GetStaffPrincipalIdentityByEmailAsync(string email, string[] validCampusLeaderDescriptors, DateTime today)
        {
            throw new NotImplementedException();
        }

        public Task<List<PersonIdentityModel>> GetStaffPrincipalIdentityByProfileEmailAsync(string email, string[] validCampusLeaderDescriptors, DateTime today)
        {
            throw new NotImplementedException();
        }
    }
}
