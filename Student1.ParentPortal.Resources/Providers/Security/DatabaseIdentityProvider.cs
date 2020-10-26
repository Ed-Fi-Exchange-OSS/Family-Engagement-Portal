using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Security.Authentication;
using System.Text;
using System.Threading.Tasks;
using SimpleInjector;
using Student1.ParentPortal.Data.Models.EdFi25;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Resources.Providers.Logger;
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
            var logger = _container.GetInstance<ILogger>();
            PersonIdentityModel person = null;

            foreach (var idProvider in identityProviders.OrderBy(x => x.Order))
            {
                var personCandidate = await idProvider.GetIdentity(email);
                if (personCandidate != null)
                { 
                    person = personCandidate;
                    break;
                }
            }

            if (person == null)
            {
                await logger.LogErrorAsync($"Could not find a person with the provided email: {email}");
                throw new AuthenticationException("Could not find a person with provided email");
            }

            return person;
        }
    }
}
