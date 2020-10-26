using System.Data.Entity;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Data.Models.EdFi31
{
    public class ApplicationRepository : IApplicationRepository
    {
        private readonly EdFi31Context _edFiDb;

        public ApplicationRepository(EdFi31Context edFiDb)
        {
            _edFiDb = edFiDb;
        }

        public async Task<bool> IsApplicationOffline()
        {
            var data = await _edFiDb.AppOfflines.SingleOrDefaultAsync();
            return data != null && data.IsAppOffline;
        }
    }
}
