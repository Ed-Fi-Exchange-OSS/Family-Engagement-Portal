using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Models.User;

namespace Student1.ParentPortal.Data.Models.EdFi26
{
    public class StudentRepository : IStudentRepository
    {
        private readonly EdFi26Context _edFiDb;

        public StudentRepository(EdFi26Context edFiDb)
        {
            _edFiDb = edFiDb;
        }

        public async Task<List<StudentAttendanceEvent>> GetStudentAttendanceEventsAsync(int studentUsi)
        {
            var attendanceEvents = await (from s in _edFiDb.StudentSchoolAttendanceEvents
                                          join sy in _edFiDb.SchoolYearTypes on s.SchoolYear equals sy.SchoolYear
                                          join aed in _edFiDb.AttendanceEventCategoryDescriptors on s.AttendanceEventCategoryDescriptorId equals aed.AttendanceEventCategoryDescriptorId
                                          join aet in _edFiDb.AttendanceEventCategoryTypes on aed.AttendanceEventCategoryTypeId equals aet.AttendanceEventCategoryTypeId
                                          where s.StudentUsi == studentUsi && sy.CurrentSchoolYear
                                          select new StudentAttendanceEvent
                                          {
                                              DateOfEvent = s.EventDate,
                                              Reason = s.AttendanceEventReason,
                                              EventCategory = aet.CodeValue,
                                              EventDescription = aet.Description
                                          }).ToListAsync();

            return attendanceEvents;
        }

        public async Task<UserProfileModel> GetStudentProfileAsync(int studentUsi)
        {
            var edfiProfile = await (from s in _edFiDb.Students
                                          .Include(x => x.StudentAddresses.Select(y => y.AddressType))
                                          .Include(x => x.StudentElectronicMails.Select(y => y.ElectronicMailType))
                                          .Include(x => x.StudentTelephones.Select(y => y.TelephoneNumberType))
                                          .Include(x => x.StudentIdentificationCodes)
                                     where s.StudentUsi == studentUsi
                                     select s).FirstOrDefaultAsync();

            return ToUserProfileModel(edfiProfile);
        }

        public async Task<BriefProfileModel> GetBriefStudentProfileAsync(int studentUsi)
        {
            var edfiProfile = await (from s in _edFiDb.Students
                                            .Include(x => x.StudentAddresses.Select(y => y.AddressType))
                                            .Include(x => x.StudentElectronicMails.Select(y => y.ElectronicMailType))
                                            .Include(x => x.StudentTelephones.Select(y => y.TelephoneNumberType))
                                            .Include(x => x.StudentIdentificationCodes)
                                     where s.StudentUsi == studentUsi
                                     select s).FirstOrDefaultAsync();

            return ToBriefProfileModel(edfiProfile);
        }

        public async Task<List<StudentAbsencesCount>> GetStudentsWithAbsenceCountGreaterOrEqualThanThresholdAsync(int thresholdCount)
        {
            var studentsAndAbsenceCount = await (from s in _edFiDb.StudentSchoolAttendanceEvents
                                                 join sy in _edFiDb.SchoolYearTypes on s.SchoolYear equals sy.SchoolYear
                                                 where sy.CurrentSchoolYear
                                                 group s by s.StudentUsi into g
                                                 where g.Count() >= thresholdCount
                                                 select new StudentAbsencesCount
                                                 {
                                                     StudentUsi = g.Key,
                                                     AbsenceCount = g.Count()
                                                 }).ToListAsync();

            return studentsAndAbsenceCount;
        }

        public async Task<List<ParentPortal.Models.Student.DisciplineIncident>> GetStudentDisciplineIncidentsAsync(int studentUsi, string disciplineIncidentDescriptor)
        {
            var data = await (from sdia in _edFiDb.StudentDisciplineIncidentAssociations
                              join spct in _edFiDb.StudentParticipationCodeTypes on sdia.StudentParticipationCodeTypeId equals spct.StudentParticipationCodeTypeId
                              join di in _edFiDb.DisciplineIncidents on sdia.IncidentIdentifier equals di.IncidentIdentifier
                              join dadi in _edFiDb.DisciplineActionDisciplineIncidents on new { di.IncidentIdentifier, di.SchoolId } equals new { dadi.IncidentIdentifier, dadi.SchoolId }
                              join da in _edFiDb.DisciplineActions on new { dadi.DisciplineActionIdentifier, dadi.StudentUsi, dadi.DisciplineDate } equals new { da.DisciplineActionIdentifier, da.StudentUsi, da.DisciplineDate }
                              join dad in _edFiDb.DisciplineActionDisciplines on new { da.DisciplineActionIdentifier, da.StudentUsi, da.DisciplineDate } equals new { dad.DisciplineActionIdentifier, dad.StudentUsi, dad.DisciplineDate }
                              join dd in _edFiDb.DisciplineDescriptors on dad.DisciplineDescriptorId equals dd.DisciplineDescriptorId
                              join dt in _edFiDb.DisciplineTypes on dd.DisciplineTypeId equals dt.DisciplineTypeId
                              join s in _edFiDb.Students
                                          .Include(x => x.StudentSectionAssociations)
                                      on sdia.StudentUsi equals s.StudentUsi
                              where sdia.StudentUsi == studentUsi /*&& _edFiDb.Sessions.Where(x => x.SchoolId == sdia.SchoolId).Max(x => x.BeginDate) <= di.IncidentDate*/
                              && spct.CodeValue == disciplineIncidentDescriptor
                              orderby di.IncidentDate descending
                              select new
                              {
                                  IncidentIdentifier = di.IncidentIdentifier,
                                  IncidentDate = di.IncidentDate,
                                  Description = di.IncidentDescription,
                                  DisciplineActionIdentifier = da.DisciplineActionIdentifier,
                                  DisciplineActionDescription = dt.Description,
                                  DisciplineActionCodeValue = dt.CodeValue
                              }).ToListAsync();

            // There can be multiple discipline incidents
            // And each incident can have multiple actions associated to them

            var incidents = (from d in data
                             group d by d.IncidentIdentifier into g
                             select new ParentPortal.Models.Student.DisciplineIncident
                             {
                                 IncidentIdentifier = g.Key,
                                 IncidentDate = g.First().IncidentDate,
                                 Description = g.First().Description,
                                 DisciplineActionCodeValue = g.First().DisciplineActionCodeValue,
                                 DisciplineActionsTaken = g.Select(x => new DisciplineActionTaken { DisciplineActionIdentifier = x.DisciplineActionIdentifier, Description = x.DisciplineActionDescription }).ToList()
                             }).ToList();

            return incidents;
        }

        public async Task<List<StudentSummary>> GetStudentsSummary(List<int> StudentUsis)
        {
            var studentsSummary = await _edFiDb.StudentAbcSummaries.Where(x => StudentUsis.Any(usi => usi == x.StudentUsi))
                                    .Select(x => new StudentSummary
                                    {
                                        StudentUsi = x.StudentUsi,
                                        StudentUniqueId = x.StudentUniqueId,
                                        FirstName = x.FirstName,
                                        MiddleName = x.MiddleName,
                                        LastSurname = x.LastSurname,
                                        GradeLevel = x.GradeLevel,
                                        Gpa = x.Gpa,
                                        MissingassignmentCount = x.MissingAssignments ?? 0,
                                        DisciplineIncidentCount = x.DisciplineIncidents ?? 0,
                                        AbsenceCount = x.Absences ?? 0,
                                        CourseAverage = x.FinalAvg ?? x.SemesterAvg ?? (x.ExamAvg.HasValue ? (x.ExamAvg.Value + x.GradingPeriodAvg.Value) / 2 : x.GradingPeriodAvg ?? 0),
                                    }).ToListAsync();

            return studentsSummary;
        }

        public async Task<List<StudentCourse>> GetStudentTranscriptCoursesAsync(int studentUsi)
        {
            var transcript = await (from ct in _edFiDb.CourseTranscripts
                                    join c in _edFiDb.Courses on new { ct.CourseCode, ct.EducationOrganizationId } equals new { c.CourseCode, c.EducationOrganizationId }
                                    join asd in _edFiDb.AcademicSubjectDescriptors on c.AcademicSubjectDescriptorId equals asd.AcademicSubjectDescriptorId
                                    join ast in _edFiDb.AcademicSubjectTypes on asd.AcademicSubjectTypeId equals ast.AcademicSubjectTypeId
                                    join cart in _edFiDb.CourseAttemptResultTypes on ct.CourseAttemptResultTypeId equals cart.CourseAttemptResultTypeId
                                    join gld in _edFiDb.GradeLevelDescriptors on ct.WhenTakenGradeLevelDescriptorId equals gld.GradeLevelDescriptorId
                                    join glt in _edFiDb.GradeLevelTypes on gld.GradeLevelTypeId equals glt.GradeLevelTypeId
                                    join td in _edFiDb.TermDescriptors on ct.TermDescriptorId equals td.TermDescriptorId
                                    join tt in _edFiDb.TermTypes on td.TermTypeId equals tt.TermTypeId
                                    join ses in _edFiDb.Sessions on td.TermDescriptorId equals ses.TermDescriptorId
                                    // TODO: Get Teacher or Instructor Name
                                    //join co in _edFiDb.CourseOfferings on new {c.EducationOrganizationId, c.CourseCode} equals new {co.EducationOrganizationId, co.CourseCode}
                                    //join sec in _edFiDb.Sections on new {co.LocalCourseCode, co.SchoolId, co.SchoolYear, co.TermDescriptorId} equals new { sec.LocalCourseCode, sec.SchoolId, sec.SchoolYear, sec.TermDescriptorId }
                                    //join stusec in _edFiDb.StudentSectionAssociations on new { sec.SchoolId, sec.ClassPeriodName, sec.ClassroomIdentificationCode, sec.LocalCourseCode, sec.TermDescriptorId, sec.SchoolYear, sec.UniqueSectionCode, sec.SequenceOfCourse } equals new { stusec.SchoolId, stusec.ClassPeriodName, stusec.ClassroomIdentificationCode, stusec.LocalCourseCode, stusec.TermDescriptorId, stusec.SchoolYear, stusec.UniqueSectionCode, stusec.SequenceOfCourse }
                                    //join stasec in _edFiDb.StaffSectionAssociations on new { sec.SchoolId, sec.ClassPeriodName, sec.ClassroomIdentificationCode, sec.LocalCourseCode, sec.TermDescriptorId, sec.SchoolYear, sec.UniqueSectionCode, sec.SequenceOfCourse } equals new { stasec.SchoolId, stasec.ClassPeriodName, stasec.ClassroomIdentificationCode, stasec.LocalCourseCode, stasec.TermDescriptorId, stasec.SchoolYear, stasec.UniqueSectionCode, stasec.SequenceOfCourse }
                                    //join staff in _edFiDb.Staffs on stasec.StaffUsi equals staff.StaffUsi
                                    where ct.StudentUsi == studentUsi && ct.SchoolYear == ses.SchoolYear
                                    orderby ct.SchoolYear descending, ct.TermDescriptorId, ast.Description, c.CourseTitle
                                    select new StudentCourse
                                    {
                                        SessionName = ses.SessionName,
                                        CourseCode = c.CourseCode,
                                        CourseTitle = c.CourseTitle,
                                        AcademicSubjectDescription = ast.Description,
                                        AttemptResultTypeDescription = cart.Description,
                                        SchoolYearTaken = ct.SchoolYear,
                                        GradeLevelTaken = glt.Description,
                                        CreditsEarned = ct.EarnedCredits,
                                        FinalNumericGradeEarned = ct.FinalNumericGradeEarned,
                                        FinalLetterGradeEarned = ct.FinalLetterGradeEarned,
                                    }).ToListAsync();

            return transcript;
        }

