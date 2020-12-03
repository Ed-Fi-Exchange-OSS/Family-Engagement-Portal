using Student1.ParentPortal.Resources.Providers.Configuration;
using System;
using System.Web.Http;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/ApplicationFeatures")]
    public class ApplicationFeaturesController : ApiController
    {
        private readonly IApplicationSettingsProvider _config;

        public ApplicationFeaturesController(IApplicationSettingsProvider config)
        {
            _config = config;
        }

        [AllowAnonymous]
        [HttpGet]
        [Route("UIFeatures")]
        public IHttpActionResult GetFeatures()
        {
            UIFeatures result = new UIFeatures();

            result.OAuthAzure = Convert.ToBoolean(_config.GetSetting("authentication.azure.visible"));
            result.OAuthGoogle = Convert.ToBoolean(_config.GetSetting("authentication.google.visible"));
            result.OAuthHotmail = Convert.ToBoolean(_config.GetSetting("authentication.hotmail.visible"));
            result.OAuthFacebook = Convert.ToBoolean(_config.GetSetting("authentication.facebook.visible"));

            return Ok(result);
        }
    }

    public class UIFeatures
    {
        public bool OAuthAzure { get; set; }
        public bool OAuthGoogle { get; set; }
        public bool OAuthHotmail { get; set; }
        public bool OAuthFacebook { get; set; }
    }
}