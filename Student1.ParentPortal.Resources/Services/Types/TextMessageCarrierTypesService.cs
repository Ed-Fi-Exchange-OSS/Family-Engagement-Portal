using Student1.ParentPortal.Data.Models.EdFi25;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Types;
using Student1.ParentPortal.Data.Models;

namespace Student1.ParentPortal.Resources.Services.Types
{
    public interface ITextMessageCarrierTypesService
    {
        Task<List<TextMessageCarrierTypeModel>> GetTextMessageCarrierTypes();
    }

    public class TextMessageCarrierTypesService : ITextMessageCarrierTypesService
    {
        private readonly ITypesRepository _typesRepository;

        public TextMessageCarrierTypesService(ITypesRepository typesRepository)
        {
            _typesRepository = typesRepository;
        }

        public async Task<List<TextMessageCarrierTypeModel>> GetTextMessageCarrierTypes()
        {
            return await _typesRepository.GetTextMessageCarrierTypes();
        }
    }
}
