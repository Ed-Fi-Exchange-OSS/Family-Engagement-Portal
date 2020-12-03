using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Student;

namespace Student1.ParentPortal.Models.Staff
{
    public class ParentStudentTermFilterModel
    {
        public string SearchTerm { get; set; }
        public GradesLevelModel GradeLevels { get; set; }
        public int SchoolId { get; set; }
    }
}
