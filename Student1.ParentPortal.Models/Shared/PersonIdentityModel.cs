using System;

namespace Student1.ParentPortal.Models.Shared
{
    public class PersonIdentityModel
    {
        public int Usi { get; set; }
        public string UniqueId { get; set; }
        public string FirstName { get; set; }
        public string LastSurname { get; set; }
        public string Email { get; set; }
        public string PersonType { get; set; }
        public int PersonTypeId { get; set; }
    }
}
