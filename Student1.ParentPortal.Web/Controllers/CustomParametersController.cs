using Student1.ParentPortal.Resources.Providers.Configuration;
using System.Web.Http;

namespace Student1.ParentPortal.Web.Controllers
{
    public class CustomParametersController : ApiController
    {
        private readonly ICustomParametersProvider _customParametersProvider;

        public CustomParametersController(ICustomParametersProvider customParametersProvider)
        {
            _customParametersProvider = customParametersProvider;
        }

        // GET: api/CustomParameters
        [AllowAnonymous]
        public IHttpActionResult Get()
        {
            var model = _customParametersProvider.GetParameters();
            return Ok(model);
        }
    }
}
