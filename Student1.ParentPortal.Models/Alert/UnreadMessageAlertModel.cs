using Student1.ParentPortal.Models.Student;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Alert
{
    public class UnreadMessageAlertModel
    {
        public string FirstName { get; set; }
        public string LastSurname { get; set; }
        public int UnreadMessageCount { get; set; }
        public string Email { get; set; }
        public string Telephone { get; set; }
        public string SMSDomain { get; set; }
        public int? PreferredMethodOfContactTypeId { get; set; }
        public ICollection<int> AlertTypeIds { get; set; }
        public string PersonUniqueId { get; set; }
        public string PersonType { get; set; }
        public string LanguageCode { get; set; }
    }
}
