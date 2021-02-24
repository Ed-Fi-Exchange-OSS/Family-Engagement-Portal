using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Models.User;

namespace Student1.ParentPortal.Data.Models.EdFi25
{
    public class StudentRepository : IStudentRepository
    {
        private readonly EdFi25Context _edFiDb;

        public StudentRepository(EdFi25Context edFiDb)
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

        public async Task<List<StudentAbsencesCount>> GetStudentsWithAbsenceCountGreaterOrEqualThanThresholdAsync(int thresholdCount)
        {
            var studentsAndAbsenceCount = await(from s in _edFiDb.StudentSchoolAttendanceEvents
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
                where sdia.StudentUsi == studentUsi && _edFiDb.Sessions.Where(x => x.SchoolId == sdia.SchoolId).Max(x => x.BeginDate) <= di.IncidentDate
                && spct.CodeValue == disciplineIncidentDescriptor
                orderby di.IncidentDate descending
                select new
                {
                    IncidentIdentifier = di.IncidentIdentifier,
                    IncidentDate = di.IncidentDate,
                    Description = di.IncidentDescription,
                    DisciplineActionIdentifier = da.DisciplineActionIdentifier,
                    DisciplineActionDescription = dt.Description
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
            var transcript = await(from ct in _edFiDb.CourseTranscripts
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
            var gpaData = await(from sar in _edFiDb.StudentAcademicRecords
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
            var data = await(from gra in _edFiDb.Grades.Include(x => x.GradeType).Include(x => x.GradingPeriod)
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
                           }).OrderBy(x=>x.ClassPeriodName).ToList();

            return courses;
        }

        public async Task<List<AssessmentRecord>> GetStudentAssessmentAsync(int studentUsi, string assessmentReportingMethodTypeDescriptor, string assessmentTitle)
        {
            var data = await(from sa in _edFiDb.StudentAssessments
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
                                MaxRawScore = (decimal)a.MaxRawScore,
                                AdministrationDate  = sa.AdministrationDate,
                                Result = sasr.Result,
                                PerformanceLevelMet = plt.ShortDescription,
                                GradeLevel = sa.GradeLevelDescriptor.Descriptor.CodeValue
                             }).ToListAsync();

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
                                                on new { gbe.SchoolId, gbe.ClassPeriodName, gbe.ClassroomIdentificationCode, gbe.LocalCourseCode, gbe.UniqueSectionCode, gbe.SequenceOfCourse, gbe.SchoolYear, gbe.TermDescriptorId} 
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
            var model = await(from si in _edFiDb.StudentIndicators
                              where si.StudentUsi == studentUsi
                                    && si.EndDate == null
                              select new Student1.ParentPortal.Models.Student.StudentIndicator
                              {
                                  IndicatorName = si.IndicatorName,
                                  BeginDate = si.BeginDate
                              }).ToListAsync();

            return model;
        }

        public async Task<PersonBriefModel> GetStudentBriefModelAsync(int studentUsi)
        {
            var data = await (from s in _edFiDb.Students.Include(x => x.StudentElectronicMails)
                              where s.StudentUsi == studentUsi
                              select new PersonBriefModel
                              {
                                  Usi = s.StudentUsi,
                                  UniqueId = s.StudentUniqueId,
                                  FirstName = s.FirstName,
                                  LastSurname = s.LastSurname
                              }).SingleOrDefaultAsync();

            return data;
        }

        public async Task<StudentDetailModel> GetStudentDetailAsync(int studentUsi)
        {
            var data = await(from s in _edFiDb.Students
                                                     .Include(x => x.StudentElectronicMails)
                                                     .Include(x => x.StudentTelephones)
                                                     .Include(x => x.StudentRaces.Select(r => r.RaceType))
                             join sext in _edFiDb.SexTypes on s.SexTypeId equals sext.SexTypeId
                             join ssa in _edFiDb.StudentSchoolAssociations on s.StudentUsi equals ssa.StudentUsi
                             join gld in _edFiDb.GradeLevelDescriptors on ssa.EntryGradeLevelDescriptorId equals gld.GradeLevelDescriptorId
                             join glt in _edFiDb.GradeLevelTypes on gld.GradeLevelTypeId equals glt.GradeLevelTypeId
                             join sc in _edFiDb.Schools on ssa.SchoolId equals sc.SchoolId
                             join eds in _edFiDb.EducationOrganizations on sc.SchoolId equals eds.EducationOrganizationId
                             where s.StudentUsi == studentUsi
                             group new {s, sext, ssa, eds, glt } by s.StudentUniqueId into g
                             select new
                             {
                                 g.FirstOrDefault().s,
                                 SexType = g.FirstOrDefault().sext.ShortDescription,
                                 CurrentSchool = g.FirstOrDefault().eds.NameOfInstitution,
                                 GradeLevel = g.FirstOrDefault().glt.ShortDescription,
                             }).SingleOrDefaultAsync();

            if (data == null)
                return null;

            var student = new StudentDetailModel
            {
                StudentUsi = data.s.StudentUsi,
                StudentUniqueId = data.s.StudentUniqueId,
                FirstName = data.s.FirstName,
                MiddleName = data.s.MiddleName,
                LastSurname = data.s.LastSurname,
                HispanicOrLatino = data.s.HispanicLatinoEthnicity,
                Email = GetEmail(data.s.StudentElectronicMails),
                Telephone = GetTelephone(data.s.StudentTelephones),
                Races = GetRaces(data.s.StudentRaces),
                SexType = data.SexType,
                CurrentSchool = data.CurrentSchool,
                GradeLevel = data.GradeLevel,
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
                                    on new {ssa.SchoolId, ssa.ClassPeriodName, ssa.ClassroomIdentificationCode, ssa.LocalCourseCode, ssa.UniqueSectionCode, ssa.SequenceOfCourse, ssa.SchoolYear, ssa.TermDescriptorId }
                                    equals new {staffsa.SchoolId, staffsa.ClassPeriodName, staffsa.ClassroomIdentificationCode, staffsa.LocalCourseCode, staffsa.UniqueSectionCode, staffsa.SequenceOfCourse, staffsa.SchoolYear, staffsa.TermDescriptorId }
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
                              && studeSec.BeginDate == _edFiDb.Sessions.Where(x => x.SchoolId == staffSec.SchoolId).Max(x => x.BeginDate)
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
                            //Emails = staff.StaffElectronicMails.Select(e => e.ElectronicMailAddress),
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
                          ChatEnabled = true
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

            var otherStaff = await(from staff in _edFiDb.Staffs
                                               .Include(x => x.StaffCredentials)
                                               .Include(x => x.SexType)
                                               .Include(x => x.LevelOfEducationDescriptor.LevelOfEducationType)
                                               .Include(x => x.StaffLanguages.Select(l => l.LanguageDescriptor.LanguageType))
                                               .Include(x => x.StaffAddresses.Select(s => s.StateAbbreviationType))
                                               .Include(x => x.StaffTelephones)
                                               .Include(x => x.StaffElectronicMails)
                                               .Include(x => x.StaffCredentials.Select(c => c.CredentialType))
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
                                       Emails = g.FirstOrDefault().staff.StaffElectronicMails.Select(e => e.ElectronicMailAddress).ToList(),
                                       Telephone = g.FirstOrDefault().staff.StaffTelephones.Select(t => t.TelephoneNumber).ToList(),
                                       Addresses = g.FirstOrDefault().staff.StaffAddresses.Select(a => new Address
                                       {
                                           StreetNumberName = a.StreetNumberName,
                                           City = a.City,
                                           State = a.StateAbbreviationType.ShortDescription,
                                           PostalCode = a.PostalCode
                                       }).ToList(),
                                       HighlyQualifiedTeacher = g.FirstOrDefault().staff.HighlyQualifiedTeacher ?? false,
                                       HighestCompletedLevelOfEducation = g.FirstOrDefault().staff.LevelOfEducationDescriptor.LevelOfEducationType.ShortDescription,
                                       YearsOfTeachingExperience = g.FirstOrDefault().staff.YearsOfPriorTeachingExperience,
                                       Languages = g.FirstOrDefault().staff.StaffLanguages.Select(x => x.LanguageDescriptor.LanguageType.ShortDescription).ToList(),
                                       Credentials = g.FirstOrDefault().staff.StaffCredentials.Select(x => x.CredentialType.ShortDescription).ToList(),
                                       ShortBiography = g.FirstOrDefault().bio.ShortBiography,
                                       ChatEnabled = false
                                   }).ToListAsync();
            return otherStaff;
        }

        public async Task<List<StudentSuccessTeamMember>> GetParents(int studentUsi, string recipientUniqueId, int recipientTypeId)
        {
            var query = from p in _edFiDb.Parents
                                            .Include(x => x.ParentElectronicMails)
                                            .Include(x => x.ParentAddresses.Select(s => s.StateAbbreviationType))
                                            .Include(x => x.ParentTelephones)
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
                            Emails = p.ParentElectronicMails.Select(e => e.ElectronicMailAddress),
                            Telephone = p.ParentTelephones.Select(t => t.TelephoneNumber),
                            p.ParentAddresses,
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
                               Emails = p.Emails,
                               Telephone = p.Telephone,
                               Addresses = p.ParentAddresses.Select(a => new Address
                               {
                                   StreetNumberName = a.StreetNumberName,
                                   City = a.City,
                                   State = a.StateAbbreviationType.ShortDescription,
                                   PostalCode = a.PostalCode
                               }),
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
                                                .Include(x => x.StaffCredentials)
                                                .Include(x => x.SexType)
                                                .Include(x => x.LevelOfEducationDescriptor.LevelOfEducationType)
                                                .Include(x => x.StaffLanguages.Select(l => l.LanguageDescriptor.LanguageType))
                                                .Include(x => x.StaffAddresses.Select(s => s.StateAbbreviationType))
                                                .Include(x => x.StaffTelephones)
                                                .Include(x => x.StaffElectronicMails)
                                                .Include(x => x.StaffCredentials.Select(c => c.CredentialType))
                                    from bio in _edFiDb.StaffBiographies.Where(x => x.StaffUniqueId == staff.StaffUniqueId).DefaultIfEmpty()
                                    join staffEdOrg in _edFiDb.StaffEducationOrganizationAssignmentAssociations on staff.StaffUsi equals staffEdOrg.StaffUsi
                                   join staffProg in _edFiDb.StaffProgramAssociations on staff.StaffUsi equals staffProg.StaffUsi
                                   join studProg in _edFiDb.StudentProgramAssociations on new { staffProg.ProgramTypeId, staffProg.ProgramName } equals new { studProg.ProgramTypeId, studProg.ProgramName }
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
                                       Emails = g.FirstOrDefault().staff.StaffElectronicMails.Select(e => e.ElectronicMailAddress).ToList(),
                                       Telephone = g.FirstOrDefault().staff.StaffTelephones.Select(t => t.TelephoneNumber).ToList(),
                                       Addresses = g.FirstOrDefault().staff.StaffAddresses.Select(a => new Address
                                       {
                                           StreetNumberName = a.StreetNumberName,
                                           City = a.City,
                                           State = a.StateAbbreviationType.ShortDescription,
                                           PostalCode = a.PostalCode
                                       }).ToList(),
                                       HighlyQualifiedTeacher = g.FirstOrDefault().staff.HighlyQualifiedTeacher ?? false,
                                       HighestCompletedLevelOfEducation = g.FirstOrDefault().staff.LevelOfEducationDescriptor.LevelOfEducationType.ShortDescription,
                                       YearsOfTeachingExperience = g.FirstOrDefault().staff.YearsOfPriorTeachingExperience,
                                       Languages = g.FirstOrDefault().staff.StaffLanguages.Select(x => x.LanguageDescriptor.LanguageType.ShortDescription).ToList(),
                                       Credentials = g.FirstOrDefault().staff.StaffCredentials.Select(x => x.CredentialType.ShortDescription).ToList(),
                                       ShortBiography = g.FirstOrDefault().bio.ShortBiography,
                                       ChatEnabled = false
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
                                  where sp.StudentUsi != studentUsi && parentUsis.Contains(sp.ParentUsi)
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
                                      RelationToStudent = sp.RelationType.ShortDescription,
                                      Emails = s.StudentElectronicMails.Select(x => x.ElectronicMailAddress).ToList(),
                                      NameOfInstitution = eo.NameOfInstitution,
                                      GradeLevel = ssa.GradeLevelDescriptor.GradeLevelType.ShortDescription,
                                  }).ToListAsync();

            return siblings;
        }

