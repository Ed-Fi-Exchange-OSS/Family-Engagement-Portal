using Student1.ParentPortal.Data.Models.EdFi25;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Types;
using Student1.ParentPortal.Data.Models;

namespace Student1.ParentPortal.Resources.Services.Types
{
    public interface IAddressTypesService
    {
        Task<List<AddressTypeModel>> GetAddressTypes();
    }

    public class AddressTypesService : IAddressTypesService
    {
        private readonly ITypesRepository _typesRepository;

        public AddressTypesService(ITypesRepository typesRepository)
        {
            _typesRepository = typesRepository;
        }

        public async Task<List<AddressTypeModel>> GetAddressTypes()
        {
            return await _typesRepository.GetAddressTypes();
        }
    }
}
