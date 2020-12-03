
/*Add Logins for the Parents*/
INSERT INTO edfi.ParentElectronicMail (ParentUSI, ElectronicMailAddress, ElectronicMailTypeId, PrimaryEmailAddressIndicator) values (257, 'perry.savage@toolwise.onmicrosoft.com',1, 1);

-- Most data in edfi populated template is associated with year 2011.
UPDATE edfi.SchoolYearType set CurrentSchoolYear=0;
UPDATE edfi.SchoolYearType set CurrentSchoolYear=1 WHERE SchoolYear=2011;

-- Add Attendance events
-- Insert and Excused Absence
INSERT INTO edfi.StudentSchoolAttendanceEvent ([StudentUSI],[SchoolId],[SchoolYear],[EventDate],[AttendanceEventCategoryDescriptorId],[TermDescriptorId],[AttendanceEventReason]) 
values (553, 255901107, 2011, '2011-4-5', 102, 743,'Drs. Appointment');
-- Insert and Unexcused Absence
INSERT INTO edfi.StudentSchoolAttendanceEvent ([StudentUSI],[SchoolId],[SchoolYear],[EventDate],[AttendanceEventCategoryDescriptorId],[TermDescriptorId],[AttendanceEventReason]) 
values (553, 255901107, 2011, '2011-4-5', 98, 743,'Student was out of city');
-- Insert an tardy
INSERT INTO edfi.StudentSchoolAttendanceEvent ([StudentUSI],[SchoolId],[SchoolYear],[EventDate],[AttendanceEventCategoryDescriptorId],[TermDescriptorId],[AttendanceEventReason]) 
values (553, 255901107, 2011, '2011-4-5', 100, 743,'Late to class');


/*

 ***** General Data for Queries *****

Current School Year = 2011 (2010 - 2011)
PerpetratorId = 2
SuspensionDescriptorIds = 416, 417, 420, 421, 422.
ReferralDescriptorIds = 423, 414, 415, 413, 418, 419
StudentOtherNameType = 2 (nickname)
*** Debbie Savage Data ***

StudentUsi = 553
SchoolId = 255901107 EntryDate = 2010-08-23;

*/

insert into edfi.DisciplineIncident(IncidentIdentifier, SchoolId, IncidentDate, IncidentDescription)
values (24, 255901107, '2011-04-21', 'Student playing with a toy in class.');
insert into edfi.DisciplineIncident(IncidentIdentifier, SchoolId, IncidentDate, IncidentDescription)
values (25, 255901107, '2011-05-10', 'Student fought with another student.');
insert into edfi.DisciplineIncident(IncidentIdentifier, SchoolId, IncidentDate, IncidentDescription)
values (26, 255901107, '2011-03-15', 'Student damaged the school infraestructure.');

insert into edfi.StudentDisciplineIncidentAssociation(IncidentIdentifier, SchoolId, StudentUSI, StudentParticipationCodeTypeId)
values (24, 255901107, 553, 2), (25, 255901107, 553, 2), (26, 255901107, 553, 2);

insert into edfi.DisciplineAction(DisciplineActionIdentifier, DisciplineDate, StudentUSI, ResponsibilitySchoolId)
values(26, '2011-04-22', 553, 255901107),(27, '2011-05-22', 553, 255901107), (28, '2011-03-22', 553, 255901107);

insert into edfi.DisciplineActionDisciplineIncident(DisciplineActionIdentifier, DisciplineDate, IncidentIdentifier, SchoolId, StudentUSI)
values(26, '2011-04-22', 24, 255901107, 553),(27, '2011-05-22', 25, 255901107, 553),(28, '2011-03-22', 26, 255901107, 553);

insert into edfi.DisciplineActionDiscipline(DisciplineActionIdentifier, DisciplineDate, DisciplineDescriptorId,StudentUSI)
values(26, '2011-04-22', 423, 553), (27, '2011-05-22', 416, 553), (28, '2011-03-22', 420, 553);

