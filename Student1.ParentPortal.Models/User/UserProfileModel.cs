using System;
using System.Collections.Generic;
using Student1.ParentPortal.Models.Shared;

namespace Student1.ParentPortal.Models.User
{
    public class UserProfileModel
    {
        public int Usi { get; set; }
        public string UniqueId { get; set; }
        public int PersonTypeId { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastSurname { get; set; }
        public string Nickname { get; set; }
        public string FunFact { get; set; }
        public string ShortBiography { get; set; }
        public string Biography { get; set; }
        public string ImageUrl { get; set; }
        public int PreferredMethodOfContactTypeId { get; set; }
        public string ReplyExpectations { get; set; }
        public string LanguageCode { get; set; }

        public List<AddressModel> Addresses { get; set; }
        public List<TelephoneModel> TelephoneNumbers { get; set; }
        public List<ElectronicMailModel> ElectronicMails { get; set; }
    }
}
