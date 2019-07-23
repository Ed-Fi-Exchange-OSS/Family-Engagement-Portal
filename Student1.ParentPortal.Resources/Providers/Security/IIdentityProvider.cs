using System.Threading.Tasks;
using Student1.ParentPortal.Models.Shared;

namespace Student1.ParentPortal.Resources.Providers.Security
{
    public interface IIdentityProvider
    {
        Task<PersonIdentityModel> GetIdentity(string email);
    }
}
