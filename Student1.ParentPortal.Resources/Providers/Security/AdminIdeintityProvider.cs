using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SimpleInjector;
using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Models.Shared;

namespace Student1.ParentPortal.Resources.Providers.Security
{
    public class AdminIdeintityProvider : IIdentityProvider
    {
        private readonly Container _container;

        public AdminIdeintityProvider(Container container)
        {
            _container = container;
        }

        //The Admin Identity Provider should always run firts and have highest priority
        public int Order => -100;

        public async Task<PersonIdentityModel> GetIdentity(string email)
        {
            // Because this code is used in the authentication middle ware we need to resolve db dependency in here.
            var adminRepo = _container.GetInstance<IAdminRepository>();

            var adminIdentity = await adminRepo.GetAdminIdentityByEmailAsync(email);

            if (adminIdentity == null || !adminIdentity.Any())
                return null;

            var personInfo = adminIdentity.FirstOrDefault();

            personInfo.PersonType = "Admin";

            return personInfo;
        }
    }
}
