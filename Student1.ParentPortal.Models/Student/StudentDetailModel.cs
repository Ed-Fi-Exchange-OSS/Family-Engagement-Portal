using Student1.ParentPortal.Models.Shared;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Student1.ParentPortal.Models.Student
{
    public class StudentDetailModel
    {
        public StudentDetailModel()
        {
            SuccessTeamMembers = new List<StudentSuccessTeamMember>();
            Attendance = new StudentAttendance();
            Behavior = new StudentBehavior();
            CourseGrades = new StudentCourseGrades();
            MissingAssignments = new StudentMissingAssignments();
            Programs = new List<StudentProgram>();
            Indicators = new List<StudentIndicator>();
            ExternalLinks = new List<StudentExternalLink>();
        }

        public int StudentUsi { get; set; }
        public string StudentUniqueId { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastSurname { get; set; }
        public string Name => $"{FirstName} {MiddleName} {LastSurname}";
        public string Email { get; set; }
        public string Telephone { get; set; }
        public List<string> Races { get; set; }
        public bool HispanicOrLatino { get; set; }
        public string SexType { get; set; }
        public string ImageUrl { get; set; }

        public string CurrentSchool { get; set; }
        public string GradeLevel { get; set; }
        public int UnreadMessageCount { get; set; }
        public List<StudentExternalLink> ExternalLinks { get; set; }
        public StudentOnTrackToGraduate OnTrackToGraduate { get; set; }

        public List<StudentSuccessTeamMember> SuccessTeamMembers { get; set; }
        public List<StudentProgram> Programs { get; set; }
        public List<StudentIndicator> Indicators { get; set; }
        public StudentAttendance Attendance { get; set; }
        public StudentBehavior Behavior { get; set; }
        public StudentCourseGrades CourseGrades { get; set; }
        public StudentMissingAssignments MissingAssignments { get; set; }
        public StudentScheduleEntry Schedule { get; set; }
        public StudentAssessment Assessment{ get; set; }
        public List<AssessmentSubSection> StaarAssessmentHistory { get; set; }
    }

    public class Address
    {
        public string StreetNumberName { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string PostalCode { get; set; }
    }

    public class StudentProgram
    {
        public string ProgramName { get; set; }
        public DateTime BeginDate { get; set; }
    }

    public class StudentIndicator
    {
        public string IndicatorName { get; set; }
        public DateTime? BeginDate { get; set; }
    }

    public class StudentAttendance
    {
        public StudentAttendance()
        {
            ExcusedAttendanceEvents = new List<StudentAttendanceEvent>();
            UnexcusedAttendanceEvents = new List<StudentAttendanceEvent>();
            TardyAttendanceEvents = new List<StudentAttendanceEvent>();
        }

        public DateTime DateAsOf { get; set; }
        public List<StudentAttendanceEvent> ExcusedAttendanceEvents { get; set; }
        public List<StudentAttendanceEvent> UnexcusedAttendanceEvents { get; set; }
        public List<StudentAttendanceEvent> TardyAttendanceEvents { get; set; }
        public List<StudentAttendanceEvent> AbsentAttendanceEvents { get; set; }
        public int AbsenceThresholdDays { get; set; }
        public int YearToDateAbsenceCount { get; set; }
        public string ExcusedInterpretation { get; set; }
        public string UnexcusedInterpretation { get; set; }
        public string TardyInterpretation { get; set; }
        public string AbsentInterpretation { get; set; }
    }

    public class StudentAttendanceEvent
    {
        public DateTime DateOfEvent { get; set; }
        public string EventCategory { get; set; }
        public string EventDescription { get; set; }
        public string Reason { get; set; }
    }

    public class StudentBehavior
    {
        public StudentBehavior()
        {
            DisciplineIncidents = new List<DisciplineIncident>();
        }

        public DateTime DateAsOf { get; set; }
        public int YearToDateDisciplineIncidentCount { get; set; }
        public List<DisciplineIncident> DisciplineIncidents { get; set; }
        public string Interpretation { get; set; }
        public LinkModel ExternalLink { get; set; }
    }

    public class DisciplineIncident
    {
        public DisciplineIncident()
        {
            DisciplineActionsTaken = new List<DisciplineActionTaken>();
        }

        public string IncidentIdentifier { get; set; }
        public DateTime IncidentDate { get; set; }
        public string Description { get; set; }
        public IEnumerable<DisciplineActionTaken> DisciplineActionsTaken { get; set; }
    }

    public class DisciplineActionTaken
    {
        public string DisciplineActionIdentifier { get; set; }
        public string Description { get; set; }
    }

    public class StudentCourseGrades
    {
        public StudentGPA GPA { get; set; }
        public List<StudentCourseSessionTaken> Transcript { get; set; }
        public List<StudentCurrentCourse> CurrentCourses { get; set; }
        public StudentCurrentGradeAverage CurrentGradeAverage { get; set; }
        public LinkModel ExternalLink { get; set; }
    }

    public class StudentGPA
    {
        public decimal? GPA { get; set; }
        public string Interpretation { get; set; }
        public double NationalAverageGPA { get; set; }
    }

    public class StudentCurrentGradeAverage
    {
        /// <summary>
        /// The year to date average grade the student has obtained.
        /// </summary>
        public decimal GradeAverage { get; set; }
        /// <summary>
        /// The actual evaluation of the grade average the student has obtained.
        /// </summary>
        /// <example>Excellent, Very good, Good, Fair, Poor</example>
        /// <remarks>This gets evaluated from the custom parameters JSON file.</remarks>
        public string Evaluation { get; set; }
    }

    public class StudentCurrentCourse
    {
        public string CourseTitle { get; set; }
        public string LocalCourseCode { get; set; }
        public string CourseCode { get; set; }
        public string ClassPeriodName { get; set; }
        public string StaffUniqueId { get; set; }
        public int TeacherUsi { get; set; }
        public int PersonTypeId { get; set; }
        public string TeacherName { get; set; }
        public string ImageUrl { get; set; }
        public List<StudentCourseGrade> GradesByGradingPeriod { get; set; }
        public List<StudentCourseGrade> GradesByExam { get; set; }
        public List<StudentCourseGrade> GradesBySemester { get; set; }
        public List<StudentCourseGrade> GradesByFinal { get; set; } 

    }

    public class StudentCourseGrade
    {
        public string GradeType { get; set; }
        public string GradingPeriodType { get; set; }
        public decimal? NumericGradeEarned { get; set; }
        public string LetterGradeEarned { get; set; }
        public string GradeInterpretation { get; set; }
    }

    public class StudentCourseSessionTaken
    {
        public int SchoolYearTaken { get; set; }
        public string GradeLevelTaken { get; set; }
        public int GradeLevelIndex { get; set; }
        public string SessionName { get; set; }
        public List<StudentCourse> Courses { get; set; }
    }

    public class StudentCourse  
    {
        public string CourseCode { get; set; }
        public string CourseTitle { get; set; }
        public int SchoolYearTaken { get; set; }
        public int GradeLevelIndex { get; set; }
        public string GradeLevelTaken { get; set; }
        public string AcademicSubjectDescription { get; set; }
        public string AttemptResultTypeDescription { get; set; }
        public decimal CreditsEarned { get; set; }
        public decimal? FinalNumericGradeEarned { get; set; }
        public string FinalLetterGradeEarned { get; set; }
        public string SessionName { get; set; }
    }

    public class StudentSuccessTeamMember
    {
        public int Id { get; set; }
        public int StudentUsi { get; set; }
        public Guid Guid { get; set; }
        public string UniqueId { get; set; }
        public int PersonTypeId { get; set; }
        public string PersonalTitlePrefix { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastSurname { get; set; }
        public string Name => $"{FirstName} {MiddleName} {LastSurname}";
        public string SexType { get; set; }
        public string ImageUrl { get; set; }
        public string RelationToStudent { get; set; }
        public string HighestCompletedLevelOfEducation { get; set; }
        public decimal? YearsOfTeachingExperience { get; set; }
        public bool HighlyQualifiedTeacher { get; set; }
        public string ShortBiography { get; set; }
        public IEnumerable<string> Languages { get; set; }
        public IEnumerable<string> Credentials { get; set; }
        public bool EmergencyContactStatus { get; set; }
        public IEnumerable<string> Emails { get; set; }
        public IEnumerable<string> Telephone { get; set; }
        public IEnumerable<Address> Addresses { get; set; }
        public string GradeLevel { get; set; }
        public string NameOfInstitution { get; set; }
        public bool ChatEnabled { get; set; }
        public int UnreadMessageCount { get; set; }
    }

    public class StudentMissingAssignments
    {
        public int MissingAssignmentCount { get { return AssignmentSections.Sum(x => x.Assignments.Count()); } }
        public List<StudentAssignmentSection> AssignmentSections { get; set; }
        public string Interpretation { get; set; }
        public LinkModel ExternalLink { get; set; }
    }

    public class StudentAssignment
    {
        public string LocalCourseCode { get; set; }
        public string LocalCourseTitle { get; set; }
        public string CourseTitle { get; set; }
        public string AssignmentTitle { get; set; }
        public string AssignmentDescription { get; set; }
        public DateTime DateAssigned { get; set; }
        public int DaysLate { get { return (DateTime.Now - DateAssigned).Days; } }
    }

    public class StudentAssignmentSection
    {
        public IEnumerable<StudentAssignment> Assignments { get; set; }
        public string StaffFirstName { get; set; }
        public string StaffMiddleName { get; set; }
        public string StaffLastSurName { get; set; }
        public string StaffUniqueId { get; set; }
        public int  PersonTypeId { get; set; }
        public string StaffFullname => $"{StaffFirstName} {StaffMiddleName} {StaffLastSurName}";
        public string CourseTitle { get; set; }
        public string LocalCourseTitle { get; set; }
    }
    public class StudentScheduleEntry
    {
        public List<ScheduleDay> Days { get; set; }
    }

    public class ScheduleDay
    {
        public DateTime Date { get; set; }
        public string ScheduleName { get; set; }
        public List<ScheduleEvent> Events { get; set; }
    }

    public class ScheduleItem
    {
        public string CourseTitle { get; set; }
        public string BellScheduleName { get; set; }
        public DateTime Date { get; set; }
        public TimeSpan StartTime { get; set; }
        public TimeSpan EndTime { get; set; }
        public string ClassroomIdentificationCode { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastSurname { get; set; }
        public string Name => $"{FirstName} {MiddleName} {LastSurname}";
    }

    public class ScheduleEvent
    {
        public string ClassroomIdentificationCode { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastSurname { get; set; }
        public string Name => $"{FirstName} {MiddleName} {LastSurname}";
        public string ScheduleName { get; set; }
        public string CourseTitle { get; set; }
        public DateTime Date { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public bool IsToday =>
            Date.Year == DateTime.Today.Year
            && Date.Month == DateTime.Today.Month
            && Date.Day == DateTime.Today.Day;

        public double DurationInMinutes { get { return (EndTime - StartTime).TotalMinutes; } }
    }

    public class StudentAssessment
    {
        public StudentAssessment()
        {
            Assessments = new List<Assessment>();
        }
        public List<Assessment> Assessments { get; set; }
    }

    public class AssessmentRecord
    {
        public string Identifier { get; set; }
        public string Title { get; set; }
        public DateTime AdministrationDate { get; set; }
        public string ShortDescription { get; set; }
        public int? MaxRawScore { get; set; }
        public string Result { get; set; }
        public string PerformanceLevelMet { get; set; }
        public string GradeLevel { get; set; }
    }

    public class Assessment
    {
        public Assessment()
        {
            SubSections = new List<AssessmentSubSection>();
        }

        public string Identifier { get; set; }
        public string Title { get; set; }
        public DateTime AdministrationDate { get; set; }
        public string ShortDescription { get; set; }
        public int? MaxRawScore { get; set; }
        public int TotalScore { get { return SubSections.Sum(x=>x.Score); } }
        public int SubsectionCount { get { return SubSections.Count(); } }
        public List<AssessmentSubSection> SubSections { get; set; }
        public string ExternalLink { get; set; }
    }

    public class AssessmentSubSection
    {
        public string Title { get; set; }
        public int Score { get; set; }
        public string PerformanceLevelMet { get; set; }
        public string GradeLevel { get; set; }
    }

    public class StudentOnTrackToGraduate
    {
        public bool? OnTrackToGraduate { get; set; }
        public string Interpretation { get; set; }
    }

    public class StudentExternalLink
    {
        public string Url { get; set; }
        public string UrlType { get; set; }
    }
}
