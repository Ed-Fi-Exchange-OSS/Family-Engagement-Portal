using System;
using System.Collections.Generic;
using System.Linq;

namespace Student1.ParentPortal.Models.Chat
{
    public class RecipientModel
    {
        public RecipientModel()
        {
            RelationsToStudent = new List<string>();
        }

        public int Usi { get; set; }
        public string UniqueId { get; set; }
        public string FirstName { get; set; }
        public string LastSurname { get; set; }
        public string FullName => $"{FirstName} {LastSurname}";
        public string Email { get; set; }
        public int PersonTypeId { get; set; }
        public string ImageUrl { get; set; }
        public List<string> RelationsToStudent { get; set; }
        public int UnreadMessageCount { get; set; }
    }

    public class StudentRecipients
    {
        public int StudentUsi { get; set; }
        public string ImageUrl { get; set; }
        public string StudentUniqueId { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastSurname { get; set; }
        public List<string> RelationsToStudent { get; set; }
        public string FullName => $"{FirstName} {MiddleName} {LastSurname}";
        public List<RecipientModel> Recipients { get; set; }
        public int UnreadMessageCount => Recipients.Sum(x => x.UnreadMessageCount);
        public DateTime? MostRecentMessageDate { get; set; }
    }

    public class AllRecipients
    {
        public List<StudentRecipients> StudentRecipients { get; set; }
        public bool EndOfData { get; set; }
    }
}