        public async Task<PersonBriefModel> GetStudentBriefModelAsyncByUniqueId(string studentUniqueId)
        {
            var data = await(from s in _edFiDb.Students
                             where s.StudentUniqueId == studentUniqueId
                             select new PersonBriefModel
                             {
                                 Usi = s.StudentUsi,
                                 UniqueId = s.StudentUniqueId,
                                 FirstName = s.FirstName,
                                 LastSurname = s.LastSurname
                             }).SingleOrDefaultAsync();

            return data;
        }

        public async Task<List<StudentParentAssociationModel>> GetParentAssociation(int studentUsi)
        {
            var parents = await (from p in _edFiDb.Parents
                                 join pp in _edFiDb.ParentProfiles
                                                     .Include(x => x.ParentProfileTelephones)
                                                     .Include(x => x.ParentProfileElectronicMails)
                                 on p.ParentUniqueId equals pp.ParentUniqueId
                                 join spa in _edFiDb.StudentParentAssociations on p.ParentUsi equals spa.ParentUsi
                                 join s in _edFiDb.Students on spa.StudentUsi equals s.StudentUsi
                                 where s.StudentUsi == studentUsi
                                 select new StudentParentAssociationModel
                                 {
                                     ParentUsi = p.ParentUsi,
                                     Parent = new ParentModel
                                     {
                                         ParentUniqueId = p.ParentUniqueId,
                                         LanguageCode = pp.LanguageCode,
                                         Email = pp.ParentProfileElectronicMails.FirstOrDefault().ElectronicMailAddress,
                                         Telephone = pp.ParentProfileTelephones.FirstOrDefault().TelephoneNumber,
                                         SMSDomain = pp.ParentProfileTelephones.FirstOrDefault().TextMessageCarrierType.SmsSuffixDomain,
                                         ParentAlert = new ParentAlertModel
                                         {
                                             PreferredMethodOfContactTypeId = pp.PreferredMethodOfContactTypeId
                                         }
                                     }
                                 }).ToListAsync();
            return parents;
        }

