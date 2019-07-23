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
    }
}
