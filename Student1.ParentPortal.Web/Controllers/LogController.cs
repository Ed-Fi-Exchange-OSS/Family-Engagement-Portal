using System.Threading.Tasks;
using System.Web.Http;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Resources.Providers.Logger;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/log")]
    public class LogController : ApiController
    {
        private readonly ILogger _logger;

        public LogController(ILogger logger)
        {
            _logger = logger;
        }

        [AllowAnonymous]
        [HttpPost]
        [Route("error")]
        public async Task<IHttpActionResult> PostError(LogRequestModel model)
        {
            await _logger.LogErrorAsync(model.Message);
            return Ok();
        }

        [AllowAnonymous]
        [HttpPost]
        [Route("info")]
        public async Task<IHttpActionResult> PostInfo(LogRequestModel model)
        {
            await _logger.LogInformationAsync(model.Message);
            return Ok();
        }

        [AllowAnonymous]
        [HttpPost]
        [Route("warning")]
        public async Task<IHttpActionResult> PostWarning(LogRequestModel model)
        {
            await _logger.LogWarningAsync(model.Message);
            return Ok();
        }
    }
}