using Student1.ParentPortal.Data.Models.EdFi25;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Types;
using Student1.ParentPortal.Data.Models;

namespace Student1.ParentPortal.Resources.Services.Types
{
    public interface ITelephoneNumberTypesService
    {
        Task<List<TelephoneNumberTypeModel>> GetTelephoneNumberTypes();
    }

    public class TelephoneNumberTypesService : ITelephoneNumberTypesService
    {
        private readonly ITypesRepository _typesRepository;

        public TelephoneNumberTypesService(ITypesRepository typesRepository)
        {
            _typesRepository = typesRepository;
        }

        public async Task<List<TelephoneNumberTypeModel>> GetTelephoneNumberTypes()
        {
            return await _typesRepository.GetTelephoneNumberTypes();
        }
    }
}
