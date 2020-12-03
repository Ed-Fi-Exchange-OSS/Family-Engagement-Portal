using Student1.ParentPortal.Resources.Services.Schools;
using Student1.ParentPortal.Web.Security;
using System.Threading.Tasks;
using System.Web.Http;
using System.Linq;

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

        [HttpGet]
        public async Task<IHttpActionResult> GetSchoolsByPrincipal()
        {
            var person = SecurityPrincipal.Current;
            var role = person.Claims.SingleOrDefault(x => x.Type == "person_role").Value;

            if (role.Equals("CampusLeader", System.StringComparison.InvariantCultureIgnoreCase))
                return Ok(await _schoolsService.GetSchoolsByPrincipal(person.PersonUSI));

            return NotFound();
        }
    }
}