        public async Task<decimal?> GetStudentGPAAsync(int studentUsi)
        {
            var gpaData = await (from sar in _edFiDb.StudentAcademicRecords
                                 join sy in _edFiDb.SchoolYearTypes on sar.SchoolYear equals sy.SchoolYear
                                 join td in _edFiDb.TermDescriptors on sar.TermDescriptorId equals td.TermDescriptorId
                                 join tt in _edFiDb.TermTypes on td.TermTypeId equals tt.TermTypeId
                                 where sar.StudentUsi == studentUsi && sy.CurrentSchoolYear
                                 select new
                                 {
                                     TermDescriptorId = td.TermDescriptorId,
                                     TermDescription = tt.Description,
                                     GPA = sar.CumulativeGradePointAverage,
                                 }).ToListAsync();

            // There could be multiple values per term.
            // So lets find the latest.
            var latestAcademicRecord = gpaData.OrderByDescending(x => x.TermDescriptorId).FirstOrDefault();

            return latestAcademicRecord?.GPA;
        }

        public async Task<List<StudentCurrentCourse>> GetStudentGradesByGradingPeriodAsync(int studentUsi, string gradeTypeGradingPeriodDescriptor, string gradeTypeSemesterDescriptor, string gradeTypeExamDescriptor, string gradeTypeFinalDescriptor)
        {
            var data = await (from gra in _edFiDb.Grades.Include(x => x.GradeType).Include(x => x.GradingPeriod)
                              join sy in _edFiDb.SchoolYearTypes on gra.SchoolYear equals sy.SchoolYear
                              join ssa in _edFiDb.StaffSectionAssociations.Include(x => x.Staff)
                                       on new { gra.SchoolId, gra.ClassPeriodName, gra.ClassroomIdentificationCode, gra.LocalCourseCode, gra.TermDescriptorId, gra.SchoolYear, gra.UniqueSectionCode, gra.SequenceOfCourse }
                                   equals new { ssa.SchoolId, ssa.ClassPeriodName, ssa.ClassroomIdentificationCode, ssa.LocalCourseCode, ssa.TermDescriptorId, ssa.SchoolYear, ssa.UniqueSectionCode, ssa.SequenceOfCourse }
                              join co in _edFiDb.CourseOfferings.Include(x => x.Course)
                                       on new { gra.LocalCourseCode, gra.SchoolId, gra.SchoolYear, gra.TermDescriptorId }
                                   equals new { co.LocalCourseCode, co.SchoolId, co.SchoolYear, co.TermDescriptorId }
                              where gra.StudentUsi == studentUsi
                                    && (gra.GradeType.CodeValue == gradeTypeGradingPeriodDescriptor ||
                                    gra.GradeType.CodeValue == gradeTypeSemesterDescriptor ||
                                    gra.GradeType.CodeValue == gradeTypeExamDescriptor ||
                                    gra.GradeType.CodeValue == gradeTypeFinalDescriptor)
                              && sy.CurrentSchoolYear // Current SchoolYear Only
                              orderby gra.GradingPeriodBeginDate
                              select new
                              {
                                  // Course info.
                                  co.Course.CourseTitle,
                                  co.LocalCourseCode,
                                  co.CourseCode,
                                  co.Course.CourseDescription,
                                  // Staff info.
                                  ssa.StaffUsi,
                                  ssa.Staff.StaffUniqueId,
                                  ssa.Staff.PersonalTitlePrefix,
                                  ssa.Staff.FirstName,
                                  ssa.Staff.MiddleName,
                                  ssa.Staff.LastSurname,
                                  ssa.ClassPeriodName,
                                  // Grade Info
                                  // The Grade Type: Grading Period, Semester, Final, etc...
                                  GradeTypeCodeValue = gra.GradeType.CodeValue,
                                  GradeTypeDescription = gra.GradeType.ShortDescription,
                                  // The grading Period: First Six Weeks, Second..., First Semester, ..., End of Year
                                  gra.GradingPeriodDescriptorId,
                                  GradingPeriodDescription = gra.GradingPeriod.GradingPeriodDescriptor.GradingPeriodType.ShortDescription,
                                  gra.LetterGradeEarned,
                                  gra.NumericGradeEarned,
                                  gra.GradingPeriodBeginDate,
                              }
                ).ToListAsync();

            var courses = (from d in data
                           group d by d.CourseCode into g
                           select new StudentCurrentCourse
                           {
                               CourseCode = g.Key,
                               CourseTitle = g.First().CourseTitle,
                               LocalCourseCode = g.First().LocalCourseCode,
                               ClassPeriodName = g.First().ClassPeriodName,
                               TeacherUsi = g.First().StaffUsi,
                               StaffUniqueId = g.First().StaffUniqueId,
                               TeacherName = $"{g.First().PersonalTitlePrefix} {g.First().FirstName} {g.First().LastSurname}",
                               GradesByGradingPeriod = g.Where(x => x.GradeTypeCodeValue == gradeTypeGradingPeriodDescriptor)
                                                        .OrderBy(x => x.GradingPeriodDescription)
                                                        .GroupBy(x => x.GradingPeriodDescription) //By Grading Period
                                                        .Select(x => new StudentCourseGrade
                                                        {
                                                            GradeType = x.FirstOrDefault().GradeTypeDescription,
                                                            GradingPeriodType = x.FirstOrDefault().GradingPeriodDescription,
                                                            LetterGradeEarned = x.FirstOrDefault().LetterGradeEarned,
                                                            NumericGradeEarned = x.FirstOrDefault().NumericGradeEarned
                                                        }).ToList(),
                               GradesBySemester = g.Where(x => x.GradeTypeCodeValue == gradeTypeSemesterDescriptor)
                                                        .OrderBy(x => x.GradingPeriodDescription)
                                                        .GroupBy(x => x.GradingPeriodDescription) //By Grading Period
                                                        .Select(x => new StudentCourseGrade
                                                        {
                                                            GradeType = x.FirstOrDefault().GradeTypeDescription,
                                                            GradingPeriodType = x.FirstOrDefault().GradingPeriodDescription,
                                                            LetterGradeEarned = x.FirstOrDefault().LetterGradeEarned,
                                                            NumericGradeEarned = x.FirstOrDefault().NumericGradeEarned
                                                        }).ToList(),
                               GradesByExam = g.Where(x => x.GradeTypeCodeValue == gradeTypeExamDescriptor)
                                                        .OrderBy(x => x.GradingPeriodDescription)
                                                        .GroupBy(x => x.GradingPeriodDescription) //By Grading Period
                                                        .Select(x => new StudentCourseGrade
                                                        {
                                                            GradeType = x.FirstOrDefault().GradeTypeDescription,
                                                            GradingPeriodType = x.FirstOrDefault().GradingPeriodDescription,
                                                            LetterGradeEarned = x.FirstOrDefault().LetterGradeEarned,
                                                            NumericGradeEarned = x.FirstOrDefault().NumericGradeEarned
                                                        }).ToList(),
                               GradesByFinal = g.Where(x => x.GradeTypeCodeValue == gradeTypeFinalDescriptor)
                                                        .OrderBy(x => x.GradingPeriodDescription)
                                                        .GroupBy(x => x.GradingPeriodDescription) //By Grading Period
                                                        .Select(x => new StudentCourseGrade
                                                        {
                                                            GradeType = x.FirstOrDefault().GradeTypeDescription,
                                                            GradingPeriodType = x.FirstOrDefault().GradingPeriodDescription,
                                                            LetterGradeEarned = x.FirstOrDefault().LetterGradeEarned,
                                                            NumericGradeEarned = x.FirstOrDefault().NumericGradeEarned
                                                        }).ToList(),
                           }).OrderBy(x => x.ClassPeriodName).ToList();

            return courses;
        }

        public async Task<List<AssessmentRecord>> GetStudentAssessmentAsync(int studentUsi, string assessmentReportingMethodTypeDescriptor, string assessmentTitle)
        {
            var data = await (from sa in _edFiDb.StudentAssessments
                                         .Include(x => x.GradeLevelDescriptor.Descriptor)
                              join sasr in _edFiDb.StudentAssessmentScoreResults
                                             .Include(x => x.AssessmentReportingMethodType)
                                  on new { sa.AssessmentIdentifier, sa.Namespace, sa.StudentAssessmentIdentifier, sa.StudentUsi }
                                  equals new { sasr.AssessmentIdentifier, sasr.Namespace, sasr.StudentAssessmentIdentifier, sasr.StudentUsi }
                              join a in _edFiDb.Assessments on new { sa.AssessmentIdentifier, sa.Namespace } equals new { a.AssessmentIdentifier, a.Namespace }
                              from sapl in _edFiDb.StudentAssessmentPerformanceLevels.Where(x => x.StudentUsi == sa.StudentUsi
                                                                     && x.AssessmentIdentifier == sa.AssessmentIdentifier
                                                                     && x.StudentAssessmentIdentifier == sa.StudentAssessmentIdentifier
                                                                     && x.Namespace == sa.Namespace
                                                                     && x.PerformanceLevelMet == true
                                                                     ).DefaultIfEmpty()
                              from pld in _edFiDb.PerformanceLevelDescriptors.Where(x => x.PerformanceLevelDescriptorId == sapl.PerformanceLevelDescriptorId).DefaultIfEmpty()
                              from plt in _edFiDb.PerformanceBaseConversionTypes.Where(x => x.PerformanceBaseConversionTypeId == pld.PerformanceBaseConversionTypeId).DefaultIfEmpty()
                              where sa.StudentUsi == studentUsi
                                    && sasr.AssessmentReportingMethodType.CodeValue == assessmentReportingMethodTypeDescriptor
                                    && a.AssessmentTitle == assessmentTitle
                              select new AssessmentRecord
                              {
                                  Title = a.AssessmentTitle,
                                  Identifier = a.AssessmentIdentifier,
                                  MaxRawScore = a.MaxRawScore,
                                  AdministrationDate = sa.AdministrationDate,
                                  Result = sasr.Result,
                                  PerformanceLevelMet = plt.ShortDescription,
                                  GradeLevel = sa.GradeLevelDescriptor.Descriptor.CodeValue
                              }).ToListAsync();

            return data;
        }

        public async Task<ParentPortal.Models.Student.Assessment> GetStudentAssesmentPerformanceLevel(int studentUsi, string assessmentReportingMethodTypeDescriptor, string assessmentTitle)
        {
            var data = await (from sa in _edFiDb.StudentAssessments
                              join a in _edFiDb.Assessments on new { sa.AssessmentIdentifier, sa.Namespace } equals new { a.AssessmentIdentifier, a.Namespace }
                              join sapl in _edFiDb.StudentAssessmentPerformanceLevels
                                    .Include(x => x.AssessmentReportingMethodType)
                                    on new { sa.StudentUsi, sa.AssessmentIdentifier, sa.StudentAssessmentIdentifier, sa.Namespace }
                                    equals new { sapl.StudentUsi, sapl.AssessmentIdentifier, sapl.StudentAssessmentIdentifier, sapl.Namespace }
                              join d in _edFiDb.Descriptors
                                    on sapl.PerformanceLevelDescriptorId equals d.DescriptorId
                              where sa.StudentUsi == studentUsi
                                && sapl.AssessmentReportingMethodType.CodeValue == assessmentReportingMethodTypeDescriptor
                                    && a.AssessmentTitle == assessmentTitle
                                    && sapl.PerformanceLevelMet == true
                              orderby sa.AdministrationDate descending
                              select new ParentPortal.Models.Student.Assessment
                              {
                                  Version = a.Version,
                                  Title = a.AssessmentTitle,
                                  Identifier = a.AssessmentIdentifier,
                                  MaxRawScore = a.MaxRawScore,
                                  AdministrationDate = sa.AdministrationDate,
                                  PerformanceLevelMet = d.CodeValue,
                                  ReportingMethodCodeValue = sapl.AssessmentReportingMethodType.CodeValue
                              }).FirstOrDefaultAsync();
            return data;
        }

