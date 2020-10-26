using System;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Http;
using Student1.ParentPortal.Models.Chat;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Resources.Services.Communications;
using Student1.ParentPortal.Resources.Services.Notifications;
using Student1.ParentPortal.Web.Hubs;
using Student1.ParentPortal.Web.Security;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/communications")]
    public class CommunicationsController : ApiController
    {
        private readonly ICommunicationsService _communicationsService;
        private readonly INotificationsService _notificationsService;

        public CommunicationsController(ICommunicationsService communicationsService, INotificationsService notificationsService)
        {
            _communicationsService = communicationsService;
            _notificationsService = notificationsService;
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
                return Ok(await _communicationsService.GetAllParentRecipients(request.StudentUsi, person.PersonUniqueId, person.PersonTypeId, request.RowsToSkip, request.RowsToRetrieve));


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

            await _notificationsService.SendNotificationAsync(chatLogItemModel);
            ChatHub.UpdateClients(returnModel);
            return Ok(returnModel);
        }

        [HttpPost, Route("groupMessages")]
        public async Task<IHttpActionResult> GroupMessages(GroupMessageSectionModel groupMessageSectionModel)
        {
            var sender = SecurityPrincipal.Current;
            await _communicationsService.SendSectionGroupMessage(groupMessageSectionModel, sender.PersonUSI, sender.PersonUniqueId);
            return Ok();
        }

        [HttpPost, Route("families/calculate/section")]
        public async Task<IHttpActionResult> CalculateFamiliesPerSection(TeacherStudentsRequestModel groupMessageSectionModel)
        {
            var sender = SecurityPrincipal.Current;
            var model  = await _communicationsService.GetFamilyMemberCountBySection(sender.PersonUSI, groupMessageSectionModel);
            return Ok(model);
        }

        [HttpPost, Route("groupMessages/principals")]
        public async Task<IHttpActionResult> GroupMessages(GroupMessagePrincipalModel groupMessageSectionModel)
        {
            var sender = SecurityPrincipal.Current;
            await _communicationsService.SendPrincipalGroupMessage(groupMessageSectionModel, sender.PersonUSI, sender.PersonUniqueId);
            return Ok();
        }

        [HttpPost, Route("groupMessages/individual/principals")]
        public async Task<IHttpActionResult> GroupMessages(IndividualMessagePrincipalModel groupMessageSectionModel)
        {
            var sender = SecurityPrincipal.Current;
            await _communicationsService.SendPrincipalIndividualGroupMessage(groupMessageSectionModel, sender.PersonUSI, sender.PersonUniqueId);
            return Ok();
        }

        [HttpPost, Route("recipient/principals")]
        public async Task<IHttpActionResult> PrincipalRecipientMessages(RecipientUnreadPrincipalMessagesModel recipientUnreadPrincipalMessagesModel)
        {
            var person = SecurityPrincipal.Current;
            return Ok(await _communicationsService.PrincipalRecipientMessages(person.PersonUniqueId, 
                                                                                    person.PersonTypeId, 
                                                                                    recipientUnreadPrincipalMessagesModel.RowsToSkip, 
                                                                                    recipientUnreadPrincipalMessagesModel.RowsToRetrive, 
                                                                                    recipientUnreadPrincipalMessagesModel.SearchTerm,
                                                                                    recipientUnreadPrincipalMessagesModel.OnlyUnreadMessages));
        }

        [Route("families/calculate")]
        [HttpPost]
        public async Task<IHttpActionResult> CalculateFamiliesPerCampus(ParentStudentCountFilterModel request)
        {
            var campusLeader = SecurityPrincipal.Current;
            var model = await _communicationsService.GetFamilyMemberCountByCampusGradeLevelAndProgram(campusLeader.PersonUSI, request);

            if (model == null)
                return NotFound();

            return Ok(model);
        }

        [Route("families/search")]
        [HttpPost]
        public async Task<IHttpActionResult> GetParentStudentByTermAndGradeLevel(ParentStudentTermFilterModel parentStudentTermFilter)
        {
            var campusLeader = SecurityPrincipal.Current;
            var model = await _communicationsService.GetParentStudentByTermAndGradeLevel(campusLeader.PersonUniqueId, parentStudentTermFilter.SearchTerm, parentStudentTermFilter.GradeLevels);

            if (model == null)
                return NotFound();

            return Ok(model);
        }

        [Route("families/count")]
        [HttpPost]
        public async Task<IHttpActionResult> GetParentStudentByTermAndGradeLevelCount(ParentStudentTermFilterModel parentStudentTermFilter)
        {
            var campusLeader = SecurityPrincipal.Current;
            var model = await _communicationsService.GetParentStudentByTermAndGradeLevelCount(campusLeader.PersonUniqueId, parentStudentTermFilter.SearchTerm, parentStudentTermFilter.GradeLevels);

            if (model == null)
                return NotFound();

            return Ok(model);
        }

        [AllowAnonymous]
        [HttpGet]
        [Route("groupMessages/send")]
        public async Task<IHttpActionResult> SendGroupMessages() 
        {
            try
            {
                await _communicationsService.SendGroupMessages();
                return Ok("We have sent the queued group messages.");
            }
            catch (Exception ex)
            {
                return Ok($"Yup Something Happened: {ex.Message}");
            }
        }

        [Route("groupMessages/{schoolId}/queue")]
        [HttpPost]
        public async Task<IHttpActionResult> GetGroupMessagesQueue(int schoolId, QueuesFilterModel queuesFilterModel) 
        {
            var campusLeader = SecurityPrincipal.Current;
            var model = await _communicationsService.GetGroupMessagesQueues(campusLeader.PersonUniqueId, schoolId, queuesFilterModel);

            if (model == null)
                return NotFound();

            return Ok(model);
        }
    }
}
