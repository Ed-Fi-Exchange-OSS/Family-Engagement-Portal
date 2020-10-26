using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Shared
{
    public class SchoolYearTypeModel
    {
        public short SchoolYear { get; set; }
        public string SchoolYearDescription { get; set; }
        public bool CurrentSchoolYear { get; set; }
    }
}