        public async Task<List<ParentStudentsModel>> GetParentsBySearchTermAndGrades(int staffUsi, string term, GradesLevelModel model)
        {
            int studentUniqueId = 0;
            string firstName = "", lastName = "";
            var searchName = new List<string>();
            var isStudentId = int.TryParse(term, out studentUniqueId);

            if (!string.IsNullOrEmpty(term))
            {
                searchName = term.Split(' ').ToList();
                firstName = searchName[0];
                lastName = searchName.Count > 1 ? searchName[1] : string.Empty;
            }

            if (!model.PageSize.HasValue)
                model.PageSize = 0;

            var queryBase = (from edor in _edFiDb.EducationOrganizations
                             join seoaa in _edFiDb.StaffEducationOrganizationAssignmentAssociations on edor.EducationOrganizationId equals seoaa.EducationOrganizationId
                             join sgl in _edFiDb.SchoolGradeLevels on edor.EducationOrganizationId equals sgl.SchoolId
                             join ssa in _edFiDb.StudentSchoolAssociations on sgl.GradeLevelDescriptorId equals ssa.EntryGradeLevelDescriptorId
                             join spa in _edFiDb.StudentParentAssociations on ssa.StudentUsi equals spa.StudentUsi
                             join s in _edFiDb.Students on ssa.StudentUsi equals s.StudentUsi
                             join p in _edFiDb.Parents on spa.ParentUsi equals p.ParentUsi
                             join pp in _edFiDb.ParentProfiles on p.ParentUniqueId equals pp.ParentUniqueId
                             where seoaa.StaffUsi == staffUsi
                             select new
                             {
                                 ParentFirstName = p.FirstName,
                                 ParentMiddleName = p.MiddleName,
                                 ParentLastSurname = p.LastSurname,
                                 ParentUniqueId = p.ParentUniqueId,
                                 ParentUsi = p.ParentUsi,
                                 LanguageCode = pp.LanguageCode,
                                 PreferredMethodOfContactTypeId = pp.PreferredMethodOfContactTypeId,
                                 ParentRelation = spa.EmergencyContactStatus == true ? "Emergency Contact" : "Parent",
                                 sgl.GradeLevelDescriptorId,
                                 StudentUniqueId = s.StudentUniqueId,
                                 StudentUsi = ssa.StudentUsi,
                                 StudentFirstName = ssa.Student.FirstName,
                                 StudentMiddleName = ssa.Student.MiddleName,
                                 StudentLastSurname = ssa.Student.LastSurname,
                                 GradeLevel = ssa.GradeLevelDescriptor.Descriptor.CodeValue
                             });

            if (string.IsNullOrEmpty(term))
            {
                queryBase = (from q in queryBase
                             where model.Grades.Contains(q.GradeLevelDescriptorId)
                             select q);
            }

            if (isStudentId)
            {
                queryBase = (from q in queryBase
                             where model.Grades.Contains(q.GradeLevelDescriptorId) && q.StudentUniqueId == term
                             select q);
            }

            if (!string.IsNullOrEmpty(term) && !string.IsNullOrEmpty(lastName))
            {
                queryBase = (from q in queryBase
                             where model.Grades.Contains(q.GradeLevelDescriptorId)
                             && (((q.StudentFirstName.Contains(firstName) && q.StudentLastSurname.Contains(lastName)) || (q.StudentFirstName.Contains(lastName) && q.StudentLastSurname.Contains(firstName))) ||
                                 ((q.ParentFirstName.Contains(firstName) && q.ParentLastSurname.Contains(lastName)) || (q.ParentFirstName.Contains(lastName) && q.ParentLastSurname.Contains(firstName))))
                             select q);
            }

            if (!string.IsNullOrEmpty(term) && !string.IsNullOrEmpty(firstName) && string.IsNullOrEmpty(lastName))
            {
                queryBase = (from q in queryBase
                             where model.Grades.Contains(q.GradeLevelDescriptorId)
                             && ((q.StudentFirstName.Contains(firstName) || q.StudentLastSurname.Contains(firstName)) || (q.ParentFirstName.Contains(firstName) || q.ParentLastSurname.Contains(firstName)))
                             select q);
            }

            if (model.PageSize.HasValue)
            {
                queryBase = queryBase.Skip(model.SkipRows).Take(model.PageSize.Value);
            }

            var query = (from q in queryBase
                         select new ParentStudentsModel
                         {
                             ParentUsi = q.ParentUsi,
                             ParentUniqueId = q.ParentUniqueId,
                             ParentFirstName = q.ParentFirstName,
                             ParentLastSurname = q.ParentLastSurname,
                             //EdFiEmail = q.EdFiEmail,
                             //ProfileEmail = q.ProfileEmail,
                             //ProfileTelephone = q.ProfileTelephone,
                             //ProfileTelephoneSMSSuffixDomain = q.ProfileTelephoneSMSSuffixDomain,
                             LanguageCode = q.LanguageCode,
                             PreferredMethodOfContactTypeId = q.PreferredMethodOfContactTypeId,
                             StudentFirstName = q.StudentFirstName,
                             StudentLastSurname = q.StudentLastSurname,
                             StudentUsi = q.StudentUsi,
                             StudentUniqueId = q.StudentUniqueId
                         }).OrderBy(x => x.StudentFirstName);


            var students = await query.ToListAsync();

            return students;
        }

