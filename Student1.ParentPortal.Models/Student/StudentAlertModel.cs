using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Student
{
    public class StudentAlertModel
    {
        public ICollection<StudentParentAssociationModel> StudentParentAssociations { get; set; }
        public int StudentUSI { get; set; }
        public string StudentUniqueId { get; set; }
        public int ValueCount { get; set; }
        public string FirstName { get; set; }
        public string LastSurname { get; set; }
        public ICollection<ParentAlertCourseModel> Courses { get; set; }
        public int ExcusedCount { get; set; }
        public int UnexcusedCount { get; set; }
        public int TardyCount { get; set; }
        public int AbsenceCount => ExcusedCount + UnexcusedCount + TardyCount;
    }

    public class StudentParentAssociationModel
    {
        public int ParentUsi { get; set; }
        public virtual ParentModel Parent { get; set; }
    }

    public class ParentModel
    {
        public ParentModel()
        {
            ParentAlert = new ParentAlertModel();
        }
        public virtual ParentAlertModel ParentAlert { get; set; }
        public string Email { get; set; }
        public string Telephone { get; set; }
        public string SMSDomain { get; set; }
        public string ParentUniqueId { get; set; }
        public string LanguageCode { get; set; }
    }

    public class ParentAlertModel
    {
        public int? PreferredMethodOfContactTypeId { get; set; }
        public ICollection<int> AlertTypeIds { get; set; }
    }

    public class ParentAlertCourseModel {
        public string CourseTitle { get; set; }
        public decimal? GradeNumber { get; set; }
    }

}
