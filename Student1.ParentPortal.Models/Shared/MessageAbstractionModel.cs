using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Shared
{
    public class MessageAbstractionModel
    {
        public string SenderName { get; set; }
        public string SenderUniqueId { get; set; }
        public string RecipientUniqueId { get; set; }
        public string RecipientEmail { get; set; }
        public string RecipientTelephone { get; set; }
        public string RecipientTelephoneSMSDomain { get; set; }
        public string Subject { get; set; }
        public string BodyMessage { get; set; }
        public StudentMessageAbstractModel AboutStudent { get; set; }
        public int DelivaryMethod { get; set; }
        public string LanguageCode { get; set; }
    }

    public class StudentMessageAbstractModel 
    {
        public string StudentUniqueId { get; set; }
        public string StudentName { get; set; }
    }
}
