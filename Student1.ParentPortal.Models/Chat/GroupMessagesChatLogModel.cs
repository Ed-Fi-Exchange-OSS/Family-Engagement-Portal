using Student1.ParentPortal.Models.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Chat
{
    public class GroupMessagesChatLogModel
    {
        public Guid GroupMessagesLogId { get; set; }
        public Guid ChatLogId { get; set; }
        public GroupMessagesStatusEnum Status { get; set; }
        public string ErrorMessage { get; set; }
    }
}
