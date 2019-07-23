using System.Threading.Tasks;
using Student1.ParentPortal.Data.Models;

namespace Student1.ParentPortal.Resources.Services.Application
{
    public interface IApplicationService {
        Task<bool> IsApplicationOfflineAsync();
    }

    public class ApplicationService : IApplicationService
    {
        private readonly IApplicationRepository _applicationRepository;

        public ApplicationService(IApplicationRepository applicationRepository)
        {
            _applicationRepository = applicationRepository;
        }

        public async Task<bool> IsApplicationOfflineAsync()
        {
            return await _applicationRepository.IsApplicationOffline();
        }
    }
}
