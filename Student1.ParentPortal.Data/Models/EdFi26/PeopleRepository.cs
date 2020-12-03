using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Shared;

namespace Student1.ParentPortal.Data.Models.EdFi26
{
    public class PeopleRepository : IPeopleRepository
    {
        private readonly EdFi26Context _edFiDb;

        public PeopleRepository(EdFi26Context edFiDb)
        {
            _edFiDb = edFiDb;
        }

        public async Task<PersonIdentityModel> GetIdentityByEmailAsync(string email, string[] validParentDescriptors)
        {

            var alternateEmail = email.Replace("providenceschools.org", "ppsd.org");
            var identities = await _edFiDb.People
                .Where(x => x.ElectronicMailAddress == email || x.ElectronicMailAddress == alternateEmail)
                .Select(x => new PersonIdentityModel {
                    Usi = x.Usi,
                    UniqueId = x.UniqueId,
                    PersonType = x.PersonType,
                    FirstName = x.FirstName,
                    LastSurname = x.LastSurname,
                    Email = x.ElectronicMailAddress,
                    PositionTitle = x.PositionTitle,
                }).ToListAsync();

            var student = identities.FirstOrDefault(x => x.PersonType == ChatLogPersonTypeEnum.Student.DisplayName);
            var parent = identities.FirstOrDefault(x => x.PersonType == ChatLogPersonTypeEnum.Parent.DisplayName && validParentDescriptors.Contains(x.PositionTitle));
            var staff = identities.FirstOrDefault(x => x.PersonType == ChatLogPersonTypeEnum.Staff.DisplayName);

            if (student != null)
            {
                student.PersonTypeId = ChatLogPersonTypeEnum.Student.Value;
                student.IdentificationCode = (await _edFiDb.StudentIdentificationCodes.FirstOrDefaultAsync(x => x.StudentUsi == student.Usi && x.AssigningOrganizationIdentificationCode == "LASID"))?.IdentificationCode;
                return student;
            }
            else if (parent != null)
            {
                parent.PersonTypeId = ChatLogPersonTypeEnum.Parent.Value;
                parent.IdentificationCode = "";
                return parent;
            }
            else if(staff != null)
            {
                staff.PersonTypeId = ChatLogPersonTypeEnum.Staff.Value;
                var code = (await _edFiDb.StaffIdentificationCodes.FirstOrDefaultAsync(x => x.StaffUsi == staff.Usi && x.AssigningOrganizationIdentificationCode == "LASID"))?.IdentificationCode;
                staff.IdentificationCode = code ?? "";
                return staff;
            }

            return null;
        }
    }
}
