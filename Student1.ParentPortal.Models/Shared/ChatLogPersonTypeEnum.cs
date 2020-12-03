using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Shared
{
    public class ChatLogPersonTypeEnum : Enumeration<ChatLogPersonTypeEnum>
    {
        public static readonly ChatLogPersonTypeEnum Parent = new ChatLogPersonTypeEnum(1, "Parent");
        public static readonly ChatLogPersonTypeEnum Staff = new ChatLogPersonTypeEnum(2, "Staff");
        public static readonly ChatLogPersonTypeEnum Student = new ChatLogPersonTypeEnum(3, "Student");

        private ChatLogPersonTypeEnum(int value, string displayName) : base(value, displayName)
        {
        }
    }
}
