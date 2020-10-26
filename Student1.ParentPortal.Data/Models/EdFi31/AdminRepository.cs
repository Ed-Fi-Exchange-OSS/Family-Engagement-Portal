using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Shared;

namespace Student1.ParentPortal.Data.Models.EdFi31
{
    public class AdminRepository : IAdminRepository
    {
        private readonly EdFi31Context _edFiDb;
        public AdminRepository(EdFi31Context edFiDb)
        {
            _edFiDb = edFiDb;
        }
        public async Task<List<PersonIdentityModel>> GetAdminIdentityByEmailAsync(string email)
        {
            var identity = await (from s in _edFiDb.Staffs
                                         join sa in _edFiDb.StaffElectronicMails on s.StaffUsi equals sa.StaffUsi
                                         join a in _edFiDb.Admins on sa.ElectronicMailAddress equals a.ElectronicMailAddress
                                         where a.ElectronicMailAddress == email
                                         select new PersonIdentityModel
                                         {
                                             Usi = s.StaffUsi,
                                             UniqueId = s.StaffUniqueId,
                                             PersonTypeId = ChatLogPersonTypeEnum.Staff.Value,
                                             FirstName = s.FirstName,
                                             LastSurname = s.LastSurname,
                                             Email = a.ElectronicMailAddress
                                         }).ToListAsync();
            if(!identity.Any())
                identity = await (from p in _edFiDb.Parents
                                    join pa in _edFiDb.ParentElectronicMails on p.ParentUsi equals pa.ParentUsi
                                    join a in _edFiDb.Admins on pa.ElectronicMailAddress equals a.ElectronicMailAddress
                                    where a.ElectronicMailAddress == email
                                    select new PersonIdentityModel
                                    {
                                        Usi = p.ParentUsi,
                                        UniqueId = p.ParentUniqueId,
                                        PersonTypeId = ChatLogPersonTypeEnum.Parent.Value,
                                        FirstName = p.FirstName,
                                        LastSurname = p.LastSurname,
                                        Email = a.ElectronicMailAddress
                                    }).ToListAsync();

            return identity;
        }
    }
}
