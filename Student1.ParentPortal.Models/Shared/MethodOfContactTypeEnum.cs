using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Shared
{
    public class MethodOfContactTypeEnum : Enumeration<MethodOfContactTypeEnum>
    {
        public static readonly MethodOfContactTypeEnum Email = new MethodOfContactTypeEnum(1, "Electronic Email");
        public static readonly MethodOfContactTypeEnum SMS = new MethodOfContactTypeEnum(2, "Text Message (SMS)");
        public static readonly MethodOfContactTypeEnum Notification = new MethodOfContactTypeEnum(3, "Push Notifications (Mobile app)");

        private MethodOfContactTypeEnum(int value, string displayName) : base(value, displayName)
        {
        }
    }
}
