using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Shared
{
    public class LogTypeEnum : Enumeration<LogTypeEnum>
    {
        public static readonly LogTypeEnum Info = new LogTypeEnum(1, "Info");
        public static readonly LogTypeEnum Warning = new LogTypeEnum(2, "Warning");
        public static readonly LogTypeEnum Error = new LogTypeEnum(3, "Error");

        private LogTypeEnum(int value, string displayName) : base(value, displayName)
        {
        }
    }
}
