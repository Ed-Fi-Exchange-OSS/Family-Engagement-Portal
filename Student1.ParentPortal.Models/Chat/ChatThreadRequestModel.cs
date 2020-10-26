using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Chat
{
    public class ChatThreadRequestModel
    {
        public int StudentUsi { get; set; }
        public string RecipientUniqueId { get; set; }
        public int RecipientTypeId { get; set; }
        public string SenderUniqueId { get; set; }
        public int? SenderTypeId { get; set; }
        public int RowsToSkip { get; set; }
        public int? UnreadMessageCount { get; set; }
    }
}
