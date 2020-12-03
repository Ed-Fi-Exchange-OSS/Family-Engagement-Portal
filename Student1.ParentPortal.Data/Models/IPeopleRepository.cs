using Student1.ParentPortal.Models.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Data.Models
{
    public interface IPeopleRepository
    {
        Task<PersonIdentityModel> GetIdentityByEmailAsync(string email, string[] validParentDescriptors);
    }
}
