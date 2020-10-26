using System;

namespace Student1.ParentPortal.Models.Staff
{
    public class StaffSectionModel
    {
        public int SchoolId { get; set; }
        public string ClassPeriodName { get; set; } 
        public string ClassroomIdentificationCode { get; set; } 
        public string LocalCourseCode { get; set; }
        public int TermDescriptorId { get; set; }
        public short SchoolYear { get; set; }
        public string UniqueSectionCode { get; set; }
        public int SequenceOfCourse { get; set; }
        public DateTime? BeginDate { get; set; }
        public string SessionName { get; set; }
        public string CourseTitle { get; set; }
    }
}
