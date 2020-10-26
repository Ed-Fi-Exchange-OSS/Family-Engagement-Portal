using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Chat;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Models.User;

namespace Student1.ParentPortal.Data.Models
{
    public interface ICommunicationsRepository
    {
        Task<ChatLogHistoryModel> GetThreadByParticipantsAsync(string studentUniqueId, string senderUniqueId, int senderTypeid, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int? unreadMessageCount, int rowsToRetrieve = 15);
        Task<ChatLogItemModel> PersistMessage(ChatLogItemModel model);
        Task<List<UnreadMessageModel>> RecipientUnreadMessages(string recipientUniqueId, int recipientTypeId);
        Task<int> UnreadMessageCount(int studentUsi, string recipientUniqueId, int recipientTypeId, string senderUniqueid, int? senderTypeId);
        Task SetRecipientRead(ChatLogItemModel model);
        Task SetRecipientsRead(string studentUniqueId, string senderUniqueId, int senderTypeid, string recipientUniqueId, int recipientTypeId);
        Task<AllRecipients> GetAllParentRecipients(int? studentUsi, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrieve, string[] validLeadersDescriptors, DateTime today);
        Task<AllRecipients> GetAllStaffRecipients(int? studentUsi, string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrieve, DateTime today);
        Task<List<UnreadMessageModel>> PrincipalRecipientMessages(string recipientUniqueId, int recipientTypeId, int rowsToSkip, int rowsToRetrieve, string searchTerm, bool onlyUnreadMessages);
        Task<int> PrincipalRecipientMessagesCount(string recipientUniqueId, int recipientTypeId, string searchTerm, bool onlyUnreadMessages);
        Task<ParentStudentCountModel> GetFamilyMembersByGradesAndPrograms(int staffUsi, ParentStudentCountFilterModel model, string[] validParentDescriptors, DateTime today);
        Task<List<ParentStudentsModel>> GetParentsByGradeLevelsAndPrograms(string personUniqueId, int[] grades, int[] programs, string[] validParentDescriptors, string[] validEmailTypeDescriptors, DateTime today);
        Task<GroupMessagesQueueLogModel> PersistQueueGroupMessage(GroupMessagesQueueLogModel model);
        Task<GroupMessagesChatLogModel> PersistChatGroupMessage(GroupMessagesChatLogModel model);
        Task<List<GroupMessagesQueueLogModel>> GetGroupMessagesQueuesQueued();
        Task<List<GroupMessagesQueueLogModel>> GetGroupMessagesQueuesQueued(string staffUniqueId, int schoolId, QueuesFilterModel model);
        Task<GroupMessagesQueueLogModel> UpdateGroupMessagesQueue(GroupMessagesQueueLogModel model);
        Task<List<ParentStudentsModel>> GetParentsByGradeLevelsAndSearchTerm(string personUniqueId, string term, GradesLevelModel model, string[] validParentDescriptors, DateTime today);
        Task<GroupMessagesQueueLogModel> GetGroupMessagesQueue(Guid Id);
        Task<List<ParentStudentsModel>> GetParentsByPanrentUsisAndGradeLevels(string personUniqueId, int[] parentUsis, int[] gradeLevels, string[] validParentDescriptors, string[] validEmailTypeDescriptors, DateTime today);
        Task<int> GetParentsByGradeLevelsAndSearchTermCount(string personUniqueId, string term, GradesLevelModel model, string[] validParentDescriptors, DateTime today);
    }
}
