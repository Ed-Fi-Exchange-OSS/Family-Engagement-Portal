namespace Student1.ParentPortal.Models.Student
{
    public class StudentCampusLeaderModel
    {
        public StudentCampusLeaderModel()
        {
        }
        public int StudentUsi { get; set; }
        public string StudentUniqueId { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastSurname { get; set; }
        public string StudentCompleteName => $"{FirstName} {MiddleName} {LastSurname}";
        public string GradeLevel { get; set; }
        public string CurrentSchool { get; set; }
        public string TeacherFirstName { get; set; }
        public string TeacherMiddleName { get; set; }
        public string TeacherLastSurname { get; set; }
        public string TeacherCompleteName => $"{TeacherFirstName} {TeacherMiddleName} {TeacherLastSurname}";
        public int StaffUsi { get; set; }
        public string StaffUniqueId { get; set; }
    }
}