        public async Task<ParentPortal.Models.Student.Assessment> GetStudentAssesmentScore(int studentUsi, string assessmentReportingMethodTypeDescriptor, string assessmentTitle)
        {
            var data = await (from sa in _edFiDb.StudentAssessments
                              join a in _edFiDb.Assessments
                                    on new { sa.AssessmentIdentifier, sa.Namespace }
                                    equals new { a.AssessmentIdentifier, a.Namespace }
                              join sasr in _edFiDb.StudentAssessmentScoreResults
                                            .Include(x => x.AssessmentReportingMethodType)
                                    on new { sa.AssessmentIdentifier, sa.Namespace, sa.StudentAssessmentIdentifier, sa.StudentUsi }
                                    equals new { sasr.AssessmentIdentifier, sasr.Namespace, sasr.StudentAssessmentIdentifier, sasr.StudentUsi }
                              where sa.StudentUsi == studentUsi
                                && sasr.AssessmentReportingMethodType.CodeValue == assessmentReportingMethodTypeDescriptor
                                && a.AssessmentTitle == assessmentTitle
                              orderby sa.AdministrationDate descending
                              select new ParentPortal.Models.Student.Assessment
                              {
                                  Version = a.Version,
                                  Title = a.AssessmentTitle,
                                  Identifier = a.AssessmentIdentifier,
                                  MaxRawScore = a.MaxRawScore,
                                  AdministrationDate = sa.AdministrationDate,
                                  Result = sasr.Result,
                                  ReportingMethodCodeValue = sasr.AssessmentReportingMethodType.CodeValue
                              }).FirstOrDefaultAsync();
            return data;
        }

        public async Task<List<ParentPortal.Models.Student.Assessment>> GetACCESSStudentAssesmentScore(int studentUsi, string assessmentReportingMethodTypeDescriptor, string assessmentTitle)
        {
            var data = await (from sa in _edFiDb.StudentAssessments
                              join d in _edFiDb.Descriptors on sa.WhenAssessedGradeLevelDescriptorId equals d.DescriptorId
                              join a in _edFiDb.Assessments
                                    on new { sa.AssessmentIdentifier, sa.Namespace }
                                    equals new { a.AssessmentIdentifier, a.Namespace }
                              join sasr in _edFiDb.StudentAssessmentScoreResults
                                            .Include(x => x.AssessmentReportingMethodType)
                                    on new { sa.AssessmentIdentifier, sa.Namespace, sa.StudentAssessmentIdentifier, sa.StudentUsi }
                                    equals new { sasr.AssessmentIdentifier, sasr.Namespace, sasr.StudentAssessmentIdentifier, sasr.StudentUsi }
                              where sa.StudentUsi == studentUsi
                                && sasr.AssessmentReportingMethodType.CodeValue == assessmentReportingMethodTypeDescriptor
                                && a.AssessmentTitle == assessmentTitle
                              orderby a.Version descending
                              select new ParentPortal.Models.Student.Assessment
                              {
                                  Version = a.Version,
                                  Title = a.AssessmentTitle,
                                  Identifier = a.AssessmentIdentifier,
                                  MaxRawScore = a.MaxRawScore,
                                  AdministrationDate = sa.AdministrationDate,
                                  Result = sasr.Result,
                                  ReportingMethodCodeValue = sasr.AssessmentReportingMethodType.CodeValue,
                                  Gradelevel = d.CodeValue
                              }).Take(3).ToListAsync();
            return data;
        }

        public async Task<StudentMissingAssignments> GetStudentMissingAssignments(int studentUsi, string[] gradeBookMissingAssignmentTypeDescriptors, string missingAssignmentLetterGrade)
        {
            // Get all assignments and homeworks that were assigned to the section that the student is enrolled in.
            // Assumption: If he hasn't turned it in then its a candidate for missing assignments.
            // Ed-Fi does not define a assignment due date.

            var studentMaxBeginDate = await _edFiDb.StudentSectionAssociations
                                                 .Where(x => x.StudentUsi == studentUsi)
                                                 .GroupBy(x => x.StudentUsi)
                                                 .Select(g => g.Max(x => x.BeginDate))
                                                 .SingleOrDefaultAsync();

            var missingAssignments = await (from gbe in _edFiDb.GradebookEntries
                                                        .Include(x => x.GradebookEntryType)
                                            join ssa in _edFiDb.StudentSectionAssociations
                                                on new { gbe.SchoolId, gbe.ClassPeriodName, gbe.ClassroomIdentificationCode, gbe.LocalCourseCode, gbe.UniqueSectionCode, gbe.SequenceOfCourse, gbe.SchoolYear, gbe.TermDescriptorId }
                                                equals new { ssa.SchoolId, ssa.ClassPeriodName, ssa.ClassroomIdentificationCode, ssa.LocalCourseCode, ssa.UniqueSectionCode, ssa.SequenceOfCourse, ssa.SchoolYear, ssa.TermDescriptorId }
                                            join staffsa in _edFiDb.StaffSectionAssociations
                                                on new { gbe.SchoolId, gbe.ClassPeriodName, gbe.ClassroomIdentificationCode, gbe.LocalCourseCode, gbe.UniqueSectionCode, gbe.SequenceOfCourse, gbe.SchoolYear, gbe.TermDescriptorId }
                                                equals new { staffsa.SchoolId, staffsa.ClassPeriodName, staffsa.ClassroomIdentificationCode, staffsa.LocalCourseCode, staffsa.UniqueSectionCode, staffsa.SequenceOfCourse, staffsa.SchoolYear, staffsa.TermDescriptorId }
                                            join staff in _edFiDb.Staffs on staffsa.StaffUsi equals staff.StaffUsi
                                            join co in _edFiDb.CourseOfferings on new { gbe.LocalCourseCode, gbe.SchoolId, gbe.SchoolYear, gbe.TermDescriptorId } equals new { co.LocalCourseCode, co.SchoolId, co.SchoolYear, co.TermDescriptorId }
                                            join c in _edFiDb.Courses on new { co.EducationOrganizationId, co.CourseCode } equals new { c.EducationOrganizationId, c.CourseCode }
                                            from sge in _edFiDb.StudentGradebookEntries.Where(x => x.StudentUsi == studentUsi
                                                                                                  && x.GradebookEntryTitle == gbe.GradebookEntryTitle
                                                                                                  && x.ClassroomIdentificationCode == gbe.ClassroomIdentificationCode
                                                                                                  && x.SchoolId == gbe.SchoolId
                                                                                                  && x.ClassPeriodName == gbe.ClassPeriodName
                                                                                                  && x.LocalCourseCode == gbe.LocalCourseCode
                                                                                                  && x.SchoolYear == gbe.SchoolYear
                                                                                                  && x.TermDescriptorId == gbe.TermDescriptorId
                                                                                                  && x.UniqueSectionCode == gbe.UniqueSectionCode
                                                                                                  && x.SequenceOfCourse == gbe.SequenceOfCourse
                                                                                                  && x.DateAssigned == gbe.DateAssigned
                                                                                                  ).DefaultIfEmpty() // Left join to get missing assignments.
                                            where ssa.StudentUsi == studentUsi
                                                  && sge.DateFulfilled == null // Not delivered
                                                  && sge.LetterGradeEarned == missingAssignmentLetterGrade
                                                  && gbe.GradebookEntryTypeId != null // They have to be categorized
                                                  && gradeBookMissingAssignmentTypeDescriptors.Contains(gbe.GradebookEntryType.CodeValue) // Only Homework and Assignments
                                                  && sge.BeginDate == studentMaxBeginDate
                                            group new { gbe, co, c, staff } by c.CourseTitle into g
                                            select new StudentAssignmentSection
                                            {
                                                CourseTitle = g.Key,
                                                StaffFirstName = g.FirstOrDefault().staff.FirstName,
                                                StaffMiddleName = g.FirstOrDefault().staff.MiddleName,
                                                StaffLastSurName = g.FirstOrDefault().staff.LastSurname,
                                                Assignments = g.Select(x => new StudentAssignment
                                                {
                                                    LocalCourseCode = x.gbe.LocalCourseCode,
                                                    LocalCourseTitle = x.co.LocalCourseTitle,
                                                    CourseTitle = x.c.CourseTitle,
                                                    AssignmentTitle = x.gbe.GradebookEntryTitle,
                                                    AssignmentDescription = x.gbe.Description,
                                                    DateAssigned = x.gbe.DateAssigned
                                                })
                                            }).ToListAsync();
            foreach (var item in missingAssignments)
            {
                item.Assignments = item.Assignments.ToList().OrderBy(x => x.DaysLate);
            }

            return new StudentMissingAssignments { AssignmentSections = missingAssignments };
        }

        public async Task<bool?> IsStudentOnTrackToGraduateAsync(int studentUsi)
        {

            var isOnTrack = await (from s in _edFiDb.Students
                                   join sgr in _edFiDb.StudentGraduationReadinesses
                                        on s.StudentUniqueId equals sgr.StudentUniqueId
                                   where s.StudentUsi == studentUsi
                                   select sgr.OnTrackToGraduate
                                  ).SingleOrDefaultAsync();
            return isOnTrack;
        }

        public async Task<List<Student1.ParentPortal.Models.Student.StudentIndicator>> GetStudentIndicatorsAsync(int studentUsi)
        {
            var model = await (from si in _edFiDb.StudentIndicators
                               where si.StudentUsi == studentUsi
                                     && si.EndDate == null
                               select new Student1.ParentPortal.Models.Student.StudentIndicator
                               {
                                   IndicatorName = si.IndicatorName,
                                   BeginDate = si.BeginDate
                               }).ToListAsync();

            return model;
        }

        public async Task<List<Student1.ParentPortal.Models.Student.StudentIndicator>> GetStudentIndicatorsAsync(int studentUsi, string ellDescriptorCodeValue, string accommodationDescriptorCodeValue, string specialEducationDescriptorCodeValue)
        {
            var model = await (from si in _edFiDb.StudentIndicators
                               where si.StudentUsi == studentUsi
                                     && si.EndDate == null
                               select new Student1.ParentPortal.Models.Student.StudentIndicator
                               {
                                   IndicatorName = si.IndicatorName,
                                   BeginDate = si.BeginDate
                               }).ToListAsync();

            var otherIndicators = await (from s in _edFiDb.Students
                                         .Include(x => x.LimitedEnglishProficiencyDescriptor.Descriptor)
                                         join ssa in _edFiDb.StudentSchoolAssociations on s.StudentUsi equals ssa.StudentUsi
                                         join spa in _edFiDb.StudentProgramAssociations
                                                on new { s.StudentUsi } //, EducationOrganizationId = ssa.SchoolId
                                                equals new { spa.StudentUsi } //, spa.EducationOrganizationId
                                         join pt in _edFiDb.ProgramTypes on spa.ProgramTypeId equals pt.ProgramTypeId
                                         group new { s, ssa, pt } by s.StudentUsi into g
                                         select new {
                                             Ell = g.Select(x => x.s.LimitedEnglishProficiencyDescriptor.Descriptor.CodeValue).FirstOrDefault(x => x == ellDescriptorCodeValue),
                                             Accommodation504 = g.Select(x => x.pt.CodeValue).FirstOrDefault(x => x == accommodationDescriptorCodeValue),
                                             SpecialEducation = g.Select(x => x.pt.CodeValue).FirstOrDefault(x => x == specialEducationDescriptorCodeValue)
                                         }).FirstOrDefaultAsync();

            if (otherIndicators == null)
                return model;

            if (otherIndicators.Ell != null)
                model.Add(new ParentPortal.Models.Student.StudentIndicator { IndicatorName = otherIndicators.Ell });

            if (otherIndicators.Accommodation504 != null)
                model.Add(new ParentPortal.Models.Student.StudentIndicator { IndicatorName = otherIndicators.Accommodation504 });

            if (otherIndicators.SpecialEducation != null)
                model.Add(new ParentPortal.Models.Student.StudentIndicator { IndicatorName = otherIndicators.SpecialEducation });

            return model;
        }

