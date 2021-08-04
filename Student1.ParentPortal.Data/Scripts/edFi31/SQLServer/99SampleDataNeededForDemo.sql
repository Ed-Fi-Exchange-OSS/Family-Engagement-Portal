-- Sex Descroptors
-- 2018 Male
-- 2017 Female
-- Parent Usi = 3 uniqueid = 777779
-- Students [436, 722] UniqueIds [605255, 605541]
-- Staff for 436 = 53 uniqueid = 207272
-- Staff for 722 = 49 uniqueId = 207260

-- Person Type 1 = Parent; 2 = Staff;

-- Descriptor Relation Config

update edfi.Descriptor set CodeValue = 'M' where DescriptorId = 1881;
insert into edfi.StaffElectronicMail(ElectronicMailTypeDescriptorId, StaffUSI, ElectronicMailAddress)
values(818, 49, 'fred.lloyd@toolwise.onmicrosoft.com');
update edfi.ParentElectronicMail set ElectronicMailAddress = 'perry.savage@toolwise.onmicrosoft.com' where ParentUSI = 3;

update edfi.StaffElectronicMail set ElectronicMailAddress = 'alexander.kim@toolwise.onmicrosoft.com' where StaffUSI = 53;
update edfi.Student set FirstName = 'Hannah', MiddleName= 'Valeria', LastSurname ='Rodriguez', BirthSexDescriptorId = 2017 where StudentUSI = 436;
update edfi.Student set BirthSexDescriptorId = 2018 where StudentUSI = 722;
update edfi.SchoolYearType set CurrentSchoolYear = 0;
GO
update edfi.SchoolYearType set CurrentSchoolYear = 1 where SchoolYear = 2011;
GO
-- Add Student To parent
insert into edfi.StudentParentAssociation(ParentUSI, StudentUSI, RelationDescriptorId, PrimaryContactStatus, LivesWith, EmergencyContactStatus)
Values(3,436,1881,1,1,1);
GO

update edfi.StudentSchoolAssociation set SchoolYear = 2011 where StudentUSI in (436, 722);

-- Grading Period = 927
-- Grading Period Config
 update edfi.Descriptor set CodeValue = 'A1' where DescriptorId = 935;
 update edfi.Descriptor set CodeValue = 'A2' where DescriptorId = 942;
 update edfi.Descriptor set CodeValue = 'A3' where DescriptorId = 948;
 update edfi.Descriptor set CodeValue = 'A4' where DescriptorId = 939;
 update edfi.Descriptor set CodeValue = 'A5' where DescriptorId = 932;
 update edfi.Descriptor set CodeValue = 'A6' where DescriptorId = 945;
 GO

 -- 246 Unexcused absence
update edfi.Descriptor set CodeValue = 'A' where DescriptorId = 246;

--Adding Student Absences
insert into edfi.StudentSchoolAttendanceEvent(AttendanceEventCategoryDescriptorId, EventDate, SchoolId, SchoolYear, SessionName, StudentUSI, AttendanceEventReason)
values (246, '2011-05-20',255901001, 2011, '2010-2011 Spring Semester', 436 ,'The student was out of the city.');

insert into edfi.StudentSchoolAttendanceEvent(AttendanceEventCategoryDescriptorId, EventDate, SchoolId, SchoolYear, SessionName, StudentUSI, AttendanceEventReason)
values (246, '2011-05-21',255901001, 2011, '2010-2011 Spring Semester', 436 ,'Traffic.');

insert into edfi.StudentSchoolAttendanceEvent(AttendanceEventCategoryDescriptorId, EventDate, SchoolId, SchoolYear, SessionName, StudentUSI, AttendanceEventReason)
values (246, '2011-05-10',255901044, 2011, '2010-2011 Spring Semester', 722 ,'The student left the school.');
GO

--Adding student discipline incidents
insert into edfi.DisciplineIncident(IncidentIdentifier, SchoolId, IncidentDate, IncidentDescription)
values (22, 255901001, '2011-04-21', 'Student playing with a toy in class.');
insert into edfi.DisciplineIncident(IncidentIdentifier, SchoolId, IncidentDate, IncidentDescription)
values (23, 255901044, '2011-04-20', 'Student missbehaving in class.');
GO

