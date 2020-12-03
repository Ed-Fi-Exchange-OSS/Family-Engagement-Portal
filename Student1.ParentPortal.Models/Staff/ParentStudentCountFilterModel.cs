using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Staff
{
    public class ParentStudentCountFilterModel
    {
        public int[] Grades { get; set; }
        public int[] Programs { get; set; }
        public int SchoolId { get; set; }
    }
}
