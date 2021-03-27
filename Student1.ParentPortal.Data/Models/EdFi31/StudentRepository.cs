using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Staff;
using Student1.ParentPortal.Models.Student;
using Student1.ParentPortal.Models.User;

namespace Student1.ParentPortal.Data.Models.EdFi31
{
    public class StudentRepository : IStudentRepository
    {
        private readonly EdFi31Context _edFiDb;

        public StudentRepository(EdFi31Context edFiDb)
        {
            _edFiDb = edFiDb;
        }

        public async Task<List<StudentAttendanceEvent>> GetStudentAttendanceEventsAsync(int studentUsi)
        {
            var attendanceEvents = await (from s in _edFiDb.StudentSchoolAttendanceEvents
                                          join sy in _edFiDb.SchoolYearTypes on s.SchoolYear equals sy.SchoolYear
                                          join aecd in _edFiDb.Descriptors on s.AttendanceEventCategoryDescriptorId equals aecd.DescriptorId
                                          where s.StudentUsi == studentUsi && sy.CurrentSchoolYear
                                          select new StudentAttendanceEvent
                                          {
                                              DateOfEvent = s.EventDate,
                                              Reason = s.AttendanceEventReason,
                                              EventCategory = aecd.CodeValue,
                                              EventDescription = aecd.Description
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
                              join di in _edFiDb.DisciplineIncidents on new { sdia.IncidentIdentifier, sdia.SchoolId } equals new { di.IncidentIdentifier, di.SchoolId }
                              join spcd in _edFiDb.Descriptors on sdia.StudentParticipationCodeDescriptorId equals spcd.DescriptorId
                              join dadi in _edFiDb.DisciplineActionStudentDisciplineIncidentAssociations
                                      on new { di.IncidentIdentifier, di.SchoolId }
                                  equals new { dadi.IncidentIdentifier, dadi.SchoolId }
                              join da in _edFiDb.DisciplineActions
                                      on new { dadi.DisciplineActionIdentifier, dadi.StudentUsi, dadi.DisciplineDate }
                                  equals new { da.DisciplineActionIdentifier, da.StudentUsi, da.DisciplineDate }
                              join dad in _edFiDb.DisciplineActionDisciplines
                                      on new { da.DisciplineActionIdentifier, da.StudentUsi, da.DisciplineDate }
                                  equals new { dad.DisciplineActionIdentifier, dad.StudentUsi, dad.DisciplineDate }
                              join dt in _edFiDb.Descriptors on dad.DisciplineDescriptorId equals dt.DescriptorId
                              join s in _edFiDb.Students
                                                  .Include(x => x.StudentSectionAssociations)
                                              on sdia.StudentUsi equals s.StudentUsi
                              where sdia.StudentUsi == studentUsi && _edFiDb.Sessions.Where(x => x.SchoolId == sdia.SchoolId && x.BeginDate <= date && x.EndDate >= date).Max(x => x.BeginDate) <= di.IncidentDate
                              && spcd.CodeValue == disciplineIncidentDescriptor
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
                                 DisciplineActionsTaken = g.Select(x => new DisciplineActionTaken { DisciplineActionIdentifier = x.DisciplineActionIdentifier, Description = x.DisciplineActionDescription })
                             }).ToList();

            return incidents;
        }

        public async Task<List<StudentCourse>> GetStudentTranscriptCoursesAsync(int studentUsi)
        {
            var transcript = await(from ct in _edFiDb.CourseTranscripts
                                    join c in _edFiDb.Courses on new { ct.CourseCode, ct.EducationOrganizationId } equals new { c.CourseCode, c.EducationOrganizationId }
                                    join asd in _edFiDb.AcademicSubjectDescriptors on c.AcademicSubjectDescriptorId equals asd.AcademicSubjectDescriptorId
                                    join ast in _edFiDb.Descriptors on asd.AcademicSubjectDescriptorId equals ast.DescriptorId
                                    join cart in _edFiDb.Descriptors on ct.CourseAttemptResultDescriptorId equals cart.DescriptorId
                                    join gld in _edFiDb.GradeLevelDescriptors on ct.WhenTakenGradeLevelDescriptorId equals gld.GradeLevelDescriptorId
                                    join glt in _edFiDb.Descriptors on gld.GradeLevelDescriptorId equals glt.DescriptorId
                                    join td in _edFiDb.TermDescriptors on ct.TermDescriptorId equals td.TermDescriptorId
                                    join tt in _edFiDb.TermDescriptors on td.TermDescriptorId equals tt.TermDescriptorId
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
                                 join tt in _edFiDb.Descriptors on td.TermDescriptorId equals tt.DescriptorId
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
                                        SexType = x.SexType,
                                        Gpa = x.Gpa,
                                        MissingassignmentCount = x.MissingAssignments ?? 0,
                                        DisciplineIncidentCount = x.DisciplineIncidents ?? 0,
                                        AbsenceCount = x.Absences ?? 0,
                                        CourseAverage = x.FinalAvg ?? x.SemesterAvg ?? (x.ExamAvg.HasValue ? (x.ExamAvg.Value + x.GradingPeriodAvg.Value) / 2 : x.GradingPeriodAvg ?? 0),
                                    }).ToListAsync();

            return studentsSummary;
        }

