using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Management;
using Student1.ParentPortal.Resources.Services.Application;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/ApplicationOffline")]
    public class ApplicationOfflineController : ApiController
    {
        private readonly IApplicationService _applicationService;

        public ApplicationOfflineController(IApplicationService applicationService)
        {
            _applicationService = applicationService;
        }

        [AllowAnonymous]
        [HttpGet]
        public async Task<IHttpActionResult> Get()
        {
            var model = await _applicationService.IsApplicationOfflineAsync();
            return Ok(model);
        }
    }
}