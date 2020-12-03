namespace Student1.ParentPortal.Models.Staff
{
    public class BriefProfileModel
    {
        public int Usi { get; set; }
        public string UniqueId { get; set; }
        public int PersonTypeId { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastSurname { get; set; }
        public string Name => $"{FirstName} {MiddleName} {LastSurname}";
        public string FullName => $"{FirstName} {LastSurname}";
        public string Email { get; set; }
        public string Role { get; set; }
        public string LanguageCode { get; set; }
        public string ImageUrl { get; set; }
        public string FeedbackExternalUrl { get; set; }
        public int? SchoolId { get; set; }
        public int? DeliveryMethodOfContact { get; set; }
        public string IdentificationCode { get; set; }
    }
}
