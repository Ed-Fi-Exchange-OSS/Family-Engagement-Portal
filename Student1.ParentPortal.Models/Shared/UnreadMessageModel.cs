using Student1.ParentPortal.Models.Chat;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Shared
{
    public class UnreadMessageModel
    {
        public string UniqueId { get; set; }
        public int Usi { get; set; }
        public int PersonTypeId { get; set; }
        public int StudentUsi { get; set; }
        public string StudentUniqueId { get; set; }
        public DateTime? OldestMessageDateSent { get; set; } 
        public string StudentFirstName { get; set; }
        public string StudentMiddleName { get; set; }
        public string StudentLastSurname { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastSurname { get; set; }
        public string StudentName => $"{StudentFirstName} {StudentMiddleName} {StudentLastSurname}";
        public string Name => $"{FirstName} {MiddleName} {LastSurname}";
        public int UnreadMessageCount { get; set; }
        public string ImageUrl { get; set; }
        public string RelationToStudent { get; set; }
        public string LanguageCode { get; set; }
    }


    public class RecipientUnreadMessagesModel
    {
        public List<UnreadMessageModel> UnreadMessages { get; set; }
        public int UnreadMessagesCount { get; set; }
    }

    public class RecipientRecentMessagesModel {
        public List<UnreadMessageModel> RecentMessages { get; set; }
        public bool EndOfRecipients { get; set; }
    }

    public class AllRecipientsRequestModel
    {
        public int RowsToSkip { get; set; }
        public int RowsToRetrieve { get; set; }
        public int? StudentUsi { get; set; }
    }
}