        public async Task<PersonBriefModel> GetStudentBriefModelAsync(int studentUsi)
        {
            var data = await (from s in _edFiDb.Students.Include(x => x.StudentElectronicMails)
                                .Include(x => x.StudentIdentificationCodes)
                              where s.StudentUsi == studentUsi
                              select new PersonBriefModel
                              {
                                  Usi = s.StudentUsi,
                                  UniqueId = s.StudentUniqueId,
                                  FirstName = s.FirstName,
                                  LastSurname = s.LastSurname,
                                  IdentificationCode = s.StudentIdentificationCodes.FirstOrDefault(x => x.AssigningOrganizationIdentificationCode == "LASID").IdentificationCode
                              }).SingleOrDefaultAsync();

            data.PersonTypeId = ChatLogPersonTypeEnum.Staff.Value;
            data.Role = "Student";

            return data;
        }

        public async Task<StudentDetailModel> GetStudentDetailAsync(int studentUsi)
        {
            var data = await (from s in _edFiDb.Students
                                                      .Include(x => x.StudentElectronicMails)
                                                      .Include(x => x.StudentTelephones)
                                                      .Include(x => x.StudentRaces.Select(r => r.RaceType))
                                                      .Include(x => x.StudentOtherNames)
                                                      .Include(x => x.StudentIdentificationCodes)
                              join sext in _edFiDb.SexTypes on s.SexTypeId equals sext.SexTypeId
                              join ssa in _edFiDb.StudentSchoolAssociations on s.StudentUsi equals ssa.StudentUsi
                              join gld in _edFiDb.GradeLevelDescriptors on ssa.EntryGradeLevelDescriptorId equals gld.GradeLevelDescriptorId
                              join glt in _edFiDb.GradeLevelTypes on gld.GradeLevelTypeId equals glt.GradeLevelTypeId
                              join sc in _edFiDb.Schools on ssa.SchoolId equals sc.SchoolId
                              join eds in _edFiDb.EducationOrganizations on sc.SchoolId equals eds.EducationOrganizationId
                              where s.StudentUsi == studentUsi && ssa.ExitWithdrawDate == null
                              group new { s, sext, ssa, eds, glt } by s.StudentUniqueId into g
                              select new
                              {
                                  g.FirstOrDefault().s,
                                  SexType = g.FirstOrDefault().sext.ShortDescription,
                                  CurrentSchool = g.FirstOrDefault().eds.NameOfInstitution,
                                  GradeLevel = g.FirstOrDefault().glt.ShortDescription,
                                  GradeLevelTypeId = g.FirstOrDefault().glt.GradeLevelTypeId,
                                  OtherName = g.FirstOrDefault().s.StudentOtherNames.FirstOrDefault(),
                                  EntryDate = g.Max(x => x.ssa.EntryDate)
                              }).SingleOrDefaultAsync();

            if (data == null)
                return null;

            var student = new StudentDetailModel
            {
                StudentUsi = data.s.StudentUsi,
                StudentIdentificationCode = data.s.StudentIdentificationCodes.FirstOrDefault(x => x.AssigningOrganizationIdentificationCode == "LASID")?.IdentificationCode,
                StudentUniqueId = data.s.StudentUniqueId,
                FirstName = data.s.FirstName,
                MiddleName = data.s.MiddleName,
                LastSurname = data.s.LastSurname,
                OtherFirstName = data.OtherName?.FirstName,
                OtherMiddleName = data.OtherName?.MiddleName,
                OtherLastSurname = data.OtherName?.LastSurname,
                HispanicOrLatino = data.s.HispanicLatinoEthnicity,
                Email = GetEmail(data.s.StudentElectronicMails),
                Telephone = GetTelephone(data.s.StudentTelephones),
                Races = GetRaces(data.s.StudentRaces),
                SexType = data.SexType,
                CurrentSchool = data.CurrentSchool,
                GradeLevel = data.GradeLevel,
                GradeLevelTypeId = data.GradeLevelTypeId,
                EntryDate = data.EntryDate,
            };

            return student;
        }

        private string GetTelephone(ICollection<StudentTelephone> studentTelephones)
        {
            if (studentTelephones == null || !studentTelephones.Any())
                return null;

            return studentTelephones.First().TelephoneNumber;
        }

        private List<string> GetRaces(ICollection<StudentRace> studentRaces)
        {
            if (studentRaces == null || !studentRaces.Any())
                return null;

            return studentRaces.Select(x => x.RaceType.Description).ToList();
        }

        private string GetEmail(ICollection<StudentElectronicMail> potentialEmails)
        {
            if (potentialEmails == null || !potentialEmails.Any())
                return null;

            // Lets see if we have one marked as primary.
            var primaryEmail = potentialEmails.SingleOrDefault(x => x.PrimaryEmailAddressIndicator == true);
            if (primaryEmail != null)
                return primaryEmail.ElectronicMailAddress;

            // If we don't have marked as primary then lets return the first one we find.
            return potentialEmails.First().ElectronicMailAddress;
        }

        public async Task<List<StudentProgram>> GetStudentProgramsAsync(int studentUsi)
        {
            var model = await (from sp in _edFiDb.StudentProgramAssociations
                               where sp.StudentUsi == studentUsi
                                     && sp.EndDate == null
                               select new StudentProgram
                               {
                                   ProgramName = sp.ProgramName,
                                   BeginDate = sp.BeginDate
                               }).ToListAsync();

            return model;
        }

        public async Task<List<ScheduleItem>> GetStudentScheduleAsync(int studentUsi, DateTime mondayDate, DateTime fridayDate)
        {
            var data = await (from ssa in _edFiDb.StudentSectionAssociations
                              join sy in _edFiDb.SchoolYearTypes on ssa.SchoolYear equals sy.SchoolYear
                              join bsmt in _edFiDb.BellScheduleMeetingTimes on new { ssa.SchoolId, ssa.ClassPeriodName } equals new { bsmt.SchoolId, bsmt.ClassPeriodName }
                              join coo in _edFiDb.CourseOfferings
                                       on new { ssa.SchoolId, ssa.LocalCourseCode }
                                   equals new { coo.SchoolId, coo.LocalCourseCode }
                              join c in _edFiDb.Courses
                                  on new { EducationOrganizationId = coo.SchoolId, coo.CourseCode }
                                  equals new { c.EducationOrganizationId, c.CourseCode }
                              join staffsa in _edFiDb.StaffSectionAssociations
                                    on new { ssa.SchoolId, ssa.ClassPeriodName, ssa.ClassroomIdentificationCode, ssa.LocalCourseCode, ssa.UniqueSectionCode, ssa.SequenceOfCourse, ssa.SchoolYear, ssa.TermDescriptorId }
                                    equals new { staffsa.SchoolId, staffsa.ClassPeriodName, staffsa.ClassroomIdentificationCode, staffsa.LocalCourseCode, staffsa.UniqueSectionCode, staffsa.SequenceOfCourse, staffsa.SchoolYear, staffsa.TermDescriptorId }
                              join s in _edFiDb.Staffs on staffsa.StaffUsi equals s.StaffUsi
                              where ssa.StudentUsi == studentUsi
                                    && sy.CurrentSchoolYear
                                    && bsmt.Date >= mondayDate
                                    && bsmt.Date <= fridayDate
                              orderby bsmt.Date, bsmt.StartTime
                              select new ScheduleItem
                              {
                                  CourseTitle = c.CourseTitle,
                                  BellScheduleName = bsmt.BellScheduleName,
                                  Date = bsmt.Date,
                                  StartTime = bsmt.StartTime,
                                  EndTime = bsmt.EndTime,
                                  ClassroomIdentificationCode = ssa.ClassroomIdentificationCode,
                                  FirstName = s.FirstName,
                                  MiddleName = s.MiddleName,
                                  LastSurname = s.LastSurname,
                              }).ToListAsync();

            return data;
        }

        public async Task<List<StudentSuccessTeamMember>> GetTeachers(int studentUsi, string recipientUniqueId, int recipientTypeId)
        {
            var query = from staff in _edFiDb.Staffs
                            // Per Client Request and Data Availability we are not bringing in this information on this phase.
                            // Additionally we are commenting out to bring less data and improve performance. 
                            //.Include(x => x.StaffElectronicMails)
                            //.Include(x => x.StaffTelephones)
                            //.Include(x => x.StaffLanguages.Select(l => l.LanguageDescriptor.Descriptor))
                            //.Include(x => x.StaffCredentials.Select(c => c.Credential.CredentialTypeDescriptor.Descriptor))
                            //.Include(x => x.StaffAddresses.Select(s => s.StateAbbreviationDescriptor.Descriptor))
                        from sexd in _edFiDb.SexTypes.Where(x => x.SexTypeId == staff.SexTypeId).DefaultIfEmpty()
                        from led in _edFiDb.Descriptors.Where(x => x.DescriptorId == staff.HighestCompletedLevelOfEducationDescriptorId).DefaultIfEmpty()
                        join staffSec in _edFiDb.StaffSectionAssociations on staff.StaffUsi equals staffSec.StaffUsi
                        join studeSec in _edFiDb.StudentSectionAssociations
                              on new { staffSec.SchoolId, staffSec.LocalCourseCode, staffSec.ClassPeriodName, staffSec.SchoolYear, staffSec.ClassroomIdentificationCode, staffSec.SequenceOfCourse, staffSec.TermDescriptorId, staffSec.UniqueSectionCode }
                          equals new { studeSec.SchoolId, studeSec.LocalCourseCode, studeSec.ClassPeriodName, studeSec.SchoolYear, studeSec.ClassroomIdentificationCode, studeSec.SequenceOfCourse, studeSec.TermDescriptorId, studeSec.UniqueSectionCode }
                        join co in _edFiDb.CourseOfferings
                                on new { staffSec.LocalCourseCode, staffSec.SchoolId, staffSec.SchoolYear, staffSec.TermDescriptorId }
                                equals new { co.LocalCourseCode, co.SchoolId, co.SchoolYear, co.TermDescriptorId }
                        join staffEdOrg in _edFiDb.StaffEducationOrganizationAssignmentAssociations on staff.StaffUsi equals staffEdOrg.StaffUsi
                        join sy in _edFiDb.SchoolYearTypes on studeSec.SchoolYear equals sy.SchoolYear
                        join s in _edFiDb.Students on studeSec.StudentUsi equals s.StudentUsi
                        from bio in _edFiDb.StaffBiographies.Where(x => x.StaffUniqueId == staff.StaffUniqueId).DefaultIfEmpty()
                        where studeSec.StudentUsi == studentUsi
                              && sy.CurrentSchoolYear
                        //&& studeSec.BeginDate == _edFiDb.Sessions.Where(x => x.SchoolId == staffSec.SchoolId).Max(x => x.BeginDate)
                        select new
                        {
                            staff.StaffUsi,
                            staff.Id,
                            staff.StaffUniqueId,
                            staff.PersonalTitlePrefix,
                            staff.FirstName,
                            staff.MiddleName,
                            staff.LastSurname,
                            staff.HighlyQualifiedTeacher,
                            staff.YearsOfPriorTeachingExperience,
                            bio.ShortBiography,

                            SexType = sexd.Description,
                            co.LocalCourseTitle,
                            HighestCompletedLevelOfEducation = led.ShortDescription,

                            // Per Client Request and Data Availability we are not bringing in this information on this phase.
                            // Additionally we are commenting out to bring less data and improve performance. 
                            Emails = staff.StaffElectronicMails.Select(e => e.ElectronicMailAddress),
                            //Telephone = staff.StaffTelephones.Select(t => t.TelephoneNumber),
                            //staff.StaffAddresses,
                            //Languages = staff.StaffLanguages.Select(x => x.LanguageDescriptor.Descriptor.ShortDescription),
                            //Credentials = staff.StaffCredentials.Select(x => x.Credential.CredentialTypeDescriptor.Descriptor.ShortDescription),

                            Chat = _edFiDb.ChatLogs.Count(x => x.StudentUniqueId == s.StudentUniqueId
                                                                    && x.SenderUniqueId == staff.StaffUniqueId
                                                                    && x.SenderTypeId == ChatLogPersonTypeEnum.Staff.Value
                                                                    && x.RecipientUniqueId == recipientUniqueId
                                                                    && x.RecipientTypeId == recipientTypeId
                                                                    && !x.RecipientHasRead)
                        };

            var executedQuery = await query.ToListAsync();

            var gr = (from d in executedQuery
                      group d by d.StaffUsi into g
                      select new StudentSuccessTeamMember
                      {
                          Id = g.FirstOrDefault().StaffUsi,
                          Guid = g.FirstOrDefault().Id,
                          UniqueId = g.FirstOrDefault().StaffUniqueId,
                          StudentUsi = studentUsi,
                          PersonTypeId = ChatLogPersonTypeEnum.Staff.Value,
                          PersonalTitlePrefix = g.FirstOrDefault().PersonalTitlePrefix,
                          FirstName = g.FirstOrDefault().FirstName,
                          MiddleName = g.FirstOrDefault().MiddleName,
                          LastSurname = g.FirstOrDefault().LastSurname,
                          SexType = g.FirstOrDefault().SexType,
                          RelationToStudent = g.FirstOrDefault().LocalCourseTitle,
                          HighlyQualifiedTeacher = g.FirstOrDefault().HighlyQualifiedTeacher ?? false,
                          HighestCompletedLevelOfEducation = g.FirstOrDefault().HighestCompletedLevelOfEducation,
                          YearsOfTeachingExperience = g.FirstOrDefault().YearsOfPriorTeachingExperience,
                          ShortBiography = g.FirstOrDefault().ShortBiography,

                          // Per Client Request and Data Availability we are not bringing in this information on this phase.
                          // Additionally we are commenting out to bring less data and improve performance. 
                          //Emails = g.FirstOrDefault().Emails,
                          //Telephone = g.FirstOrDefault().Telephone,
                          //Addresses = g.FirstOrDefault().StaffAddresses.Select(a => new Address
                          //{
                          //    StreetNumberName = a.StreetNumberName,
                          //    City = a.City,
                          //    State = a.StateAbbreviationDescriptor.Descriptor.ShortDescription,
                          //    PostalCode = a.PostalCode
                          //}),
                          //Languages = g.FirstOrDefault().Languages,
                          //Credentials = g.FirstOrDefault().Credentials,

                          UnreadMessageCount = g.FirstOrDefault().Chat,
                          ChatEnabled = true,

                          Emails = g.FirstOrDefault().Emails

                      }).ToList();

            return gr;
        }

