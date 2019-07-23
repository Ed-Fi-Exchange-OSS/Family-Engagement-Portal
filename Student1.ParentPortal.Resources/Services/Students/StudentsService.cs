using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data.Entity;
using Student1.ParentPortal.Data.Models.EdFi25;
using Student1.ParentPortal.Resources.Providers.Image;
using System;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Resources.Providers.Configuration;
using Student1.ParentPortal.Resources.Services.Communications;
using Student1.ParentPortal.Resources.ExtensionMethods;

namespace Student1.ParentPortal.Resources.Services.Students
{
    public interface IStudentsService
    {
        Task<StudentDetailModel> GetStudentDetailAsync(int studentUsi, string recipientUniqueId, int recipientTypeId);
        Task<PersonBriefModel> GetPersonBriefModelAsync(int studentUsi);
        Task<List<StudentSummary>> GetStudentsSummary(List<int> StudentUsis);
    }

    public class StudentsService : IStudentsService
    {
        private readonly IStudentRepository _studentRepository;
        private readonly IImageProvider _imageUrlProvider;
        private readonly IStudentAttendanceService _studentAttendanceService;
        private readonly IStudentBehaviorService _studentBehaviorService;
        private readonly IStudentCourseGradesService _studentCourseGradesService;
        private readonly IStudentAssignmentService _studentAssignmentService;
        private readonly IStudentScheduleService _studentScheduleService;
        private readonly IStudentAssessmentService _studentAssessmentService;
        private readonly IStudentProgramService _studentProgramService;
        private readonly IStudentIndicatorService _studentIndicatorService;
        private readonly IStudentSuccessTeamService _studentSuccessTeamService;
        private readonly IStudentGraduationReadinessService _studentGraduationReadinessService;
        private readonly ICommunicationsService _communicationsService;
        private readonly ISpotlightIntegrationsService _spotlightIntegrationsService;
        private readonly ICustomParametersProvider _customParametersProvider;

        public StudentsService(IStudentRepository studentRepository, IImageProvider imageUrlProvider, IStudentAttendanceService studentAttendanceService, IStudentBehaviorService studentBehaviorService, IStudentCourseGradesService studentCourseGradesService, IStudentAssignmentService studentAssignmentService, IStudentScheduleService studentScheduleService, IStudentAssessmentService studentAssessmentService, IStudentProgramService studentProgramService, IStudentIndicatorService studentIndicatorService, IStudentSuccessTeamService studentSuccessTeamService, IStudentGraduationReadinessService studentGraduationReadinessService, ICommunicationsService communicationsService, ISpotlightIntegrationsService spotlightIntegrationsService, ICustomParametersProvider customParametersProvider)
        {
            _studentRepository = studentRepository;
            _imageUrlProvider = imageUrlProvider;
            _studentAttendanceService = studentAttendanceService;
            _studentBehaviorService = studentBehaviorService;
            _studentCourseGradesService = studentCourseGradesService;
            _studentAssignmentService = studentAssignmentService;
            _studentScheduleService = studentScheduleService;
            _studentAssessmentService = studentAssessmentService;
            _studentProgramService = studentProgramService;
            _studentIndicatorService = studentIndicatorService;
            _studentSuccessTeamService = studentSuccessTeamService;
            _studentGraduationReadinessService = studentGraduationReadinessService;
            _communicationsService = communicationsService;
            _spotlightIntegrationsService = spotlightIntegrationsService;
            _customParametersProvider = customParametersProvider;
        }

