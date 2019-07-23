namespace Student1.ParentPortal.Models.Student
{
    public class StudentSummary
    {
        public int StudentUsi { get; set; }
        public string StudentUniqueId { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastSurname { get; set; }
        public string GradeLevel { get; set; }
        public string SexType { get; set; }
        public int AbsenceCount { get; set; }
        public decimal CourseAverage { get; set; }
        public int DisciplineIncidentCount { get; set; }
        public int MissingassignmentCount { get; set; }
        public string CourseAverageInterpretation { get; set; }
        public string DisciplineIncidentInterpretation { get; set; }
        public string MissingAssigmentInterpretation { get; set; }
        public string AbsenceInterpretation { get; set; }
        public decimal? Gpa { get; set; }
        public string GpaInterpretation { get; set; }
    }
}
