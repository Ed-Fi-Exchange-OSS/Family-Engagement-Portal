using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using SimpleInjector;
using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Data.Models.EdFi25;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Resources.Providers.Configuration;

namespace Student1.ParentPortal.Resources.Providers.Security
{
    public class ParentIdeintityProvider : IIdentityProvider
    {
        private readonly Container _container;
        private readonly ICustomParametersProvider _customParametersProvider;

        public ParentIdeintityProvider(Container container, ICustomParametersProvider customParametersProvider)
        {
            _container = container;
            _customParametersProvider = customParametersProvider;
        }

        //As of when this code was written the parent identity provider should run last
        public int Order => 10;

        public async Task<PersonIdentityModel> GetIdentity(string email)
        {
            // Because this code is used in the authentication middle ware we need to resolve db dependency in here.
            var parentRepo = _container.GetInstance<IParentRepository>();

            var validParentDescriptors = _customParametersProvider.GetParameters().descriptors.validParentDescriptors;

            var parentIdentity = await parentRepo.GetParentIdentityByEmailAsync(email, validParentDescriptors);


            // If email is not found on edfi emails it will try to find it on profile emails.
            if (parentIdentity == null || !parentIdentity.Any())
                parentIdentity = await parentRepo.GetParentIdentityByProfileEmailAsync(email, validParentDescriptors);


            // If email doesnt exist on edfi emails or profile emails it isn't a parent, it can't handle so it returns null.
            if (parentIdentity == null || !parentIdentity.Any())
                return null;


            // TODO: handle case where there are duplicates
            var parentInfo = parentIdentity.FirstOrDefault();

            parentInfo.PersonType = "Parent";

            return parentInfo;

        }
    }
}
