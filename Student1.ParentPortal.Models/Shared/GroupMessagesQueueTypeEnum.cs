using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Shared
{
    public class GroupMessagesQueueTypeEnum : Enumeration<GroupMessagesQueueTypeEnum>
    {
        public static readonly GroupMessagesQueueTypeEnum Group = new GroupMessagesQueueTypeEnum(1, "Group");
        public static readonly GroupMessagesQueueTypeEnum IndividualGroup = new GroupMessagesQueueTypeEnum(2, "Individual Group");

        private GroupMessagesQueueTypeEnum(int value, string displayName) : base(value, displayName) 
        { }

    }
}
