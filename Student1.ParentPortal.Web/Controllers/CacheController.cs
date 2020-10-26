using Student1.ParentPortal.Resources.Providers.Cache;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/cache")]
    public class CacheController : ApiController
    {
        private readonly ICacheProvider _cacheProvider;
        public CacheController(ICacheProvider cacheProvider) 
        {
            _cacheProvider = cacheProvider;
        }

        [AllowAnonymous]
        [HttpGet]
        [Route("clear")]
        public IHttpActionResult Get()
        {
            _cacheProvider.Clear();
            return Ok("Cache cleared successfully.");
        }
    }
}