        public async Task<List<StudentCurrentCourse>> GetStudentGradesByGradingPeriodAsync(int studentUsi, string gradeTypeGradingPeriodDescriptor, string gradeTypeSemesterDescriptor, string gradeTypeExamDescriptor, string gradeTypeFinalDescriptor)
        {
            var query = from gra in _edFiDb.Grades
                        join gtd in _edFiDb.Descriptors on gra.GradeTypeDescriptorId equals gtd.DescriptorId
                        join gpd in _edFiDb.Descriptors on gra.GradingPeriodDescriptorId equals gpd.DescriptorId
                        join sy in _edFiDb.SchoolYearTypes on gra.SchoolYear equals sy.SchoolYear
                        join ssa in _edFiDb.StaffSectionAssociations
                                on new { gra.LocalCourseCode, gra.SchoolId, gra.SchoolYear, gra.SectionIdentifier, gra.SessionName }
                            equals new { ssa.LocalCourseCode, ssa.SchoolId, ssa.SchoolYear, ssa.SectionIdentifier, ssa.SessionName }
                        join staff in _edFiDb.Staffs on ssa.StaffUsi equals staff.StaffUsi
                        join cp in _edFiDb.SectionClassPeriods
                                on new {gra.LocalCourseCode, gra.SchoolId, gra.SchoolYear, gra.SessionName, gra.SectionIdentifier}
                            equals new {cp.LocalCourseCode, cp.SchoolId, cp.SchoolYear, cp.SessionName, cp.SectionIdentifier}
                        join co in _edFiDb.CourseOfferings
                                on new {gra.LocalCourseCode, gra.SchoolId, gra.SchoolYear, gra.SessionName}
                            equals new {co.LocalCourseCode, co.SchoolId, co.SchoolYear, co.SessionName}
                        join c in _edFiDb.Courses 
                            on new { co.CourseCode, co.EducationOrganizationId } 
                            equals new { c.CourseCode, c.EducationOrganizationId }
                        where gra.StudentUsi == studentUsi
                                  && (gtd.CodeValue == gradeTypeGradingPeriodDescriptor ||
                                      gtd.CodeValue == gradeTypeSemesterDescriptor ||
                                      gtd.CodeValue == gradeTypeExamDescriptor ||
                                      gtd.CodeValue == gradeTypeFinalDescriptor)
                                  && sy.CurrentSchoolYear // Current SchoolYear Only
                        orderby gra.BeginDate
                        select new
                        {
                            // Course info.
                            c.CourseTitle,
                            c.CourseDescription,
                            co.LocalCourseCode,
                            co.CourseCode,
                            cp.ClassPeriodName,
                            // Staff info.
                            ssa.StaffUsi,
                            staff.StaffUniqueId,
                            staff.PersonalTitlePrefix,
                            staff.FirstName,
                            staff.MiddleName,
                            staff.LastSurname,
                            // Grade Info
                            // The Grade Type: Grading Period, Semester, Final, etc...
                            GradeTypeCodeValue = gtd.CodeValue,
                            GradeTypeDescription = gtd.ShortDescription,
                            // The grading Period: First Six Weeks, Second..., First Semester, ..., End of Year
                            gra.GradingPeriodDescriptorId,
                            GradingPeriodDescription = gpd.CodeValue,
                            gra.LetterGradeEarned,
                            gra.NumericGradeEarned,
                            gra.BeginDate,
                        };

            var data = await query.ToListAsync();

            var courses = (from d in data
                           group d by d.CourseTitle into g
                           select new StudentCurrentCourse
                           {
                               CourseCode = g.First().CourseCode,
                               CourseTitle = g.Key,
                               LocalCourseCode = g.First().LocalCourseCode,
                               ClassPeriodName = g.First().ClassPeriodName,
                               TeacherUsi = g.First().StaffUsi,
                               StaffUniqueId = g.First().StaffUniqueId,
                               PersonTypeId = ChatLogPersonTypeEnum.Staff.Value,
                               TeacherName = $"{g.First().PersonalTitlePrefix} {g.First().FirstName[0]}. {g.First().LastSurname}",
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
                               GradesBySemester = g.Where(x => x.GradeTypeCodeValue == gradeTypeSemesterDescriptor) //By Semester
                                                        .OrderBy(x => x.GradingPeriodDescription)
                                                        .GroupBy(x => x.GradingPeriodDescription) //By Grading Period
                                                        .Select(x => new StudentCourseGrade
                                                        {
                                                            GradeType = x.FirstOrDefault().GradeTypeDescription,
                                                            GradingPeriodType = x.FirstOrDefault().GradingPeriodDescription,
                                                            LetterGradeEarned = x.FirstOrDefault().LetterGradeEarned,
                                                            NumericGradeEarned = x.FirstOrDefault().NumericGradeEarned
                                                        }).ToList(),
                               GradesByExam = g.Where(x => x.GradeTypeCodeValue == gradeTypeExamDescriptor) //By Exam
                                                        .OrderBy(x => x.GradingPeriodDescription)
                                                        .GroupBy(x => x.GradingPeriodDescription) //By Grading Period
                                                        .Select(x => new StudentCourseGrade
                                                        {
                                                            GradeType = x.FirstOrDefault().GradeTypeDescription,
                                                            GradingPeriodType = x.FirstOrDefault().GradingPeriodDescription,
                                                            LetterGradeEarned = x.FirstOrDefault().LetterGradeEarned,
                                                            NumericGradeEarned = x.FirstOrDefault().NumericGradeEarned
                                                        }).ToList(),
                               GradesByFinal = g.Where(x => x.GradeTypeCodeValue == gradeTypeFinalDescriptor) //By Final Grade
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
                              join sasr in _edFiDb.StudentAssessmentScoreResults
                                  on new { sa.AssessmentIdentifier, sa.Namespace, sa.StudentAssessmentIdentifier, sa.StudentUsi }
                                  equals new { sasr.AssessmentIdentifier, sasr.Namespace, sasr.StudentAssessmentIdentifier, sasr.StudentUsi }
                              join a in _edFiDb.Assessments on new { sa.AssessmentIdentifier, sa.Namespace } equals new { a.AssessmentIdentifier, a.Namespace }
                              from sapl in _edFiDb.StudentAssessmentPerformanceLevels.Where(x => x.StudentUsi == sa.StudentUsi
                                                                     && x.AssessmentIdentifier == sa.AssessmentIdentifier
                                                                     && x.StudentAssessmentIdentifier == sa.StudentAssessmentIdentifier
                                                                     && x.Namespace == sa.Namespace
                                                                     && x.PerformanceLevelMet == true
                                                                     ).DefaultIfEmpty()
                              from armd in _edFiDb.Descriptors.Where(x => x.DescriptorId == sasr.AssessmentReportingMethodDescriptorId).DefaultIfEmpty()
                              from gld in _edFiDb.Descriptors.Where(x => x.DescriptorId == sa.WhenAssessedGradeLevelDescriptorId).DefaultIfEmpty()
                              from plt in _edFiDb.Descriptors.Where(x => x.DescriptorId == sapl.PerformanceLevelDescriptorId).DefaultIfEmpty()
                              where sa.StudentUsi == studentUsi
                                    && armd.CodeValue == assessmentReportingMethodTypeDescriptor
                                    && a.AssessmentTitle == assessmentTitle
                              select new AssessmentRecord
                              {
                                  Title = a.AssessmentTitle,
                                  Identifier = a.AssessmentIdentifier,
                                  MaxRawScore = (decimal)a.MaxRawScore,
                                  AdministrationDate = sa.AdministrationDate,
                                  Result = sasr.Result,
                                  PerformanceLevelMet = plt.ShortDescription,
                                  GradeLevel = gld.CodeValue
                              }).ToListAsync();

            return data;
        }

        public async Task<StudentMissingAssignments> GetStudentMissingAssignments(int studentUsi, string[] gradeBookMissingAssignmentTypeDescriptors, string missingAssignmentLetterGrade)
        {
            // Get all assignments and homeworks that were assigned to the section that the student is enrolled in.
            // Assumption: If he hasn't turned it in then its a candidate for missing assignments.
            // Ed-Fi does not define a assignment due date.

            var missingAssignments = await (from gbe in _edFiDb.GradebookEntries
                                            join ssa in _edFiDb.StudentSectionAssociations
                                                    on new { gbe.LocalCourseCode, gbe.SchoolId, gbe.SchoolYear, gbe.SectionIdentifier, gbe.SessionName}
                                                equals new { ssa.LocalCourseCode, ssa.SchoolId, ssa.SchoolYear, ssa.SectionIdentifier, ssa.SessionName}
                                            join staffsa in _edFiDb.StaffSectionAssociations
                                                    on new {gbe.LocalCourseCode, gbe.SchoolId, gbe.SchoolYear, gbe.SectionIdentifier, gbe.SessionName }
                                                    equals new {staffsa.LocalCourseCode, staffsa.SchoolId, staffsa.SchoolYear, staffsa.SectionIdentifier, staffsa.SessionName }
                                            join staff in _edFiDb.Staffs on staffsa.StaffUsi equals staff.StaffUsi
                                            join co in _edFiDb.CourseOfferings
                                                    on new { gbe.LocalCourseCode, gbe.SchoolId, gbe.SchoolYear, gbe.SessionName }
                                                equals new { co.LocalCourseCode, co.SchoolId, co.SchoolYear, co.SessionName }
                                            join c in _edFiDb.Courses
                                                    on new { co.EducationOrganizationId, co.CourseCode }
                                                    equals new { c.EducationOrganizationId, c.CourseCode }
                                            from gbed in _edFiDb.Descriptors.Where(x => x.DescriptorId == gbe.GradebookEntryTypeDescriptorId)
                                            from sge in _edFiDb.StudentGradebookEntries.Where(x => x.StudentUsi == studentUsi
                                                                                                 && x.DateAssigned == gbe.DateAssigned
                                                                                                 && x.GradebookEntryTitle == gbe.GradebookEntryTitle
                                                                                                 && x.LocalCourseCode == gbe.LocalCourseCode
                                                                                                 && x.SchoolId == gbe.SchoolId
                                                                                                 && x.SchoolYear == gbe.SchoolYear
                                                                                                 && x.SectionIdentifier == gbe.SectionIdentifier
                                                                                                 && x.SessionName == gbe.SessionName).DefaultIfEmpty() // Left join to get missing assignments.   
                                            where ssa.StudentUsi == studentUsi
                                                  && sge.DateFulfilled == null // Not delivered
                                                  && sge.LetterGradeEarned == missingAssignmentLetterGrade
                                                  && gbe.DateAssigned >= _edFiDb.Sessions.Where(x => x.SchoolId == ssa.SchoolId).Max(x => x.BeginDate)
                                            group new { gbe, co, c, staff} by c.CourseTitle into g
                                            select new StudentAssignmentSection
                                            {
                                                CourseTitle = g.Key,
                                                StaffFirstName = g.FirstOrDefault().staff.FirstName,
                                                StaffMiddleName = g.FirstOrDefault().staff.MiddleName,
                                                StaffLastSurName = g.FirstOrDefault().staff.LastSurname,
                                                PersonTypeId = ChatLogPersonTypeEnum.Staff.Value,
                                                StaffUniqueId = g.FirstOrDefault().staff.StaffUniqueId,
                                                Assignments = g.Select(x => new StudentAssignment {
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

        public async Task<List<StudentIndicator>> GetStudentIndicatorsAsync(int studentUsi)
        {
            var model = await (from seoasi in _edFiDb.StudentEducationOrganizationAssociationStudentIndicators
                               where seoasi.StudentUsi == studentUsi
                               join seoasip in _edFiDb.StudentEducationOrganizationAssociationStudentIndicatorPeriods
                                    on new {seoasi.StudentUsi, seoasi.EducationOrganizationId, seoasi.IndicatorName }
                                    equals new {seoasip.StudentUsi, seoasip.EducationOrganizationId, seoasip.IndicatorName}
                               where seoasip.EndDate == null
                               select new StudentIndicator
                               {
                                   IndicatorName = seoasip.IndicatorName,
                                   BeginDate = seoasip.BeginDate
                               }).ToListAsync();

            return model;
        }

        public async Task<PersonBriefModel> GetStudentBriefModelAsync(int studentUsi)
        {
            var data = await (from s in _edFiDb.Students
                             .Include(x => x.StudentEducationOrganizationAssociations.Select(seoa => seoa.StudentEducationOrganizationAssociationElectronicMails))
                              where s.StudentUsi == studentUsi
                              select new PersonBriefModel
                              {
                                  Usi = s.StudentUsi,
                                  UniqueId = s.StudentUniqueId,
                                  FirstName = s.FirstName,
                                  LastSurname = s.LastSurname
                              }).SingleOrDefaultAsync();

            data.PersonTypeId = ChatLogPersonTypeEnum.Student.Value;
            data.Role = "Student";
            return data;
        }

        public async Task<StudentDetailModel> GetStudentDetailAsync(int studentUsi)
        {
            var query = from s in _edFiDb.Students
                                        .Include(x => x.StudentEducationOrganizationAssociations.Select(seoa => seoa.StudentEducationOrganizationAssociationElectronicMails))
                                        .Include(x => x.StudentEducationOrganizationAssociations.Select(seoa => seoa.StudentEducationOrganizationAssociationTelephones))
                                        .Include(x => x.StudentEducationOrganizationAssociations.Select(seoa => seoa.StudentEducationOrganizationAssociationTelephones))
                                        .Include(x => x.StudentEducationOrganizationAssociations.Select(seoa => seoa.StudentEducationOrganizationAssociationRaces
                                        .Select(seoar => seoar.RaceDescriptor.Descriptor)))
                        join steo in _edFiDb.StudentEducationOrganizationAssociations on s.StudentUsi equals steo.StudentUsi
                        join sext in _edFiDb.SexDescriptors on steo.SexDescriptorId equals sext.SexDescriptorId
                        join d in _edFiDb.Descriptors on sext.SexDescriptorId equals d.DescriptorId
                        join ssa in _edFiDb.StudentSchoolAssociations on s.StudentUsi equals ssa.StudentUsi
                        join gld in _edFiDb.GradeLevelDescriptors on ssa.EntryGradeLevelDescriptorId equals gld.GradeLevelDescriptorId
                        join d2 in _edFiDb.Descriptors on gld.GradeLevelDescriptorId equals d2.DescriptorId
                        join sc in _edFiDb.Schools on ssa.SchoolId equals sc.SchoolId
                        join eds in _edFiDb.EducationOrganizations on sc.SchoolId equals eds.EducationOrganizationId
                        where s.StudentUsi == studentUsi
                        select new
                        {
                            s.StudentUsi,
                            s.StudentUniqueId,
                            s.FirstName,
                            s.MiddleName,
                            s.LastSurname,
                            s.StudentEducationOrganizationAssociations,
                            SexType = d.ShortDescription,
                            CurrentSchool = eds.NameOfInstitution,
                            GradeLevel = d2.ShortDescription,
                        };

            var executedQuery = await query.FirstOrDefaultAsync();

            if (executedQuery == null)
                return null;


            var student = new StudentDetailModel
            {
                StudentUsi = executedQuery.StudentUsi,
                StudentUniqueId = executedQuery.StudentUniqueId,
                FirstName = executedQuery.FirstName,
                MiddleName = executedQuery.MiddleName,
                LastSurname = executedQuery.LastSurname,
                HispanicOrLatino = executedQuery.StudentEducationOrganizationAssociations.First().HispanicLatinoEthnicity.HasValue ? executedQuery.StudentEducationOrganizationAssociations.First().HispanicLatinoEthnicity.Value : false,
                Email = GetEmail(executedQuery.StudentEducationOrganizationAssociations.SelectMany(seoa => seoa.StudentEducationOrganizationAssociationElectronicMails)),
                Telephone = GetTelephone(executedQuery.StudentEducationOrganizationAssociations.SelectMany(seoa => seoa.StudentEducationOrganizationAssociationTelephones)),
                Races = GetRaces(executedQuery.StudentEducationOrganizationAssociations.SelectMany(seoa => seoa.StudentEducationOrganizationAssociationRaces)),
                SexType = executedQuery.SexType,
                CurrentSchool = executedQuery.CurrentSchool,
                GradeLevel = executedQuery.GradeLevel,
            };

            return student;
        }
        private string GetTelephone(IEnumerable<StudentEducationOrganizationAssociationTelephone> studentTelephones)
        {
            if (studentTelephones == null || !studentTelephones.Any())
                return null;

            return studentTelephones.First().TelephoneNumber;
        }

        private List<string> GetRaces(IEnumerable<StudentEducationOrganizationAssociationRace> studentRaces)
        {
            if (studentRaces == null || !studentRaces.Any())
                return null;

            return studentRaces.Select(x => x.RaceDescriptor.Descriptor.Description).ToList();
        }

        private string GetEmail(IEnumerable<StudentEducationOrganizationAssociationElectronicMail> potentialEmails)
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
                               join gspa in _edFiDb.GeneralStudentProgramAssociations
                                    on new {sp.BeginDate, sp.EducationOrganizationId, sp.ProgramEducationOrganizationId, sp.ProgramName, sp.ProgramTypeDescriptorId, sp.StudentUsi }
                                    equals new {gspa.BeginDate, gspa.EducationOrganizationId, gspa.ProgramEducationOrganizationId, gspa.ProgramName, gspa.ProgramTypeDescriptorId, gspa.StudentUsi }
                               where gspa.EndDate == null
                               select new StudentProgram
                               {
                                   ProgramName = sp.ProgramName,
                                   BeginDate = sp.BeginDate
                               }).ToListAsync();

            return model;
        }

        public async Task<List<ScheduleItem>> GetStudentScheduleAsync(int studentUsi, DateTime mondayDate, DateTime fridayDate)
        {

            var data = await (from sec in _edFiDb.Sections
                              join sy in _edFiDb.SchoolYearTypes on sec.SchoolYear equals sy.SchoolYear
                              join scp in _edFiDb.SectionClassPeriods
                                      on new { sec.LocalCourseCode, sec.SchoolId, sec.SchoolYear, sec.SectionIdentifier, sec.SessionName }
                                  equals new { scp.LocalCourseCode, scp.SchoolId, scp.SchoolYear, scp.SectionIdentifier, scp.SessionName }
                              join ssa in _edFiDb.StudentSectionAssociations
                                      on new { sec.SchoolId, sec.LocalCourseCode, sec.SessionName, sec.SchoolYear, sec.SectionIdentifier }
                                  equals new { ssa.SchoolId, ssa.LocalCourseCode, ssa.SessionName, ssa.SchoolYear, ssa.SectionIdentifier }
                              join coo in _edFiDb.CourseOfferings
                                        on new { sec.SchoolId, sec.LocalCourseCode, sec.SessionName, sec.SchoolYear }
                                    equals new { coo.SchoolId, coo.LocalCourseCode, coo.SessionName, coo.SchoolYear }
                              join c in _edFiDb.Courses
                                  on new { EducationOrganizationId = coo.SchoolId, coo.CourseCode }
                                  equals new { c.EducationOrganizationId, c.CourseCode }
                              join bsn in _edFiDb.BellScheduleClassPeriods
                                      on new { scp.ClassPeriodName, scp.SchoolId }
                                  equals new { bsn.ClassPeriodName, bsn.SchoolId }
                              join bsd in _edFiDb.BellScheduleDates
                                      on new { bsn.BellScheduleName, bsn.SchoolId }
                                  equals new { bsd.BellScheduleName, bsd.SchoolId }
                              join cpm in _edFiDb.ClassPeriodMeetingTimes
                                          on new { scp.SchoolId, scp.ClassPeriodName }
                                      equals new { cpm.SchoolId, cpm.ClassPeriodName }
                              join sta in _edFiDb.StaffSectionAssociations
                                        on new { sec.SchoolId, sec.LocalCourseCode, sec.SectionIdentifier, sec.SessionName, sec.SchoolYear }
                                    equals new { sta.SchoolId, sta.LocalCourseCode, sta.SectionIdentifier, sta.SessionName, sta.SchoolYear }
                              join s in _edFiDb.Staffs on sta.StaffUsi equals s.StaffUsi
                              where ssa.StudentUsi == studentUsi
                                    && sy.CurrentSchoolYear
                                    && bsd.Date >= mondayDate // Between current week
                                    && bsd.Date <= fridayDate
                                    && ssa.BeginDate <= fridayDate// This filters out courses that have already ended.
                                    && ssa.EndDate >= mondayDate // This filters out courses that have already ended.
                              orderby bsd.Date, cpm.StartTime
                              select new ScheduleItem
                              {
                                  CourseTitle = c.CourseTitle,
                                  BellScheduleName = bsn.BellScheduleName,
                                  Date = bsd.Date,
                                  StartTime = cpm.StartTime,
                                  EndTime = cpm.EndTime,
                                  ClassroomIdentificationCode = sec.LocationClassroomIdentificationCode,
                                  FirstName = s.FirstName,
                                  MiddleName = s.MiddleName,
                                  LastSurname = s.LastSurname,
                              }).ToListAsync();

            //There might be dupes because we are bringing in all sessions (

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
                        from sexd in _edFiDb.Descriptors.Where(x => x.DescriptorId == staff.SexDescriptorId).DefaultIfEmpty()
                        from led in _edFiDb.Descriptors.Where(x => x.DescriptorId == staff.HighestCompletedLevelOfEducationDescriptorId).DefaultIfEmpty()
                        join staffSec in _edFiDb.StaffSectionAssociations on staff.StaffUsi equals staffSec.StaffUsi
                        join studeSec in _edFiDb.StudentSectionAssociations
                              on new { staffSec.SchoolId, staffSec.LocalCourseCode, staffSec.SessionName, staffSec.SchoolYear, staffSec.SectionIdentifier }
                          equals new { studeSec.SchoolId, studeSec.LocalCourseCode, studeSec.SessionName, studeSec.SchoolYear, studeSec.SectionIdentifier }
                        join co in _edFiDb.CourseOfferings
                                on new { staffSec.LocalCourseCode, staffSec.SchoolId, staffSec.SchoolYear, staffSec.SessionName }
                                equals new { co.LocalCourseCode, co.SchoolId, co.SchoolYear, co.SessionName}
                        join staffEdOrg in _edFiDb.StaffEducationOrganizationAssignmentAssociations on staff.StaffUsi equals staffEdOrg.StaffUsi
                        join sy in _edFiDb.SchoolYearTypes on studeSec.SchoolYear equals sy.SchoolYear
                        join  s in _edFiDb.Students on studeSec.StudentUsi equals s.StudentUsi
                        from bio in _edFiDb.StaffBiographies.Where(x => x.StaffUniqueId == staff.StaffUniqueId).DefaultIfEmpty()
                        where studeSec.StudentUsi == studentUsi
                              && sy.CurrentSchoolYear
                              && studeSec.BeginDate == _edFiDb.Sessions.Where(x => x.SchoolId == staffSec.SchoolId).Max(x => x.BeginDate)
                        select new {
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
                          ChatEnabled = ChatLogPersonTypeEnum.Parent.Value == recipientTypeId
                      }).ToList();

            return gr;
        }

        public async Task<List<StudentSuccessTeamMember>> GetOtherStaff(int studentUsi)
        {
            var query = from staff in _edFiDb.Staffs
                            // Per Client Request and Data Availability we are not bringing in this information on this phase.
                            // Additionally we are commenting out to bring less data and improve performance. 
                            //.Include(x => x.StaffElectronicMails)
                            //.Include(x => x.StaffTelephones)
                            //.Include(x => x.StaffAddresses.Select(s => s.StateAbbreviationDescriptor.Descriptor))
                            //.Include(x => x.StaffLanguages.Select(l => l.LanguageDescriptor.Descriptor))
                            //.Include(x => x.StaffCredentials.Select(c => c.Credential.CredentialTypeDescriptor.Descriptor))
                        from sexd in _edFiDb.Descriptors.Where(x => x.DescriptorId == staff.SexDescriptorId).DefaultIfEmpty()
                        from led in _edFiDb.Descriptors.Where(x => x.DescriptorId == staff.HighestCompletedLevelOfEducationDescriptorId).DefaultIfEmpty()
                        join staffCohort in _edFiDb.StaffCohortAssociations on staff.StaffUsi equals staffCohort.StaffUsi
                        join studCohort in _edFiDb.StudentCohortAssociations
                                on new { staffCohort.CohortIdentifier, staffCohort.EducationOrganizationId }
                            equals new { studCohort.CohortIdentifier, studCohort.EducationOrganizationId }
                        join staffEdOrg in _edFiDb.StaffEducationOrganizationAssignmentAssociations on staff.StaffUsi equals staffEdOrg.StaffUsi
                        join s in _edFiDb.Students on studCohort.StudentUsi equals s.StudentUsi
                        from bio in _edFiDb.StaffBiographies.Where(x => x.StaffUniqueId == staff.StaffUniqueId).DefaultIfEmpty()
                        where studCohort.StudentUsi == studentUsi && studCohort.BeginDate == _edFiDb.Sessions.Where(x => x.SchoolId == staffEdOrg.EducationOrganizationId).Max(x => x.BeginDate)
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
                            SexType = sexd.Description,
                            HighestCompletedLevelOfEducation = led.ShortDescription,
                            // Per Client Request and Data Availability we are not bringing in this information on this phase.
                            // Additionally we are commenting out to bring less data and improve performance.
                            //staff.StaffAddresses,
                            //Emails = staff.StaffElectronicMails.Select(e => e.ElectronicMailAddress),
                            //Telephone = staff.StaffTelephones.Select(t => t.TelephoneNumber),
                            //Languages = staff.StaffLanguages.Select(x => x.LanguageDescriptor.Descriptor.ShortDescription),
                            //Credentials = staff.StaffCredentials.Select(x => x.Credential.CredentialTypeDescriptor.Descriptor.ShortDescription),
                        };

            var executedQuery = await query.ToListAsync();

            var otherStaff = (from ex in executedQuery
                              group ex by ex.StaffUsi into g
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
                                  RelationToStudent = g.FirstOrDefault().PositionTitle,
                                  HighlyQualifiedTeacher = g.FirstOrDefault().HighlyQualifiedTeacher ?? false,
                                  HighestCompletedLevelOfEducation = g.FirstOrDefault().HighestCompletedLevelOfEducation,
                                  YearsOfTeachingExperience = g.FirstOrDefault().YearsOfPriorTeachingExperience,
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
                                  ShortBiography = g.FirstOrDefault().ShortBiography,
                                  ChatEnabled = false
                              }).ToList();

            return otherStaff;
        }

        public async Task<List<StudentSuccessTeamMember>> GetParents(int studentUsi, string recipientUniqueId, int recipientTypeId)
        {
            var query = from p in _edFiDb.Parents
                                           .Include(x => x.ParentElectronicMails)
                                           .Include(x => x.ParentAddresses.Select(s => s.StateAbbreviationDescriptor.Descriptor))
                                           .Include(x => x.ParentTelephones)
                        from sex in _edFiDb.Descriptors.Where(x => x.DescriptorId == p.SexDescriptorId).DefaultIfEmpty()
                        join spa in _edFiDb.StudentParentAssociations on p.ParentUsi equals spa.ParentUsi
                        from rel in _edFiDb.Descriptors.Where(x => x.DescriptorId == spa.RelationDescriptorId).DefaultIfEmpty()
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
                                   State = a.StateAbbreviationDescriptor.Descriptor.ShortDescription,
                                   PostalCode = a.PostalCode
                               }),
                               ShortBiography = p.ShortBiography,
                               EmergencyContactStatus = p.EmergencyContactStatus.HasValue ? p.EmergencyContactStatus.Value : false,
                               UnreadMessageCount = p.Chat,
                               ChatEnabled = ChatLogPersonTypeEnum.Staff.Value == recipientTypeId
                           }).ToList();

            return parents;
        }

        public async Task<List<StudentSuccessTeamMember>> GetProgramAssociatedStaff(int studentUsi)
        {
            var query = from staff in _edFiDb.Staffs
                            // Per Client Request and Data Availability we are not bringing in this information on this phase.
                            // Additionally we are commenting out to bring less data and improve performance. 
                            //.Include(x => x.StaffElectronicMails)
                            //.Include(x => x.StaffLanguages.Select(l => l.LanguageDescriptor.Descriptor))
                            //.Include(x => x.StaffCredentials.Select(c => c.Credential.CredentialTypeDescriptor.Descriptor))
                            //.Include(x => x.StaffAddresses.Select(s => s.StateAbbreviationDescriptor.Descriptor))
                            //.Include(x => x.StaffTelephones)
                        from sexd in _edFiDb.Descriptors.Where(x => x.DescriptorId == staff.SexDescriptorId).DefaultIfEmpty()
                        from led in _edFiDb.Descriptors.Where(x => x.DescriptorId == staff.HighestCompletedLevelOfEducationDescriptorId).DefaultIfEmpty()
                        join staffProg in _edFiDb.StaffProgramAssociations on staff.StaffUsi equals staffProg.StaffUsi
                        join prog in _edFiDb.Programs
                                on new { staffProg.ProgramName, staffProg.ProgramTypeDescriptorId }
                            equals new { prog.ProgramName, prog.ProgramTypeDescriptorId }
                        join gspa in _edFiDb.GeneralStudentProgramAssociations
                                on new { staffProg.BeginDate, prog.EducationOrganizationId, staffProg.ProgramEducationOrganizationId, staffProg.ProgramName, staffProg.ProgramTypeDescriptorId }
                            equals new { gspa.BeginDate, gspa.EducationOrganizationId, gspa.ProgramEducationOrganizationId, gspa.ProgramName, gspa.ProgramTypeDescriptorId }
                        join s in _edFiDb.Students on gspa.StudentUsi equals s.StudentUsi
                        from bio in _edFiDb.StaffBiographies.Where(x => x.StaffUniqueId == staff.StaffUniqueId).DefaultIfEmpty()
                        where gspa.StudentUsi == studentUsi && gspa.EndDate == null
                        select new
                        {
                            staff.StaffUsi,
                            staff.Id,
                            staff.StaffUniqueId,
                            staff.PersonalTitlePrefix,
                            staff.FirstName,
                            staff.MiddleName,
                            staff.LastSurname,
                            staffProg.ProgramName,
                            staff.YearsOfPriorTeachingExperience,
                            staff.HighlyQualifiedTeacher,
                            bio.ShortBiography,

                            SexType = sexd.Description,
                            HighestCompletedLevelOfEducation = led.ShortDescription,
                            // Per Client Request and Data Availability we are not bringing in this information on this phase.
                            // Additionally we are commenting out to bring less data and improve performance. 
                            //staff.StaffAddresses,
                            //Emails = staff.StaffElectronicMails.Select(e => e.ElectronicMailAddress),
                            //Telephone = staff.StaffTelephones.Select(t => t.TelephoneNumber),
                            //Languages = staff.StaffLanguages.Select(x => x.LanguageDescriptor.Descriptor.ShortDescription),
                            //Credentials = staff.StaffCredentials.Select(x => x.Credential.CredentialTypeDescriptor.Descriptor.ShortDescription),
                            ChatEnabled = false
                        };


            var executedQuery = await query.ToListAsync();

            var otherStaff = (from ex in executedQuery
                              group ex by ex.StaffUsi into g
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
                                  RelationToStudent = g.FirstOrDefault().ProgramName,
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
                                  HighlyQualifiedTeacher = g.FirstOrDefault().HighlyQualifiedTeacher ?? false,
                                  HighestCompletedLevelOfEducation = g.FirstOrDefault().HighestCompletedLevelOfEducation,
                                  YearsOfTeachingExperience = g.FirstOrDefault().YearsOfPriorTeachingExperience,
                                  ShortBiography = g.FirstOrDefault().ShortBiography,
                                  ChatEnabled = false
                              }).ToList();


            return otherStaff;
        }

        public async Task<List<StudentSuccessTeamMember>> GetSiblings(int studentUsi)
        {
            var parentUsis = await (from sp in _edFiDb.StudentParentAssociations
                                    where sp.StudentUsi == studentUsi
                                    select sp.ParentUsi).ToListAsync();


            var query = from sp in _edFiDb.StudentParentAssociations
                        join rel in _edFiDb.Descriptors on sp.RelationDescriptorId equals rel.DescriptorId
                        join s in _edFiDb.Students
                               // Per Client Request and Data Availability we are not bringing in this information on this phase.
                               // Additionally we are commenting out to bring less data and improve performance.
                               //.Include(x => x.StudentEducationOrganizationAssociations.Select(y => y.StudentEducationOrganizationAssociationElectronicMails))
                               //.Include(x => x.StudentEducationOrganizationAssociations.Select(y => y.StudentEducationOrganizationAssociationLanguages.Select(l => l.LanguageDescriptor.Descriptor)))
                               on sp.StudentUsi equals s.StudentUsi
                        join seoa in _edFiDb.StudentEducationOrganizationAssociations on s.StudentUsi equals seoa.StudentUsi
                        join sex in _edFiDb.Descriptors on seoa.SexDescriptorId equals sex.DescriptorId
                        join ssa in _edFiDb.StudentSchoolAssociations on sp.StudentUsi equals ssa.StudentUsi
                        join gld in _edFiDb.Descriptors on ssa.EntryGradeLevelDescriptorId equals gld.DescriptorId
                        join eo in _edFiDb.EducationOrganizations.DefaultIfEmpty()
                              on ssa.SchoolId equals eo.EducationOrganizationId
                        where sp.StudentUsi != studentUsi && parentUsis.Contains(sp.ParentUsi)
                        select new
                        {
                            s.StudentUsi,
                            s.Id,
                            s.StudentUniqueId,
                            s.PersonalTitlePrefix,
                            s.FirstName,
                            s.MiddleName,
                            s.LastSurname,
                            sex.Description,
                            eo.NameOfInstitution,
                            gld.ShortDescription,
                            // Per Client Request and Data Availability we are not bringing in this information on this phase.
                            // Additionally we are commenting out to bring less data and improve performance.
                            //Emails = s.StudentEducationOrganizationAssociations.SelectMany(x => x.StudentEducationOrganizationAssociationElectronicMails).Select(x => x.ElectronicMailAddress),
                            //Languages = s.StudentEducationOrganizationAssociations.SelectMany(x => x.StudentEducationOrganizationAssociationLanguages.Select(y => y.LanguageDescriptor.Descriptor.ShortDescription)),
                        };

            var executedQuery = await query.ToListAsync();

            var siblings = (from ex in executedQuery
                            group ex by ex.StudentUsi into g
                            select new StudentSuccessTeamMember
                            {
                                Id = g.FirstOrDefault().StudentUsi,
                                Guid = g.FirstOrDefault().Id,
                                UniqueId = g.FirstOrDefault().StudentUniqueId,
                                PersonalTitlePrefix = g.FirstOrDefault().PersonalTitlePrefix,
                                FirstName = g.FirstOrDefault().FirstName,
                                MiddleName = g.FirstOrDefault().MiddleName,
                                LastSurname = g.FirstOrDefault().LastSurname,
                                SexType = g.FirstOrDefault().Description,
                                // Per Client Request and Data Availability we are not bringing in this information on this phase.
                                // Additionally we are commenting out to bring less data and improve performance.
                                //Emails = g.FirstOrDefault().Emails,
                                //Languages = g.FirstOrDefault().Languages,
                                NameOfInstitution = g.FirstOrDefault().NameOfInstitution,
                                GradeLevel = g.FirstOrDefault().ShortDescription,
                                StudentUsi = studentUsi,
                                RelationToStudent = "Sibling"
                            }).ToList();

            return siblings;
        }

        public async Task<PersonBriefModel> GetStudentBriefModelAsyncByUniqueId(string studentUniqueId)
        {
            var data = await (from s in _edFiDb.Students
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
            var parents = await(from p in _edFiDb.Parents
                                 join pp in _edFiDb.ParentProfiles on p.ParentUniqueId equals pp.ParentUniqueId
                                 join ppt in _edFiDb.ParentProfileTelephones on pp.ParentUniqueId equals ppt.ParentUniqueId
                                 join tmc in _edFiDb.TextMessageCarrierTypes on ppt.TelephoneCarrierTypeId equals tmc.TextMessageCarrierTypeId
                                 join ppe in _edFiDb.ParentProfileElectronicMails on pp.ParentUniqueId equals ppe.ParentUniqueId
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
                                         Email = ppe.ElectronicMailAddress,
                                         Telephone = ppt.TelephoneNumber,
                                         SMSDomain = tmc.SmsSuffixDomain,
                                         ParentAlert = new ParentAlertModel
                                         {
                                             PreferredMethodOfContactTypeId = pp.PreferredMethodOfContactTypeId
                                         }
                                     }
                                 }).ToListAsync();
            return parents;
        }

        public async Task<List<ParentStudentsModel>> GetParentsBySection(int staffUsi, StaffSectionModel model, string[] validEmailTypeDescriptors, DateTime today)
        {
            var baseQuery = (from s in _edFiDb.Students
                             join ssa in _edFiDb.StudentSchoolAssociations on s.StudentUsi equals ssa.StudentUsi
                             join studSec in _edFiDb.StudentSectionAssociations
                                     on new {ssa.StudentUsi, ssa.SchoolId}
                                 equals new {studSec.StudentUsi, studSec.SchoolId}
                             join sy in _edFiDb.SchoolYearTypes on studSec.SchoolYear equals sy.SchoolYear
                             join ses in _edFiDb.Sessions
                                     on new {studSec.SchoolId, studSec.SchoolYear, studSec.SessionName}
                                 equals new {ses.SchoolId, ses.SchoolYear, ses.SessionName}
                             join staffSec in _edFiDb.StaffSectionAssociations
                                     on new { studSec.SchoolId, studSec.SessionName, studSec.SectionIdentifier, studSec.LocalCourseCode, studSec.SchoolYear }
                                 equals new { staffSec.SchoolId, staffSec.SessionName, staffSec.SectionIdentifier, staffSec.LocalCourseCode, staffSec.SchoolYear }
                             join pr in _edFiDb.StudentParentAssociations on s.StudentUsi equals pr.StudentUsi
                             join p in _edFiDb.Parents on pr.ParentUsi equals p.ParentUsi
                             // Left join
                             from staff in _edFiDb.Staffs.Where(x => x.StaffUsi == staffSec.StaffUsi).DefaultIfEmpty()
                             from pe in _edFiDb.ParentElectronicMails.Where(x => x.ParentUsi == p.ParentUsi).DefaultIfEmpty()
                             from ped in _edFiDb.Descriptors.Where(x => x.DescriptorId == pe.ElectronicMailTypeDescriptorId && validEmailTypeDescriptors.Contains(x.CodeValue)).DefaultIfEmpty()
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
                                 // This validation is for prod database, the PreferredMethodOfContactTypeId some times is null
                                 PreferredMethodOfContactTypeId = pp.PreferredMethodOfContactTypeId != null ? pp.PreferredMethodOfContactTypeId : 0,

                                 StudentFirstName = s.FirstName,
                                 StudentLastSurname = s.LastSurname,
                                 StudentUsi = s.StudentUsi,
                                 StudentUniqueId = s.StudentUniqueId,
                                 StaffFirstName = staff.FirstName,
                                 StaffLastSurname = staff.LastSurname,

                                 // Section info for filtering,
                                 studSec.SchoolId,
                                 studSec.LocalCourseCode,
                                 studSec.SchoolYear,
                                 studSec.SectionIdentifier,
                                 studSec.SessionName
                             });

            // Filtering can be all Teacher Sections or a specific section.
            if (!string.IsNullOrEmpty(model.UniqueSectionCode))
                baseQuery = baseQuery.Where(x=> x.SchoolId == model.SchoolId
                                            && x.LocalCourseCode == model.LocalCourseCode
                                            && x.SchoolYear == model.SchoolYear
                                            && x.SectionIdentifier == model.UniqueSectionCode
                                            && x.SessionName == model.SessionName);

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
                             StudentUniqueId = q.StudentUniqueId,
                             StaffFirstName = q.StaffFirstName,
                             StaffLastSurname = q.StaffLastSurname
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
                                     on new { studSec.SchoolId, studSec.SchoolYear, studSec.SessionName }
                                 equals new { ses.SchoolId, ses.SchoolYear, ses.SessionName }
                             join staffSec in _edFiDb.StaffSectionAssociations
                                     on new { studSec.SchoolId, studSec.SessionName, studSec.SectionIdentifier, studSec.LocalCourseCode, studSec.SchoolYear }
                                 equals new { staffSec.SchoolId, staffSec.SessionName, staffSec.SectionIdentifier, staffSec.LocalCourseCode, staffSec.SchoolYear }
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
                                 studSec.SchoolYear,
                                 studSec.SectionIdentifier,
                                 studSec.SessionName
                             });


            

            // Filtering can be all Teacher Sections or a specific section.
            if (!string.IsNullOrEmpty(model.UniqueSectionCode))
                baseQuery = baseQuery.Where(x => x.SchoolId == model.SchoolId
                                            && x.LocalCourseCode == model.LocalCourseCode
                                            && x.SchoolYear == model.SchoolYear
                                            && x.SectionIdentifier == model.UniqueSectionCode
                                            && x.SessionName == model.SessionName);

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
                        from sexd in _edFiDb.Descriptors.Where(x => x.DescriptorId == staff.SexDescriptorId).DefaultIfEmpty()
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
                            SexType = sexd.Description,
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
                          SexType = g.FirstOrDefault().SexType,
                          HighlyQualifiedTeacher = g.FirstOrDefault().HighlyQualifiedTeacher ?? false,
                          HighestCompletedLevelOfEducation = g.FirstOrDefault().HighestCompletedLevelOfEducation,
                          YearsOfTeachingExperience = g.FirstOrDefault().YearsOfPriorTeachingExperience,
                          ShortBiography = g.FirstOrDefault().ShortBiography,
                          UnreadMessageCount = g.FirstOrDefault().Chat,
                          ChatEnabled = ChatLogPersonTypeEnum.Parent.Value == recipientTypeId
                      }).ToList();

            return gr;
        }

        public async Task<ParentPortal.Models.Student.Assessment> GetStudentAssesmentScore(int studentUsi, string assessmentReportingMethodTypeDescriptor, string assessmentTitle)
        {
            var data = await (from sa in _edFiDb.StudentAssessments
                              join a in _edFiDb.Assessments
                                    on new { sa.AssessmentIdentifier, sa.Namespace }
                                    equals new { a.AssessmentIdentifier, a.Namespace }
                              join sasr in _edFiDb.StudentAssessmentScoreResults
                                            .Include(x => x.AssessmentReportingMethodDescriptor)
                                    on new { sa.AssessmentIdentifier, sa.Namespace, sa.StudentAssessmentIdentifier, sa.StudentUsi }
                                    equals new { sasr.AssessmentIdentifier, sasr.Namespace, sasr.StudentAssessmentIdentifier, sasr.StudentUsi }
                              where sa.StudentUsi == studentUsi && a.AssessmentTitle == assessmentTitle
                              orderby sa.AdministrationDate descending
                              select new ParentPortal.Models.Student.Assessment
                              {
                                  //Version = a.Version,
                                  Title = a.AssessmentTitle,
                                  Identifier = a.AssessmentIdentifier,
                                  MaxRawScore = (decimal)a.MaxRawScore,
                                  AdministrationDate = sa.AdministrationDate,
                                  Result = sasr.Result
                                  //ReportingMethodCodeValue = sasr.AssessmentReportingMethodType.CodeValue
                              }).FirstOrDefaultAsync();
            return data;
        }

        public async Task<ParentPortal.Models.Student.Assessment> GetStudentAssesmentPerformanceLevel(int studentUsi, string assessmentReportingMethodTypeDescriptor, string assessmentTitle)
        {
            var data = await (from sa in _edFiDb.StudentAssessments
                              join a in _edFiDb.Assessments on new { sa.AssessmentIdentifier, sa.Namespace } equals new { a.AssessmentIdentifier, a.Namespace }
                              join sapl in _edFiDb.StudentAssessmentPerformanceLevels
                                    .Include(x => x.AssessmentReportingMethodDescriptor)
                                    on new { sa.StudentUsi, sa.AssessmentIdentifier, sa.StudentAssessmentIdentifier, sa.Namespace }
                                    equals new { sapl.StudentUsi, sapl.AssessmentIdentifier, sapl.StudentAssessmentIdentifier, sapl.Namespace }
                              join d in _edFiDb.Descriptors
                                    on sapl.PerformanceLevelDescriptorId equals d.DescriptorId
                              where sa.StudentUsi == studentUsi
                                    && a.AssessmentTitle == assessmentTitle
                                    && sapl.PerformanceLevelMet == true
                              orderby sa.AdministrationDate descending
                              select new ParentPortal.Models.Student.Assessment
                              {
                                  //Version = a.Version,
                                  Title = a.AssessmentTitle,
                                  Identifier = a.AssessmentIdentifier,
                                  MaxRawScore = (decimal)a.MaxRawScore,
                                  AdministrationDate = sa.AdministrationDate,
                                  PerformanceLevelMet = d.CodeValue,
                                  //ReportingMethodCodeValue = sapl.AssessmentReportingMethodType.CodeValue
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
                                            .Include(x => x.AssessmentReportingMethodDescriptor)
                                    on new { sa.AssessmentIdentifier, sa.Namespace, sa.StudentAssessmentIdentifier, sa.StudentUsi }
                                    equals new { sasr.AssessmentIdentifier, sasr.Namespace, sasr.StudentAssessmentIdentifier, sasr.StudentUsi }
                              where sa.StudentUsi == studentUsi
                                //&& sasr.AssessmentReportingMethodType.CodeValue == assessmentReportingMethodTypeDescriptor
                                && a.AssessmentTitle == assessmentTitle
                              select new ParentPortal.Models.Student.Assessment
                              {
                                  Version = a.AssessmentVersion,
                                  Title = a.AssessmentTitle,
                                  Identifier = a.AssessmentIdentifier,
                                  MaxRawScore = (decimal)a.MaxRawScore,
                                  AdministrationDate = sa.AdministrationDate,
                                  Result = sasr.Result,
                                  //ReportingMethodCodeValue = sasr.AssessmentReportingMethodType.CodeValue,
                                  Gradelevel = d.CodeValue
                              }).Take(3).ToListAsync();
            return data;
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

            var result = list.GroupBy(x => new { x.IdentificationCode, x.AssessmentIdentifier }).Select(x => new StudentObjectiveAssessment
            {
                Title = x.Key.IdentificationCode,
                EnglishResult = x.FirstOrDefault(r => !r.AssessmentIdentifier.Contains("Spanish") && r.AdministrationDate == x.Where(d => !d.AssessmentIdentifier.Contains("Spanish")).Max(d => d.AdministrationDate))?.Result,
                SpanishResult = x.FirstOrDefault(r => r.AssessmentIdentifier.Contains("Spanish") && r.AdministrationDate == x.Where(d => d.AssessmentIdentifier.Contains("Spanish")).Max(d => d.AdministrationDate))?.Result,
                ParentIdentificationCode = x.FirstOrDefault().ParentIdentificationCode,
                IdentificationCode = x.FirstOrDefault().IdentificationCode,
                AssessmentIdentifier = x.FirstOrDefault().AssessmentIdentifier,
                AdministrationDate = x.Max(p => p.AdministrationDate)
            }).ToList();

            return result;
        }

        public Task<int> getTotalInstructionalDays(int studentUsi, StudentCalendar studentCalendar)
        {
            throw new NotImplementedException();
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
                    DateCompleted = studentGoal.DateCompleted,
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
                    DateCreated = DateTime.Now,
                    DateUpdated = DateTime.Now,
                    Description = entity.Description,
                    InterventionStart = entity.InterventionStart,
                });

                await _edFiDb.SaveChangesAsync();

                foreach (var step in entity.Steps)
                {
                    _edFiDb.StudentGoalSteps.Add(new StudentGoalStep
                    {
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
                                  Labels = sg.Labels,
                                  GradeLevel = sg.GradeLevel,
                                  DateCompleted = sg.DateCompleted,
                                  StudentUsi = sg.StudentUsi,
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
                    FavoriteAnimal = newRecord.FavoriteAnimal,
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

        public async Task<List<PersonIdentityModel>> GetStudentIdentityByEmailAsync(string email)
        {
            var identity = await (from s in _edFiDb.Students
                                  join sa in _edFiDb.StudentEducationOrganizationAssociationElectronicMails on s.StudentUsi equals sa.StudentUsi
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
                                     where s.StudentUsi == studentUsi
                                     select s).FirstOrDefaultAsync();

            return ToUserProfileModel(edfiProfile);
        }

        public async Task<List<StudentCalendarDay>> GetStudentCalendarDays(int studentUsi)
        {
            var studentSchoolAssociation = await _edFiDb.StudentSchoolAssociations.FirstOrDefaultAsync(x => x.StudentUsi == studentUsi && x.ExitWithdrawDate == null);
            if (studentSchoolAssociation != null)
            {
                var days = await (from cd in _edFiDb.CalendarDates
                                  join cdc in _edFiDb.CalendarDateCalendarEvents
                                     on new { cd.SchoolId, cd.Date } equals new { cdc.SchoolId, cdc.Date }
                                  join d in _edFiDb.Descriptors on cdc.CalendarEventDescriptorId equals d.DescriptorId into dc
                                  from ced in dc.DefaultIfEmpty()
                                  where cd.SchoolId == studentSchoolAssociation.SchoolId
                                  select new
                                  {
                                      Date = cd.Date,
                                      EventName = ced != null ? ced.CodeValue : string.Empty,
                                      EventDescription = ced != null ? ced.CodeValue : string.Empty,
                                  }).ToListAsync();

                return days.Select(x => new StudentCalendarDay
                {
                    Date = x.Date,
                    Event = new StudentCalendarEvent { Name = x.EventName, Description = x.EventDescription }
                }).ToList();
            }

            return new List<StudentCalendarDay>();
        }

        private UserProfileModel ToUserProfileModel(Student student)
        {
            var model = new UserProfileModel
            {
                Usi = student.StudentUsi,
                UniqueId = student.StudentUniqueId,
                FirstName = student.FirstName,
                MiddleName = student.MiddleName,
                LastSurname = student.LastSurname
            };

            return model;
        }
    }
}
