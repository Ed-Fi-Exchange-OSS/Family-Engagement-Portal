using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SimpleInjector;
using Student1.ParentPortal.Data.Models.EdFi25;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Resources.Providers.Security;

namespace Student1.ParentPortal.Resources.Services
{
    public interface IDatabaseIdentityProvider
    {
        Task<PersonIdentityModel> GetPersonInformationAsync(string email);
    }

    public class DatabaseIdentityProvider : IDatabaseIdentityProvider
    {
        private readonly Container _container;

        public DatabaseIdentityProvider(Container container)
        {
            _container = container;
        }

        public async Task<PersonIdentityModel> GetPersonInformationAsync(string email)
        {
            // Because this code is used in the authentication middle ware we need to resolve dependencies in here.
            var identityProviders = _container.GetAllInstances<IIdentityProvider>();

            PersonIdentityModel person = null;

            foreach (var idProvider in identityProviders)
            {
                var personCandidate = await idProvider.GetIdentity(email);
                if (personCandidate != null)
                { 
                    person = personCandidate;
                    break;
                }
            }

            if (person == null)
                throw new NotImplementedException("Could not find a person with provided email");

            return person;
        }
    }
}
