using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Chat
{
    public class GroupMessagePrincipalModel
    {
        public int SchoolId { get; set; }
        public int[] GradeLevels { get; set; }
        public int[] Programs { get; set; }
        public string Message { get; set; }
        public string Subject { get; set; }
        public string Audience { get; set; }
    }
}
