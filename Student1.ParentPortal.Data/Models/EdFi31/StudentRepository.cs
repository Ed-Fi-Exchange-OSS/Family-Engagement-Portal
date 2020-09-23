// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Student;

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

      
        public async Task<List<ParentPortal.Models.Student.DisciplineIncident>> GetStudentDisciplineIncidentsAsync(int studentUsi, string disciplineIncidentDescriptor)
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
                where sdia.StudentUsi == studentUsi && _edFiDb.Sessions.Where(x => x.SchoolId == sdia.SchoolId).Max(x => x.BeginDate) <= di.IncidentDate
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
                join c in _edFiDb.Courses on new {co.CourseCode, co.EducationOrganizationId} equals new { c.CourseCode, c.EducationOrganizationId }
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
                                 MaxRawScore = a.MaxRawScore,
                                 AdministrationDate = sa.AdministrationDate,
                                 Result = sasr.Result,
                                 PerformanceLevelMet = plt.ShortDescription,
                                 GradeLevel = gld.CodeValue
                             }).ToListAsync();

            return data;
        }

        public async Task<StudentMissingAssignments> GetStudentMissingAssignments(int studentUsi, string[] gradeBookMissingAssignmentTypeDescriptors)
        {
            // Get all assignments and homeworks that were assigned to the section that the student is enrolled in.
            // Assumption: If he hasn't turned it in then its a candidate for missing assignments.
            // Ed-Fi does not define a assignment due date.

            var missingAssignments = await (from gbe in _edFiDb.GradebookEntries
                                            join gbed in _edFiDb.Descriptors on gbe.GradebookEntryTypeDescriptorId equals gbed.DescriptorId
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
                                                  && sge.NumericGradeEarned == null
                                                  && gbe.GradebookEntryTypeDescriptorId != null // They have to be categorized
                                                  && gradeBookMissingAssignmentTypeDescriptors.Contains(gbed.CodeValue) // Only Homework and Assignments
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
                       join sext in _edFiDb.SexDescriptors on s.BirthSexDescriptorId equals sext.SexDescriptorId
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

            var executedQuery = await query.SingleOrDefaultAsync();

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
                                  join sex in _edFiDb.Descriptors on s.BirthSexDescriptorId equals sex.DescriptorId
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
    }
}
