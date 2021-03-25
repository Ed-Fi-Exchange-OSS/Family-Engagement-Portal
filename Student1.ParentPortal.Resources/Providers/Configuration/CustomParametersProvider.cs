using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Web;

namespace Student1.ParentPortal.Resources.Providers.Configuration
{
    public interface ICustomParametersProvider
    {
        CustomParameters GetParameters();
    }
    public class CustomParametersProvider : ICustomParametersProvider
    {
        public CustomParameters GetParameters()
        {
            var version = ConfigurationManager.AppSettings["application.ed-fi.version"];
            var pathToJson = HttpContext.Current.Server.MapPath($"~/customizableParameters{version}.json");
            return JsonConvert.DeserializeObject<CustomParameters>(File.ReadAllText(pathToJson));
        }
    }
    /* Classes below are generated with http://json2csharp.com/ */
    // To regenerate: 
    //  - Copy and paste JSON from the root ~.Web/customizableParameters.json file.
    //  - Rename "RootObject" to "CustomParameters"

    public class CustomParameters
    {
        public Attendance attendance { get; set; }
        public Behavior behavior { get; set; }
        public CourseGrades courseGrades { get; set; }
        public Assignments assignments { get; set; }
        public List<Assessment> assessments { get; set; }
        public Assessment staarAssessmentHistory { get; set; }
        public GraduationReadiness graduationReadiness { get; set; }
        public List<ExternalLink> studentProfileExternalLinks { get; set; }
        public Descriptors descriptors { get; set; }
        public string feedbackExternalUrl { get; set; }
        public string[] mostCommonLanguageCodes { get; set; }
        public List<Page> featureToggle { get; set; }
        public List<Assessment> arcAssessments { get; set; }
        public List<Assessment> assessmentIndicators { get; set; }
        public List<Assessment> starAssessments { get; set; }
        public List<Assessment> accessAssessments { get; set; }
        public AssessmentPerformanceLevel assessmentPerformanceLevel { get; set; }

        public List<CanDoDescriptor> canDoDescriptors { get; set; }
    }

    public class AssessmentPerformanceLevel
    {
        public List<ThresholdRule<string>> thresholdRules { get; set; }
    }

    public class ThresholdRule<T>
    {
        public string interpretation { get; set; }
        public string @operator { get; set; }
        public T value { get; set; }
    }

    public class Attendance
    {
        public AttendanceType ADA { get; set; }
        public AttendanceType periodLevelAttendance { get; set; }
    }

    public class AttendanceType
    {
       public int maxAbsencesCountThreshold { get; set; }
       public AttendanceCategory excused { get; set; }
       public AttendanceCategory unexcused { get; set; }
       public AttendanceCategory tardy { get; set; }
    }

    public class AttendanceCategory
    {
        public int maxAbsencesCountThreshold { get; set; }
        public int alertThreshold { get; set; }
        public List<ThresholdRule<int>> thresholdRules { get; set; }
    }

    public class Behavior
    {
        public int maxDisciplineIncidentsCountThreshold { get; set; }
        public int alertThreshold { get; set; }
        public List<ThresholdRule<int>> thresholdRules { get; set; }
        public ExternalLink linkToSystemWithDetails { get; set; }
    }

    public class Gpa
    {
        public double nationalAverage { get; set; }
        public List<ThresholdRule<decimal>> thresholdRules { get; set; }
    }

    public class CourseAverage
    {
        public int alertThreshold { get; set; }
        public List<ThresholdRule<decimal>> thresholdRules { get; set; }
    }

    public class CourseGrades
    {
        public Gpa gpa { get; set; }
        public CourseAverage courseAverage { get; set; }
        public ExternalLink linkToSystemWithDetails { get; set; }
    }

    public class Assignments
    {
        public int alertThreshold { get; set; }
        public int maxAssigmentsCountThreshold { get; set; }
        public List<ThresholdRule<int>> thresholdRules { get; set; }
        public ExternalLink linkToSystemWithDetails { get; set; }
    }

    public class Assessment
    {
        public string title { get; set; }
        public List<string> assessmentIdentifiers { get; set; }
        public string assessmentReportingMethodTypeDescriptor { get; set; }
        public string shortDescription { get; set; }
        public string externalLink { get; set; }
        public bool getPerformanceLevel { get; set; }
        public string assessmentReportingMethodTypeDescriptorProficiency { get; set; }
    }

    public class GraduationReadiness
    {
        public List<ThresholdRule<bool>> thresholdRules { get; set; }
    }

    public class ExternalLink
    {
        public string title { get; set; }
        public string url { get; set; }
        public string linkText { get; set; }
    }

    public class Descriptors
    {
        public string excusedAbsenceDescriptorCodeValue { get; set; }
        public string unexcusedAbsenceDescriptorCodeValue { get; set; }
        public string tardyDescriptorCodeValue { get; set; }
        public string absentDescriptorCodeValue { get; set; }
        public string[] gradeBookMissingAssignmentTypeDescriptors { get; set; }
        public string gradeTypeGradingPeriodDescriptor { get; set; }
        public string gradeTypeSemesterDescriptor { get; set; }
        public string gradeTypeExamDescriptor { get; set; }
        public string gradeTypeFinalDescriptor { get; set; }
        public string[] validParentDescriptors { get; set; }
        public string [] validCampusLeaderDescriptors { get; set; }
        public string [] schoolGradingPeriodDescriptors { get; set; }
        public string [] examGradingPeriods { get; set; }
        public string disciplineIncidentDescriptor { get; set; }
        public string missingAssignmentLetterGrade { get; set; }
        public string[] validEmailTypeDescriptors { get; set; }
        public string[] suspensionDescriptors { get; set; }
        public string assessmentLengthOfTime { get; set; }
        public Descriptor ellDescriptor { get; set; }
        public Descriptor accommodationDescriptor { get; set; }
        public Descriptor specialEducationDescriptor { get; set; }
        public string instructionalDayDescriptorCodeValue { get; set; }
        public string nonInstrunctionalDayDescriptorCodeValue { get; set; }
    }

    public class Descriptor
    {
        public string CodeValue { get; set; }
        public string DisplayName { get; set; }
        public string Url { get; set; }
    }

    public class Page
    {
        public string page { get; set; }
        public string route { get; set; }
        public List<Feature> features { get; set; }
    }

    public class Feature
    {
        public string name { get; set; }
        public bool enabled { get; set; }
        public StudentAbc studentAbc { get; set; }
    }

    public class StudentAbc 
    {
        public bool missingAssignments { get; set; }
        public bool courseAverage { get; set; }
        public bool behavior { get; set; }
        public bool absence { get; set; }
    }
    public class CanDoDescriptor
    {
        public List<int> gradeLevels { get; set; }
        public string subject { get; set; }
        public int proficiency { get; set; }
        public string description { get; set; }
    }
}
