using System;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Http;
using Student1.ParentPortal.Models.Alert;
using Student1.ParentPortal.Resources.Services.Alerts;
using Student1.ParentPortal.Web.Security;

namespace Student1.ParentPortal.Web.Controllers
{
    
    [RoutePrefix("api/alerts")]
    public class AlertsController : ApiController
    {
        private readonly IAlertService _alertsService;

        public AlertsController(IAlertService alertsService)
        {
            _alertsService = alertsService;
        }

        // GET: api/Alerts
        [AllowAnonymous]
        [HttpGet]
        [Route("send")]
        public async Task<IHttpActionResult> Get()
        {
            try
            {
                await _alertsService.SendAlerts();
                return Ok("Alerts were queued to be sent.");
            }
            catch (Exception ex)
            {
                return Ok($"Yup Something Happened: {ex.Message}");
            }
        }

        [HttpGet]
        [Route("parent")]
        public async Task<IHttpActionResult> GetParentAlerts()
        {
            var person = SecurityPrincipal.Current;
            var role = person.Claims.SingleOrDefault(x => x.Type == "role").Value;

            if (role.Equals("Parent", System.StringComparison.InvariantCultureIgnoreCase))
                return Ok(await _alertsService.GetParentAlertTypes(person.PersonUSI));

            return NotFound(); // A Teacher Shouldnt have access
        }


        [HttpGet]
        [Route("parent/{uniqueId}")]
        public async Task<IHttpActionResult> ParentHasReadStudentAlerts(string uniqueId)
        {
            var person = SecurityPrincipal.Current;
            var role = person.Claims.SingleOrDefault(x => x.Type == "role").Value;

            if (role.Equals("Parent", System.StringComparison.InvariantCultureIgnoreCase))
            {
                await _alertsService.ParentHasReadStudentAlerts(person.PersonUniqueId, uniqueId);
                return Ok();
            }

            return NotFound(); // A Teacher Shouldnt have access
        }

        [HttpPost]
        [Route("parent")]
        public async Task<IHttpActionResult> SaveParentAlerts(ParentAlertTypeModel model)
        {
            var person = SecurityPrincipal.Current;
            var role = person.Claims.SingleOrDefault(x => x.Type == "role").Value;

            if (role.Equals("Parent", System.StringComparison.InvariantCultureIgnoreCase))
                return Ok(await _alertsService.SaveParentAlertTypes(model, person.PersonUSI));

            return NotFound(); // A Teacher Shouldnt have access
        }
    }
}