insert into edfi.StudentAssessment
(AssessmentIdentifier, [Namespace], StudentAssessmentIdentifier, StudentUSI, AdministrationDate, AdministrationLanguageDescriptorId, AdministrationEnvironmentTypeId, RetestIndicatorTypeId)
values ('01774fa3-06f1-47fe-8801-c8b1e65057f2', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, '2011-09-28 15:00:00.0000000', 512, 3, 1);

insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodTypeId, [Namespace], StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeId)
values('01774fa3-06f1-47fe-8801-c8b1e65057f2', 28, 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 8, 1);

insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodTypeId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('01774fa3-06f1-47fe-8801-c8b1e65057f2', 28, 'http://ed-fi.org/Assessment/Assessment.xml', 577, 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 1);

insert into edfi.StudentOtherName (StudentUSI, OtherNameTypeId, FirstName, LastSurname)
values(553, 2, 'Debs', 'Savage');

insert into edfi.AssessmentReportingMethodType (CodeValue, Description, ShortDescription)
values
('Composite (Overall) Proficiency Level', 'Composite (Overall) Proficiency Level', 'Composite (Overall) Proficiency Level'),
('Composite (Overall) Scale Score', 'Composite (Overall) Scale Score', 'Composite (Overall) Scale Score'),
('Comprehension Proficiency Level', 'Comprehension Proficiency Level', 'Comprehension Proficiency Level'),
('Comprehension Scale Score', 'Comprehension Scale Score', 'Comprehension Scale Score'),
('Listening Proficiency Level', 'Listening Proficiency Level', 'Listening Proficiency Level'),
('Listening Scale Score', 'Listening Scale Score', 'Listening Scale Score'),
('Literacy Proficiency Level', 'Literacy Proficiency Level', 'Literacy Proficiency Level'),
('Literacy Scale Score', 'Literacy Scale Score', 'Literacy Scale Score'),
('Oral Proficiency Level', 'Oral Proficiency Level', 'Oral Proficiency Level'),
('Oral Scale Score', 'Oral Scale Score', 'Oral Scale Score'),
('Reading Proficiency Level', 'Reading Proficiency Level', 'Reading Proficiency Level'),
('Reading Scale Score', 'Reading Scale Score', 'Reading Scale Score'),
('Speaking Proficiency Level', 'Speaking Proficiency Level', 'Speaking Proficiency Level'),
('Speaking Scale Score', 'Speaking Scale Score', 'Speaking Scale Score'),
('Writing Proficiency Level', 'Writing Proficiency Level', 'Writing Proficiency Level'),
('Writing Scale Score', 'Writing Scale Score', 'Writing Scale Score'),
('Length of Time in LEP/ELL Program', 'Length of Time in LEP/ELL Program', 'Length of Time in LEP/ELL Program');

