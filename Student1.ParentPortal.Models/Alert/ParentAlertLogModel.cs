using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Alert
{
    public class ParentStudentAlertLogModel
    {
        public string ParentUniqueId { get; set; }
        public string StudentUniqueId { get; set; }
        public string Value { get; set; }
        public string AlertTypeName { get; set; }
    }
}