        public async Task<List<ParentStudentsModel>> GetParentsBySection(int staffUsi, StaffSectionModel model, string[] validEmailTypeDescriptors, DateTime today)
        {
            var baseQuery = (from s in _edFiDb.Students
                             join ssa in _edFiDb.StudentSchoolAssociations on s.StudentUsi equals ssa.StudentUsi
                             join studSec in _edFiDb.StudentSectionAssociations
                                     on new { ssa.StudentUsi, ssa.SchoolId }
                                 equals new { studSec.StudentUsi, studSec.SchoolId }
                             join sy in _edFiDb.SchoolYearTypes on studSec.SchoolYear equals sy.SchoolYear
                             join ses in _edFiDb.Sessions
                                     on new { studSec.SchoolId, studSec.SchoolYear }
                                 equals new { ses.SchoolId, ses.SchoolYear }
                             join staffSec in _edFiDb.StaffSectionAssociations
                                     on new { studSec.SchoolId, studSec.LocalCourseCode, studSec.SchoolYear }
                                 equals new { staffSec.SchoolId, staffSec.LocalCourseCode, staffSec.SchoolYear }
                             join pr in _edFiDb.StudentParentAssociations on s.StudentUsi equals pr.StudentUsi
                             join p in _edFiDb.Parents on pr.ParentUsi equals p.ParentUsi
                             join pe in _edFiDb.ParentElectronicMails on p.ParentUsi equals pe.ParentUsi
                             // Left join
                             from pp in _edFiDb.ParentProfiles.Where(x => x.ParentUniqueId == p.ParentUniqueId).DefaultIfEmpty()
                             from ppe in _edFiDb.ParentProfileElectronicMails
                                 .Where(x => x.ParentUniqueId == p.ParentUniqueId && x.PrimaryEmailAddressIndicator == true)
                                 .DefaultIfEmpty()
                             from ppt in _edFiDb.ParentProfileTelephones.Where(x =>
                                 x.ParentUniqueId == p.ParentUniqueId && x.PrimaryMethodOfContact == true &&
                                 x.TextMessageCapabilityIndicator == true).DefaultIfEmpty()
                             from pptc in _edFiDb.TextMessageCarrierTypes
                                 .Where(x => x.TextMessageCarrierTypeId == ppt.TelephoneCarrierTypeId).DefaultIfEmpty()
                             where staffSec.StaffUsi == staffUsi
                                     && sy.CurrentSchoolYear
                             && ses.BeginDate <= today && ses.EndDate >= today
                             select new
                             {
                                 ParentUsi = p.ParentUsi,
                                 ParentUniqueId = p.ParentUniqueId,
                                 ParentFirstName = p.FirstName,
                                 ParentLastSurname = p.LastSurname,
                                 EdFiEmail = pe.ElectronicMailAddress,
                                 ProfileEmail = ppe.ElectronicMailAddress,
                                 ProfileTelephone = ppt.TelephoneNumber,
                                 ProfileTelephoneSMSSuffixDomain = pptc.SmsSuffixDomain,
                                 LanguageCode = pp.LanguageCode,
                                 pp.PreferredMethodOfContactTypeId,

                                 StudentFirstName = s.FirstName,
                                 StudentLastSurname = s.LastSurname,
                                 StudentUsi = s.StudentUsi,
                                 StudentUniqueId = s.StudentUniqueId,

                                 // Section info for filtering,
                                 studSec.SchoolId,
                                 studSec.LocalCourseCode,
                                 studSec.SchoolYear
                             });

            // Filtering can be all Teacher Sections or a specific section.
            if (!string.IsNullOrEmpty(model.UniqueSectionCode))
                baseQuery = baseQuery.Where(x => x.SchoolId == model.SchoolId
                                            && x.LocalCourseCode == model.LocalCourseCode
                                            && x.SchoolYear == model.SchoolYear);

            var query = (from q in baseQuery
                         select new ParentStudentsModel
                         {
                             ParentUsi = q.ParentUsi,
                             ParentUniqueId = q.ParentUniqueId,
                             ParentFirstName = q.ParentFirstName,
                             ParentLastSurname = q.ParentLastSurname,
                             EdFiEmail = q.EdFiEmail,
                             ProfileEmail = q.ProfileEmail,
                             ProfileTelephone = q.ProfileTelephone,
                             ProfileTelephoneSMSSuffixDomain = q.ProfileTelephoneSMSSuffixDomain,
                             LanguageCode = q.LanguageCode,
                             PreferredMethodOfContactTypeId = q.PreferredMethodOfContactTypeId,
                             StudentFirstName = q.StudentFirstName,
                             StudentLastSurname = q.StudentLastSurname,
                             StudentUsi = q.StudentUsi,
                             StudentUniqueId = q.StudentUniqueId
                         });

            var studentsAssociatedWithStaff = await query.ToListAsync();

            return studentsAssociatedWithStaff;
        }

