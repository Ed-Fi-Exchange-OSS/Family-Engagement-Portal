using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Staff
{
    public class TeacherStudentsRequestModel
    {
       public StaffSectionModel Section { get; set; }
       public string StudentName { get; set; } 
    }
}
