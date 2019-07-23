using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Student;

namespace Student1.ParentPortal.Data.Models.EdFi25
{
    public class SpotlightIntegrationRepository : ISpotlightIntegrationRepository
    {

        private readonly EdFi25Context _edFiDb;

        public SpotlightIntegrationRepository(EdFi25Context edFiDb)
        {
            _edFiDb = edFiDb;
        }

        public async Task<List<StudentExternalLink>> GetStudentExternalLinks(string studentUniqueId)
        {
            return await _edFiDb.SpotlightIntegrations.Where(x => x.StudentUniqueId == studentUniqueId)
                                .Select(x => new StudentExternalLink
                                {
                                    Url = x.Url,
                                    UrlType = x.UrlType.ShortDescription
                                }).ToListAsync();
        }
    }
}
