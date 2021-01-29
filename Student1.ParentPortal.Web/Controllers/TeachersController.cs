using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Resources.Services;
using Student1.ParentPortal.Resources.Services.Schools;
using Student1.ParentPortal.Web.Security;
using System.Threading.Tasks;
using System.Web.Http;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/teachers")]
    public class TeachersController : ApiController
    {
        private readonly ITeachersService _teachersService;
        private readonly ISchoolsService _schoolsService;

        public TeachersController(ITeachersService teachersService,
            ISchoolsService schoolsService)
        {
            _teachersService = teachersService;
            _schoolsService = schoolsService;
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

        [Route("teacher/sections/{id:int}")]
        [HttpGet]
        public async Task<IHttpActionResult> GetTeachersSectionsById(int id)
        {
            var model = await _teachersService.GetStaffSectionsAsync(id);

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
            if (request.StaffUsi == 0) request.StaffUsi = teacher.PersonUSI;

            var model = await _teachersService.GetStudentsInSection(request.StaffUsi, request, teacher.PersonUniqueId, teacher.PersonTypeId);

            if (model == null)
                return NotFound();

            return Ok(model);
        }

        [Route("schools")]
        [HttpGet]
        public async Task<IHttpActionResult> GetCampusLeaderSchools()
        {
            var teacherUsi = SecurityPrincipal.Current.PersonUSI;
            var model = await _schoolsService.GetDistinctSchoolsByPrincipal(teacherUsi);
            if (model == null) return NotFound();
            return Ok(model);
        }

        [Route("grades/{id:int}")]
        [HttpGet]
        public async Task<IHttpActionResult> GetGradesBySchool(int id)
        {
            var model = await _schoolsService.GetOnlyGradeLevelsBySchoolId(id);
            if (model == null) return NotFound();
            return Ok(model);
        }

        [Route("campusleader/information")]
        [HttpPost]
        public async Task<IHttpActionResult> GetCampusLeaderInformation(CampusLeaderStudentSearchModel request)
        {
            var model = await _teachersService.GetTeacherStudentsByCampusLeader(request);

            if (model == null)
                return NotFound();

            return Ok(model);
        }
    }
}
