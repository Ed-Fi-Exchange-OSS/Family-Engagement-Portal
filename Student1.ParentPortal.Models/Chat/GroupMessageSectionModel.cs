using Student1.ParentPortal.Models.Staff;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Chat
{
    public class GroupMessageSectionModel
    {
        public StaffSectionModel Section { get; set; }
        public string Message { get; set; }
        public string Subject { get; set; }
    }
}
