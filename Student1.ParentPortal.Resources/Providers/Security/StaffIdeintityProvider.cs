using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using SimpleInjector;
using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Data.Models.EdFi25;
using Student1.ParentPortal.Models.Shared;

namespace Student1.ParentPortal.Resources.Providers.Security
{
    public class StaffIdeintityProvider : IIdentityProvider
    {
        private readonly Container _container;

        public StaffIdeintityProvider(Container container)
        {
            _container = container;
        }

        public async Task<PersonIdentityModel> GetIdentity(string email)
        {
            // Because this code is used in the authentication middle ware we need to resolve db dependency in here.
            var staffRepo = _container.GetInstance<IStaffRepository>();

            var staffIdentity = await staffRepo.GetStaffIdentityByEmailAsync(email);

            // If email is not found on edfi emails it will try to find it on profile emails.
            if (staffIdentity == null || !staffIdentity.Any())
                staffIdentity = await staffRepo.GetStaffIdentityByProfileEmailAsync(email);

            // If email doesnt exist on edfi emails or profile emails it isn't a staff, it can't handle so it returns null.
            if (staffIdentity == null || !staffIdentity.Any())
                return null;

                // TODO: handle case where there are duplicates
                var personInfo = staffIdentity.FirstOrDefault();

            personInfo.PersonType = "Staff";

            return personInfo;

        }
    }
}
