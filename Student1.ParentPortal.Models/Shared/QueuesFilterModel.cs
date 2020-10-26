using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Shared
{
    public class QueuesFilterModel
    {
        public DateTime? From { get; set; }
        public DateTime? To { get; set; }
        public int?[] GradeLevels { get; set; }
        public int?[] Programs { get; set; }
        public string SearchTerm { get; set; }
    }
}