        public async Task<StudentDetailModel> GetStudentDetailAsync(int studentUsi, string recipientUniqueId, int recipientTypeId)
        {
            var student = await _studentRepository.GetStudentDetailAsync(studentUsi);

            if (student == null)
                return null;
            // Add ABCs
            student.ImageUrl = await _imageUrlProvider.GetStudentImageUrlAsync(student.StudentUniqueId);
            student.Attendance = await _studentAttendanceService.GetStudentAttendanceAsync(student.StudentUsi);
            student.Behavior = await _studentBehaviorService.GetStudentBehaviorAsync(student.StudentUsi);
            student.CourseGrades = await _studentCourseGradesService.GetStudentCourseGradesAsync(student.StudentUsi);
            student.MissingAssignments = await _studentAssignmentService.GetStudentMissingAssignments(student.StudentUsi);
            student.Schedule = await _studentScheduleService.GetStudentScheduleAsync(student.StudentUsi);
            student.Assessment = await _studentAssessmentService.GetStudentAssessmentsAsync(student.StudentUsi);
            student.Programs = await _studentProgramService.GetStudentProgramsAsync(student.StudentUsi);
            student.Indicators = await _studentIndicatorService.GetStudentIndicatorsAsync(student.StudentUsi);
            student.SuccessTeamMembers = await _studentSuccessTeamService.GetStudentSuccessTeamAsync(student.StudentUsi, recipientUniqueId, recipientTypeId);
            student.OnTrackToGraduate = await _studentGraduationReadinessService.IsStudentOnTrackToGraduateAsync(student.StudentUsi);
            student.UnreadMessageCount = await _communicationsService.UnreadMessageCount(student.StudentUsi, recipientUniqueId, recipientTypeId, null, null);
            student.ExternalLinks = await _spotlightIntegrationsService.GetStudentExternalLinks(student.StudentUniqueId);
            student.StaarAssessmentHistory = await _studentAssessmentService.GetStudentStaarAssessmentHistoryAsync(student.StudentUsi);

            return student;
        }

        public async Task<PersonBriefModel> GetPersonBriefModelAsync(int studentUsi)
        {
            var student = await _studentRepository.GetStudentBriefModelAsync(studentUsi);

            student.ImageUrl = await _imageUrlProvider.GetStudentImageUrlAsync(student.UniqueId);
            return student;
        }

        public async Task<List<StudentSummary>> GetStudentsSummary(List<int> StudentUsis)
        {
            var data = await _studentRepository.GetStudentsSummary(StudentUsis);


            foreach(var sm in data)
            {
                sm.CourseAverageInterpretation = InterpretCurrentGradeAverage(sm.CourseAverage);
                sm.DisciplineIncidentInterpretation = InterpretIncidentCount(sm.DisciplineIncidentCount);
                sm.MissingAssigmentInterpretation = InterpretMissingAssignmentCount(sm.MissingassignmentCount);
                sm.AbsenceInterpretation = InterpretUnexcusedAbsencesCount(sm.AbsenceCount);
                sm.GpaInterpretation = sm.Gpa.HasValue ? InterpretGPA(sm.Gpa.Value) : "";
            }

            return data;
        }

        private string InterpretUnexcusedAbsencesCount(int absencesCount)
        {
            return _customParametersProvider.GetParameters().attendance.ADA.unexcused.thresholdRules.GetRuleThatApplies(absencesCount).interpretation;
        }

        private string InterpretIncidentCount(int incidentCount)
        {
            return _customParametersProvider.GetParameters().behavior.thresholdRules.GetRuleThatApplies(incidentCount).interpretation;
        }

        private string InterpretCurrentGradeAverage(decimal gradeAverage)
        {
            return _customParametersProvider.GetParameters()
                            .courseGrades.courseAverage.thresholdRules
                            .GetRuleThatApplies(gradeAverage).interpretation;
        }

        private string InterpretMissingAssignmentCount(int missingAssignmentsCount)
        {
            return _customParametersProvider.GetParameters().assignments.thresholdRules.GetRuleThatApplies(missingAssignmentsCount).interpretation;
        }
        private string InterpretGPA(decimal gpa)
        {
            return _customParametersProvider.GetParameters()
                            .courseGrades.gpa.thresholdRules
                            .GetRuleThatApplies(gpa).interpretation;
        }
    }
}
