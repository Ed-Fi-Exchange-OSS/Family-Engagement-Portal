using System.Linq;
using System.Threading.Tasks;
using SimpleInjector;
using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Resources.Providers.Configuration;

namespace Student1.ParentPortal.Resources.Providers.Security
{
    public class StaffIdeintityProvider : IIdentityProvider
    {
        private readonly Container _container;
        private readonly ICustomParametersProvider _customParametersProvider;

        public StaffIdeintityProvider(Container container, ICustomParametersProvider customParametersProvider)
        {
            _container = container;
            _customParametersProvider = customParametersProvider;
        }

        //As of when this code was written the teacher identity provider should run after the Admin provider.
        public int Order => 100;

        public async Task<PersonIdentityModel> GetIdentity(string email)
        {
            // Because this code is used in the authentication middle ware we need to resolve db dependency in here.
            var staffRepo = _container.GetInstance<IStaffRepository>();

            var validStaffDescriptors = _customParametersProvider.GetParameters().descriptors.validStaffDescriptors;

            var staffIdentity = await staffRepo.GetStaffIdentityByEmailAsync(email, validStaffDescriptors);

            // If email is not found on edfi emails it will try to find it on profile emails.
            if (staffIdentity == null || !staffIdentity.Any())
                staffIdentity = await staffRepo.GetStaffIdentityByProfileEmailAsync(email, validStaffDescriptors);

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
