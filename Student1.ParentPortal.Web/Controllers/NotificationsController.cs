using Student1.ParentPortal.Models.Notifications;
using Student1.ParentPortal.Resources.Services.Notifications;
using Student1.ParentPortal.Web.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/notifications")]
    public class NotificationsController : ApiController
    {
        private readonly INotificationsService _notificationsService;
        public NotificationsController(INotificationsService notificationsService)
        {
            _notificationsService = notificationsService;
        }

        [HttpPost]
        [Route("setIdentifier")]
        public async Task<IHttpActionResult> SetNotificationsIdentifier(NotificationsIdentifierModel model)
        {
            var person = SecurityPrincipal.Current;
            var role = person.Role;
            model.PersonType = role;
            await _notificationsService.PersistNotificationToken(model);
            return Ok(true);
        }
    }
}
