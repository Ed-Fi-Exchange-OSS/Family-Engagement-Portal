using Student1.ParentPortal.Resources.Providers.Configuration;
using System.Web.Http;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/mobile")]
    public class MobileController : ApiController
    {
        private readonly IApplicationSettingsProvider _settingsProvider;
        public MobileController(IApplicationSettingsProvider settingsProvider) 
        {
            _settingsProvider = settingsProvider;
        }

        [AllowAnonymous]
        [HttpGet]
        [Route("mobileVersion")]
        public IHttpActionResult Get()
        {
            var mobileVersion = _settingsProvider.GetSetting("mobileapp.version.parent");
            return Ok(mobileVersion);
        }

    }
}
