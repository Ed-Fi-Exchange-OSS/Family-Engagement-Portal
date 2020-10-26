using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Shared
{
    public class GroupMessagesStatusEnum : Enumeration<GroupMessagesStatusEnum>
    {
        public static readonly GroupMessagesStatusEnum Queued = new GroupMessagesStatusEnum(1, "queued");
        public static readonly GroupMessagesStatusEnum Processing = new GroupMessagesStatusEnum(2, "processing");
        public static readonly GroupMessagesStatusEnum Sent = new GroupMessagesStatusEnum(3, "sent");
        public static readonly GroupMessagesStatusEnum Error = new GroupMessagesStatusEnum(4, "error");

        private GroupMessagesStatusEnum(int value, string displayName) : base(value, displayName) 
        { }
    }
}