        public async Task<List<StudentSuccessTeamMember>> GetOtherStaff(int studentUsi)
        {
            var studentMaxBeginDate = await _edFiDb.StudentCohortAssociations
                                                 .Where(x => x.StudentUsi == studentUsi)
                                                 .GroupBy(x => x.StudentUsi)
                                                 .Select(g => g.Max(x => x.BeginDate))
                                                 .SingleOrDefaultAsync();

            var otherStaff = await (from staff in _edFiDb.Staffs
                                                .Include(x => x.SexType)
                                                .Include(x => x.LevelOfEducationDescriptor.LevelOfEducationType)
                                        //.Include(x => x.StaffLanguages.Select(l => l.LanguageDescriptor.LanguageType))
                                        //.Include(x => x.StaffAddresses.Select(s => s.StateAbbreviationType))
                                        //.Include(x => x.StaffTelephones)
                                        //.Include(x => x.StaffElectronicMails)
                                        //.Include(x => x.StaffCredentials.Select(c => c.CredentialType))
                                        //.Include(x => x.StaffCredentials)
                                    from bio in _edFiDb.StaffBiographies.Where(x => x.StaffUniqueId == staff.StaffUniqueId).DefaultIfEmpty()
                                    join staffCohort in _edFiDb.StaffCohortAssociations on staff.StaffUsi equals staffCohort.StaffUsi
                                    join studCohort in _edFiDb.StudentCohortAssociations on new { staffCohort.CohortIdentifier, staffCohort.EducationOrganizationId } equals new { studCohort.CohortIdentifier, studCohort.EducationOrganizationId }
                                    join staffEdOrg in _edFiDb.StaffEducationOrganizationAssignmentAssociations on staff.StaffUsi equals staffEdOrg.StaffUsi
                                    where studCohort.StudentUsi == studentUsi
                                          && studCohort.BeginDate == studentMaxBeginDate
                                    group new { staff, staffEdOrg, bio } by staff.StaffUsi into g
                                    select new StudentSuccessTeamMember
                                    {
                                        Id = g.FirstOrDefault().staff.StaffUsi,
                                        Guid = g.FirstOrDefault().staff.Id,
                                        UniqueId = g.FirstOrDefault().staff.StaffUniqueId,
                                        PersonTypeId = ChatLogPersonTypeEnum.Staff.Value,
                                        PersonalTitlePrefix = g.FirstOrDefault().staff.PersonalTitlePrefix,
                                        FirstName = g.FirstOrDefault().staff.FirstName,
                                        MiddleName = g.FirstOrDefault().staff.MiddleName,
                                        LastSurname = g.FirstOrDefault().staff.LastSurname,
                                        SexType = g.FirstOrDefault().staff.SexType.Description,
                                        RelationToStudent = g.FirstOrDefault().staffEdOrg.PositionTitle,
                                        HighlyQualifiedTeacher = g.FirstOrDefault().staff.HighlyQualifiedTeacher ?? false,
                                        HighestCompletedLevelOfEducation = g.FirstOrDefault().staff.LevelOfEducationDescriptor.LevelOfEducationType.ShortDescription,
                                        YearsOfTeachingExperience = g.FirstOrDefault().staff.YearsOfPriorTeachingExperience,
                                        ShortBiography = g.FirstOrDefault().bio.ShortBiography,
                                        ChatEnabled = false,
                                        //Emails = g.FirstOrDefault().staff.StaffElectronicMails.Select(e => e.ElectronicMailAddress).ToList(),
                                        //Telephone = g.FirstOrDefault().staff.StaffTelephones.Select(t => t.TelephoneNumber).ToList(),
                                        //Addresses = g.FirstOrDefault().staff.StaffAddresses.Select(a => new Address
                                        //{
                                        //    StreetNumberName = a.StreetNumberName,
                                        //    City = a.City,
                                        //    State = a.StateAbbreviationType.ShortDescription,
                                        //    PostalCode = a.PostalCode
                                        //}).ToList(),
                                        //Languages = g.FirstOrDefault().staff.StaffLanguages.Select(x => x.LanguageDescriptor.LanguageType.ShortDescription).ToList(),
                                        //Credentials = g.FirstOrDefault().staff.StaffCredentials.Select(x => x.CredentialType.ShortDescription).ToList(),
                                    }).ToListAsync();
            return otherStaff;
        }

        public async Task<List<StudentSuccessTeamMember>> GetParents(int studentUsi, string recipientUniqueId, int recipientTypeId)
        {
            var query = from p in _edFiDb.Parents
                            //.Include(x => x.ParentElectronicMails)
                            //.Include(x => x.ParentAddresses.Select(s => s.StateAbbreviationType))
                            //.Include(x => x.ParentTelephones)
                        from sex in _edFiDb.SexTypes.Where(x => x.SexTypeId == p.SexTypeId).DefaultIfEmpty()
                        join spa in _edFiDb.StudentParentAssociations on p.ParentUsi equals spa.ParentUsi
                        from rel in _edFiDb.RelationTypes.Where(x => x.RelationTypeId == spa.RelationTypeId).DefaultIfEmpty()
                        join s in _edFiDb.Students on spa.StudentUsi equals s.StudentUsi
                        from bio in _edFiDb.ParentBiographies.Where(x => x.ParentUniqueId == p.ParentUniqueId).DefaultIfEmpty()
                        where spa.StudentUsi == studentUsi
                        select new
                        {
                            p.ParentUsi,
                            p.Id,
                            p.ParentUniqueId,
                            p.PersonalTitlePrefix,
                            p.FirstName,
                            p.MiddleName,
                            p.LastSurname,
                            sex.Description,
                            rel.ShortDescription,
                            bio.ShortBiography,
                            spa.EmergencyContactStatus,
                            //Emails = p.ParentElectronicMails.Select(e => e.ElectronicMailAddress),
                            //Telephone = p.ParentTelephones.Select(t => t.TelephoneNumber),
                            //p.ParentAddresses,
                            Chat = _edFiDb.ChatLogs.Count(x => x.StudentUniqueId == s.StudentUniqueId
                                                           && x.SenderUniqueId == p.ParentUniqueId
                                                           && x.SenderTypeId == ChatLogPersonTypeEnum.Parent.Value
                                                           && x.RecipientUniqueId == recipientUniqueId
                                                           && x.RecipientTypeId == recipientTypeId
                                                           && !x.RecipientHasRead)
                        };

            var executedQuery = await query.ToListAsync();

            var parents = (from p in executedQuery
                           select new StudentSuccessTeamMember
                           {
                               Id = p.ParentUsi,
                               Guid = p.Id,
                               UniqueId = p.ParentUniqueId,
                               StudentUsi = studentUsi,
                               PersonTypeId = ChatLogPersonTypeEnum.Parent.Value,
                               PersonalTitlePrefix = p.PersonalTitlePrefix,
                               FirstName = p.FirstName,
                               MiddleName = p.MiddleName,
                               LastSurname = p.LastSurname,
                               SexType = p.Description,
                               RelationToStudent = p.ShortDescription,
                               //Emails = p.Emails,
                               //Telephone = p.Telephone,
                               //Addresses = p.ParentAddresses.Select(a => new Address
                               //{
                               //    StreetNumberName = a.StreetNumberName,
                               //    City = a.City,
                               //    State = a.StateAbbreviationType.ShortDescription,
                               //    PostalCode = a.PostalCode
                               //}),
                               ShortBiography = p.ShortBiography,
                               EmergencyContactStatus = p.EmergencyContactStatus.HasValue ? p.EmergencyContactStatus.Value : false,
                               UnreadMessageCount = p.Chat,
                               ChatEnabled = true
                           }).ToList();

            return parents;
        }