/* NOTE: I didnt see any AssessmentStudent data for 'Alternate_AccessScores_2019' i will ignore it for now. */
insert into edfi.Assessment (AssessmentIdentifier, [Namespace], AssessmentTitle, [Version], EducationOrganizationId)
values
('AccessScores_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'Access Scores Results', 2019, 255901107),
('AccessScores_2018', 'http://ed-fi.org/Assessment/Assessment.xml', 'Access Scores Results', 2018, 255901107),
('AccessScores_2017', 'http://ed-fi.org/Assessment/Assessment.xml', 'Access Scores Results', 2017, 255901107),
('Alternate_AccessScores_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'Alternate Access Scores Results', 2018, 255901107),
('STAR_EarlyLiteracy_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'STAR Early Literacy', 2019, 255901107),
('STAR_Math_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'STAR Math', 2019, 255901107),
('STAR_Reading_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'STAR Reading', 2019, 255901107)

insert into edfi.StudentAssessment 
(AssessmentIdentifier, [Namespace], StudentAssessmentIdentifier, StudentUSI, AdministrationDate, AdministrationEnvironmentTypeId, RetestIndicatorTypeId)
values
('AccessScores_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, '2019-03-22', 3, 1),
('AccessScores_2018', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, '2018-03-22', 3, 1),
('AccessScores_2017', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, '2017-03-22', 3, 1),
('STAR_EarlyLiteracy_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, '2019-03-22', 3, 1),
('STAR_Math_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, '2019-03-22', 3, 1),
('STAR_Reading_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, '2019-03-22', 3, 1)

insert into edfi.StudentAssessmentScoreResult 
(AssessmentIdentifier, [Namespace], StudentAssessmentIdentifier, StudentUSI, AssessmentReportingMethodTypeId, Result, ResultDatatypeTypeId)
values
('AccessScores_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 45, 2, 1),
('AccessScores_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 49, 3.5, 1),
('AccessScores_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 51, 4, 1),
('AccessScores_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 57, 3, 1),
('AccessScores_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 59, 3, 1),
('AccessScores_2018', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 45, 2.5, 1),
('AccessScores_2018', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 49, 3.4, 1),
('AccessScores_2018', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 51, 1, 1),
('AccessScores_2018', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 57, 1.5, 1),
('AccessScores_2018', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 59, 5, 1),
('AccessScores_2017', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 45, 4, 1),
('AccessScores_2017', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 49, 3.6, 1),
('AccessScores_2017', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 51, 2, 1),
('AccessScores_2017', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 57, 1.4, 1),
('AccessScores_2017', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 59, 6, 1),
('AccessScores_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 46, 400, 1),
('AccessScores_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 50, 300, 1),
('AccessScores_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 56, 400, 1),
('AccessScores_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 58, 450, 1),
('AccessScores_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 60, 450, 1),
('AccessScores_2018', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 46, 300, 1),
('AccessScores_2018', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 50, 300, 1),
('AccessScores_2018', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 56, 280, 1),
('AccessScores_2018', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 58, 320, 1),
('AccessScores_2018', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 60, 300, 1),
('AccessScores_2017', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 46, 420, 1),
('AccessScores_2017', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 50, 320, 1),
('AccessScores_2017', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 56, 420, 1),
('AccessScores_2017', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 58, 470, 1),
('AccessScores_2017', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 60, 470, 1),
('STAR_EarlyLiteracy_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 28, 300, 1),
('STAR_Math_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 28, 400, 1),
('STAR_Reading_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 28, 356, 1),
('STAR_EarlyLiteracy_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 63, 300, 1),
('STAR_Math_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 63, 400, 1),
('STAR_Reading_2019', 'http://ed-fi.org/Assessment/Assessment.xml', 'UKoF+54tt1h4tA2SxdCfbZWXDX2hYAbtqaTQNpNS', 553, 63, 356, 1);
/* I'm missing the performance level descriptor for star assessments in order to put data in the staar indicator [] */




--update edfi.StaffElectronicMail set ElectronicMailAddress = 'alexander.kim@toolwise.onmicrosoft.com' where StaffUSI = 53;
--update edfi.Student set FirstName = 'Hannah', MiddleName= 'Valeria', LastSurname ='Rodriguez', BirthSexDescriptorId = 2017 where StudentUSI = 436;
--update edfi.Student set BirthSexDescriptorId = 2018 where StudentUSI = 722;
--update edfi.SchoolYearType set CurrentSchoolYear = 0;
--GO
--update edfi.SchoolYearType set CurrentSchoolYear = 1 where SchoolYear = 2011;
--GO
---- Add Student To parent
--insert into edfi.StudentParentAssociation(ParentUSI, StudentUSI, RelationDescriptorId, PrimaryContactStatus, LivesWith, EmergencyContactStatus)
--Values(3,436,1881,1,1,1);
--GO

--update edfi.StudentSchoolAssociation set SchoolYear = 2011 where StudentUSI in (436, 722);

---- Grading Period = 927
---- Grading Period Config
-- update edfi.Descriptor set CodeValue = 'A1' where DescriptorId = 935;
-- update edfi.Descriptor set CodeValue = 'A2' where DescriptorId = 942;
-- update edfi.Descriptor set CodeValue = 'A3' where DescriptorId = 948;
-- update edfi.Descriptor set CodeValue = 'A4' where DescriptorId = 939;
-- update edfi.Descriptor set CodeValue = 'A5' where DescriptorId = 932;
-- update edfi.Descriptor set CodeValue = 'A6' where DescriptorId = 945;
-- GO

-- -- 246 Unexcused absence
--update edfi.Descriptor set CodeValue = 'A' where DescriptorId = 246;

----Adding Student Absences
--insert into edfi.StudentSchoolAttendanceEvent(AttendanceEventCategoryDescriptorId, EventDate, SchoolId, SchoolYear, SessionName, StudentUSI, AttendanceEventReason)
--values (246, '2011-05-20',255901001, 2011, '2010-2011 Spring Semester', 436 ,'The student was out of the city.');

--insert into edfi.StudentSchoolAttendanceEvent(AttendanceEventCategoryDescriptorId, EventDate, SchoolId, SchoolYear, SessionName, StudentUSI, AttendanceEventReason)
--values (246, '2011-05-21',255901001, 2011, '2010-2011 Spring Semester', 436 ,'Traffic.');

--insert into edfi.StudentSchoolAttendanceEvent(AttendanceEventCategoryDescriptorId, EventDate, SchoolId, SchoolYear, SessionName, StudentUSI, AttendanceEventReason)
--values (246, '2011-05-10',255901044, 2011, '2010-2011 Spring Semester', 722 ,'The student left the school.');
--GO

----Adding student discipline incidents
--insert into edfi.DisciplineIncident(IncidentIdentifier, SchoolId, IncidentDate, IncidentDescription)
--values (22, 255901001, '2011-04-21', 'Student playing with a toy in class.');
--insert into edfi.DisciplineIncident(IncidentIdentifier, SchoolId, IncidentDate, IncidentDescription)
--values (23, 255901044, '2011-04-20', 'Student missbehaving in class.');
--GO

---- StudentParticipationCodeDescriptor = 2180 -> Perpetrator
--insert into edfi.StudentDisciplineIncidentAssociation(IncidentIdentifier, SchoolId, StudentUSI, StudentParticipationCodeDescriptorId)
--values (22, 255901001, 436, 2180);
--insert into edfi.StudentDisciplineIncidentAssociation(IncidentIdentifier, SchoolId, StudentUSI, StudentParticipationCodeDescriptorId)
--values (23, 255901044, 722, 2180);
--GO


--insert into edfi.DisciplineAction(DisciplineActionIdentifier, DisciplineDate, StudentUSI, ResponsibilitySchoolId)
--values(26, '2011-04-22', 436, 255901001);
--insert into edfi.DisciplineAction(DisciplineActionIdentifier, DisciplineDate, StudentUSI, ResponsibilitySchoolId)
--values(27, '2011-04-22', 722, 255901044);
--GO

--insert into edfi.DisciplineActionStudentDisciplineIncidentAssociation(DisciplineActionIdentifier, DisciplineDate, IncidentIdentifier, SchoolId, StudentUSI)
--values(26, '2011-04-22', 22, 255901001, 436);
--insert into edfi.DisciplineActionStudentDisciplineIncidentAssociation(DisciplineActionIdentifier, DisciplineDate, IncidentIdentifier, SchoolId, StudentUSI)
--values(27, '2011-04-22', 23, 255901044, 722);
--GO

--insert into edfi.DisciplineActionDiscipline(DisciplineActionIdentifier, DisciplineDate, DisciplineDescriptorId,StudentUSI)
--values(26, '2011-04-22', 771, 436);
--insert into edfi.DisciplineActionDiscipline(DisciplineActionIdentifier, DisciplineDate, DisciplineDescriptorId,StudentUSI)
--values(27, '2011-04-22', 771, 722);
--GO

---- 897 Homework
--update edfi.Descriptor set CodeValue = 'HMWK' where DescriptorId = 897;

---- Adding students missing asignments
--insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
--values('2011-04-12', 'Assigment 1', 'ALG-2', 255901001, 2011, '25590100106Trad220ALG222011', '2010-2011 Spring Semester', 897);

--insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
--values('2011-04-20', 'Assigment 2', 'SS-06', 255901044, 2011, '25590104406Trad112SS0622011', '2010-2011 Spring Semester', 897);
--insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
--values('2011-04-20', 'Assigment 1', 'SS-06', 255901044, 2011, '25590104406Trad112SS0622011', '2010-2011 Spring Semester', 897);

--insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
--values('2011-04-20', 'Assigment 2', 'SCI-06', 255901044, 2011, '25590104405Trad212SCI0622011', '2010-2011 Spring Semester', 897);
--insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
--values('2011-04-10', 'Assigment 1', 'SCI-06', 255901044, 2011, '25590104405Trad212SCI0622011', '2010-2011 Spring Semester', 897);
--GO

---- Add GPA
--update edfi.StudentAcademicRecord set CumulativeGradePointAverage = '3.5' where StudentUSI = 436;
--update edfi.StudentAcademicRecord set CumulativeGradePointAverage = '4.0' where StudentUSI = 722;
--GO

---- ADDING WEEK FOR SCHEDULE

--insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
--values('Normal Schedule', '2011-05-02', 255901001)
--insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
--values('Normal Schedule', '2011-05-03', 255901001)
--insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
--values('Normal Schedule', '2011-05-04', 255901001)
--insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
--values('Normal Schedule', '2011-05-05', 255901001)
--insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
--values('Normal Schedule', '2011-05-06', 255901001)
--GO
---- ADDING ASSESSMENTS

--insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
--values('SAT MATH', 'uri://ed-fi.org/Assessment/Assessment.xml', 'SAT', 113, 2011,'2012-05-03',550);
--insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
--values('SAT EBRW', 'uri://ed-fi.org/Assessment/Assessment.xml', 'SAT', 113, 2011,'2012-05-03',550);

--insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
--values('PSAT MATH', 'uri://ed-fi.org/Assessment/Assessment.xml', 'PSAT', 113, 2011,'2012-05-03',550);
--insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
--values('PSAT EBRW', 'uri://ed-fi.org/Assessment/Assessment.xml', 'PSAT', 113, 2011,'2012-05-03',550);

--insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
--values('STAAR English I', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', 113, 2011,'2012-05-03',550);
--insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
--values('STAAR Algebra I', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', 113, 2011,'2012-05-03',550);
--insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
--values('STAAR English II', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', 113, 2011,'2012-05-03',550);
--insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
--values('STAAR Biology', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', 113, 2011,'2012-05-03',550);
--insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
--values('STAAR U.S. History', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', 113, 2011,'2012-05-03',550);

--insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
--values('STAAR READING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', 113, 2011,'2012-05-03',550);
--insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
--values('STAAR MATHEMATICS', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', 113, 2011,'2012-05-03',550);
--insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
--values('STAAR WRITING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', 113, 2011,'2012-05-03',550);
--insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
--values('STAAR SCIENCE', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', 113, 2011,'2012-05-03',550);
--insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
--values('STAAR SOCIAL STUDIES', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', 113, 2011,'2012-05-03',550);
--GO

---- 218 Scale Score
---- ASIGNING ASSESSMENTS TO STUDENTS
--insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
--values('SAT MATH', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, '2012-10-29');
--insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
--values('SAT EBRW', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, '2012-10-29');

--insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
--values('PSAT MATH', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, '2012-10-29');
--insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
--values('PSAT EBRW', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, '2012-10-29');

--insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
--values('STAAR English I', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, '2012-10-29');
--insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
--values('STAAR Algebra I', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, '2012-10-29');
--insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
--values('STAAR English II', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, '2012-10-29');
--insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
--values('STAAR Biology', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, '2012-10-29');
--insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
--values('STAAR U.S. History', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, '2012-10-29');

--insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
--values('STAAR READING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, '2011-10-29', 907);
--insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
--values('STAAR MATHEMATICS', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, '2011-10-29', 907);
--insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
--values('STAAR WRITING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, '2011-10-29', 907);
--insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
--values('STAAR SCIENCE', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, '2011-10-29', 907);
--insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
--values('STAAR SOCIAL STUDIES', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, '2011-10-29', 907);

--insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
--values('STAAR READING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, '2012-10-29', 917);
--insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
--values('STAAR MATHEMATICS', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, '2012-10-29', 917);
--insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
--values('STAAR WRITING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, '2012-10-29', 917);
--insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
--values('STAAR SCIENCE', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, '2012-10-29', 917);
--insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
--values('STAAR SOCIAL STUDIES', 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, '2012-10-29', 917);

--GO
---- ADDING ASSESSMENT SCORE RESULTS

--insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
--values('SAT MATH', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 500, 1938);
--insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
--values('SAT EBRW', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 450, 1938);

--insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
--values('PSAT MATH', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 500, 1938);
--insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
--values('PSAT EBRW', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 450, 1938);

--insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
--values('STAAR English I', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 500, 1938);
--insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
--values('STAAR Algebra I', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 450, 1938);
--insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
--values('STAAR English II', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 500, 1938);
--insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
--values('STAAR Biology', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 450, 1938);
--insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
--values('STAAR U.S. History', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 500, 1938);


--insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
--values('STAAR READING', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, 500, 1938);
--insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
--values('STAAR MATHEMATICS', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, 450, 1938);
--insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
--values('STAAR WRITING', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, 500, 1938);
--insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
--values('STAAR SCIENCE', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, 450, 1938);
--insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
--values('STAAR SOCIAL STUDIES', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, 500, 1938);

--insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
--values('STAAR READING', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, 500, 1938);
--insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
--values('STAAR MATHEMATICS', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, 450, 1938);
--insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
--values('STAAR WRITING', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, 500, 1938);
--insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
--values('STAAR SCIENCE', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, 450, 1938);
--insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
--values('STAAR SOCIAL STUDIES', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, 500, 1938);

--GO

---- Configuring Performance Levels

--update edfi.Descriptor set CodeValue = 'Masters Grade Level', ShortDescription = 'Masters Grade Level' where DescriptorId = 1650;
--update edfi.Descriptor set CodeValue = 'Approaches Grade Level', ShortDescription = 'Approaches Grade Level' where DescriptorId = 1651;
--update edfi.Descriptor set CodeValue = 'Meets Grade Level', ShortDescription = 'Approaches Grade Level' where DescriptorId = 1652;
--update edfi.Descriptor set CodeValue = 'Dit Not Meet Grade Level', ShortDescription = 'Approaches Grade Level' where DescriptorId = 1653;

--GO

---- Adding Performance Levels [1650-1653]

--insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
--values('SAT MATH', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1650, 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 1 );
--insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
--values('SAT EBRW', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1651, 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 1 );

--insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
--values('PSAT MATH', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1650, 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 1 );
--insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
--values('PSAT EBRW', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1651, 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 1 );

--insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
--values('STAAR English I', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1650, 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 1 );
--insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
--values('STAAR Algebra I', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1651, 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 1 );
--insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
--values('STAAR English II', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1652, 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 1 );
--insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
--values('STAAR Biology', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1653, 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 1 );
--insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
--values('STAAR U.S. History', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1650, 'goiwenfwf319r9r9v8noAWWDQN9dq', 436, 1 );

--insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
--values('STAAR READING', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1650, 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, 1 );
--insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
--values('STAAR MATHEMATICS', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1651, 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, 1 );
--insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
--values('STAAR WRITING', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1652, 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, 1 );
--insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
--values('STAAR SCIENCE', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1653, 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, 1 );
--insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
--values('STAAR SOCIAL STUDIES', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1650, 'goiwenfwf319r9r9v8noAWWDQN9dq', 722, 1 );

--insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
--values('STAAR READING', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1650, 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, 1 );
--insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
--values('STAAR MATHEMATICS', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1651, 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, 1 );
--insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
--values('STAAR WRITING', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1652, 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, 1 );
--insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
--values('STAAR SCIENCE', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1653, 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, 1 );
--insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
--values('STAAR SOCIAL STUDIES', 218, 'uri://ed-fi.org/Assessment/Assessment.xml', 1650, 'goiwenfwf319r9r9v8noAWWDQN9dq1', 722, 1 );
--GO

---- Adding Messages
--insert into ParentPortal.ChatLog(StudentUniqueId, SenderTypeId, SenderUniqueId, RecipientTypeId, RecipientUniqueId, OriginalMessage, DateSent, RecipientHasRead)
--values(605541, 2, 207260, 1, 777779, 'Message for Demo', '2011-04-2', 0);

--insert into ParentPortal.ChatLog(StudentUniqueId, SenderTypeId, SenderUniqueId, RecipientTypeId, RecipientUniqueId, OriginalMessage, DateSent, RecipientHasRead)
--values(605255, 2, 207272, 1, 777779, 'Hello', '2011-04-2', 0);
--insert into ParentPortal.ChatLog(StudentUniqueId, SenderTypeId, SenderUniqueId, RecipientTypeId, RecipientUniqueId, OriginalMessage, DateSent, RecipientHasRead)
--values(605255, 2, 207272, 1, 777779, 'This is a message', '2011-04-3', 0);
--GO

---- Adding Alerts
--insert into ParentPortal.AlertLog(SchoolYear, AlertTypeId, ParentUniqueId, StudentUniqueId, Value, [Read], UTCSentDate)
--values(2011, 1, 777779, 605255, 2, 0, '2011-05-20');
--insert into ParentPortal.AlertLog(SchoolYear, AlertTypeId, ParentUniqueId, StudentUniqueId, Value, [Read], UTCSentDate)
--values(2011, 1, 777779, 605541, 1, 0, '2011-05-10');
--GO

---- Updating Grade Data for Students
--update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = 436 and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 1;
--update edfi.Grade set NumericGradeEarned = 91 where StudentUSI = 436 and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 2;
--update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = 436 and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 3;
--update edfi.Grade set NumericGradeEarned = 93 where StudentUSI = 436 and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 4;
--update edfi.Grade set NumericGradeEarned = 94 where StudentUSI = 436 and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 5;
--update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = 436 and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 6;

--update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = 436 and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 1;
--update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = 436 and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 2;
--update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = 436 and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 3;
--update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = 436 and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 4;
--update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = 436 and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 5;
--update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = 436 and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 6;

--update edfi.Grade set NumericGradeEarned = 80 where StudentUSI = 436 and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 1;
--update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = 436 and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 2;
--update edfi.Grade set NumericGradeEarned = 82 where StudentUSI = 436 and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 3;
--update edfi.Grade set NumericGradeEarned = 83 where StudentUSI = 436 and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 4;
--update edfi.Grade set NumericGradeEarned = 84 where StudentUSI = 436 and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 5;
--update edfi.Grade set NumericGradeEarned = 85 where StudentUSI = 436 and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 6;

--update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = 436 and LocalCourseCode = 'GOVT' and  GradingPeriodSequence = 1;
--update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = 436 and LocalCourseCode = 'GOVT' and  GradingPeriodSequence = 2;
--update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = 436 and LocalCourseCode = 'GOVT' and  GradingPeriodSequence = 3;
--update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = 436 and LocalCourseCode = 'GOVT' and  GradingPeriodSequence = 4;
--update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = 436 and LocalCourseCode = 'GOVT' and  GradingPeriodSequence = 5;
--update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = 436 and LocalCourseCode = 'GOVT' and  GradingPeriodSequence = 6;

--update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = 436 and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 1;
--update edfi.Grade set NumericGradeEarned = 71 where StudentUSI = 436 and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 2;
--update edfi.Grade set NumericGradeEarned = 72 where StudentUSI = 436 and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 3;
--update edfi.Grade set NumericGradeEarned = 73 where StudentUSI = 436 and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 4;
--update edfi.Grade set NumericGradeEarned = 74 where StudentUSI = 436 and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 5;
--update edfi.Grade set NumericGradeEarned = 75 where StudentUSI = 436 and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 6;

--update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = 436 and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 1;
--update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = 436 and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 2;
--update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = 436 and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 3;
--update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = 436 and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 4;
--update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = 436 and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 5;
--update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = 436 and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 6;


--update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = 436 and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 1;
--update edfi.Grade set NumericGradeEarned = 61 where StudentUSI = 436 and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 2;
--update edfi.Grade set NumericGradeEarned = 62 where StudentUSI = 436 and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 3;
--update edfi.Grade set NumericGradeEarned = 63 where StudentUSI = 436 and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 4;
--update edfi.Grade set NumericGradeEarned = 64 where StudentUSI = 436 and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 5;
--update edfi.Grade set NumericGradeEarned = 65 where StudentUSI = 436 and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 6;

--update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = 722 and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 1;
--update edfi.Grade set NumericGradeEarned = 91 where StudentUSI = 722 and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 2;
--update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = 722 and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 3;
--update edfi.Grade set NumericGradeEarned = 93 where StudentUSI = 722 and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 4;
--update edfi.Grade set NumericGradeEarned = 94 where StudentUSI = 722 and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 5;
--update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = 722 and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 6;

--update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = 722 and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 1;
--update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = 722 and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 2;
--update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = 722 and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 3;
--update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = 722 and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 4;
--update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = 722 and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 5;
--update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = 722 and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 6;

--update edfi.Grade set NumericGradeEarned = 80 where StudentUSI = 722 and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 1;
--update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = 722 and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 2;
--update edfi.Grade set NumericGradeEarned = 82 where StudentUSI = 722 and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 3;
--update edfi.Grade set NumericGradeEarned = 83 where StudentUSI = 722 and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 4;
--update edfi.Grade set NumericGradeEarned = 84 where StudentUSI = 722 and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 5;
--update edfi.Grade set NumericGradeEarned = 85 where StudentUSI = 722 and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 6;

--update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = 722 and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 1;
--update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = 722 and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 2;
--update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = 722 and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 3;
--update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = 722 and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 4;
--update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = 722 and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 5;
--update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = 722 and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 6;

--update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = 722 and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 1;
--update edfi.Grade set NumericGradeEarned = 71 where StudentUSI = 722 and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 2;
--update edfi.Grade set NumericGradeEarned = 72 where StudentUSI = 722 and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 3;
--update edfi.Grade set NumericGradeEarned = 73 where StudentUSI = 722 and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 4;
--update edfi.Grade set NumericGradeEarned = 74 where StudentUSI = 722 and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 5;
--update edfi.Grade set NumericGradeEarned = 75 where StudentUSI = 722 and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 6;

--update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = 722 and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 1;
--update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = 722 and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 2;
--update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = 722 and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 3;
--update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = 722 and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 4;
--update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = 722 and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 5;
--update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = 722 and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 6;


--update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = 436 and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 1;
--update edfi.Grade set NumericGradeEarned = 61 where StudentUSI = 436 and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 2;
--update edfi.Grade set NumericGradeEarned = 62 where StudentUSI = 436 and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 3;
--update edfi.Grade set NumericGradeEarned = 63 where StudentUSI = 436 and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 4;
--update edfi.Grade set NumericGradeEarned = 64 where StudentUSI = 436 and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 5;
--update edfi.Grade set NumericGradeEarned = 65 where StudentUSI = 436 and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 6;
--GO