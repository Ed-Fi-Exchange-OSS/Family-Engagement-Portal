using System;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.User;
using Student1.ParentPortal.Resources.Services;
using Student1.ParentPortal.Resources.Services.Parents;
using Student1.ParentPortal.Web.Security;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/feedback")]
    public class FeedbackController : ApiController
    {
        private readonly IFeedbackService _feedbackService;

        public FeedbackController(IFeedbackService feedbackService)
        {
            _feedbackService = feedbackService;
        }

        [HttpPost]
        [Route("persist")]
        public async Task<IHttpActionResult> PersistFeedback(FeedbackRequestModel model)
        {
            var person = SecurityPrincipal.Current;
            return Ok(await _feedbackService.PersistFeedback(person.PersonUniqueId, person.PersonTypeId, person.FirstName, person.LastSurname, person.Email, model));
        }
    }
}