        public async Task<List<StudentSuccessTeamMember>> GetProgramAssociatedStaff(int studentUsi)
        {
            var otherStaff = await (from staff in _edFiDb.Staffs
                                                .Include(x => x.SexType)
                                                .Include(x => x.LevelOfEducationDescriptor.LevelOfEducationType)
                                        //.Include(x => x.StaffCredentials)
                                        //.Include(x => x.StaffLanguages.Select(l => l.LanguageDescriptor.LanguageType))
                                        //.Include(x => x.StaffAddresses.Select(s => s.StateAbbreviationType))
                                        //.Include(x => x.StaffTelephones)
                                        //.Include(x => x.StaffElectronicMails)
                                        //.Include(x => x.StaffCredentials.Select(c => c.CredentialType))
                                    from bio in _edFiDb.StaffBiographies.Where(x => x.StaffUniqueId == staff.StaffUniqueId).DefaultIfEmpty()
                                    join staffProg in _edFiDb.StaffProgramAssociations on staff.StaffUsi equals staffProg.StaffUsi
                                    join studProg in _edFiDb.StudentProgramAssociations
                                         on new { staffProg.ProgramTypeId, staffProg.ProgramName, staffProg.BeginDate, staffProg.ProgramEducationOrganizationId }
                                         equals new { studProg.ProgramTypeId, studProg.ProgramName, studProg.BeginDate, studProg.ProgramEducationOrganizationId }
                                    where studProg.StudentUsi == studentUsi
                                          && studProg.EndDate == null
                                    group new { staff, staffProg, bio } by staff.StaffUsi into g
                                    select new StudentSuccessTeamMember
                                    {
                                        Id = g.FirstOrDefault().staff.StaffUsi,
                                        Guid = g.FirstOrDefault().staff.Id,
                                        UniqueId = g.FirstOrDefault().staff.StaffUniqueId,
                                        PersonTypeId = ChatLogPersonTypeEnum.Staff.Value,
                                        PersonalTitlePrefix = g.FirstOrDefault().staff.PersonalTitlePrefix,
                                        FirstName = g.FirstOrDefault().staff.FirstName,
                                        MiddleName = g.FirstOrDefault().staff.MiddleName,
                                        LastSurname = g.FirstOrDefault().staff.LastSurname,
                                        SexType = g.FirstOrDefault().staff.SexType.Description,
                                        RelationToStudent = g.FirstOrDefault().staffProg.ProgramName,

                                        HighlyQualifiedTeacher = g.FirstOrDefault().staff.HighlyQualifiedTeacher ?? false,
                                        HighestCompletedLevelOfEducation = g.FirstOrDefault().staff.LevelOfEducationDescriptor.LevelOfEducationType.ShortDescription,
                                        YearsOfTeachingExperience = g.FirstOrDefault().staff.YearsOfPriorTeachingExperience,

                                        ShortBiography = g.FirstOrDefault().bio.ShortBiography,
                                        ChatEnabled = false,
                                        //Emails = g.FirstOrDefault().staff.StaffElectronicMails.Select(e => e.ElectronicMailAddress).ToList(),
                                        //Telephone = g.FirstOrDefault().staff.StaffTelephones.Select(t => t.TelephoneNumber).ToList(),
                                        //Addresses = g.FirstOrDefault().staff.StaffAddresses.Select(a => new Address
                                        //{
                                        //    StreetNumberName = a.StreetNumberName,
                                        //    City = a.City,
                                        //    State = a.StateAbbreviationType.ShortDescription,
                                        //    PostalCode = a.PostalCode
                                        //}).ToList(),
                                        //Languages = g.FirstOrDefault().staff.StaffLanguages.Select(x => x.LanguageDescriptor.LanguageType.ShortDescription).ToList(),
                                        //Credentials = g.FirstOrDefault().staff.StaffCredentials.Select(x => x.CredentialType.ShortDescription).ToList(),
                                    }).ToListAsync();
            return otherStaff;
        }

        public async Task<List<StudentSuccessTeamMember>> GetSiblings(int studentUsi)
        {
            var parentUsis = await (from sp in _edFiDb.StudentParentAssociations
                                    where sp.StudentUsi == studentUsi
                                    select sp.ParentUsi).ToListAsync();

            var siblings = await (from sp in _edFiDb.StudentParentAssociations
                                                 .Include(x => x.RelationType)
                                                 .Include(x => x.EmergencyContactStatus)
                                  join s in _edFiDb.Students
                                                .Include(x => x.StudentElectronicMails)
                                                .Include(x => x.SexType)
                                                .Include(x => x.StudentLanguages.Select(l => l.LanguageDescriptor.LanguageType))
                                         on sp.StudentUsi equals s.StudentUsi
                                  join ssa in _edFiDb.StudentSchoolAssociations
                                                .Include(x => x.GradeLevelDescriptor.GradeLevelType)
                                         on sp.StudentUsi equals ssa.StudentUsi
                                  join eo in _edFiDb.EducationOrganizations.DefaultIfEmpty()
                                         on ssa.SchoolId equals eo.EducationOrganizationId
                                  where sp.StudentUsi != studentUsi && parentUsis.Contains(sp.ParentUsi) && ssa.ExitWithdrawDate == null
                                  select new StudentSuccessTeamMember
                                  {
                                      Id = s.StudentUsi,
                                      Guid = s.Id,
                                      UniqueId = s.StudentUniqueId,
                                      PersonalTitlePrefix = s.PersonalTitlePrefix,
                                      FirstName = s.FirstName,
                                      MiddleName = s.MiddleName,
                                      LastSurname = s.LastSurname,
                                      SexType = s.SexType.Description,
                                      RelationToStudent = "Sibling",
                                      //Emails = new List<string>(),
                                      //Emails = s.StudentElectronicMails.Select(x => x.ElectronicMailAddress).ToList(),
                                      NameOfInstitution = eo.NameOfInstitution,
                                      GradeLevel = ssa.GradeLevelDescriptor.GradeLevelType.ShortDescription,
                                  }).ToListAsync();

            return siblings;
        }

        public async Task<List<StudentCalendarDay>> GetStudentCalendarDays(int studentUsi)
        {
            var studentSchoolAssociation = await _edFiDb.StudentSchoolAssociations.FirstOrDefaultAsync(x => x.StudentUsi == studentUsi && x.ExitWithdrawDate == null);
            var days = await (from cd in _edFiDb.CalendarDates
                              join cdc in _edFiDb.CalendarDateCalendarEvents
                                 on new { cd.SchoolId, cd.Date } equals new { cdc.SchoolId, cdc.Date }
                              join d in _edFiDb.Descriptors on cdc.CalendarEventDescriptorId equals d.DescriptorId into dc
                              from ced in dc.DefaultIfEmpty()
                              where cd.SchoolId == studentSchoolAssociation.SchoolId
                              select new {
                                  Date = cd.Date,
                                  EventName = ced.CodeValue,
                                  EventDescription = ced.CodeValue
                              }).ToListAsync();

            return days.Select(x => new StudentCalendarDay
            {
                Date = x.Date,
                Event = new StudentCalendarEvent { Name = x.EventName, Description = x.EventDescription }
            }).ToList();
        }

        public async Task<int> getTotalInstructionalDays(int studentUsi, StudentCalendar studentCalendar)
        {
            var ssas = await (from ssa in _edFiDb.StudentSchoolAssociations
                              where ssa.StudentUsi == studentUsi
                              select new {
                                  ssa.EntryDate,
                                  ssa.ExitWithdrawDate
                              }).ToListAsync();

            return studentCalendar.InstructionalDays.Count(x => ssas.Any(s => x.Date >= s.EntryDate && (s.ExitWithdrawDate == null || x.Date <= s.ExitWithdrawDate)));
        }

        public async Task<List<StudentObjectiveAssessment>> GetStudentObjectiveAssessments(int studentUsi)
        {
            var list = await (from sasoa in _edFiDb.StudentAssessmentStudentObjectiveAssessments
                              join sasoasr in _edFiDb.StudentAssessmentStudentObjectiveAssessmentScoreResults
                                     on new { sasoa.AssessmentIdentifier, sasoa.IdentificationCode, sasoa.Namespace, sasoa.StudentAssessmentIdentifier, sasoa.StudentUsi }
                                     equals new { sasoasr.AssessmentIdentifier, sasoasr.IdentificationCode, sasoasr.Namespace, sasoasr.StudentAssessmentIdentifier, sasoasr.StudentUsi }
                              join sa in _edFiDb.StudentAssessments
                                     on new { sasoa.AssessmentIdentifier, sasoa.Namespace, sasoa.StudentAssessmentIdentifier, sasoa.StudentUsi }
                                     equals new { sa.AssessmentIdentifier, sa.Namespace, sa.StudentAssessmentIdentifier, sa.StudentUsi }
                              join oe in _edFiDb.ObjectiveAssessments
                                     on new { sasoa.AssessmentIdentifier, sasoa.Namespace, sasoa.IdentificationCode }
                                     equals new { oe.AssessmentIdentifier, oe.Namespace, oe.IdentificationCode }
                              where sasoa.StudentUsi == studentUsi
                              select new
                              {
                                  Title = oe.Description,
                                  sasoasr.Result,
                                  sa.AdministrationDate,
                                  oe.ParentIdentificationCode,
                                  sasoa.AssessmentIdentifier,
                                  oe.IdentificationCode
                              }).ToListAsync();

            var result = list.GroupBy(x => x.Title).Select(x => new StudentObjectiveAssessment
            {
                Title = x.Key,
                EnglishResult = x.FirstOrDefault(r => !r.AssessmentIdentifier.Contains("Spanish") && r.AdministrationDate == x.Where(d => !d.AssessmentIdentifier.Contains("Spanish")).Max(d => d.AdministrationDate))?.Result,
                SpanishResult = x.FirstOrDefault(r => r.AssessmentIdentifier.Contains("Spanish") && r.AdministrationDate == x.Where(d => d.AssessmentIdentifier.Contains("Spanish")).Max(d => d.AdministrationDate))?.Result,
                ParentIdentificationCode = x.FirstOrDefault().ParentIdentificationCode,
                IdentificationCode = x.FirstOrDefault().IdentificationCode,
                AssessmentIdentifier = x.FirstOrDefault().AssessmentIdentifier,
                AdministrationDate = x.Max(p => p.AdministrationDate)
            }).ToList();

            return result;
        }

        private UserProfileModel ToUserProfileModel(Student student)
        {
            var model = new UserProfileModel
            {
                Usi = student.StudentUsi,
                UniqueId = student.StudentUniqueId,
                FirstName = student.FirstName,
                MiddleName = student.MiddleName,
                LastSurname = student.LastSurname,
                IdentificationCode = student.StudentIdentificationCodes.FirstOrDefault(x => x.AssigningOrganizationIdentificationCode == "LASID")?.IdentificationCode,
                Addresses = student.StudentAddresses.Select(x => new AddressModel
                {
                    AddressTypeId = x.AddressTypeId,
                    StreetNumberName = x.StreetNumberName,
                    ApartmentRoomSuiteNumber = x.ApartmentRoomSuiteNumber,
                    City = x.City,
                    StateAbbreviationTypeId = x.StateAbbreviationTypeId,
                    PostalCode = x.PostalCode
                }).ToList(),
                ElectronicMails = student.StudentElectronicMails.Select(x => new ElectronicMailModel
                {
                    ElectronicMailAddress = x.ElectronicMailAddress,
                    ElectronicMailTypeId = x.ElectronicMailTypeId,
                    PrimaryEmailAddressIndicator = x.PrimaryEmailAddressIndicator
                }).ToList(),
                TelephoneNumbers = student.StudentTelephones.Select(x => new TelephoneModel
                {
                    TelephoneNumber = x.TelephoneNumber,
                    TextMessageCapabilityIndicator = x.TextMessageCapabilityIndicator,
                    TelephoneNumberTypeId = x.TelephoneNumberTypeId
                }).ToList()
            };

            return model;
        }

        private BriefProfileModel ToBriefProfileModel(Student profile)
        {
            var briefProfileModel = new BriefProfileModel();
            briefProfileModel.FirstName = profile.FirstName;
            briefProfileModel.MiddleName = profile.MiddleName;
            briefProfileModel.LastSurname = profile.LastSurname;
            briefProfileModel.Usi = profile.StudentUsi;
            briefProfileModel.UniqueId = profile.StudentUniqueId;
            //briefProfileModel.LanguageCode = profile.LanguageCode;
            briefProfileModel.PersonTypeId = ChatLogPersonTypeEnum.Student.Value;
            briefProfileModel.Role = ChatLogPersonTypeEnum.Student.DisplayName;
            briefProfileModel.Email = profile.StudentElectronicMails.FirstOrDefault().ElectronicMailAddress;
            briefProfileModel.IdentificationCode = profile.StudentIdentificationCodes.FirstOrDefault(x => x.AssigningOrganizationIdentificationCode == "LASID")?.IdentificationCode;

            return briefProfileModel;
        }

