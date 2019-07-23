using System.Threading.Tasks;
using System.Web.Http;
using Student1.ParentPortal.Resources.Services.Parents;
using Student1.ParentPortal.Web.Security;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/parents")]
    public class ParentsController : ApiController
    {
        private readonly IParentsService _parentssService;

        public ParentsController(IParentsService parentService)
        {
            _parentssService = parentService;
        }

        [Route("students")]
        [HttpGet]
        public async Task<IHttpActionResult> GetStudentsAssociatedWithParent()
        {
            var parent = SecurityPrincipal.Current;
            var model = await _parentssService.GetStudentsAssociatedWithParentAsync(parent.PersonUSI, parent.PersonUniqueId, parent.PersonTypeId);

            if (model == null)
                return NotFound();

            return Ok(model);
        }
    }
}
