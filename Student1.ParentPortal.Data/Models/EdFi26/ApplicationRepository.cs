using System.Data.Entity;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Data.Models.EdFi26
{
    public class ApplicationRepository : IApplicationRepository
    {
        private readonly EdFi26Context _edFiDb;

        public ApplicationRepository(EdFi26Context edFiDb)
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
