using Student1.ParentPortal.Resources.Services.Schools;
using Student1.ParentPortal.Web.Security;
using System.Threading.Tasks;
using System.Web.Http;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/schools")]
    public class SchoolsController : ApiController
    {
        private readonly ISchoolsService _schoolsService;

        public SchoolsController(ISchoolsService schoolsService)
        {
            _schoolsService = schoolsService;
        }


        [HttpGet, Route("{schoolId}/gradesLevels")]
        public async Task<IHttpActionResult> GetGrades(int schoolId)
        {
            var model = await _schoolsService.GetGradeLevelsBySchoolId(schoolId);

            if (model == null)
                return NotFound();

            return Ok(model);
        }

        [HttpGet, Route("{schoolId}/programs")]
        public async Task<IHttpActionResult> GetPrograms(int schoolId)
        {
            var model = await _schoolsService.GetProgramssBySchoolId(schoolId);

            if (model == null)
                return NotFound();

            return Ok(model);
        }


    }
}
