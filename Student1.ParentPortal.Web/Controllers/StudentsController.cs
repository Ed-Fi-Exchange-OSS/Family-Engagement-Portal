using System.Threading.Tasks;
using System.Web.Http;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Resources.Services.Students;
using Student1.ParentPortal.Web.Security;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/students")]
    public class StudentsController : ApiController
    {
        private readonly IStudentsService _studentsService;
        private readonly IStudentAttendanceService _studentAttendanceService;
        private readonly IStudentBehaviorService _studentBehaviorService;
        private readonly IStudentCourseGradesService _studentCourseGradesService;
        private readonly IStudentAssignmentService _studentAssignmentService;
        private readonly IStudentSuccessTeamService _studentSuccessTeamService;
        private readonly IStudentScheduleService _studentScheduleService;
        private readonly IStudentAssessmentService _studentAssessmentService;

        public StudentsController(IStudentsService studentsService,
                                  IStudentAttendanceService studentAttendanceService,
                                  IStudentBehaviorService studentBehaviorService,
                                  IStudentCourseGradesService studentCourseGradesService,
                                  IStudentAssignmentService studentAssignmentService,
                                  IStudentSuccessTeamService studentSuccessTeamService,
                                  IStudentScheduleService studentScheduleService,
                                  IStudentAssessmentService studentAssessmentService)
        {
            _studentsService = studentsService;
            _studentAttendanceService = studentAttendanceService;
            _studentBehaviorService = studentBehaviorService;
            _studentCourseGradesService = studentCourseGradesService;
            _studentAssignmentService = studentAssignmentService;
            _studentSuccessTeamService = studentSuccessTeamService;
            _studentScheduleService = studentScheduleService;
            _studentAssessmentService = studentAssessmentService;
        }

        [HttpGet, Route("{id:int}")]
        public async Task<IHttpActionResult> Get(int id)
        {

            var recipient = SecurityPrincipal.Current;

            var model = await _studentsService.GetStudentDetailAsync(id, recipient.PersonUniqueId, recipient.PersonTypeId);

            if (model == null)
                return NotFound();

            return Ok(model);
        }

        [HttpGet, Route("{id:int}/brief")]
        public async Task<IHttpActionResult> GetBriefModel(int id)
        {
            var model = await _studentsService.GetPersonBriefModelAsync(id);

            if (model == null)
                return NotFound();

            return Ok(model);
        }

        [HttpGet, Route("{id:int}/detail")]
        public async Task<IHttpActionResult> GetBriefDetail(int id)
        {

            var recipient = SecurityPrincipal.Current;

            var model = await _studentsService.GetStudentBriefDetailAsync(id, recipient.PersonUniqueId, recipient.PersonTypeId);

            if (model == null)
                return NotFound();

            return Ok(model);
        }

        [HttpGet, Route("{id:int}/detail/attendance")]
        public async Task<IHttpActionResult> GetStudentAttendance(int id) 
        {
            var model = await _studentAttendanceService.GetStudentAttendanceAsync(id);

            if (model == null)
                return NotFound();

            return Ok(model);
        }

        [HttpGet, Route("{id:int}/detail/behavior")]
        public async Task<IHttpActionResult> GetStudentBehavior(int id)
        {
            var model = await _studentBehaviorService.GetStudentBehaviorAsync(id);

            if (model == null)
                return NotFound();

            return Ok(model);
        }

        [HttpGet, Route("{id:int}/detail/courseGrades")]
        public async Task<IHttpActionResult> GetStudentCourseGrades(int id)
        {
            var model = await _studentCourseGradesService.GetStudentCourseGradesAsync(id);

            if (model == null)
                return NotFound();

            return Ok(model);
        }

        [HttpGet, Route("{id:int}/detail/missingAssignments")]
        public async Task<IHttpActionResult> GetStudentMissingAssignments(int id)
        {
            var model = await _studentAssignmentService.GetStudentMissingAssignments(id);

            if (model == null)
                return NotFound();

            return Ok(model);
        }

        [HttpGet, Route("{id:int}/detail/successTeamMembers")]
        public async Task<IHttpActionResult> GetStudentSuccessTeam(int id)
        {
            var recipient = SecurityPrincipal.Current;

            var model = await _studentSuccessTeamService.GetStudentSuccessTeamAsync(id, recipient.PersonUniqueId, recipient.PersonTypeId);

            if (model == null)
                return NotFound();

            return Ok(model);
        }

        [HttpGet, Route("{id:int}/detail/schedule")]
        public async Task<IHttpActionResult> GetStudentSchedule(int id)
        {
            var model = await _studentScheduleService.GetStudentScheduleAsync(id);

            if (model == null)
                return NotFound();

            return Ok(model);
        }

        [HttpGet, Route("{id:int}/detail/assessments")]
        public async Task<IHttpActionResult> GetStudentAssessments(int id)
        {
            var model = await _studentAssessmentService.GetStudentAssessmentsAsync(id);

            if (model == null)
                return NotFound();

            return Ok(model);
        }

        [HttpGet, Route("{id:int}/detail/staarAssessmentHistory")]
        public async Task<IHttpActionResult> GetStudentStaarAssessmentHistory(int id)
        {
            var model = await _studentAssessmentService.GetStudentStaarAssessmentHistoryAsync(id);

            if (model == null)
                return NotFound();

            return Ok(model);
        }
    }
}
