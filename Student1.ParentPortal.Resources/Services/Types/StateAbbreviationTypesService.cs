using Student1.ParentPortal.Data.Models.EdFi25;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Types;
using Student1.ParentPortal.Data.Models;

namespace Student1.ParentPortal.Resources.Services.Types
{
    public interface IStateAbbreviationTypesService
    {
        Task<List<StateAbbreviationTypeModel>> GetStateAbbreviationTypes();
    }

    public class StateAbbreviationTypesService : IStateAbbreviationTypesService
    {
        private readonly ITypesRepository _typesRepository;

        public StateAbbreviationTypesService(ITypesRepository typesRepository)
        {
            _typesRepository = typesRepository;
        }

        public async Task<List<StateAbbreviationTypeModel>> GetStateAbbreviationTypes()
        {
            return await _typesRepository.GetStateAbbreviationTypes();
        }
    }
}
