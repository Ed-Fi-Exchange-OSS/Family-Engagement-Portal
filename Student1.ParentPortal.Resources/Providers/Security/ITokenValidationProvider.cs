using Student1.ParentPortal.Models.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.Security
{
    public interface ITokenValidationProvider
    {
        Task<PersonIdentityModel> ValidateTokenAsync(string idToken);
    }
}
