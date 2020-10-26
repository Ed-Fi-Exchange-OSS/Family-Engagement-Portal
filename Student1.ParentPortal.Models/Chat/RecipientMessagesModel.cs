using Student1.ParentPortal.Models.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Chat
{
    public class RecipientMessagesModel
    {
        public List<UnreadMessageModel> Messages { get; set; }
        public int UnreadMessagesCount { get; set; }
        public int RecipientCount { get; set; }
    }
}