        public async Task<ParentPortal.Models.Student.StudentGoal> AddStudentGoal(ParentPortal.Models.Student.StudentGoal studentGoal)
        {
            ParentPortal.Models.Student.StudentGoal result = new ParentPortal.Models.Student.StudentGoal();
            try
            {
                StudentGoal newGoal = new StudentGoal
                {
                    Additional = studentGoal.Additional,
                    Completed = studentGoal.Completed == "" ? "NA" : studentGoal.Completed,
                    DateGoalCreated = studentGoal.DateGoalCreated,
                    DateScheduled = studentGoal.DateScheduled,
                    Goal = studentGoal.Goal,
                    StudentUsi = studentGoal.StudentUsi,
                    GoalType = studentGoal.GoalType,
                    DateCompleted=studentGoal.DateCompleted,
                    DateCreated = DateTime.Now,
                    DateUpdated = DateTime.Now,
                    GradeLevel = studentGoal.GradeLevel,
                    Labels = studentGoal.Labels
                };

                newGoal = _edFiDb.StudentGoals.Add(newGoal);
                await _edFiDb.SaveChangesAsync();

                if (newGoal.StudentGoalId > 0)
                {
                    foreach (var step in studentGoal.Steps)
                    {
                        step.StudentGoalId = newGoal.StudentGoalId;
                        await AddStudentGoalStep(step);
                    }
                }

                result = await (from sg in _edFiDb.StudentGoals
                                where sg.StudentGoalId == newGoal.StudentGoalId
                                select new ParentPortal.Models.Student.StudentGoal
                                {
                                    Labels=sg.Labels,
                                    GradeLevel=sg.GradeLevel,
                                    DateCompleted = sg.DateCompleted,
                                    Goal = sg.Goal,
                                    GoalType = sg.GoalType,
                                    Additional = sg.Additional,
                                    Completed = sg.Completed == "NA" ? "" : sg.Completed,
                                    DateCreated = sg.DateCreated,
                                    DateGoalCreated = sg.DateGoalCreated,
                                    DateScheduled = sg.DateScheduled,
                                    DateUpdated = sg.DateUpdated,
                                    StudentGoalId = sg.StudentGoalId,
                                    Steps = sg.StudentGoalSteps.Select(p => new ParentPortal.Models.Student.StudentGoalStep
                                    {
                                        StudentGoalId = p.StudentGoalId,
                                        Completed = p.Completed,
                                        DateCreated = p.DateCreated,
                                        DateUpdated = p.DateUpdated,
                                        StepName = p.StepName,
                                        StudentGoalStepId = p.StudentGoalStepId,
                                        IsActive = p.IsActive,
                                        StudentGoalInterventionId = p.StudentGoalInterventionId
                                    }).ToList()
                                }).FirstOrDefaultAsync();
            }
            catch
            {
                return null;
            }
            return result;
        }

        public async Task<ParentPortal.Models.Student.StudentGoal> UpdateStudentGoal(ParentPortal.Models.Student.StudentGoal studentGoal)
        {
            ParentPortal.Models.Student.StudentGoal result = new ParentPortal.Models.Student.StudentGoal();
            try
            {
                StudentGoal currentGoal = await _edFiDb.StudentGoals.FirstOrDefaultAsync(p => p.StudentGoalId == studentGoal.StudentGoalId);
                currentGoal.Goal = studentGoal.Goal;
                currentGoal.DateGoalCreated = studentGoal.DateGoalCreated;
                currentGoal.DateScheduled = studentGoal.DateScheduled;
                currentGoal.Labels = studentGoal.Labels;
                currentGoal.Additional = studentGoal.Additional;
                currentGoal.Completed = studentGoal.Completed ?? "NA";
                currentGoal.DateCompleted = studentGoal.DateCompleted;
                currentGoal.DateUpdated = DateTime.Now;
                await _edFiDb.SaveChangesAsync();

                var listSteps = await _edFiDb.StudentGoalSteps.Where(p => p.StudentGoalId == studentGoal.StudentGoalId).ToListAsync();
                foreach (var currentStep in listSteps)
                {
                    var existStep = studentGoal.Steps.FirstOrDefault(p => p.StudentGoalStepId == currentStep.StudentGoalStepId);
                    if (existStep == null)
                    {
                        _edFiDb.StudentGoalSteps.Remove(currentStep);
                    }
                }
                await _edFiDb.SaveChangesAsync();

                foreach (var step in studentGoal.Steps)
                {
                    if (step.StudentGoalStepId == 0)
                    {
                        step.StudentGoalId = studentGoal.StudentGoalId;
                        await AddStudentGoalStep(step);
                    }
                    else
                    {
                        await UpdateStudentGoalStep(step);
                    }
                }

                result = await (from sg in _edFiDb.StudentGoals
                                where sg.StudentGoalId == studentGoal.StudentGoalId
                                select new ParentPortal.Models.Student.StudentGoal
                                {
                                    Labels = sg.Labels,
                                    GradeLevel = sg.GradeLevel,
                                    DateCompleted = sg.DateCompleted,
                                    Goal = sg.Goal,
                                    GoalType = sg.GoalType,
                                    Additional = sg.Additional,
                                    Completed = sg.Completed == "NA" ? "" : sg.Completed,
                                    DateCreated = sg.DateCreated,
                                    DateGoalCreated = sg.DateGoalCreated,
                                    DateScheduled = sg.DateScheduled,
                                    DateUpdated = sg.DateUpdated,
                                    StudentGoalId = sg.StudentGoalId,
                                    Steps = sg.StudentGoalSteps.Select(p => new ParentPortal.Models.Student.StudentGoalStep
                                    {
                                        StudentGoalId = p.StudentGoalId,
                                        Completed = p.Completed,
                                        DateCreated = p.DateCreated,
                                        DateUpdated = p.DateUpdated,
                                        StepName = p.StepName,
                                        StudentGoalStepId = p.StudentGoalStepId,
                                        IsActive = p.IsActive,
                                        StudentGoalInterventionId = p.StudentGoalInterventionId
                                    }).ToList()
                                }).FirstOrDefaultAsync();
            }
            catch
            {
                return null;
            }
            return result;
        }

        public async Task<bool> AddStudentGoalStep(ParentPortal.Models.Student.StudentGoalStep studentGoalStep)
        {
            try
            {
                StudentGoalStep newStep = new StudentGoalStep
                {
                    Completed = studentGoalStep.Completed,
                    StepName = studentGoalStep.StepName,
                    StudentGoalId = studentGoalStep.StudentGoalId,
                    DateCreated = DateTime.Now,
                    DateUpdated = DateTime.Now,
                    IsActive = studentGoalStep.IsActive,
                    StudentGoalInterventionId = studentGoalStep.StudentGoalInterventionId
                };

                _edFiDb.StudentGoalSteps.Add(newStep);
                await _edFiDb.SaveChangesAsync();
            }
            catch
            {
                return false;
            }
            return true;
        }

        public async Task<bool> UpdateStudentGoalStep(ParentPortal.Models.Student.StudentGoalStep studentGoalStep)
        {
            try
            {
                StudentGoalStep currentStep = await _edFiDb.StudentGoalSteps.FirstOrDefaultAsync(p => p.StudentGoalStepId == studentGoalStep.StudentGoalStepId);
                currentStep.IsActive = studentGoalStep.IsActive;
                currentStep.StudentGoalInterventionId = studentGoalStep.StudentGoalInterventionId;
                currentStep.Completed = studentGoalStep.Completed;
                currentStep.DateUpdated = DateTime.Now;
                await _edFiDb.SaveChangesAsync();
            }
            catch
            {
                return false;
            }
            return true;
        }

        public async Task<ParentPortal.Models.Student.StudentGoal> UpdateStudentGoalIntervention(ParentPortal.Models.Student.StudentGoalIntervention entity)
        {
            ParentPortal.Models.Student.StudentGoal result = new ParentPortal.Models.Student.StudentGoal();
            try
            {
                var listSteps = await _edFiDb.StudentGoalSteps.Where(p => p.StudentGoalId == entity.StudentGoalId).ToListAsync();
                foreach (var step in listSteps)
                {
                    step.IsActive = false;
                    step.DateUpdated = DateTime.Now;
                }

                var entityResult = _edFiDb.StudentGoalInterventions.Add(new StudentGoalIntervention
                {
                    StudentGoalId = entity.StudentGoalId,
                    StudentUsi = entity.StudentUsi,
                    DateCreated=DateTime.Now,
                    DateUpdated=DateTime.Now,
                    Description=entity.Description,
                    InterventionStart= entity.InterventionStart,
                });

                await _edFiDb.SaveChangesAsync();

                foreach (var step in entity.Steps)
                {
                    _edFiDb.StudentGoalSteps.Add(new StudentGoalStep {
                        Completed = false,
                        StepName = step.StepName,
                        StudentGoalId = entity.StudentGoalId,
                        DateCreated = DateTime.Now,
                        DateUpdated = DateTime.Now,
                        IsActive = true,
                        StudentGoalInterventionId = entityResult.StudentGoalInterventionId
                    });
                }

                await _edFiDb.SaveChangesAsync();

                result = await (from sg in _edFiDb.StudentGoals
                                where sg.StudentGoalId == entity.StudentGoalId
                                select new ParentPortal.Models.Student.StudentGoal
                                {
                                    Labels = sg.Labels,
                                    GradeLevel = sg.GradeLevel,
                                    DateCompleted = sg.DateCompleted,
                                    Goal = sg.Goal,
                                    GoalType = sg.GoalType,
                                    Additional = sg.Additional,
                                    Completed = sg.Completed == "NA" ? "" : sg.Completed,
                                    DateCreated = sg.DateCreated,
                                    DateGoalCreated = sg.DateGoalCreated,
                                    DateScheduled = sg.DateScheduled,
                                    DateUpdated = sg.DateUpdated,
                                    StudentGoalId = sg.StudentGoalId,
                                    Steps = sg.StudentGoalSteps.Select(p => new ParentPortal.Models.Student.StudentGoalStep
                                    {
                                        StudentGoalId = p.StudentGoalId,
                                        Completed = p.Completed,
                                        DateCreated = p.DateCreated,
                                        DateUpdated = p.DateUpdated,
                                        StepName = p.StepName,
                                        StudentGoalStepId = p.StudentGoalStepId,
                                        IsActive = p.IsActive,
                                        StudentGoalInterventionId = p.StudentGoalInterventionId
                                    }).ToList()
                                }).FirstOrDefaultAsync();
            }
            catch
            {
                return null;
            }
            return result;
        }

        public async Task<List<ParentPortal.Models.Student.StudentGoal>> GetStudentGoals(int studentUsi)
        {
            var list = await (from sg in _edFiDb.StudentGoals
                              where sg.StudentUsi == studentUsi
                              select new ParentPortal.Models.Student.StudentGoal
                              {
                                  Labels=sg.Labels,
                                  GradeLevel = sg.GradeLevel,
                                  DateCompleted = sg.DateCompleted,
                                  StudentUsi=sg.StudentUsi,
                                  Goal = sg.Goal,
                                  GoalType = sg.GoalType,
                                  Additional = sg.Additional,
                                  Completed = sg.Completed == "NA" ? "" : sg.Completed,
                                  DateCreated = sg.DateCreated,
                                  DateGoalCreated = sg.DateGoalCreated,
                                  DateScheduled = sg.DateScheduled,
                                  DateUpdated = sg.DateUpdated,
                                  StudentGoalId = sg.StudentGoalId,
                                  Steps = sg.StudentGoalSteps.Select(p => new ParentPortal.Models.Student.StudentGoalStep
                                  {
                                      StudentGoalId=p.StudentGoalId,
                                      Completed = p.Completed,
                                      DateCreated = p.DateCreated,
                                      DateUpdated = p.DateUpdated,
                                      StepName = p.StepName,
                                      StudentGoalStepId = p.StudentGoalStepId,
                                      IsActive=p.IsActive,
                                      StudentGoalInterventionId=p.StudentGoalInterventionId
                                  }).ToList()

                              }).ToListAsync();
            return list;
        }

        public async Task<List<ParentPortal.Models.Student.StudentGoalLabel>> GetStudentGoalLabels()
        {
            var list = await (from sg in _edFiDb.StudentGoalLabels
                              select new ParentPortal.Models.Student.StudentGoalLabel
                              {
                                  StudentGoalLabelId = sg.StudentGoalLabelId,
                                  Label = sg.Label,
                                  DateCreated = sg.DateCreated,
                                  DateUpdated = sg.DateUpdated

                              }).ToListAsync();
            return list;
        }

