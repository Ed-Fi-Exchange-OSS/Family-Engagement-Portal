using System.Threading.Tasks;
using System.Web.Http;
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Resources.Services;
using Student1.ParentPortal.Web.Security;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/teachers")]
    public class TeachersController : ApiController
    {
        private readonly ITeachersService _teachersService;

        public TeachersController(ITeachersService teachersService)
        {
            _teachersService = teachersService;
        }

        [Route("sections")]
        [HttpGet]
        public async Task<IHttpActionResult> GetTeachersSections()
        {
            // Get the teacherUSI from the security principal.
            var teacherUsi = SecurityPrincipal.Current.PersonUSI;
            var model = await _teachersService.GetStaffSectionsAsync(teacherUsi);

            if (model == null)
                return NotFound();

            return Ok(model);
        }

        [Route("students")]
        [HttpPost]
        public async Task<IHttpActionResult> GetTeachersStudents(TeacherStudentsRequestModel request)
        {
            // Get the teacherUSI from the security principal.
            var teacher = SecurityPrincipal.Current;
            var model = await _teachersService.GetStudentsInSection(teacher.PersonUSI, request, teacher.PersonUniqueId, teacher.PersonTypeId);

            if (model == null)
                return NotFound();

            return Ok(model);
        }
    }
}
