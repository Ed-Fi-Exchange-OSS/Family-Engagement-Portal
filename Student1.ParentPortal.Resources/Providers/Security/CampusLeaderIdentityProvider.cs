using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SimpleInjector;
using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Resources.Providers.Configuration;
using Student1.ParentPortal.Resources.Providers.Date;

namespace Student1.ParentPortal.Resources.Providers.Security
{
    public class CampusLeaderIdentityProvider : IIdentityProvider
    {
        private readonly Container _container;
        private readonly ICustomParametersProvider _customParametersProvider;
        private readonly IDateProvider _dateProvider;
        public CampusLeaderIdentityProvider(Container container, ICustomParametersProvider customParametersProvider, IDateProvider dateProvider)
        {
            _container = container;
            _customParametersProvider = customParametersProvider;
            _dateProvider = dateProvider;
        }
        public int Order => -50;

        public async Task<PersonIdentityModel> GetIdentity(string email)
        {
            var staffRepo = _container.GetInstance<IStaffRepository>();

            var validCampusLeaderDescriptors = _customParametersProvider.GetParameters().descriptors.validCampusLeaderDescriptors;

            var staffIdentity = await staffRepo.GetStaffPrincipalIdentityByEmailAsync(email, validCampusLeaderDescriptors, _dateProvider.Today());

            if (staffIdentity == null || !staffIdentity.Any())
                staffIdentity = await staffRepo.GetStaffPrincipalIdentityByProfileEmailAsync(email, validCampusLeaderDescriptors, _dateProvider.Today());

            // If email doesnt exist on edfi emails or profile emails it isn't a staff, it can't handle so it returns null.
            if (staffIdentity == null || !staffIdentity.Any())
                return null;

            // TODO: handle case where there are duplicates
            var personInfo = staffIdentity.FirstOrDefault();

            personInfo.PersonType = "CampusLeader";

            return personInfo;
        }
    }
}
