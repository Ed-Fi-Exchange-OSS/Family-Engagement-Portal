using Student1.ParentPortal.Data.Models.EdFi25;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Types;
using Student1.ParentPortal.Data.Models;

namespace Student1.ParentPortal.Resources.Services.Types
{
    public interface IElectronicMailTypesService
    {
        Task<List<ElectronicMailTypeModel>> GetElectronicMailTypes();
    }

    public class ElectronicMailTypesService : IElectronicMailTypesService
    {
        private readonly ITypesRepository _typesRepository;

        public ElectronicMailTypesService(ITypesRepository typesRepository)
        {
            _typesRepository = typesRepository;
        }

        public async Task<List<ElectronicMailTypeModel>> GetElectronicMailTypes()
        {
            return await _typesRepository.GetElectronicMailTypes();
        }
    }
}
