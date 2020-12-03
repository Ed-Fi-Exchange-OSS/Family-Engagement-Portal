using System;

namespace Student1.ParentPortal.Models.Shared
{
    public class PersonBriefModel
    {
        public int Usi { get; set; }
        public string UniqueId { get; set; }
        public int PersonTypeId { get; set; }
        public string FirstName { get; set; }
        public string LastSurname { get; set; }
        public string FullName => $"{FirstName} {LastSurname}";
        public string ImageUrl { get; set; }
        public string IdentificationCode { get; set; }


        public string Role { get; set; }
        public string LanguageCode { get; set; }
        public string FeedbackExternalUrl { get; set; }
        public int? SchoolId { get; set; }
        public int? DeliveryMethodOfContact { get; set; }
    }
}