        public async Task<ParentStudentCountModel> GetFamilyMembersBySection(int staffUsi, StaffSectionModel model, string[] validParentDescriptors, DateTime today)
        {
            var baseQuery = (from s in _edFiDb.Students
                             join ssa in _edFiDb.StudentSchoolAssociations on s.StudentUsi equals ssa.StudentUsi
                             join studSec in _edFiDb.StudentSectionAssociations
                                     on new { ssa.StudentUsi, ssa.SchoolId }
                                 equals new { studSec.StudentUsi, studSec.SchoolId }
                             join sy in _edFiDb.SchoolYearTypes on studSec.SchoolYear equals sy.SchoolYear
                             join ses in _edFiDb.Sessions
                                  on new { studSec.SchoolId, studSec.SchoolYear }
                              equals new { ses.SchoolId, ses.SchoolYear }
                             join staffSec in _edFiDb.StaffSectionAssociations
                                     on new { studSec.SchoolId, studSec.LocalCourseCode, studSec.SchoolYear }
                                 equals new { staffSec.SchoolId, staffSec.LocalCourseCode, staffSec.SchoolYear }
                             join pr in _edFiDb.StudentParentAssociations on s.StudentUsi equals pr.StudentUsi
                             join p in _edFiDb.Parents on pr.ParentUsi equals p.ParentUsi
                             // Left join
                             from pp in _edFiDb.ParentProfiles.Where(x => x.ParentUniqueId == p.ParentUniqueId).DefaultIfEmpty()
                             where staffSec.StaffUsi == staffUsi
                                     && sy.CurrentSchoolYear
                                     && ses.BeginDate <= today && ses.EndDate >= today
                             select new
                             {
                                 LanguageCode = pp.LanguageCode,
                                 ParentUsi = p.ParentUsi,
                                 StudentUsi = s.StudentUsi,
                                 // Section info for filtering,
                                 studSec.SchoolId,
                                 studSec.LocalCourseCode,
                                 studSec.SchoolYear
                             });




            // Filtering can be all Teacher Sections or a specific section.
            if (!string.IsNullOrEmpty(model.UniqueSectionCode))
                baseQuery = baseQuery.Where(x => x.SchoolId == model.SchoolId
                                            && x.LocalCourseCode == model.LocalCourseCode
                                            && x.SchoolYear == model.SchoolYear);

            var parentsLanguages = await baseQuery.ToListAsync();

            var result = new ParentStudentCountModel()
            {
                FamilyMembersCount = baseQuery.GroupBy(x => x.ParentUsi).Count(),
                StudentsCount = baseQuery.GroupBy(x => x.StudentUsi).Count()
            };
            return result;
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

                            Chat = _edFiDb.ChatLogs.Count(x => x.StudentUniqueId == s.StudentUniqueId)
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

        public Task<ParentPortal.Models.Student.Assessment> GetStudentAssesmentScore(int studentUsi, string assessmentReportingMethodTypeDescriptor, string assessmentTitle)
        {
            throw new NotImplementedException();
        }

        public Task<ParentPortal.Models.Student.Assessment> GetStudentAssesmentPerformanceLevel(int studentUsi, string assessmentReportingMethodTypeDescriptor, string assessmentTitle)
        {
            throw new NotImplementedException();
        }

        public Task<List<ParentPortal.Models.Student.Assessment>> GetACCESSStudentAssesmentScore(int studentUsi, string assessmentReportingMethodTypeDescriptor, string assessmentTitle)
        {
            throw new NotImplementedException();
        }

        public Task<List<StudentObjectiveAssessment>> GetStudentObjectiveAssessments(int studentUsi)
        {
            throw new NotImplementedException();
        }

        public Task<int> getTotalInstructionalDays(int studentUsi, StudentCalendar studentCalendar)
        {
            throw new NotImplementedException();
        }

        public Task<StudentGoal> AddStudentGoal(StudentGoal studentGoal)
        {
            throw new NotImplementedException();
        }

        public Task<StudentGoal> UpdateStudentGoal(StudentGoal studentGoal)
        {
            throw new NotImplementedException();
        }

        public Task<bool> AddStudentGoalStep(StudentGoalStep studentGoalStep)
        {
            throw new NotImplementedException();
        }

        public Task<bool> UpdateStudentGoalStep(StudentGoalStep studentGoalStep)
        {
            throw new NotImplementedException();
        }

        public Task<List<StudentGoal>> GetStudentGoals(int studentUsi)
        {
            throw new NotImplementedException();
        }

        public Task<List<StudentGoalLabel>> GetStudentGoalLabels()
        {
            throw new NotImplementedException();
        }

        public Task<StudentGoal> UpdateStudentGoalIntervention(StudentGoalIntervention entity)
        {
            throw new NotImplementedException();
        }

        public Task<StudentAllAbout> AddStudentAllAbout(StudentAllAbout studentGoal)
        {
            throw new NotImplementedException();
        }

        public Task<StudentAllAbout> UpdateStudentAllAbout(StudentAllAbout studentGoal)
        {
            throw new NotImplementedException();
        }

        public Task<StudentAllAbout> GetStudentAllAbout(int studentUsi)
        {
            throw new NotImplementedException();
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

        public async Task<List<StudentCalendarDay>> GetStudentCalendarDays(int studentUsi)
        {
            var studentSchoolAssociation = await _edFiDb.StudentSchoolAssociations.FirstOrDefaultAsync(x => x.StudentUsi == studentUsi && x.ExitWithdrawDate == null);
            var days = await (from cd in _edFiDb.CalendarDates
                              join cdc in _edFiDb.CalendarDateCalendarEvents
                                 on new { cd.SchoolId, cd.Date } equals new { cdc.SchoolId, cdc.Date }
                              join d in _edFiDb.Descriptors on cdc.CalendarEventDescriptorId equals d.DescriptorId into dc
                              from ced in dc.DefaultIfEmpty()
                              where cd.SchoolId == studentSchoolAssociation.SchoolId
                              select new
                              {
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
    }
}
