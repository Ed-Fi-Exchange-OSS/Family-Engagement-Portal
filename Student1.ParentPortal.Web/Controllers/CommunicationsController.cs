using System.Linq;
using System.Threading.Tasks;
using System.Web.Http;
using Student1.ParentPortal.Models.Chat;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Resources.Services.Communications;
using Student1.ParentPortal.Web.Hubs;
using Student1.ParentPortal.Web.Security;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/communications")]
    public class CommunicationsController : ApiController
    {
        private readonly ICommunicationsService _communicationsService;

        public CommunicationsController(ICommunicationsService communicationsService)
        {
            _communicationsService = communicationsService;
        }

        [HttpPost, Route("thread")]
        public async Task<IHttpActionResult> GetChatThread(ChatThreadRequestModel request)
        {
            var sender = SecurityPrincipal.Current;

            var model = await _communicationsService.GetConversationAsync(request.StudentUsi, sender.PersonUniqueId, sender.PersonTypeId, request.RecipientUniqueId, request.RecipientTypeId, request.RowsToSkip, request.UnreadMessageCount);

            if (model == null)
                return NotFound();

            return Ok(model);
        }

        [HttpPost, Route("unreadCount")]
        public async Task<IHttpActionResult> UnreadMessageCount(ChatThreadRequestModel request)
        {
            var recipient = SecurityPrincipal.Current;

            var count = await _communicationsService.UnreadMessageCount(request.StudentUsi, recipient.PersonUniqueId, recipient.PersonTypeId, request.SenderUniqueId, request.SenderTypeId);

            return Ok(count);
        }

        [HttpGet, Route("recipientUnread")]
        public async Task<IHttpActionResult> RecipientUnreadMessages()
        {
            var person = SecurityPrincipal.Current;
            var role = person.Claims.SingleOrDefault(x => x.Type == "role").Value;

            return Ok(await _communicationsService.RecipientUnreadMessages(person.PersonUniqueId, person.PersonTypeId));
        }

        [HttpPost, Route("allRecipients")]
        public async Task<IHttpActionResult> RecipientRecentMessages(AllRecipientsRequestModel request)
        {
            var person = SecurityPrincipal.Current;

            var role = person.Claims.SingleOrDefault(x => x.Type == "role").Value;

            if (role.Equals("Parent", System.StringComparison.InvariantCultureIgnoreCase))
                return Ok(await _communicationsService.GetAllParentRecipients(request.StudentUsi,person.PersonUniqueId, person.PersonTypeId, request.RowsToSkip, request.RowsToRetrieve));


            return Ok(await _communicationsService.GetAllStaffRecipients(request.StudentUsi, person.PersonUniqueId, person.PersonTypeId, request.RowsToSkip, request.RowsToRetrieve));
        }

        [HttpPost, Route("recipientRead")]
        public async Task<IHttpActionResult> SetRecipientRead(ChatLogItemModel chatLogItemModel)
        {
            var recipient = SecurityPrincipal.Current;

            chatLogItemModel.RecipientUniqueId = recipient.PersonUniqueId;
            chatLogItemModel.RecipientTypeId = recipient.PersonTypeId;

            await _communicationsService.SetRecipientRead(chatLogItemModel);

            return Ok();
        }

        // NOTE: The rest of the methods are hosted in the CharHub SignalR hub.

        [HttpPost, Route("persist"), AllowAnonymous]
        public async Task<IHttpActionResult> PersistMessage(ChatLogItemModel chatLogItemModel)
        {
            var sender = SecurityPrincipal.Current;

            chatLogItemModel.SenderUniqueId = sender.PersonUniqueId;
            chatLogItemModel.SenderTypeId = sender.PersonTypeId;

            var returnModel = await _communicationsService.PersistMessage(chatLogItemModel);

            // If everything good then update clients
            if (returnModel == null)
                return NotFound();

            ChatHub.UpdateClients(returnModel);
            return Ok(returnModel);
        }

       
    }
}
