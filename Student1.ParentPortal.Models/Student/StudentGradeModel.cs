using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Student
{
    public class GradesLevelModel
    {
        public int[] Grades { get; set; }
        public int SkipRows { get; set; }
        public int? PageSize { get; set; }
    }
}