-- StudentParticipationCodeDescriptor = 2180 -> Perpetrator
insert into edfi.StudentDisciplineIncidentAssociation(IncidentIdentifier, SchoolId, StudentUSI, StudentParticipationCodeDescriptorId)
values (22, 255901001, 436, 2180);
insert into edfi.StudentDisciplineIncidentAssociation(IncidentIdentifier, SchoolId, StudentUSI, StudentParticipationCodeDescriptorId)
values (23, 255901044, 722, 2180);
GO


insert into edfi.DisciplineAction(DisciplineActionIdentifier, DisciplineDate, StudentUSI, ResponsibilitySchoolId)
values(26, '2011-04-22', 436, 255901001);
insert into edfi.DisciplineAction(DisciplineActionIdentifier, DisciplineDate, StudentUSI, ResponsibilitySchoolId)
values(27, '2011-04-22', 722, 255901044);
GO

insert into edfi.DisciplineActionStudentDisciplineIncidentAssociation(DisciplineActionIdentifier, DisciplineDate, IncidentIdentifier, SchoolId, StudentUSI)
values(26, '2011-04-22', 22, 255901001, 436);
insert into edfi.DisciplineActionStudentDisciplineIncidentAssociation(DisciplineActionIdentifier, DisciplineDate, IncidentIdentifier, SchoolId, StudentUSI)
values(27, '2011-04-22', 23, 255901044, 722);
GO

insert into edfi.DisciplineActionDiscipline(DisciplineActionIdentifier, DisciplineDate, DisciplineDescriptorId,StudentUSI)
values(26, '2011-04-22', 771, 436);
insert into edfi.DisciplineActionDiscipline(DisciplineActionIdentifier, DisciplineDate, DisciplineDescriptorId,StudentUSI)
values(27, '2011-04-22', 771, 722);
GO

-- 897 Homework
update edfi.Descriptor set CodeValue = 'HMWK' where DescriptorId = 897;

-- Adding students missing asignments
insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
values('2011-04-12', 'Assigment 1', 'ALG-2', 255901001, 2011, '25590100106Trad220ALG222011', '2010-2011 Spring Semester', 897);

insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
values('2011-04-20', 'Assigment 2', 'SS-06', 255901044, 2011, '25590104406Trad112SS0622011', '2010-2011 Spring Semester', 897);
insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
values('2011-04-20', 'Assigment 1', 'SS-06', 255901044, 2011, '25590104406Trad112SS0622011', '2010-2011 Spring Semester', 897);

insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
values('2011-04-20', 'Assigment 2', 'SCI-06', 255901044, 2011, '25590104405Trad212SCI0622011', '2010-2011 Spring Semester', 897);
insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
values('2011-04-10', 'Assigment 1', 'SCI-06', 255901044, 2011, '25590104405Trad212SCI0622011', '2010-2011 Spring Semester', 897);
GO

-- Add GPA
update edfi.StudentAcademicRecord set CumulativeGradePointAverage = '3.5' where StudentUSI = 436;
update edfi.StudentAcademicRecord set CumulativeGradePointAverage = '4.0' where StudentUSI = 722;
GO

-- ADDING WEEK FOR SCHEDULE

insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
values('Normal Schedule', '2011-05-02', 255901001)
insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
values('Normal Schedule', '2011-05-03', 255901001)
insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
values('Normal Schedule', '2011-05-04', 255901001)
insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
values('Normal Schedule', '2011-05-05', 255901001)
insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
values('Normal Schedule', '2011-05-06', 255901001)
GO
-- ADDING ASSESSMENTS

insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('SAT MATH', 'uri://ed-fi.org/Assessment/Assessment.xml', 'SAT', 113, 2011,'2012-05-03',550);
insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('SAT EBRW', 'uri://ed-fi.org/Assessment/Assessment.xml', 'SAT', 113, 2011,'2012-05-03',550);

insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('PSAT MATH', 'uri://ed-fi.org/Assessment/Assessment.xml', 'PSAT', 113, 2011,'2012-05-03',550);
insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('PSAT EBRW', 'uri://ed-fi.org/Assessment/Assessment.xml', 'PSAT', 113, 2011,'2012-05-03',550);

insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('STAAR English I', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', 113, 2011,'2012-05-03',550);
insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('STAAR Algebra I', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', 113, 2011,'2012-05-03',550);
insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('STAAR English II', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', 113, 2011,'2012-05-03',550);
insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('STAAR Biology', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', 113, 2011,'2012-05-03',550);
insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('STAAR U.S. History', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', 113, 2011,'2012-05-03',550);

insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('STAAR READING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', 113, 2011,'2012-05-03',550);
insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('STAAR MATHEMATICS', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', 113, 2011,'2012-05-03',550);
insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('STAAR WRITING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', 113, 2011,'2012-05-03',550);
insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('STAAR SCIENCE', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', 113, 2011,'2012-05-03',550);
insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('STAAR SOCIAL STUDIES', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', 113, 2011,'2012-05-03',550);
GO

-- 218 Scale Score
-- ASIGNING ASSESSMENTS TO STUDENTS
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
values('SAT MATH', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, '2012-10-29');
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
values('SAT EBRW', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, '2012-10-29');

insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
values('PSAT MATH', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, '2012-10-29');
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
values('PSAT EBRW', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, '2012-10-29');

insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
values('STAAR English I', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, '2012-10-29');
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
values('STAAR Algebra I', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, '2012-10-29');
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
values('STAAR English II', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, '2012-10-29');
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
values('STAAR Biology', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, '2012-10-29');
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
values('STAAR U.S. History', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, '2012-10-29');

insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR READING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, '2011-10-29', 907);
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR MATHEMATICS', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, '2011-10-29', 907);
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR WRITING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, '2011-10-29', 907);
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR SCIENCE', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, '2011-10-29', 907);
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR SOCIAL STUDIES', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, '2011-10-29', 907);

insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR READING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, '2012-10-29', 917);
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR MATHEMATICS', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, '2012-10-29', 917);
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR WRITING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, '2012-10-29', 917);
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR SCIENCE', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, '2012-10-29', 917);
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR SOCIAL STUDIES', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, '2012-10-29', 917);

GO
-- ADDING ASSESSMENT SCORE RESULTS

insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('SAT MATH', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 500, 1938);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('SAT EBRW', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 450, 1938);

insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('PSAT MATH', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 500, 1938);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('PSAT EBRW', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 450, 1938);

insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR English I', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 500, 1938);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR Algebra I', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 450, 1938);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR English II', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 500, 1938);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR Biology', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 450, 1938);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR U.S. History', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 500, 1938);


insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR READING', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, 500, 1938);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR MATHEMATICS', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, 450, 1938);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR WRITING', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, 500, 1938);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR SCIENCE', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, 450, 1938);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR SOCIAL STUDIES', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, 500, 1938);

insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR READING', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, 500, 1938);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR MATHEMATICS', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, 450, 1938);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR WRITING', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, 500, 1938);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR SCIENCE', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, 450, 1938);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR SOCIAL STUDIES', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, 500, 1938);

GO

-- Configuring Performance Levels

update edfi.Descriptor set CodeValue = 'Masters Grade Level', ShortDescription = 'Masters Grade Level' where DescriptorId = 1650;
update edfi.Descriptor set CodeValue = 'Approaches Grade Level', ShortDescription = 'Approaches Grade Level' where DescriptorId = 1651;
update edfi.Descriptor set CodeValue = 'Meets Grade Level', ShortDescription = 'Approaches Grade Level' where DescriptorId = 1652;
update edfi.Descriptor set CodeValue = 'Dit Not Meet Grade Level', ShortDescription = 'Approaches Grade Level' where DescriptorId = 1653;

GO

-- Adding Performance Levels [1650-1653]

insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('SAT MATH', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1650, 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('SAT EBRW', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1651, 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 1 );

insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('PSAT MATH', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1650, 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('PSAT EBRW', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1651, 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 1 );

insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR English I', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1650, 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR Algebra I', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1651, 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR English II', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1652, 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR Biology', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1653, 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR U.S. History', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1650, 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 1 );

insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR READING', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1650, 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR MATHEMATICS', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1651, 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR WRITING', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1652, 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR SCIENCE', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1653, 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR SOCIAL STUDIES', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1650, 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, 1 );

insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR READING', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1650, 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR MATHEMATICS', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1651, 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR WRITING', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1652, 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR SCIENCE', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1653, 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR SOCIAL STUDIES', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1650, 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, 1 );
GO

-- Adding Messages
insert into ParentPortal.ChatLog(StudentUniqueId, SenderTypeId, SenderUniqueId, RecipientTypeId, RecipientUniqueId, EnglishMessage, DateSent, RecipientHasRead)
values(605541, 2, 207260, 1, 777779, 'Message for Demo', '2011-04-2', 0);

insert into ParentPortal.ChatLog(StudentUniqueId, SenderTypeId, SenderUniqueId, RecipientTypeId, RecipientUniqueId, EnglishMessage, DateSent, RecipientHasRead)
values(605255, 2, 207272, 1, 777779, 'Hello', '2011-04-2', 0);
insert into ParentPortal.ChatLog(StudentUniqueId, SenderTypeId, SenderUniqueId, RecipientTypeId, RecipientUniqueId, EnglishMessage, DateSent, RecipientHasRead)
values(605255, 2, 207272, 1, 777779, 'This is a message', '2011-04-3', 0);
GO

-- Adding Alerts
insert into ParentPortal.AlertLog(SchoolYear, AlertTypeId, ParentUniqueId, StudentUniqueId, Value, [Read], UTCSentDate)
values(2011, 1, 777779, 605255, 2, 0, '2011-05-20');
insert into ParentPortal.AlertLog(SchoolYear, AlertTypeId, ParentUniqueId, StudentUniqueId, Value, [Read], UTCSentDate)
values(2011, 1, 777779, 605541, 1, 0, '2011-05-10');
GO

-- Updating Grade Data for Students
update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = 436 and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 91 where StudentUSI = 436 and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = 436 and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 93 where StudentUSI = 436 and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 94 where StudentUSI = 436 and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = 436 and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = 436 and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = 436 and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = 436 and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = 436 and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = 436 and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = 436 and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 80 where StudentUSI = 436 and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = 436 and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 82 where StudentUSI = 436 and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 83 where StudentUSI = 436 and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 84 where StudentUSI = 436 and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 85 where StudentUSI = 436 and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = 436 and LocalCourseCode = 'GOVT' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = 436 and LocalCourseCode = 'GOVT' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = 436 and LocalCourseCode = 'GOVT' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = 436 and LocalCourseCode = 'GOVT' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = 436 and LocalCourseCode = 'GOVT' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = 436 and LocalCourseCode = 'GOVT' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = 436 and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 71 where StudentUSI = 436 and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 72 where StudentUSI = 436 and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 73 where StudentUSI = 436 and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 74 where StudentUSI = 436 and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 75 where StudentUSI = 436 and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = 436 and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = 436 and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = 436 and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = 436 and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = 436 and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = 436 and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 6;


update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = 436 and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 61 where StudentUSI = 436 and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 62 where StudentUSI = 436 and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 63 where StudentUSI = 436 and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 64 where StudentUSI = 436 and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 65 where StudentUSI = 436 and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = 722 and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 91 where StudentUSI = 722 and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = 722 and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 93 where StudentUSI = 722 and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 94 where StudentUSI = 722 and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = 722 and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = 722 and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = 722 and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = 722 and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = 722 and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = 722 and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = 722 and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 80 where StudentUSI = 722 and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = 722 and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 82 where StudentUSI = 722 and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 83 where StudentUSI = 722 and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 84 where StudentUSI = 722 and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 85 where StudentUSI = 722 and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = 722 and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = 722 and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = 722 and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = 722 and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = 722 and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = 722 and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = 722 and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 71 where StudentUSI = 722 and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 72 where StudentUSI = 722 and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 73 where StudentUSI = 722 and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 74 where StudentUSI = 722 and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 75 where StudentUSI = 722 and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = 722 and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = 722 and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = 722 and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = 722 and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = 722 and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = 722 and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 6;


update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = 436 and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 61 where StudentUSI = 436 and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 62 where StudentUSI = 436 and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 63 where StudentUSI = 436 and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 64 where StudentUSI = 436 and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 65 where StudentUSI = 436 and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 6;
GO

update edfi.CourseOffering set LocalCourseTitle = 'Algebra 1' where CourseCode = 'ALG-1'
update edfi.CourseOffering set LocalCourseTitle = 'Algebra 2' where CourseCode = 'ALG-2'
update edfi.CourseOffering set LocalCourseTitle = 'Arts 1' where CourseCode = 'ART-01'
update edfi.CourseOffering set LocalCourseTitle = 'Arts 2' where CourseCode = 'ART-02'
update edfi.CourseOffering set LocalCourseTitle = 'Arts 3' where CourseCode = 'ART-03'
update edfi.CourseOffering set LocalCourseTitle = 'Arts 4' where CourseCode = 'ART-04'
update edfi.CourseOffering set LocalCourseTitle = 'Arts 5' where CourseCode = 'ART-05'
update edfi.CourseOffering set LocalCourseTitle = 'Arts 6' where CourseCode = 'ART-06'
update edfi.CourseOffering set LocalCourseTitle = 'Arts' where CourseCode = 'ART-1'
update edfi.CourseOffering set LocalCourseTitle = 'Biology' where CourseCode = 'BIO'
update edfi.CourseOffering set LocalCourseTitle = 'Chemistry' where CourseCode = 'CHEM'
update edfi.CourseOffering set LocalCourseTitle = 'English 1' where CourseCode = 'ENG-1'
update edfi.CourseOffering set LocalCourseTitle = 'English 2' where CourseCode = 'ENG-2'
update edfi.CourseOffering set LocalCourseTitle = 'English 3' where CourseCode = 'ENG-3'
update edfi.CourseOffering set LocalCourseTitle = 'English 4' where CourseCode = 'ENG-4'
update edfi.CourseOffering set LocalCourseTitle = 'Environmental Systems' where CourseCode = 'ENVIRSYS'
update edfi.CourseOffering set LocalCourseTitle = 'Geometry' where CourseCode = 'GEOM'
update edfi.CourseOffering set LocalCourseTitle = 'Mathematics 1' where CourseCode = 'MATH-01'
update edfi.CourseOffering set LocalCourseTitle = 'Mathematics 2' where CourseCode = 'MATH-02'
update edfi.CourseOffering set LocalCourseTitle = 'Mathematics 3' where CourseCode = 'MATH-03'
update edfi.CourseOffering set LocalCourseTitle = 'Mathematics 4' where CourseCode = 'MATH-04'
update edfi.CourseOffering set LocalCourseTitle = 'Mathematics 5' where CourseCode = 'MATH-05'
update edfi.CourseOffering set LocalCourseTitle = 'Mathematics 6' where CourseCode = 'MATH-06'
update edfi.CourseOffering set LocalCourseTitle = 'Mathematics 7' where CourseCode = 'MATH-07'
update edfi.CourseOffering set LocalCourseTitle = 'Mathematics 8' where CourseCode = 'MATH-08'
update edfi.CourseOffering set LocalCourseTitle = 'Music 1' where CourseCode = 'MUS-01'
update edfi.CourseOffering set LocalCourseTitle = 'Music 2' where CourseCode = 'MUS-02'
update edfi.CourseOffering set LocalCourseTitle = 'Music 3' where CourseCode = 'MUS-03'
update edfi.CourseOffering set LocalCourseTitle = 'Music 4' where CourseCode = 'MUS-04'
update edfi.CourseOffering set LocalCourseTitle = 'Music 5' where CourseCode = 'MUS-05'
update edfi.CourseOffering set LocalCourseTitle = 'Music 6' where CourseCode = 'MUS-06'
update edfi.CourseOffering set LocalCourseTitle = 'Science 1' where CourseCode = 'SCI-01'
update edfi.CourseOffering set LocalCourseTitle = 'Science 2' where CourseCode = 'SCI-02'
update edfi.CourseOffering set LocalCourseTitle = 'Science 3' where CourseCode = 'SCI-03'
update edfi.CourseOffering set LocalCourseTitle = 'Science 4' where CourseCode = 'SCI-04'
update edfi.CourseOffering set LocalCourseTitle = 'Science 5' where CourseCode = 'SCI-05'
update edfi.CourseOffering set LocalCourseTitle = 'Science 6' where CourseCode = 'SCI-06'
update edfi.CourseOffering set LocalCourseTitle = 'Science 7' where CourseCode = 'SCI-07'
update edfi.CourseOffering set LocalCourseTitle = 'Science 8' where CourseCode = 'SCI-08'
update edfi.CourseOffering set LocalCourseTitle = 'Spanish 1' where CourseCode = 'SPAN-1'
update edfi.CourseOffering set LocalCourseTitle = 'Spanish 2' where CourseCode = 'SPAN-2'
update edfi.CourseOffering set LocalCourseTitle = 'Spanish 3' where CourseCode = 'SPAN-3'

GO