        public async Task<ParentPortal.Models.Student.StudentAllAbout> AddStudentAllAbout(ParentPortal.Models.Student.StudentAllAbout newRecord)
        {
            ParentPortal.Models.Student.StudentAllAbout result = new ParentPortal.Models.Student.StudentAllAbout();
            try
            {
                StudentAllAbout record = new StudentAllAbout
                {
                    FavoriteAnimal=newRecord.FavoriteAnimal,
                    StudentAllAboutId = newRecord.StudentAllAboutId,
                    FavoriteSubjectSchool = newRecord.FavoriteSubjectSchool,
                    FavoriteThingToDo = newRecord.FavoriteThingToDo,
                    FunFact = newRecord.FunFact,
                    LearningThings = newRecord.LearningThings,
                    LearnToDo = newRecord.LearnToDo,
                    OneThingWant = newRecord.OneThingWant,
                    PrefferedName = newRecord.PrefferedName,
                    TypesOfBook = newRecord.TypesOfBook,
                    StudentUsi = newRecord.StudentUsi,
                    DateCreated = DateTime.Now,
                    DateUpdated = DateTime.Now,
                };

                record = _edFiDb.StudentAllAbouts.Add(record);
                await _edFiDb.SaveChangesAsync();
                result = await GetStudentAllAbout(record.StudentUsi);
            }
            catch
            {
                return null;
            }
            return result;
        }

        public async Task<ParentPortal.Models.Student.StudentAllAbout> UpdateStudentAllAbout(ParentPortal.Models.Student.StudentAllAbout updatedRecord)
        {
            ParentPortal.Models.Student.StudentAllAbout result = new ParentPortal.Models.Student.StudentAllAbout();
            try
            {
                StudentAllAbout currentRecord = await _edFiDb.StudentAllAbouts.FirstOrDefaultAsync(p => p.StudentAllAboutId == updatedRecord.StudentAllAboutId);
                currentRecord.FavoriteAnimal = updatedRecord.FavoriteAnimal;
                currentRecord.FavoriteSubjectSchool = updatedRecord.FavoriteSubjectSchool;
                currentRecord.FavoriteThingToDo = updatedRecord.FavoriteThingToDo;
                currentRecord.FunFact = updatedRecord.FunFact;
                currentRecord.LearningThings = updatedRecord.LearningThings;
                currentRecord.LearnToDo = updatedRecord.LearnToDo;
                currentRecord.OneThingWant = updatedRecord.OneThingWant;
                currentRecord.PrefferedName = updatedRecord.PrefferedName;
                currentRecord.TypesOfBook = updatedRecord.TypesOfBook;
                currentRecord.DateUpdated = DateTime.Now;
                await _edFiDb.SaveChangesAsync();
                result = await GetStudentAllAbout(currentRecord.StudentUsi);
            }
            catch
            {
                return null;
            }
            return result;
        }

        public async Task<ParentPortal.Models.Student.StudentAllAbout> GetStudentAllAbout(int studentUsi)
        {
            var record = await (from sg in _edFiDb.StudentAllAbouts
                                select new ParentPortal.Models.Student.StudentAllAbout
                                {
                                    StudentAllAboutId = sg.StudentAllAboutId,
                                    StudentUsi = sg.StudentUsi,
                                    FavoriteAnimal = sg.FavoriteAnimal,
                                    FavoriteSubjectSchool = sg.FavoriteSubjectSchool,
                                    FavoriteThingToDo = sg.FavoriteThingToDo,
                                    FunFact = sg.FunFact,
                                    LearningThings = sg.LearningThings,
                                    LearnToDo = sg.LearnToDo,
                                    OneThingWant = sg.OneThingWant,
                                    PrefferedName = sg.PrefferedName,
                                    TypesOfBook = sg.TypesOfBook,
                                    DateCreated = sg.DateCreated,
                                    DateUpdated = sg.DateUpdated

                                }).FirstOrDefaultAsync();
            return record;
        }

        public async Task<List<StudentSuccessTeamMember>> GetPrincipals(int studentUsi, string[] validLeadersDescriptors, string recipientUniqueId, int recipientTypeId)
        {
            var query = from staff in _edFiDb.Staffs
                        join staffEdOrg in _edFiDb.StaffEducationOrganizationAssignmentAssociations on staff.StaffUsi equals staffEdOrg.StaffUsi
                        join seoa in _edFiDb.StudentEducationOrganizationAssociations on staffEdOrg.EducationOrganizationId equals seoa.EducationOrganizationId
                        join s in _edFiDb.Students on seoa.StudentUsi equals s.StudentUsi
                        from led in _edFiDb.Descriptors.Where(x => x.DescriptorId == staff.HighestCompletedLevelOfEducationDescriptorId).DefaultIfEmpty()
                        from bio in _edFiDb.StaffBiographies.Where(x => x.StaffUniqueId == staff.StaffUniqueId).DefaultIfEmpty()
                        where s.StudentUsi == studentUsi && validLeadersDescriptors.Contains(staffEdOrg.PositionTitle)
                        select new
                        {
                            staff.StaffUsi,
                            staff.Id,
                            staff.StaffUniqueId,
                            staff.PersonalTitlePrefix,
                            staff.FirstName,
                            staff.MiddleName,
                            staff.LastSurname,
                            staffEdOrg.PositionTitle,
                            staff.YearsOfPriorTeachingExperience,
                            staff.HighlyQualifiedTeacher,
                            bio.ShortBiography,
                            HighestCompletedLevelOfEducation = led.ShortDescription,
                            Chat = _edFiDb.ChatLogs.Count(x => x.StudentUniqueId == s.StudentUniqueId
                                                                    && x.SenderUniqueId == staff.StaffUniqueId
                                                                    && x.SenderTypeId == ChatLogPersonTypeEnum.Staff.Value
                                                                    && x.RecipientUniqueId == recipientUniqueId
                                                                    && x.RecipientTypeId == recipientTypeId
                                                                    && !x.RecipientHasRead)
                        };

            var executedQuery = await query.ToListAsync();

            var gr = (from d in executedQuery
                      group d by d.StaffUsi into g
                      select new StudentSuccessTeamMember
                      {
                          Id = g.FirstOrDefault().StaffUsi,
                          Guid = g.FirstOrDefault().Id,
                          UniqueId = g.FirstOrDefault().StaffUniqueId,
                          StudentUsi = studentUsi,
                          PersonTypeId = ChatLogPersonTypeEnum.Staff.Value,
                          PersonalTitlePrefix = g.FirstOrDefault().PersonalTitlePrefix,
                          RelationToStudent = g.FirstOrDefault().PositionTitle,
                          FirstName = g.FirstOrDefault().FirstName,
                          MiddleName = g.FirstOrDefault().MiddleName,
                          LastSurname = g.FirstOrDefault().LastSurname,
                          HighlyQualifiedTeacher = g.FirstOrDefault().HighlyQualifiedTeacher ?? false,
                          HighestCompletedLevelOfEducation = g.FirstOrDefault().HighestCompletedLevelOfEducation,
                          YearsOfTeachingExperience = g.FirstOrDefault().YearsOfPriorTeachingExperience,
                          ShortBiography = g.FirstOrDefault().ShortBiography,
                          UnreadMessageCount = g.FirstOrDefault().Chat,
                          ChatEnabled = ChatLogPersonTypeEnum.Parent.Value == recipientTypeId
                      }).ToList();

            return gr;
        }

        public Task<PersonBriefModel> GetStudentBriefModelAsyncByUniqueId(string studentUniqueId)
        {
            throw new NotImplementedException();
        }

        public Task<List<StudentParentAssociationModel>> GetParentAssociation(int studentUsi)
        {
            throw new NotImplementedException();
        }

        public Task<List<ParentStudentsModel>> GetParentsBySection(int staffUsi, StaffSectionModel model, string[] validEmailTypeDescriptors, DateTime today)
        {
            throw new NotImplementedException();
        }

        public Task<ParentStudentCountModel> GetFamilyMembersBySection(int staffUsi, StaffSectionModel model, string[] validParentDescriptors, DateTime today)
        {
            throw new NotImplementedException();
        }

        public async Task<List<ParentPortal.Models.Student.DisciplineIncident>> GetStudentDisciplineIncidentsAsync(int studentUsi, string disciplineIncidentDescriptor, DateTime date)
        {
            var data = await(from sdia in _edFiDb.StudentDisciplineIncidentAssociations
                             join spct in _edFiDb.StudentParticipationCodeTypes on sdia.StudentParticipationCodeTypeId equals spct.StudentParticipationCodeTypeId
                             join di in _edFiDb.DisciplineIncidents on sdia.IncidentIdentifier equals di.IncidentIdentifier
                             join dadi in _edFiDb.DisciplineActionDisciplineIncidents on new { di.IncidentIdentifier, di.SchoolId } equals new { dadi.IncidentIdentifier, dadi.SchoolId }
                             join da in _edFiDb.DisciplineActions on new { dadi.DisciplineActionIdentifier, dadi.StudentUsi, dadi.DisciplineDate } equals new { da.DisciplineActionIdentifier, da.StudentUsi, da.DisciplineDate }
                             join dad in _edFiDb.DisciplineActionDisciplines on new { da.DisciplineActionIdentifier, da.StudentUsi, da.DisciplineDate } equals new { dad.DisciplineActionIdentifier, dad.StudentUsi, dad.DisciplineDate }
                             join dd in _edFiDb.DisciplineDescriptors on dad.DisciplineDescriptorId equals dd.DisciplineDescriptorId
                             join dt in _edFiDb.DisciplineTypes on dd.DisciplineTypeId equals dt.DisciplineTypeId
                             join s in _edFiDb.Students
                                         .Include(x => x.StudentSectionAssociations)
                                     on sdia.StudentUsi equals s.StudentUsi
                             where sdia.StudentUsi == studentUsi /*&& _edFiDb.Sessions.Where(x => x.SchoolId == sdia.SchoolId).Max(x => x.BeginDate) <= di.IncidentDate*/
                             && spct.CodeValue == disciplineIncidentDescriptor
                             orderby di.IncidentDate descending
                             select new
                             {
                                 IncidentIdentifier = di.IncidentIdentifier,
                                 IncidentDate = di.IncidentDate,
                                 Description = di.IncidentDescription,
                                 DisciplineActionIdentifier = da.DisciplineActionIdentifier,
                                 DisciplineActionDescription = dt.Description,
                                 DisciplineActionCodeValue = dt.CodeValue
                             }).ToListAsync();

            // There can be multiple discipline incidents
            // And each incident can have multiple actions associated to them

            var incidents = (from d in data
                             group d by d.IncidentIdentifier into g
                             select new ParentPortal.Models.Student.DisciplineIncident
                             {
                                 IncidentIdentifier = g.Key,
                                 IncidentDate = g.First().IncidentDate,
                                 Description = g.First().Description,
                                 DisciplineActionCodeValue = g.First().DisciplineActionCodeValue,
                                 DisciplineActionsTaken = g.Select(x => new DisciplineActionTaken { DisciplineActionIdentifier = x.DisciplineActionIdentifier, Description = x.DisciplineActionDescription }).ToList()
                             }).ToList();

            return incidents;
        }

        public async Task<List<PersonIdentityModel>> GetStudentIdentityByEmailAsync(string email)
        {
            var identity = await (from s in _edFiDb.Students
                                  join sa in _edFiDb.StudentElectronicMails on s.StudentUsi equals sa.StudentUsi
                                  where sa.ElectronicMailAddress == email
                                  select new PersonIdentityModel
                                  {
                                      Usi = s.StudentUsi,
                                      UniqueId = s.StudentUniqueId,
                                      PersonTypeId = ChatLogPersonTypeEnum.Student.Value,
                                      FirstName = s.FirstName,
                                      LastSurname = s.LastSurname,
                                      Email = sa.ElectronicMailAddress
                                  }).ToListAsync();

            return identity;
        }
    }
}
