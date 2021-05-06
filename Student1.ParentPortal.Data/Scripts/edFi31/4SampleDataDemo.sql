--Descriptors variables

--Gender Descriptors
declare @femaleSexDescriptorId int;
declare @maleSexDescriptorId int;

declare @staffUSIPrincipalGrandBenHighSchool int;
declare @electronictWorkMailDescriptor int

declare @fatherRelationDescriptor int;
declare @motherRelationDescriptor int;

--Roles's users ans USIs
declare @principalEmail as varchar = 'fred.lloyd@toolwise.onmicrosoft.com'
declare @principalStaffUSI AS int;
declare @teacherEmail as varchar = 'alexander.kim@toolwise.onmicrosoft.com'	
declare @teacherUSI AS int;
declare @studentMaleEmail as varchar = 'chadwick.garner@toolwise.onmicrosoft.com'
declare @studentMaleUSI AS int
declare @parentEmail as varchar = 'perry.savage@toolwise.onmicrosoft.com'
declare @parentUSI AS int
declare @studentFemaleEmail as varchar = 'chadwick1.garner@toolwise.onmicrosoft.com'
declare @studentFemaleUSI AS int
declare @descriptorPrincial AS int

--descriptors Assignment 
select @femaleSexDescriptorId = DescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/SexDescriptor' and CodeValue = 'Female' -- 2091
select @maleSexDescriptorId = DescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/SexDescriptor' and CodeValue = 'Male' -- 2090
select @electronictWorkMailDescriptor = DescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/ElectronicMailTypeDescriptor' and CodeValue = 'Work'
select @fatherRelationDescriptor = DescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/RelationDescriptor' and Description = 'Father'
select @motherRelationDescriptor = DescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/RelationDescriptor' and Description = 'Mother'
select @descriptorPrincial = DescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/StaffClassificationDescriptor' and Description = 'Principal'


----------------------------------------------------------------------------------------------------------------------------
--Double check the names
select @principalStaffUSI = StaffUSI from edfi.Staff where FirstName = 'Fred' and LastSurname = 'Lloyd';
select @teacherUSI        = StaffUSI from edfi.Staff where FirstName = 'Russell' and LastSurname = 'Gomez'
select @parentUSI         = ParentUSI from edfi.Parent where FirstName = 'April' and LastSurname = 'Terrell'


----------------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT 1 FROM edfi.StaffElectronicMail WHERE ElectronicMailAddress = 'fred.lloyd@toolwise.onmicrosoft.com')
BEGIN
	insert into edfi.StaffElectronicMail(ElectronicMailTypeDescriptorId, StaffUSI, ElectronicMailAddress)
								  values(853, 9, 'fred.lloyd@toolwise.onmicrosoft.com');
END

update edfi.StaffEducationOrganizationAssignmentAssociation set StaffClassificationDescriptorId = @descriptorPrincial where StaffUSI = @principalStaffUSI

INSERT INTO [ParentPortal].[Admin]([ElectronicMailAddress],[CreateDate],[LastModifiedDate],[Id]) VALUES ('trent.newton@toolwise.onmicrosoft.com' ,GETDATE() ,GETDATE(),newid())

update edfi.StaffElectronicMail set ElectronicMailAddress= 'trent.newton@toolwise.onmicrosoft.com' where StaffUSI = 58 
update edfi.StaffElectronicMail set StaffUSI = 51  where ElectronicMailAddress= 'trent.newton@toolwise.onmicrosoft.com'
update edfi.Student set FirstName = 'Hannah', MiddleName= 'Valeria', LastSurname ='Terrell', BirthSexDescriptorId = @femaleSexDescriptorId where StudentUSI = 435;
select  @studentMaleUSI = StudentUSI from edfi.Student where FirstName = 'Marshall' and LastSurname = 'Terrell'
select  @studentFemaleUSI = StudentUSI from edfi.Student where FirstName = 'Hannah' and LastSurname = 'Terrell'
update edfi.StudentEducationOrganizationAssociationElectronicMail set ElectronicMailAddress = 'chadwick.garner@toolwise.onmicrosoft.com' where StudentUSI = 435;


update edfi.StaffElectronicMail  set StaffUSI = 15 where ElectronicMailAddress = 'fred.lloyd@toolwise.onmicrosoft.com'
update edfi.StaffElectronicMail set ElectronicMailAddress = 'alexander.kim@toolwise.onmicrosoft.com' where StaffUSI = 57--@teacherUSI;


--update parent information
update edfi.ParentElectronicMail set ElectronicMailAddress = 'perry.savage@toolwise.onmicrosoft.com' where ParentUSI = @parentUSI
--update student female information
update edfi.Student set BirthSexDescriptorId = @femaleSexDescriptorId where StudentUSI = @studentFemaleUSI;
update edfi.Student set BirthSexDescriptorId = @maleSexDescriptorId where StudentUSI = @studentMaleUSI;

update edfi.SchoolYearType set CurrentSchoolYear = 0;
update edfi.SchoolYearType set CurrentSchoolYear = 1 where SchoolYear = 2011;


--'ParentPortal.AdminStudentDetailFeatures'.

-- Add Student To parent
insert into edfi.StudentParentAssociation(ParentUSI, StudentUSI, RelationDescriptorId, PrimaryContactStatus, LivesWith, EmergencyContactStatus)
	Values(@parentUSI,@studentFemaleUSI,@fatherRelationDescriptor,1,1,1);


--enroll student for this school year
update edfi.StudentSchoolAssociation set SchoolYear = 2011 where StudentUSI in (@studentMaleUSI, @studentFemaleUSI);

declare @firstSixWeeks int;
declare @secondSixWeeks int;
declare @thirdSixWeeks int;
declare @fourthSixWeeks int;
declare @fifthSixWeeks int;
declare @sixthSixWeeks int;

select @firstSixWeeks = DescriptorId from edfi.Descriptor where Namespace like 'uri://ed-fi.org/GradingPeriodDescriptor' and CodeValue = 'First Six Weeks'
select @secondSixWeeks = DescriptorId from edfi.Descriptor where Namespace like 'uri://ed-fi.org/GradingPeriodDescriptor' and CodeValue = 'Second Six Weeks'
select @thirdSixWeeks = DescriptorId from edfi.Descriptor where Namespace like 'uri://ed-fi.org/GradingPeriodDescriptor' and CodeValue = 'Third Six Weeks'
select @fourthSixWeeks = DescriptorId from edfi.Descriptor where Namespace like 'uri://ed-fi.org/GradingPeriodDescriptor' and CodeValue = 'Fourth Six Weeks'
select @fifthSixWeeks = DescriptorId from edfi.Descriptor where Namespace like 'uri://ed-fi.org/GradingPeriodDescriptor' and CodeValue = 'Fifth Six Weeks'
select @sixthSixWeeks = DescriptorId from edfi.Descriptor where Namespace like 'uri://ed-fi.org/GradingPeriodDescriptor' and CodeValue = 'Sixth Six Weeks'



declare @highSchoolId as int = 255901001
declare @middleSchoolId as int =255901044
declare @disciplineDescriptor int 
declare @assessmentReportingMethodDescriptor int
select @assessmentReportingMethodDescriptor = DescriptorId from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/AssessmentReportingMethodDescriptor' and CodeValue = 'Scale score'

declare @absenceDescriptor int;
declare @absenceExcused int;
declare @absenceUnExcused int;
declare @absenceTardy int;

select @absenceExcused = DescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AttendanceEventCategoryDescriptor' and CodeValue = 'Excused Absence'
select @absenceTardy = DescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AttendanceEventCategoryDescriptor' and CodeValue = 'Tardy'
select @absenceUnExcused = DescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AttendanceEventCategoryDescriptor' and CodeValue = 'Unexcused Absence'
select @absenceDescriptor = DescriptorId from edfi.Descriptor where Namespace like 'uri://ed-fi.org/AttendanceEventCategoryDescriptor' and Description = 'Unexcused Absence'

 ----INSERTING Tardies and excused absences

 insert into edfi.StudentSchoolAttendanceEvent(AttendanceEventCategoryDescriptorId, EventDate, SchoolId, SchoolYear, SessionName, StudentUSI, AttendanceEventReason)
values 
(@absenceExcused, '2011-01-07',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,'Dental appointment'),
(@absenceExcused, '2011-01-11',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,'Dental appointment'),
(@absenceTardy, '2011-01-28',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceTardy, '2011-02-09',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceTardy, '2011-06-16',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceTardy, '2011-08-24',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceTardy, '2011-12-01',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,'');

--Student MARSHALL Tardies
--select * from edfi.StudentSchoolAttendanceEvent where StudentUSI = 721
 insert into edfi.StudentSchoolAttendanceEvent(AttendanceEventCategoryDescriptorId, EventDate, SchoolId, SchoolYear, SessionName, StudentUSI, AttendanceEventReason)
values 
(@absenceTardy, '2011-01-10',@middleSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceTardy, '2011-02-14',@middleSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceTardy, '2011-04-11',@middleSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceTardy, '2011-05-23',@middleSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceTardy, '2011-06-20',@middleSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),

(@absenceTardy, '2011-07-11',@middleSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceTardy, '2011-08-15',@middleSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceTardy, '2011-09-12',@middleSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceTardy, '2011-10-24',@middleSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceTardy, '2011-11-07',@middleSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceTardy, '2011-12-06',@middleSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),

(@absenceExcused, '2011-01-07',@middleSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,'Dental appointment'),
(@absenceExcused, '2011-02-11',@middleSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,'Dental appointment'),
(@absenceExcused, '2011-03-07',@middleSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceExcused, '2011-04-12',@middleSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceExcused, '2011-05-07',@middleSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceExcused, '2011-06-11',@middleSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),

(@absenceUnExcused, '2011-06-14',@middleSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceUnExcused, '2011-03-15',@middleSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,'');

 

--Insert Student all about
SET IDENTITY_INSERT [ParentPortal].[StudentAllAbout] ON
INSERT [ParentPortal].[StudentAllAbout] ([StudentAllAboutId], [StudentUSI], [PrefferedName], [FunFact], [TypesOfBook], [FavoriteAnimal], [FavoriteThingToDo], [FavoriteSubjectSchool], [OneThingWant], [LearnToDo], [LearningThings], [DateCreated], [DateUpdated]) VALUES (1, 435, N'Hannah', N'I am funny', N'Sci-Fi', N'Dogs are cute', N'Reading', N'Math', N'Travel', N'Math', N'Yes', CAST(N'2021-02-24T17:49:04.427' AS DateTime), CAST(N'2021-02-24T17:49:04.427' AS DateTime))
SET IDENTITY_INSERT [ParentPortal].[StudentAllAbout] OFF
-- Insert teacher admin
SET IDENTITY_INSERT [ParentPortal].[Admin] ON 
INSERT [ParentPortal].[Admin] ([AdminUSI], [ElectronicMailAddress], [CreateDate], [LastModifiedDate], [Id]) VALUES (3, N'trent.newton@toolwise.onmicrosoft.com', CAST(N'2020-06-03T00:00:00.0000000' AS DateTime2), CAST(N'2020-06-03T00:00:00.0000000' AS DateTime2), N'a3b7e2df-de0c-43ce-8e6d-2da37e3b0ab3')
SET IDENTITY_INSERT [ParentPortal].[Admin] OFF

--Adding student discipline incidents

declare @perpetratorDisciplineDescriptor int;
declare @reporterDisciplineDescriptor int;
select @perpetratorDisciplineDescriptor = DescriptorId from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/DisciplineIncidentParticipationCodeDescriptor' and CodeValue = 'Perpetrator'
select @reporterDisciplineDescriptor = DescriptorId from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/DisciplineIncidentParticipationCodeDescriptor' and CodeValue = 'Reporter'

insert into edfi.DisciplineIncident(IncidentIdentifier, SchoolId, IncidentDate, IncidentDescription)
values (30, @middleSchoolId, '2011-06-04', 'Student playing with a toy in class.');

INSERT INTO [edfi].[DisciplineAction]
           ([DisciplineActionIdentifier],[DisciplineDate],[StudentUSI],[DisciplineActionLength],[ActualDisciplineActionLength]
           ,[DisciplineActionLengthDifferenceReasonDescriptorId],[RelatedToZeroTolerancePolicy],[ResponsibilitySchoolId]
           ,[AssignmentSchoolId],[ReceivedEducationServicesDuringExpulsion],[IEPPlacementMeetingIndicator],[Discriminator]
           ,[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           (30,'2011-06-04',@studentMaleUSI,1,1,787,NULL,@middleSchoolId,NULL,NULL,NULL,NULL,GETDATE(),GETDATE(),NEWID(),47760)

INSERT INTO [edfi].[DisciplineActionDiscipline]
           ([DisciplineActionIdentifier],[DisciplineDate],[DisciplineDescriptorId],[StudentUSI],[CreateDate])
     VALUES
           (30,'2011-06-04',797,@studentMaleUSI,GETDATE())


INSERT INTO [edfi].[StudentDisciplineIncidentAssociation]
           ([IncidentIdentifier],[SchoolId],[StudentUSI],[StudentParticipationCodeDescriptorId],[Discriminator]
           ,[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           (30,@middleSchoolId,@studentMaleUSI,2258,null,GETDATE(),GETDATE(),NEWID(),17743)

INSERT INTO [edfi].[DisciplineActionStudentDisciplineIncidentAssociation]
           ([DisciplineActionIdentifier],[DisciplineDate],[IncidentIdentifier],[SchoolId],[StudentUSI],[CreateDate])
     VALUES
           (30,'2011-06-04',30,@middleSchoolId,@studentMaleUSI,GETDATE())

declare @perpetratorDisciplineStudentDescriptor int;
declare @reporterDisciplineStudentDescriptor int;
declare @assesmentCategoryDescriptor int;
declare @gradeLevelDescriptor int;
declare @2gradeLevelDescriptor int;
declare @resultDatatypeTypeDescriptor int;

select @perpetratorDisciplineStudentDescriptor = DescriptorId from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/StudentParticipationCodeDescriptor' and CodeValue = 'Perpetrator'
select @reporterDisciplineStudentDescriptor = DescriptorId from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/StudentParticipationCodeDescriptor' and CodeValue = 'Reporter'
select @assesmentCategoryDescriptor = DescriptorId from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/AssessmentCategoryDescriptor' and CodeValue = 'College entrance exam'
select @gradeLevelDescriptor = DescriptorId from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/GradeLevelDescriptor' and CodeValue = '1th Grade'
select @2gradeLevelDescriptor = DescriptorId from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/GradeLevelDescriptor' and CodeValue = '2nd Grade'
select @resultDatatypeTypeDescriptor = DescriptorId from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/ResultDatatypeTypeDescriptor' and CodeValue = 'Integer'






--  Homework
declare @homeWorkDescriptor int;
select @homeWorkDescriptor = DescriptorId from edfi.Descriptor where Namespace =  'uri://ed-fi.org/GradebookEntryTypeDescriptor' and Description = 'Homework'
update edfi.Descriptor set CodeValue = 'HMWK' where DescriptorId = @homeWorkDescriptor;





-- Adding students missing asignments
insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
values('2011-04-12', 'Assigment 1', 'ALG-2', @highSchoolId, 2011, '25590100106Trad220ALG222011', '2010-2011 Spring Semester', @homeWorkDescriptor);

insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
values('2011-04-20', 'Assigment 2', 'SS-06', @middleSchoolId, 2011,'25590104406Trad112SS0622011', '2010-2011 Spring Semester', @homeWorkDescriptor);
insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
values('2011-04-20', 'Assigment 1', 'SS-06', @middleSchoolId, 2011,'25590104406Trad112SS0622011', '2010-2011 Spring Semester', @homeWorkDescriptor);

insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
values('2011-04-20', 'Assigment 2', 'SCI-06', @middleSchoolId, 2011, '25590104405Trad212SCI0622011', '2010-2011 Spring Semester', @homeWorkDescriptor);
insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
values('2011-04-10', 'Assigment 1', 'SCI-06', @middleSchoolId, 2011, '25590104405Trad212SCI0622011', '2010-2011 Spring Semester', @homeWorkDescriptor);


-- Add GPA
update edfi.StudentAcademicRecord set CumulativeGradePointAverage = '3.5' where StudentUSI = @studentMaleUSI;
update edfi.StudentAcademicRecord set CumulativeGradePointAverage = '4.0' where StudentUSI = @studentFemaleUSI;


-- ADDING WEEK FOR SCHEDULE

insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
values('Normal Schedule', '2011-05-02', @highSchoolId)
insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
values('Normal Schedule', '2011-05-03', @highSchoolId)
insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
values('Normal Schedule', '2011-05-04', @highSchoolId)
insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
values('Normal Schedule', '2011-05-05', @highSchoolId)
insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
values('Normal Schedule', '2011-05-06', @highSchoolId)

insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
values('Normal Schedule', '2011-05-02', @middleSchoolId)
insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
values('Normal Schedule', '2011-05-03', @middleSchoolId)
insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
values('Normal Schedule', '2011-05-04', @middleSchoolId)
insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
values('Normal Schedule', '2011-05-05', @middleSchoolId)
insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
values('Normal Schedule', '2011-05-06', @middleSchoolId)

-- ADDING ASSESSMENTS

insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('SAT MATH', 'uri://ed-fi.org/Assessment/Assessment.xml', 'SAT', @assesmentCategoryDescriptor, 2011,'2012-05-03',550);
insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('SAT EBRW', 'uri://ed-fi.org/Assessment/Assessment.xml', 'SAT', @assesmentCategoryDescriptor, 2011,'2012-05-03',550);

insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('PSAT MATH', 'uri://ed-fi.org/Assessment/Assessment.xml', 'PSAT', @assesmentCategoryDescriptor, 2011,'2012-05-03',550);
insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('PSAT EBRW', 'uri://ed-fi.org/Assessment/Assessment.xml', 'PSAT', @assesmentCategoryDescriptor, 2011,'2012-05-03',550);

insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('STAAR English I', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', @assesmentCategoryDescriptor, 2011,'2012-05-03',550);
insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('STAAR Algebra I', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', @assesmentCategoryDescriptor, 2011,'2012-05-03',550);
insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('STAAR English II', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', @assesmentCategoryDescriptor, 2011,'2012-05-03',550);
insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('STAAR Biology', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', @assesmentCategoryDescriptor, 2011,'2012-05-03',550);
insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('STAAR U.S. History', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', @assesmentCategoryDescriptor, 2011,'2012-05-03',550);

insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('STAAR READING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', @assesmentCategoryDescriptor, 2011,'2012-05-03',550);
insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('STAAR MATHEMATICS', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', @assesmentCategoryDescriptor, 2011,'2012-05-03',550);
insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('STAAR WRITING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', @assesmentCategoryDescriptor, 2011,'2012-05-03',550);
insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('STAAR SCIENCE', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', @assesmentCategoryDescriptor, 2011,'2012-05-03',550);
insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
values('STAAR SOCIAL STUDIES', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', @assesmentCategoryDescriptor, 2011,'2012-05-03',550);


-- @assessmentReportingMethodDescriptor Scale Score
-- ASIGNING ASSESSMENTS TO STUDENTS
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
values('SAT MATH', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, '2012-10-29');
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
values('SAT EBRW', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, '2012-10-29');

insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
values('PSAT MATH', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, '2012-10-29');
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
values('PSAT EBRW', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, '2012-10-29');

insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
values('STAAR English I', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, '2012-10-29');
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
values('STAAR Algebra I', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, '2012-10-29');
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
values('STAAR English II', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, '2012-10-29');
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
values('STAAR Biology', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, '2012-10-29');
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
values('STAAR U.S. History', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, '2012-10-29');

insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR READING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentMaleUSI, '2011-10-29', @gradeLevelDescriptor);
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR MATHEMATICS', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentMaleUSI, '2011-10-29', @gradeLevelDescriptor);
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR WRITING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentMaleUSI, '2011-10-29', @gradeLevelDescriptor);
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR SCIENCE', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentMaleUSI, '2011-10-29', @gradeLevelDescriptor);
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR SOCIAL STUDIES', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentMaleUSI, '2011-10-29', @gradeLevelDescriptor);

insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR READING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq1', @studentMaleUSI, '2012-10-29', @2gradeLevelDescriptor);
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR MATHEMATICS', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq1', @studentMaleUSI, '2012-10-29', @2gradeLevelDescriptor);
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR WRITING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq1', @studentMaleUSI, '2012-10-29', @2gradeLevelDescriptor);
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR SCIENCE', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq1', @studentMaleUSI, '2012-10-29', @2gradeLevelDescriptor);
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR SOCIAL STUDIES', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq1', @studentMaleUSI, '2012-10-29', @2gradeLevelDescriptor);


-- ADDING ASSESSMENT SCORE RESULTS

insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('SAT MATH', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, 500, @resultDatatypeTypeDescriptor);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('SAT EBRW', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, 450, @resultDatatypeTypeDescriptor);

insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('PSAT MATH', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, 500, @resultDatatypeTypeDescriptor);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('PSAT EBRW', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, 450, @resultDatatypeTypeDescriptor);

insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR English I', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, 500, @resultDatatypeTypeDescriptor);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR Algebra I', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, 450, @resultDatatypeTypeDescriptor);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR English II', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, 500, @resultDatatypeTypeDescriptor);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR Biology', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, 450, @resultDatatypeTypeDescriptor);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR U.S. History', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, 500, @resultDatatypeTypeDescriptor);


insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR READING', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentMaleUSI, 500, @resultDatatypeTypeDescriptor);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR MATHEMATICS', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentMaleUSI, 450, @resultDatatypeTypeDescriptor);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR WRITING', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentMaleUSI, 500, @resultDatatypeTypeDescriptor);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR SCIENCE', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentMaleUSI, 450, @resultDatatypeTypeDescriptor);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR SOCIAL STUDIES', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', @studentMaleUSI, 500, @resultDatatypeTypeDescriptor);

insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR READING', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq1', @studentMaleUSI, 500, @resultDatatypeTypeDescriptor);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR MATHEMATICS', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq1', @studentMaleUSI, 450, @resultDatatypeTypeDescriptor);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR WRITING', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq1', @studentMaleUSI, 500, @resultDatatypeTypeDescriptor);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR SCIENCE', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq1', @studentMaleUSI, 450, @resultDatatypeTypeDescriptor);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR SOCIAL STUDIES', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq1', @studentMaleUSI, 500, @resultDatatypeTypeDescriptor);



-- Configuring Performance Levels


declare @performanceLevelDescriptorMaster int;
declare @performanceLevelDescriptorApproaches int;
declare @performanceLevelDescriptorMeets int;
declare @performanceLevelDescriptorDidNotMeet int;


select @performanceLevelDescriptorMaster = DescriptorId from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/PerformanceLevelDescriptor' and Description = 'Above Benchmark'
select @performanceLevelDescriptorApproaches = DescriptorId from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/PerformanceLevelDescriptor' and Description = 'Advanced'
select @performanceLevelDescriptorMeets = DescriptorId from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/PerformanceLevelDescriptor' and Description = 'Basic'
select @performanceLevelDescriptorDidNotMeet = DescriptorId from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/PerformanceLevelDescriptor' and Description = 'Below Basic'




insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('SAT MATH', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorMaster, 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('SAT EBRW', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorApproaches, 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, 1 );

insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('PSAT MATH', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorMaster, 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('PSAT EBRW', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorApproaches, 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, 1 );

insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR English I', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorMaster, 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR Algebra I', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorApproaches, 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR English II', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorMeets, 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR Biology', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorDidNotMeet, 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR U.S. History', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorMaster, 'iwenfwf319r9r9v8noAWWDQN9dq', @studentFemaleUSI, 1 );

insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR READING', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorMaster, 'iwenfwf319r9r9v8noAWWDQN9dq', @studentMaleUSI, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR MATHEMATICS', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorApproaches, 'iwenfwf319r9r9v8noAWWDQN9dq', @studentMaleUSI, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR WRITING', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorMeets, 'iwenfwf319r9r9v8noAWWDQN9dq', @studentMaleUSI, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR SCIENCE', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorDidNotMeet, 'iwenfwf319r9r9v8noAWWDQN9dq', @studentMaleUSI, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR SOCIAL STUDIES', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorMaster, 'iwenfwf319r9r9v8noAWWDQN9dq', @studentMaleUSI, 1 );

insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR READING', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorMaster, 'iwenfwf319r9r9v8noAWWDQN9dq1', @studentMaleUSI, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR MATHEMATICS', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorApproaches, 'iwenfwf319r9r9v8noAWWDQN9dq1', @studentMaleUSI, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR WRITING', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorMeets, 'iwenfwf319r9r9v8noAWWDQN9dq1', @studentMaleUSI, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR SCIENCE', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorDidNotMeet, 'iwenfwf319r9r9v8noAWWDQN9dq1', @studentMaleUSI, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR SOCIAL STUDIES', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorMaster, 'iwenfwf319r9r9v8noAWWDQN9dq1', @studentMaleUSI, 1 );



------------StudentAssessment-
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR READING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq2', @studentFemaleUSI, '2011-10-29', @gradeLevelDescriptor);
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR MATHEMATICS', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq2', @studentFemaleUSI, '2011-10-29', @gradeLevelDescriptor);
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR WRITING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq2', @studentFemaleUSI, '2011-10-29', @gradeLevelDescriptor);
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR SCIENCE', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq2', @studentFemaleUSI, '2011-10-29', @gradeLevelDescriptor);
insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
values('STAAR SOCIAL STUDIES', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq2', @studentFemaleUSI, '2011-10-29', @gradeLevelDescriptor);


insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR READING', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq2', @studentFemaleUSI, 500, @resultDatatypeTypeDescriptor);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR MATHEMATICS', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq2', @studentFemaleUSI, 450, @resultDatatypeTypeDescriptor);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR WRITING', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq2', @studentFemaleUSI, 500, @resultDatatypeTypeDescriptor);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR SCIENCE', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq2', @studentFemaleUSI, 450, @resultDatatypeTypeDescriptor);
insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
values('STAAR SOCIAL STUDIES', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq2', @studentFemaleUSI, 500, @resultDatatypeTypeDescriptor);





insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR READING', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorDidNotMeet, 'iwenfwf319r9r9v8noAWWDQN9dq2', @studentFemaleUSI, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR MATHEMATICS', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorApproaches, 'iwenfwf319r9r9v8noAWWDQN9dq2', @studentFemaleUSI, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR WRITING', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorDidNotMeet, 'iwenfwf319r9r9v8noAWWDQN9dq2', @studentFemaleUSI, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR SCIENCE', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorDidNotMeet, 'iwenfwf319r9r9v8noAWWDQN9dq2', @studentFemaleUSI, 1 );
insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
values('STAAR SOCIAL STUDIES', @assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', @performanceLevelDescriptorMaster, 'iwenfwf319r9r9v8noAWWDQN9dq2', @studentFemaleUSI, 1 );

update edfi.Assessment  set AssessmentTitle = 'STAAR Math' where AssessmentIdentifier = 'STAAR MATHEMATICS' 
update edfi.Assessment  set AssessmentTitle = 'STAAR Reading' where AssessmentIdentifier = 'STAAR READING' 
-- Adding Messages
insert into ParentPortal.ChatLog(StudentUniqueId, SenderTypeId, SenderUniqueId, RecipientTypeId, RecipientUniqueId, EnglishMessage, DateSent, RecipientHasRead)
values(605541, 2, 207260, 1, 777779, 'Message for Demo', '2011-04-2', 0);

insert into ParentPortal.ChatLog(StudentUniqueId, SenderTypeId, SenderUniqueId, RecipientTypeId, RecipientUniqueId, EnglishMessage, DateSent, RecipientHasRead)
values(605255, 2, 207272, 1, 777779, 'Hello', '2011-04-2', 0);
insert into ParentPortal.ChatLog(StudentUniqueId, SenderTypeId, SenderUniqueId, RecipientTypeId, RecipientUniqueId, EnglishMessage, DateSent, RecipientHasRead)
values(605255, 2, 207272, 1, 777779, 'This is a message', '2011-04-3', 0);


-- Adding Alerts
insert into ParentPortal.AlertLog(SchoolYear, AlertTypeId, ParentUniqueId, StudentUniqueId, Value, [Read], UTCSentDate)
values(2011, 1, 777779, 605255, 2, 0, '2011-05-20');
insert into ParentPortal.AlertLog(SchoolYear, AlertTypeId, ParentUniqueId, StudentUniqueId, Value, [Read], UTCSentDate)
values(2011, 1, 777779, 605541, 1, 0, '2011-05-10');






-- Updating Grade Data for Students

update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 91 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 93 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 94 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 80 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 82 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 83 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 84 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 85 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'VT' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'VT' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'VT' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'VT' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'VT' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'VT' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 71 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 72 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 73 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 74 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 75 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 6;


update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 61 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 62 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 63 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 64 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 65 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 91 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 93 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 94 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 80 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 82 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 83 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 84 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 85 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 71 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 72 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 73 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 74 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 75 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 6;

update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = @studentMaleUSI and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 6;


update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 1;
update edfi.Grade set NumericGradeEarned = 61 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 2;
update edfi.Grade set NumericGradeEarned = 62 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 3;
update edfi.Grade set NumericGradeEarned = 63 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 4;
update edfi.Grade set NumericGradeEarned = 64 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 5;
update edfi.Grade set NumericGradeEarned = 65 where StudentUSI = @studentFemaleUSI and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 6;



--- Update CourseTitle to more descriptive definition

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
----------------------------------------------------------------------------------------------------------------------
--Goals students
declare @studentMaleUSI AS int
declare @studentFemaleUSI AS int




select  @studentMaleUSI = StudentUSI from edfi.Student where FirstName = 'Marshall' and LastSurname = 'Terrell'
select  @studentFemaleUSI = StudentUSI from edfi.Student where FirstName = 'Hannah' and LastSurname = 'Terrell'






INSERT INTO ParentPortal.StudentGoal 
([StudentUSI],[GoalType],[Goal],[GradeLevel],
 [DateGoalCreated],[DateScheduled],[DateCompleted],
 [Additional],[Completed],[DateCreated],[DateUpdated],[Labels])

values
(@studentFemaleUSI,'A', 'Decode most 2 syllable words','Tenth grade', GETDATE(), DATEADD(dd,31,GETDATE()),null,'','NA',GETDATE(),  GETDATE(),null),
(@studentFemaleUSI,'C', 'SELF-MANAGEMENT: manage my emotions, thoughts, and behaviors effectively in different situations and to achieve goals.','Tengh grade', GETDATE(), dateadd(dd,31,getdate()),null,'','NA', GETDATE(), GETDATE(),null),
(@studentFemaleUSI,'P', 'Demonstrate awareness of career options in the community','Tenth grade', GETDATE(), dateadd(dd,31,getdate()),null,'','NA',GETDATE(),GETDATE(),null)

INSERT INTO ParentPortal.StudentGoal 
([StudentUSI],[GoalType],[Goal],[GradeLevel],
 [DateGoalCreated],[DateScheduled],[DateCompleted],
 [Additional],[Completed],[DateCreated],[DateUpdated],[Labels])

values
(@studentMaleUSI,'A', 'Decode most 2 syllable words','Tenth grade', GETDATE(), DATEADD(dd,31,GETDATE()),null,'','NA',GETDATE(),  GETDATE(),null),
(@studentMaleUSI,'C', 'SELF-MANAGEMENT: manage my emotions, thoughts, and behaviors effectively in different situations and to achieve goals.','Tengh grade', GETDATE(), dateadd(dd,31,getdate()),null,'','NA', GETDATE(), GETDATE(),null),
(@studentMaleUSI,'P', 'Demonstrate awareness of career options in the community','Tenth grade', GETDATE(), dateadd(dd,31,getdate()),null,'','NA',GETDATE(),GETDATE(),null)

-----------------------------------------------------------------------------------------------------
go

declare @studentFemaleGoalAcademic AS int
declare @studentFemaleGoalCareer AS int
declare @studentFemaleGoalPersonal AS int

declare @studentMaleGoalAcademic AS int
declare @studentMaleGoalCareer AS int
declare @studentMaleGoalPersonal AS int

declare @studentMaleUSI AS int
declare @studentFemaleUSI AS int
select  @studentMaleUSI = StudentUSI from edfi.Student where FirstName = 'Marshall' and LastSurname = 'Terrell'
select  @studentFemaleUSI = StudentUSI from edfi.Student where FirstName = 'Hannah' and LastSurname = 'Terrell'


select @studentFemaleGoalAcademic = StudentGoalId  from ParentPortal.StudentGoal where [StudentUSI] = @studentFemaleUSI and GoalType = 'A'
select @studentFemaleGoalCareer = StudentGoalId  from ParentPortal.StudentGoal where [StudentUSI] = @studentFemaleUSI and GoalType = 'C'
select @studentFemaleGoalPersonal = StudentGoalId  from ParentPortal.StudentGoal where [StudentUSI] = @studentFemaleUSI and GoalType = 'P'

select @studentMaleGoalAcademic = StudentGoalId  from ParentPortal.StudentGoal where [StudentUSI] = @studentMaleUSI and GoalType = 'A'
select @studentMaleGoalCareer = StudentGoalId  from ParentPortal.StudentGoal where [StudentUSI] = @studentMaleUSI and GoalType = 'C'
select @studentMaleGoalPersonal = StudentGoalId  from ParentPortal.StudentGoal where [StudentUSI] = @studentMaleUSI and GoalType = 'P'

INSERT INTO [ParentPortal].[StudentGoalStep]
           ([StudentGoalId],[StepName],[Completed],[DateCreated]
           ,[DateUpdated],[IsActive],[StudentGoalInterventionId])
     VALUES
           (@studentFemaleGoalAcademic,'identify all consonant and vowel sounds',1,GETDATE(),GETDATE(),1,NULL),
		   (@studentFemaleGoalAcademic,'identify beginning, middle and ending sounds',1,GETDATE(),GETDATE(),1,NULL),
		   (@studentFemaleGoalAcademic,'be able to cumulativley blend 2 and 3 phoneme words',1,GETDATE(),GETDATE(),1,NULL),

		   (@studentFemaleGoalCareer,'Use planning and organizational tools such as checklists and picture schedules to stay on track',0,GETDATE(),GETDATE(),1,NULL),
		   (@studentFemaleGoalCareer,'Goal for completion of work; use of paper tracker or google form to track completed assignemnts',0,GETDATE(),GETDATE(),1,NULL),
		   (@studentFemaleGoalCareer,'use of stress management strategies such as short breaks and use of cool down station in classroom',0,GETDATE(),GETDATE(),1,NULL),
		   
		   (@studentFemaleGoalPersonal,'Identify career clusters in occupations within the community that I would be interested in',0,GETDATE(),GETDATE(),1,NULL)


INSERT INTO [ParentPortal].[StudentGoalStep]
           ([StudentGoalId],[StepName],[Completed],[DateCreated]
           ,[DateUpdated],[IsActive],[StudentGoalInterventionId])
     VALUES
           (@studentMaleGoalAcademic,'identify all consonant and vowel sounds',1,GETDATE(),GETDATE(),1,NULL),
		   (@studentMaleGoalAcademic,'identify beginning, middle and ending sounds',1,GETDATE(),GETDATE(),1,NULL),
		   (@studentMaleGoalAcademic,'be able to cumulativley blend 2 and 3 phoneme words',1,GETDATE(),GETDATE(),1,NULL),

		   (@studentMaleGoalCareer,'Use planning and organizational tools such as checklists and picture schedules to stay on track',0,GETDATE(),GETDATE(),1,NULL),
		   (@studentMaleGoalCareer,'Goal for completion of work; use of paper tracker or google form to track completed assignemnts',0,GETDATE(),GETDATE(),1,NULL),
		   (@studentMaleGoalCareer,'use of stress management strategies such as short breaks and use of cool down station in classroom',0,GETDATE(),GETDATE(),1,NULL),
		   
		   (@studentMaleGoalPersonal,'Identify career clusters in occupations within the community that I would be interested in',0,GETDATE(),GETDATE(),1,NULL)

	GO

--255901001  - Grand Bend High School
--@AssessmentCategoryDescriptorId    State English proficiency test

--AssesmentIdentifier : AccessScores_2019
--Namespace : uri://ed-fi.org/Assessment/Assessment.xml


declare @highSchoolId as int = 255901001


declare @studentMaleUSI AS int
declare @studentFemaleUSI AS int

--Assessments descriptors
declare @AssessmentCategoryDescriptorId int         -- 119 uri://ed-fi.org/AssessmentCategoryDescriptor State English proficiency test
declare @AcademicSubjectDescriptorId int		    -- 31	uri://ed-fi.org/AcademicSubjectDescriptor	English	
declare @ResultDatatypeTypeDescriptorInteger int	-- 2013 @ResultDatatypeTypeDescriptorInteger	uri://ed-fi.org/ResultDatatypeTypeDescriptor	Integer	
declare @ResultDatatypeTypeDescriptorDecimal int     --@ResultDatatypeTypeDescriptorDecimal	uri://ed-fi.org/ResultDatatypeTypeDescriptor	Decimal
declare @AssessmentReportingMethodDescriptorProfencyLevel int --@ResultDatatypeTypeDescriptorDecimal	uri://ed-fi.org/AssessmentReportingMethodDescriptor	Proficiency level
declare @AssessmentReportingMethodDescriptorRawScore int      --@AssessmentReportingMethodDescriptorRawScore	uri://ed-fi.org/AssessmentReportingMethodDescriptor	Raw score	Raw score
declare @AssessmentReportingMethodDescriptorScaleScore int    --@AssessmentReportingMethodDescriptorScaleScore	uri://ed-fi.org/AssessmentReportingMethodDescriptor	Scale score
declare @GradeLevelDescriptor int							  --@GradeLevelDescriptor	uri://ed-fi.org/GradeLevelDescriptor	First grade
declare @PerformaceLevelDescriptor int						  --@GradeLevelDescriptor	uri://ed-fi.org/PerformanceLevelDescriptor	Above Benchmark

select  @studentMaleUSI = StudentUSI from edfi.Student where FirstName = 'Marshall' and LastSurname = 'Terrell'
select  @studentFemaleUSI = StudentUSI from edfi.Student where FirstName = 'Hannah' and LastSurname = 'Terrell'

--select  @studentMaleUSI = 69
--select  @studentFemaleUSI = 70


select  @AssessmentCategoryDescriptorId = descriptorid from edfi.Descriptor where Namespace = 'AssessmentCategoryDescriptor' and CodeValue = 'English proficiency test'
select  @AcademicSubjectDescriptorId = descriptorid from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AcademicSubjectDescriptor' and CodeValue = 'English'
select  @ResultDatatypeTypeDescriptorInteger = descriptorid from edfi.Descriptor where Namespace = 'uri://ed-fi.org/ResultDatatypeTypeDescriptor' and CodeValue = 'Integer'
select  @ResultDatatypeTypeDescriptorDecimal = descriptorid from edfi.Descriptor where Namespace = 'uri://ed-fi.org/ResultDatatypeTypeDescriptor' and CodeValue = 'Decimal'
select  @AssessmentReportingMethodDescriptorProfencyLevel = descriptorid from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AssessmentReportingMethodDescriptor' and CodeValue = 'Proficiency level'
select  @AssessmentReportingMethodDescriptorRawScore = descriptorid from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AssessmentReportingMethodDescriptor' and CodeValue = 'Raw score'
select  @AssessmentReportingMethodDescriptorScaleScore = descriptorid from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AssessmentReportingMethodDescriptor' and CodeValue = 'Scale score'
select  @GradeLevelDescriptor = descriptorid from edfi.Descriptor where Namespace = 'uri://ed-fi.org/GradeLevelDescriptor' and CodeValue = 'First grade'
select  @PerformaceLevelDescriptor = descriptorid from edfi.Descriptor where Namespace = 'uri://ed-fi.org/PerformanceLevelDescriptor' and CodeValue = 'Above Benchmark'


DECLARE @AssesmentIdentifierMale2018 UNIQUEIDENTIFIER
DECLARE @AssesmentIdentifierMale2019 UNIQUEIDENTIFIER


DECLARE @AssesmentIdentifierFemale2018 UNIQUEIDENTIFIER
DECLARE @AssesmentIdentifierFemale2019 UNIQUEIDENTIFIER

select @AssesmentIdentifierFemale2018 = NEWID()
select @AssesmentIdentifierFemale2019 = NEWID()

select @AssesmentIdentifierMale2018 = NEWID()
select @AssesmentIdentifierMale2019 = NEWID()

INSERT [edfi].[Assessment] ([AssessmentIdentifier], [Namespace], [AssessmentTitle], [AssessmentCategoryDescriptorId], [AssessmentForm], [AssessmentVersion], [RevisionDate], [MaxRawScore], [Nomenclature], [AssessmentFamily], [EducationOrganizationId], [AdaptiveAssessment], [CreateDate], [LastModifiedDate], [Id]) 
VALUES 
(N'AccessScores_2019', N'uri://ed-fi.org/Assessment/Assessment.xml', N'Access Scores', @AssessmentCategoryDescriptorId, NULL, 2019, NULL, 6.0, NULL, NULL, 255901001, NULL, CAST(N'2019-10-31T13:36:16.000' AS DateTime), CAST(N'2019-10-31T13:36:16.250' AS DateTime), N'e6b0a3b2-4866-4050-a69e-6e9ea0df9682')
--(N'AccessScores_2018', N'uri://ed-fi.org/Assessment/Assessment.xml', N'Access Scores', @AssessmentCategoryDescriptorId, NULL, 2018, NULL, 6.0, NULL, NULL, 255901001, NULL, CAST(N'2019-12-11T15:05:39.000' AS DateTime), CAST(N'2019-12-11T15:05:39.300' AS DateTime), N'785e03b2-a06d-480b-8f9a-92803f8e8787'),

INSERT [edfi].[Assessment] ([AssessmentIdentifier], [Namespace], [AssessmentTitle], [AssessmentCategoryDescriptorId], [AssessmentForm], [AssessmentVersion], [RevisionDate], [MaxRawScore], [Nomenclature], [AssessmentFamily], [EducationOrganizationId], [AdaptiveAssessment], [CreateDate], [LastModifiedDate], [Id]) 
VALUES 
(N'AccessScores_2018', N'uri://ed-fi.org/Assessment/Assessment.xml', N'Access Scores', @AssessmentCategoryDescriptorId, NULL, 2018, NULL, 6.0, NULL, NULL, 255901001, NULL, CAST(N'2019-12-11T15:05:39.000' AS DateTime), CAST(N'2019-12-11T15:05:39.300' AS DateTime), N'785e03b2-a06d-480b-8f9a-92803f8e8787')

INSERT INTO [edfi].[ObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[MaxRawScore]
           ,[PercentOfAssessment],[Nomenclature],[Description],[ParentIdentificationCode]
           ,[AcademicSubjectDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate]
           ,[Id],[ChangeVersion])
     VALUES
           ('AccessScores_2019','STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml'
           ,6.0,0.25,null,null,null,@AcademicSubjectDescriptorId,null,GETDATE(),GETDATE(),NEWID(),15000)

INSERT INTO [edfi].[ObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[MaxRawScore]
           ,[PercentOfAssessment],[Nomenclature],[Description],[ParentIdentificationCode]
           ,[AcademicSubjectDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate]
           ,[Id],[ChangeVersion])
     VALUES
           ('AccessScores_2018','STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml'
           ,6.0,0.25,null,null,null,@AcademicSubjectDescriptorId,null,GETDATE(),GETDATE(),NEWID(),15001)


INSERT INTO [edfi].[ObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[MaxRawScore]
           ,[PercentOfAssessment],[Nomenclature],[Description],[ParentIdentificationCode]
           ,[AcademicSubjectDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate]
           ,[Id],[ChangeVersion])
     VALUES
           ('AccessScores_2019','STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml'
           ,6.0,0.25,null,null,null,@AcademicSubjectDescriptorId,null,GETDATE(),GETDATE(),NEWID(),15000)

INSERT INTO [edfi].[ObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[MaxRawScore]
           ,[PercentOfAssessment],[Nomenclature],[Description],[ParentIdentificationCode]
           ,[AcademicSubjectDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate]
           ,[Id],[ChangeVersion])
     VALUES
           ('AccessScores_2018','STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml'
           ,6.0,0.25,null,null,null,@AcademicSubjectDescriptorId,null,GETDATE(),GETDATE(),NEWID(),15001)

INSERT INTO [edfi].[ObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[MaxRawScore]
           ,[PercentOfAssessment],[Nomenclature],[Description],[ParentIdentificationCode]
           ,[AcademicSubjectDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate]
           ,[Id],[ChangeVersion])
     VALUES
           ('AccessScores_2019','STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml'
           ,6.0,0.25,null,null,null,@AcademicSubjectDescriptorId,null,GETDATE(),GETDATE(),NEWID(),15000)

INSERT INTO [edfi].[ObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[MaxRawScore]
           ,[PercentOfAssessment],[Nomenclature],[Description],[ParentIdentificationCode]
           ,[AcademicSubjectDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate]
           ,[Id],[ChangeVersion])
     VALUES
           ('AccessScores_2018','STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml'
           ,6.0,0.25,null,null,null,@AcademicSubjectDescriptorId,null,GETDATE(),GETDATE(),NEWID(),15001)

INSERT INTO [edfi].[ObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[MaxRawScore]
           ,[PercentOfAssessment],[Nomenclature],[Description],[ParentIdentificationCode]
           ,[AcademicSubjectDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate]
           ,[Id],[ChangeVersion])
     VALUES
           ('AccessScores_2019','STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml'
           ,6.0,0.25,null,null,null,@AcademicSubjectDescriptorId,null,GETDATE(),GETDATE(),NEWID(),15000)


INSERT INTO [edfi].[ObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[MaxRawScore]
           ,[PercentOfAssessment],[Nomenclature],[Description],[ParentIdentificationCode]
           ,[AcademicSubjectDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate]
           ,[Id],[ChangeVersion])
     VALUES
           ('AccessScores_2018','STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml'
           ,6.0,0.25,null,null,null,@AcademicSubjectDescriptorId,null,GETDATE(),GETDATE(),NEWID(),15001)

---------------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO [edfi].[AssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[Namespace]
           ,[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2019',@AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml','0','6.0',@ResultDatatypeTypeDescriptorDecimal,GETDATE())
INSERT INTO [edfi].[AssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[Namespace]
           ,[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2018',@AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml','0','6.0',@ResultDatatypeTypeDescriptorDecimal,GETDATE())


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- Objective Assessment Score 

INSERT INTO [edfi].[ObjectiveAssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode]
           ,[Namespace],[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2019',@AssessmentReportingMethodDescriptorRawScore,'STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml','0','6.0',@ResultDatatypeTypeDescriptorDecimal,GETDATE())

INSERT INTO [edfi].[ObjectiveAssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode]
           ,[Namespace],[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2018',@AssessmentReportingMethodDescriptorRawScore,'STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml','0','6.0',@ResultDatatypeTypeDescriptorDecimal,GETDATE())

INSERT INTO [edfi].[ObjectiveAssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode]
           ,[Namespace],[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2019',@AssessmentReportingMethodDescriptorRawScore,'STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml','0','6.0',@ResultDatatypeTypeDescriptorDecimal,GETDATE())

INSERT INTO [edfi].[ObjectiveAssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode]
           ,[Namespace],[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2018',@AssessmentReportingMethodDescriptorRawScore,'STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml','0','6.0',@ResultDatatypeTypeDescriptorDecimal,GETDATE())


INSERT INTO [edfi].[ObjectiveAssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode]
           ,[Namespace],[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2019',@AssessmentReportingMethodDescriptorRawScore,'STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml','0','6.0',@ResultDatatypeTypeDescriptorDecimal,GETDATE())

INSERT INTO [edfi].[ObjectiveAssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode]
           ,[Namespace],[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2018',@AssessmentReportingMethodDescriptorRawScore,'STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml','0','6.0',@ResultDatatypeTypeDescriptorDecimal,GETDATE())

INSERT INTO [edfi].[ObjectiveAssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode]
           ,[Namespace],[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2019',@AssessmentReportingMethodDescriptorRawScore,'STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml','0','6.0',@ResultDatatypeTypeDescriptorDecimal,GETDATE())

INSERT INTO [edfi].[ObjectiveAssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode]
           ,[Namespace],[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2018',@AssessmentReportingMethodDescriptorRawScore,'STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml','0','6.0',@ResultDatatypeTypeDescriptorDecimal,GETDATE())

------------------------------------------------------
--Student assesment
INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[AdministrationDate],[AdministrationEndDate]
		   ,[SerialNumber],[AdministrationLanguageDescriptorId],[AdministrationEnvironmentDescriptorId],[RetestIndicatorDescriptorId]
           ,[ReasonNotTestedDescriptorId],[WhenAssessedGradeLevelDescriptorId],[EventCircumstanceDescriptorId],[EventDescription]
           ,[SchoolYear],[PlatformTypeDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           ('AccessScores_2019','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2019,@studentMaleUSI,'20170502',null
           ,null,null,null,null,null,@GradeLevelDescriptor
           ,null,null,null,null,null,GETDATE(),GETDATE(),NEWID(),103939)

INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[AdministrationDate],[AdministrationEndDate]
		   ,[SerialNumber],[AdministrationLanguageDescriptorId],[AdministrationEnvironmentDescriptorId],[RetestIndicatorDescriptorId]
           ,[ReasonNotTestedDescriptorId],[WhenAssessedGradeLevelDescriptorId],[EventCircumstanceDescriptorId],[EventDescription]
           ,[SchoolYear],[PlatformTypeDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           ('AccessScores_2018','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2018,@studentMaleUSI,'20170502',null
           ,null,null,null,null,null,@GradeLevelDescriptor
           ,null,null,null,null,null,GETDATE(),GETDATE(),NEWID(),103938)


--student assesment score

INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[Namespace],[StudentAssessmentIdentifier]
           ,[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2019',@AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2019,@studentMaleUSI,3.9,@ResultDatatypeTypeDescriptorDecimal,GETDATE())

INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[Namespace],[StudentAssessmentIdentifier]
           ,[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2018',@AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2018,@studentMaleUSI,4.9,@ResultDatatypeTypeDescriptorDecimal,GETDATE())




--student assesment objetice assesment

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('AccessScores_2019','STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2019,@studentMaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('AccessScores_2018','STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2018,@studentMaleUSI,GETDATE())


INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('AccessScores_2019','STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2019,@studentMaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('AccessScores_2018','STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2018,@studentMaleUSI,GETDATE())


INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('AccessScores_2019','STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2019,@studentMaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('AccessScores_2018','STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2018,@studentMaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('AccessScores_2019','STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2019,@studentMaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('AccessScores_2018','STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2018,@studentMaleUSI,GETDATE())

-- student assesment student objective score result




INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2019',@AssessmentReportingMethodDescriptorRawScore,'STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2019,@studentMaleUSI,'2.5',@ResultDatatypeTypeDescriptorDecimal,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2018',@AssessmentReportingMethodDescriptorRawScore,'STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2018,@studentMaleUSI,'5.5',@ResultDatatypeTypeDescriptorDecimal,GETDATE())



INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2019',@AssessmentReportingMethodDescriptorRawScore,'STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2019,@studentMaleUSI,'2.5',@ResultDatatypeTypeDescriptorDecimal,GETDATE())
INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2018',@AssessmentReportingMethodDescriptorRawScore,'STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2018,@studentMaleUSI,'5.8',@ResultDatatypeTypeDescriptorDecimal,GETDATE())
------------------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2019',@AssessmentReportingMethodDescriptorRawScore,'STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2019,@studentMaleUSI,'2.5',@ResultDatatypeTypeDescriptorDecimal,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2018',@AssessmentReportingMethodDescriptorRawScore,'STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2018,@studentMaleUSI,'2.1',@ResultDatatypeTypeDescriptorDecimal,GETDATE())

------------------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2019',@AssessmentReportingMethodDescriptorRawScore,'STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2019,@studentMaleUSI,'2.5',@ResultDatatypeTypeDescriptorDecimal,GETDATE())
--
INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2018',@AssessmentReportingMethodDescriptorRawScore,'STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2018,@studentMaleUSI,'3.5',@ResultDatatypeTypeDescriptorDecimal,GETDATE())



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- STUDENT FEMALE 

------------------------------------------------------
--Student assesment
INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[AdministrationDate],[AdministrationEndDate]
		   ,[SerialNumber],[AdministrationLanguageDescriptorId],[AdministrationEnvironmentDescriptorId],[RetestIndicatorDescriptorId]
           ,[ReasonNotTestedDescriptorId],[WhenAssessedGradeLevelDescriptorId],[EventCircumstanceDescriptorId],[EventDescription]
           ,[SchoolYear],[PlatformTypeDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           ('AccessScores_2019','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2019,@studentFemaleUSI,'20170502',null
           ,null,null,null,null,null,@GradeLevelDescriptor
           ,null,null,null,null,null,GETDATE(),GETDATE(),NEWID(),103939)

INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[AdministrationDate],[AdministrationEndDate]
		   ,[SerialNumber],[AdministrationLanguageDescriptorId],[AdministrationEnvironmentDescriptorId],[RetestIndicatorDescriptorId]
           ,[ReasonNotTestedDescriptorId],[WhenAssessedGradeLevelDescriptorId],[EventCircumstanceDescriptorId],[EventDescription]
           ,[SchoolYear],[PlatformTypeDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           ('AccessScores_2018','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2018,@studentFemaleUSI,'20170502',null
           ,null,null,null,null,null,@GradeLevelDescriptor
           ,null,null,null,null,null,GETDATE(),GETDATE(),NEWID(),103938)


--student assesment score

INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[Namespace],[StudentAssessmentIdentifier]
           ,[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2019',@AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2019,@studentFemaleUSI,3.9,@ResultDatatypeTypeDescriptorDecimal,GETDATE())

INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[Namespace],[StudentAssessmentIdentifier]
           ,[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2018',@AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2018,@studentFemaleUSI,4.9,@ResultDatatypeTypeDescriptorDecimal,GETDATE())




--student assesment objetice assesment

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('AccessScores_2019','STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2019,@studentFemaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('AccessScores_2018','STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2018,@studentFemaleUSI,GETDATE())


INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('AccessScores_2019','STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2019,@studentFemaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('AccessScores_2018','STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2018,@studentFemaleUSI,GETDATE())


INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('AccessScores_2019','STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2019,@studentFemaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('AccessScores_2018','STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2018,@studentFemaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('AccessScores_2019','STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2019,@studentFemaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('AccessScores_2018','STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2018,@studentFemaleUSI,GETDATE())

-- student assesment student objective score result




INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2019',@AssessmentReportingMethodDescriptorRawScore,'STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2019,@studentFemaleUSI,'2.5',@ResultDatatypeTypeDescriptorDecimal,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2018',@AssessmentReportingMethodDescriptorRawScore,'STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2018,@studentFemaleUSI,'5.5',@ResultDatatypeTypeDescriptorDecimal,GETDATE())



INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2019',@AssessmentReportingMethodDescriptorRawScore,'STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2019,@studentFemaleUSI,'2.5',@ResultDatatypeTypeDescriptorDecimal,GETDATE())
INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2018',@AssessmentReportingMethodDescriptorRawScore,'STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2018,@studentFemaleUSI,'5.8',@ResultDatatypeTypeDescriptorDecimal,GETDATE())
------------------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2019',@AssessmentReportingMethodDescriptorRawScore,'STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2019,@studentFemaleUSI,'2.5',@ResultDatatypeTypeDescriptorDecimal,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2018',@AssessmentReportingMethodDescriptorRawScore,'STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2018,@studentFemaleUSI,'2.1',@ResultDatatypeTypeDescriptorDecimal,GETDATE())

------------------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2019',@AssessmentReportingMethodDescriptorRawScore,'STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2019,@studentFemaleUSI,'2.5',@ResultDatatypeTypeDescriptorDecimal,GETDATE())
--
INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('AccessScores_2018',@AssessmentReportingMethodDescriptorRawScore,'STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2018,@studentFemaleUSI,'3.5',@ResultDatatypeTypeDescriptorDecimal,GETDATE())



GO

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Insert Assigments

-- Fall Semester Asigment
insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
values('2010-08-23', '20 Exercises', 'ART2-EM', 255901001, 2011, '25590100104Trad322ART2EM12011', '2010-2011 Fall Semester', 933);

-- Spring Semester Asigment
insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
values('2011-04-12', 'Essay 3 Rough Draft', 'CREAT-WR', 255901001, 2011, '25590100102Trad321CREATWR22011', '2010-2011 Spring Semester', 933);


insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
values('2011-04-12', 'Essay Delivery', 'ENVIRSYS', 255901001, 2011, '25590100107Trad222ENVIRSYS2201', '2010-2011 Spring Semester', 933);


insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
values('2011-04-12', 'Ch. 10 Exercises', 'SPAN-1', 255901001, 2011, '25590100103Trad324SPAN122011', '2010-2011 Spring Semester', 933);


-- Spring Semester Asigment

insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
values('2011-04-20', 'Worksheet 22 Simple Physics', 'SS-06', 255901044, 2011,'25590104406Trad112SS0622011', '2010-2011 Spring Semester', 933);
insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
values('2011-04-20', 'Essay Delivery', 'SCI-06', 255901044, 2011,'25590104405Trad212SCI0622011', '2010-2011 Spring Semester', 933);


--Insert missing assesment for students
INSERT INTO [edfi].[StudentGradebookEntry]
           ([BeginDate],[DateAssigned],[GradebookEntryTitle],[LocalCourseCode],[SchoolId],[SchoolYear]
           ,[SectionIdentifier],[SessionName],[StudentUSI],[DateFulfilled],[LetterGradeEarned],[NumericGradeEarned]
           ,[CompetencyLevelDescriptorId],[DiagnosticStatement],[Discriminator],[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           ('2011-01-04','2011-04-12','Assigment 1','ALG-2','255901001','2011','25590100106Trad220ALG222011'
           ,'2010-2011 Spring Semester',435,NULL,'M',92.00,NULL,NULL,NULL,GETDATE(),GETDATE(),NEWID(),88348)


INSERT INTO [edfi].[StudentGradebookEntry]
           ([BeginDate],[DateAssigned],[GradebookEntryTitle],[LocalCourseCode],[SchoolId],[SchoolYear]
           ,[SectionIdentifier],[SessionName],[StudentUSI],[DateFulfilled],[LetterGradeEarned],[NumericGradeEarned]
           ,[CompetencyLevelDescriptorId],[DiagnosticStatement],[Discriminator],[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           ('2010-08-23','2010-08-23','20 Exercises','ART2-EM','255901001','2011','25590100104Trad322ART2EM12011'
           ,'2010-2011 Fall Semester',435,NULL,'M',92.00,NULL,NULL,NULL,GETDATE(),GETDATE(),NEWID(),88348)


INSERT INTO [edfi].[StudentGradebookEntry]
           ([BeginDate],[DateAssigned],[GradebookEntryTitle],[LocalCourseCode],[SchoolId],[SchoolYear]
           ,[SectionIdentifier],[SessionName],[StudentUSI],[DateFulfilled],[LetterGradeEarned],[NumericGradeEarned]
           ,[CompetencyLevelDescriptorId],[DiagnosticStatement],[Discriminator],[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           ('2011-01-04','2011-04-12','Essay 3 Rough Draft','CREAT-WR','255901001','2011','25590100102Trad321CREATWR22011'
           ,'2010-2011 Spring Semester',435,NULL,'M',92.00,NULL,NULL,NULL,GETDATE(),GETDATE(),NEWID(),88348)


INSERT INTO [edfi].[StudentGradebookEntry]
           ([BeginDate],[DateAssigned],[GradebookEntryTitle],[LocalCourseCode],[SchoolId],[SchoolYear]
           ,[SectionIdentifier],[SessionName],[StudentUSI],[DateFulfilled],[LetterGradeEarned],[NumericGradeEarned]
           ,[CompetencyLevelDescriptorId],[DiagnosticStatement],[Discriminator],[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           ('2011-01-04','2011-04-12','Essay Delivery','ENVIRSYS','255901001','2011','25590100107Trad222ENVIRSYS2201'
           ,'2010-2011 Spring Semester',435,NULL,'M',92.00,NULL,NULL,NULL,GETDATE(),GETDATE(),NEWID(),88348)


INSERT INTO [edfi].[StudentGradebookEntry]
           ([BeginDate],[DateAssigned],[GradebookEntryTitle],[LocalCourseCode],[SchoolId],[SchoolYear]
           ,[SectionIdentifier],[SessionName],[StudentUSI],[DateFulfilled],[LetterGradeEarned],[NumericGradeEarned]
           ,[CompetencyLevelDescriptorId],[DiagnosticStatement],[Discriminator],[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           ('2011-01-04','2011-04-12','Ch. 10 Exercises','SPAN-1','255901001','2011','25590100103Trad324SPAN122011'
           ,'2010-2011 Spring Semester',435,NULL,'M',92.00,NULL,NULL,NULL,GETDATE(),GETDATE(),NEWID(),88348)


INSERT INTO [edfi].[StudentGradebookEntry]
           ([BeginDate],[DateAssigned],[GradebookEntryTitle],[LocalCourseCode],[SchoolId],[SchoolYear]
           ,[SectionIdentifier],[SessionName],[StudentUSI],[DateFulfilled],[LetterGradeEarned],[NumericGradeEarned]
           ,[CompetencyLevelDescriptorId],[DiagnosticStatement],[Discriminator],[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           ('2011-01-04','2011-04-20','Worksheet 22 Simple Physics','SS-06','255901044','2011','25590104406Trad112SS0622011'
           ,'2010-2011 Spring Semester',721,NULL,'M',92.00,NULL,NULL,NULL,GETDATE(),GETDATE(),NEWID(),88348)

INSERT INTO [edfi].[StudentGradebookEntry]
           ([BeginDate],[DateAssigned],[GradebookEntryTitle],[LocalCourseCode],[SchoolId],[SchoolYear]
           ,[SectionIdentifier],[SessionName],[StudentUSI],[DateFulfilled],[LetterGradeEarned],[NumericGradeEarned]
           ,[CompetencyLevelDescriptorId],[DiagnosticStatement],[Discriminator],[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           ('2011-01-04','2011-04-20','Essay Delivery','SCI-06','255901044','2011','25590104405Trad212SCI0622011'
           ,'2010-2011 Spring Semester',721,NULL,'M',92.00,NULL,NULL,NULL,GETDATE(),GETDATE(),NEWID(),88348)

go


--Gender Descriptors
declare @femaleSexDescriptorId int;
declare @maleSexDescriptorId int;

declare @staffUSIPrincipalGrandBenHighSchool int;
declare @electronictWorkMailDescriptor int

declare @fatherRelationDescriptor int;
declare @motherRelationDescriptor int;

--Roles's users ans USIs

declare @studentMaleUSI AS int
declare @studentFemaleUSI AS int

--descriptors Assignment 
select @femaleSexDescriptorId = DescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/SexDescriptor' and CodeValue = 'Female' -- 2091
select @maleSexDescriptorId = DescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/SexDescriptor' and CodeValue = 'Male' -- 2090
select @electronictWorkMailDescriptor = DescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/ElectronicMailTypeDescriptor' and CodeValue = 'Work'
select @fatherRelationDescriptor = DescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/RelationDescriptor' and Description = 'Father'
select @motherRelationDescriptor = DescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/RelationDescriptor' and Description = 'Mother'
declare @AssessmentCategoryDescriptorId int         -- 119 uri://ed-fi.org/AssessmentCategoryDescriptor State English proficiency test
declare @AcademicSubjectDescriptorId int		    -- 31	uri://ed-fi.org/AcademicSubjectDescriptor	English	
declare @ResultDatatypeTypeDescriptorInteger int	-- 2013 @ResultDatatypeTypeDescriptorInteger	uri://ed-fi.org/ResultDatatypeTypeDescriptor	Integer	
declare @ResultDatatypeTypeDescriptorDecimal int     --@ResultDatatypeTypeDescriptorDecimal	uri://ed-fi.org/ResultDatatypeTypeDescriptor	Decimal
declare @AssessmentReportingMethodDescriptorProfencyLevel int --@ResultDatatypeTypeDescriptorDecimal	uri://ed-fi.org/AssessmentReportingMethodDescriptor	Proficiency level
declare @AssessmentReportingMethodDescriptorRawScore int      --@AssessmentReportingMethodDescriptorRawScore	uri://ed-fi.org/AssessmentReportingMethodDescriptor	Raw score	Raw score
declare @AssessmentReportingMethodDescriptorScaleScore int    --@AssessmentReportingMethodDescriptorScaleScore	uri://ed-fi.org/AssessmentReportingMethodDescriptor	Scale score
declare @GradeLevelDescriptor int							  --@GradeLevelDescriptor	uri://ed-fi.org/GradeLevelDescriptor	First grade
declare @PerformaceLevelDescriptor int						  --@GradeLevelDescriptor	uri://ed-fi.org/PerformanceLevelDescriptor	Above Benchmark
declare @ResultDatatypeTypeDescriptorLevel int


select  @ResultDatatypeTypeDescriptorLevel = descriptorid from edfi.Descriptor where Namespace = 'uri://ed-fi.org/ResultDatatypeTypeDescriptor' and CodeValue = 'Level'
select  @AssessmentCategoryDescriptorId = descriptorid from edfi.Descriptor where Namespace = 'AssessmentCategoryDescriptor' and CodeValue = 'English proficiency test'
select  @AcademicSubjectDescriptorId = descriptorid from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AcademicSubjectDescriptor' and CodeValue = 'English'
select  @ResultDatatypeTypeDescriptorInteger = descriptorid from edfi.Descriptor where Namespace = 'uri://ed-fi.org/ResultDatatypeTypeDescriptor' and CodeValue = 'Integer'
select  @ResultDatatypeTypeDescriptorDecimal = descriptorid from edfi.Descriptor where Namespace = 'uri://ed-fi.org/ResultDatatypeTypeDescriptor' and CodeValue = 'Decimal'
select  @AssessmentReportingMethodDescriptorProfencyLevel = descriptorid from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AssessmentReportingMethodDescriptor' and CodeValue = 'Proficiency level'
select  @AssessmentReportingMethodDescriptorRawScore = descriptorid from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AssessmentReportingMethodDescriptor' and CodeValue = 'Raw score'
select  @AssessmentReportingMethodDescriptorScaleScore = descriptorid from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AssessmentReportingMethodDescriptor' and CodeValue = 'Scale score'
select  @GradeLevelDescriptor = descriptorid from edfi.Descriptor where Namespace = 'uri://ed-fi.org/GradeLevelDescriptor' and CodeValue = 'First grade'
select  @PerformaceLevelDescriptor = descriptorid from edfi.Descriptor where Namespace = 'uri://ed-fi.org/PerformanceLevelDescriptor' and CodeValue = 'Above Benchmark'

select  @studentMaleUSI = StudentUSI from edfi.Student where FirstName = 'Marshall' and LastSurname = 'Terrell'
select  @studentFemaleUSI = StudentUSI from edfi.Student where FirstName = 'Hannah' and LastSurname = 'Terrell'

declare @AssesmentIdentifierFemale2019 uniqueidentifier
declare @AssesmentIdentifierFemale20192 uniqueidentifier

select  @AssesmentIdentifierFemale2019 = newid()
select  @AssesmentIdentifierFemale20192 = newid()

declare @AssesmentIdentifierMale2019 uniqueidentifier
declare @AssesmentIdentifierMale20192 uniqueidentifier

select  @AssesmentIdentifierMale2019 = newid()
select  @AssesmentIdentifierMale20192 = newid()
-----------------------------------------------------------------------------------------------
--Assesment
insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentVersion)
values('ARC_ENIL', 'uri://ed-fi.org/Assessment/Assessment.xml', 'ARC ENIL Scores', 2019);

insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentVersion)
values('ARC_IRLA', 'uri://ed-fi.org/Assessment/Assessment.xml', 'ARC IRLA Scores',  2019);

-------------Assesment Score
INSERT INTO [edfi].[AssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[Namespace]
           ,[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_ENIL',@AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml',null,null,
		   @ResultDatatypeTypeDescriptorDecimal,GETDATE())

INSERT INTO [edfi].[AssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[Namespace]
           ,[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_IRLA',@AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml',null,null,
		   @ResultDatatypeTypeDescriptorDecimal,GETDATE())



-----------------------Objetive Assesment
INSERT INTO [edfi].[ObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[MaxRawScore]
           ,[PercentOfAssessment],[Nomenclature],[Description],[ParentIdentificationCode]
           ,[AcademicSubjectDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate]
           ,[Id],[ChangeVersion])
     VALUES
           ('ARC_ENIL','ARC Reading Level','uri://ed-fi.org/Assessment/Assessment.xml',null,
		    null,null,null,null,null,null,GETDATE(),GETDATE(),NEWID(),15000)
INSERT INTO [edfi].[ObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[MaxRawScore]
           ,[PercentOfAssessment],[Nomenclature],[Description],[ParentIdentificationCode]
           ,[AcademicSubjectDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate]
           ,[Id],[ChangeVersion])
     VALUES
           ('ARC_ENIL','ARC Days on Current Power Goal','uri://ed-fi.org/Assessment/Assessment.xml',null,
		    null,null,null,null,null,null,GETDATE(),GETDATE(),NEWID(),15000)
INSERT INTO [edfi].[ObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[MaxRawScore]
           ,[PercentOfAssessment],[Nomenclature],[Description],[ParentIdentificationCode]
           ,[AcademicSubjectDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate]
           ,[Id],[ChangeVersion])
     VALUES
           ('ARC_ENIL','ARC Reading Level (Baseline)','uri://ed-fi.org/Assessment/Assessment.xml',null,
		    null,null,null,null,null,null,GETDATE(),GETDATE(),NEWID(),15000)
INSERT INTO [edfi].[ObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[MaxRawScore]
           ,[PercentOfAssessment],[Nomenclature],[Description],[ParentIdentificationCode]
           ,[AcademicSubjectDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate]
           ,[Id],[ChangeVersion])
     VALUES
           ('ARC_ENIL','ARC Score','uri://ed-fi.org/Assessment/Assessment.xml',null,
		    null,null,null,null,null,null,GETDATE(),GETDATE(),NEWID(),15000)
INSERT INTO [edfi].[ObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[MaxRawScore]
           ,[PercentOfAssessment],[Nomenclature],[Description],[ParentIdentificationCode]
           ,[AcademicSubjectDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate]
           ,[Id],[ChangeVersion])
     VALUES
           ('ARC_ENIL','ARC Baseline Reporting Date','uri://ed-fi.org/Assessment/Assessment.xml',null,
		    null,null,null,null,null,null,GETDATE(),GETDATE(),NEWID(),15000)

			--*************************************
INSERT INTO [edfi].[ObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[MaxRawScore]
           ,[PercentOfAssessment],[Nomenclature],[Description],[ParentIdentificationCode]
           ,[AcademicSubjectDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate]
           ,[Id],[ChangeVersion])
     VALUES
           ('ARC_IRLA','ARC Reading Level','uri://ed-fi.org/Assessment/Assessment.xml',null,
		    null,null,null,null,null,null,GETDATE(),GETDATE(),NEWID(),15000)
INSERT INTO [edfi].[ObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[MaxRawScore]
           ,[PercentOfAssessment],[Nomenclature],[Description],[ParentIdentificationCode]
           ,[AcademicSubjectDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate]
           ,[Id],[ChangeVersion])
     VALUES
           ('ARC_IRLA','ARC Days on Current Power Goal','uri://ed-fi.org/Assessment/Assessment.xml',null,
		    null,null,null,null,null,null,GETDATE(),GETDATE(),NEWID(),15000)
INSERT INTO [edfi].[ObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[MaxRawScore]
           ,[PercentOfAssessment],[Nomenclature],[Description],[ParentIdentificationCode]
           ,[AcademicSubjectDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate]
           ,[Id],[ChangeVersion])
     VALUES
           ('ARC_IRLA','ARC Reading Level (Baseline)','uri://ed-fi.org/Assessment/Assessment.xml',null,
		    null,null,null,null,null,null,GETDATE(),GETDATE(),NEWID(),15000)
INSERT INTO [edfi].[ObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[MaxRawScore]
           ,[PercentOfAssessment],[Nomenclature],[Description],[ParentIdentificationCode]
           ,[AcademicSubjectDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate]
           ,[Id],[ChangeVersion])
     VALUES
           ('ARC_IRLA','ARC Score','uri://ed-fi.org/Assessment/Assessment.xml',null,
		    null,null,null,null,null,null,GETDATE(),GETDATE(),NEWID(),15000)
INSERT INTO [edfi].[ObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[MaxRawScore]
           ,[PercentOfAssessment],[Nomenclature],[Description],[ParentIdentificationCode]
           ,[AcademicSubjectDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate]
           ,[Id],[ChangeVersion])
     VALUES
           ('ARC_IRLA','ARC Baseline Reporting Date','uri://ed-fi.org/Assessment/Assessment.xml',null,
		    null,null,null,null,null,null,GETDATE(),GETDATE(),NEWID(),15000)

-----------------------Objetive AssesmentScore
INSERT INTO [edfi].[ObjectiveAssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode]
           ,[Namespace],[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_ENIL',@AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level',
		   'uri://ed-fi.org/Assessment/Assessment.xml',null,null,@ResultDatatypeTypeDescriptorLevel,GETDATE())

INSERT INTO [edfi].[ObjectiveAssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode]
           ,[Namespace],[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_ENIL',@AssessmentReportingMethodDescriptorRawScore,'ARC Days on Current Power Goal',
		   'uri://ed-fi.org/Assessment/Assessment.xml',null,null,@ResultDatatypeTypeDescriptorInteger,GETDATE())

INSERT INTO [edfi].[ObjectiveAssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode]
           ,[Namespace],[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_ENIL',@AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level (Baseline)',
		   'uri://ed-fi.org/Assessment/Assessment.xml',null,null,@ResultDatatypeTypeDescriptorLevel,GETDATE())

INSERT INTO [edfi].[ObjectiveAssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode]
           ,[Namespace],[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_ENIL',@AssessmentReportingMethodDescriptorRawScore,'ARC Score',
		   'uri://ed-fi.org/Assessment/Assessment.xml',null,null,@ResultDatatypeTypeDescriptorDecimal,GETDATE())

INSERT INTO [edfi].[ObjectiveAssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode]
           ,[Namespace],[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_ENIL',@AssessmentReportingMethodDescriptorRawScore,'ARC Baseline Reporting Date',
		   'uri://ed-fi.org/Assessment/Assessment.xml',null,null,@ResultDatatypeTypeDescriptorDecimal,GETDATE())

--*************************************************************
INSERT INTO [edfi].[ObjectiveAssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode]
           ,[Namespace],[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_IRLA',@AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level',
		   'uri://ed-fi.org/Assessment/Assessment.xml',null,null,@ResultDatatypeTypeDescriptorLevel,GETDATE())

INSERT INTO [edfi].[ObjectiveAssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode]
           ,[Namespace],[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_IRLA',@AssessmentReportingMethodDescriptorRawScore,'ARC Days on Current Power Goal',
		   'uri://ed-fi.org/Assessment/Assessment.xml',null,null,@ResultDatatypeTypeDescriptorInteger,GETDATE())

INSERT INTO [edfi].[ObjectiveAssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode]
           ,[Namespace],[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_IRLA',@AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level (Baseline)',
		   'uri://ed-fi.org/Assessment/Assessment.xml',null,null,@ResultDatatypeTypeDescriptorLevel,GETDATE())

INSERT INTO [edfi].[ObjectiveAssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode]
           ,[Namespace],[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_IRLA',@AssessmentReportingMethodDescriptorRawScore,'ARC Score',
		   'uri://ed-fi.org/Assessment/Assessment.xml',null,null,@ResultDatatypeTypeDescriptorDecimal,GETDATE())

INSERT INTO [edfi].[ObjectiveAssessmentScore]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode]
           ,[Namespace],[MinimumScore],[MaximumScore],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_IRLA',@AssessmentReportingMethodDescriptorRawScore,'ARC Baseline Reporting Date',
		   'uri://ed-fi.org/Assessment/Assessment.xml',null,null,@ResultDatatypeTypeDescriptorDecimal,GETDATE())

----------------------------------------------------------------------------------------------------------------

--Student assesment
INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[AdministrationDate],[AdministrationEndDate]
		   ,[SerialNumber],[AdministrationLanguageDescriptorId],[AdministrationEnvironmentDescriptorId],[RetestIndicatorDescriptorId]
           ,[ReasonNotTestedDescriptorId],[WhenAssessedGradeLevelDescriptorId],[EventCircumstanceDescriptorId],[EventDescription]
           ,[SchoolYear],[PlatformTypeDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           ('ARC_ENIL','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2019,@studentFemaleUSI,'20170502',null
           ,null,null,null,null,null,null
           ,null,null,null,null,null,GETDATE(),GETDATE(),NEWID(),103939)

INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[AdministrationDate],[AdministrationEndDate]
		   ,[SerialNumber],[AdministrationLanguageDescriptorId],[AdministrationEnvironmentDescriptorId],[RetestIndicatorDescriptorId]
           ,[ReasonNotTestedDescriptorId],[WhenAssessedGradeLevelDescriptorId],[EventCircumstanceDescriptorId],[EventDescription]
           ,[SchoolYear],[PlatformTypeDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           ('ARC_IRLA','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale20192,@studentFemaleUSI,'20170502',null
           ,null,null,null,null,null,null
           ,null,null,null,null,null,GETDATE(),GETDATE(),NEWID(),103939)

INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[AdministrationDate],[AdministrationEndDate]
		   ,[SerialNumber],[AdministrationLanguageDescriptorId],[AdministrationEnvironmentDescriptorId],[RetestIndicatorDescriptorId]
           ,[ReasonNotTestedDescriptorId],[WhenAssessedGradeLevelDescriptorId],[EventCircumstanceDescriptorId],[EventDescription]
           ,[SchoolYear],[PlatformTypeDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           ('ARC_ENIL','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2019,@studentMaleUSI,'20170502',null
           ,null,null,null,null,null,null
           ,null,null,null,null,null,GETDATE(),GETDATE(),NEWID(),103939)

INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[AdministrationDate],[AdministrationEndDate]
		   ,[SerialNumber],[AdministrationLanguageDescriptorId],[AdministrationEnvironmentDescriptorId],[RetestIndicatorDescriptorId]
           ,[ReasonNotTestedDescriptorId],[WhenAssessedGradeLevelDescriptorId],[EventCircumstanceDescriptorId],[EventDescription]
           ,[SchoolYear],[PlatformTypeDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           ('ARC_IRLA','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale20192,@studentMaleUSI,'20170502',null
           ,null,null,null,null,null,null
           ,null,null,null,null,null,GETDATE(),GETDATE(),NEWID(),103939)

----------------------
INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[Namespace],[StudentAssessmentIdentifier]
           ,[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_ENIL',@AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml',
		   @AssesmentIdentifierFemale2019,@studentFemaleUSI,3.9,@ResultDatatypeTypeDescriptorDecimal,GETDATE())

INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[Namespace],[StudentAssessmentIdentifier]
           ,[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_IRLA',@AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml',
		   @AssesmentIdentifierFemale20192,@studentFemaleUSI,4.9,@ResultDatatypeTypeDescriptorDecimal,GETDATE())

--boy assesments
INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[Namespace],[StudentAssessmentIdentifier]
           ,[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_ENIL',@AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml',
		   @AssesmentIdentifierMale2019,@studentMaleUSI,3.9,@ResultDatatypeTypeDescriptorDecimal,GETDATE())

INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[Namespace],[StudentAssessmentIdentifier]
           ,[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_IRLA',@AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml',
		   @AssesmentIdentifierMale20192,@studentMaleUSI,5.9,@ResultDatatypeTypeDescriptorDecimal,GETDATE())


--student assesmnet objteinces
INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('ARC_ENIL','ARC Reading Level','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2019,@studentFemaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('ARC_ENIL','ARC Days on Current Power Goal','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2019,@studentFemaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('ARC_ENIL','ARC Reading Level (Baseline)','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2019,@studentFemaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('ARC_ENIL','ARC Score','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2019,@studentFemaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('ARC_ENIL','ARC Baseline Reporting Date','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2019,@studentFemaleUSI,GETDATE())

---------


-------------------boy assesment
INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('ARC_ENIL','ARC Reading Level','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2019,@studentMaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('ARC_ENIL','ARC Days on Current Power Goal','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2019,@studentMaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('ARC_ENIL','ARC Reading Level (Baseline)','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2019,@studentMaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('ARC_ENIL','ARC Score','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2019,@studentMaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('ARC_ENIL','ARC Baseline Reporting Date','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2019,@studentMaleUSI,GETDATE())

--*****************************************************************************************
INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('ARC_IRLA','ARC Reading Level','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale20192,@studentMaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('ARC_IRLA','ARC Days on Current Power Goal','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale20192,@studentMaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('ARC_IRLA','ARC Reading Level (Baseline)','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale20192,@studentMaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('ARC_IRLA','ARC Score','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale20192,@studentMaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('ARC_IRLA','ARC Baseline Reporting Date','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale20192,@studentMaleUSI,GETDATE())


-----------Boy assesments
INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('ARC_IRLA','ARC Reading Level','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale20192,@studentFemaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('ARC_IRLA','ARC Days on Current Power Goal','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale20192,@studentFemaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('ARC_IRLA','ARC Reading Level (Baseline)','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale20192,@studentFemaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('ARC_IRLA','ARC Score','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale20192,@studentFemaleUSI,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessment]
           ([AssessmentIdentifier],[IdentificationCode],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[CreateDate])
     VALUES
           ('ARC_IRLA','ARC Baseline Reporting Date','uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale20192,@studentFemaleUSI,GETDATE())




--student objetives scores

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_ENIL',@AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level',
		   'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2019,@studentFemaleUSI,'PI',
		   @ResultDatatypeTypeDescriptorLevel,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_ENIL',@AssessmentReportingMethodDescriptorRawScore,'ARC Days on Current Power Goal',
		   'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2019,@studentFemaleUSI,10,
		   @ResultDatatypeTypeDescriptorInteger,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_ENIL',@AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level (Baseline)',
		   'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2019,@studentFemaleUSI,'PI',
		   @ResultDatatypeTypeDescriptorLevel,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_ENIL',@AssessmentReportingMethodDescriptorRawScore,'ARC Score',
		   'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2019,@studentFemaleUSI,10,
		   @ResultDatatypeTypeDescriptorDecimal,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_ENIL',@AssessmentReportingMethodDescriptorRawScore,'ARC Baseline Reporting Date',
		   'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale2019,@studentFemaleUSI,'9/17/2019',
		   @ResultDatatypeTypeDescriptorLevel,GETDATE())
--*************************************************************************
INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_IRLA',@AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level',
		   'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale20192,@studentFemaleUSI,'Si',
		   @ResultDatatypeTypeDescriptorLevel,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_IRLA',@AssessmentReportingMethodDescriptorRawScore,'ARC Days on Current Power Goal',
		   'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale20192,@studentFemaleUSI,22,
		   @ResultDatatypeTypeDescriptorInteger,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_IRLA',@AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level (Baseline)',
		   'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale20192,@studentFemaleUSI,'Si',
		   @ResultDatatypeTypeDescriptorLevel,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_IRLA',@AssessmentReportingMethodDescriptorRawScore,'ARC Score',
		   'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale20192,@studentFemaleUSI,5.42,
		   @ResultDatatypeTypeDescriptorDecimal,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_IRLA',@AssessmentReportingMethodDescriptorRawScore,'ARC Baseline Reporting Date',
		   'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierFemale20192,@studentFemaleUSI,'9/17/2019',
		   @ResultDatatypeTypeDescriptorLevel,GETDATE())


--------------------------------------------------------------------------------------------------------------------
INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_ENIL',@AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level',
		   'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2019,@studentMaleUSI,'Pu',
		   @ResultDatatypeTypeDescriptorLevel,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_ENIL',@AssessmentReportingMethodDescriptorRawScore,'ARC Days on Current Power Goal',
		   'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2019,@studentMaleUSI,80,
		   @ResultDatatypeTypeDescriptorInteger,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_ENIL',@AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level (Baseline)',
		   'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2019,@studentMaleUSI,'Pu',
		   @ResultDatatypeTypeDescriptorLevel,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_ENIL',@AssessmentReportingMethodDescriptorRawScore,'ARC Score',
		   'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2019,@studentMaleUSI,10,
		   @ResultDatatypeTypeDescriptorDecimal,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_ENIL',@AssessmentReportingMethodDescriptorRawScore,'ARC Baseline Reporting Date',
		   'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale2019,@studentMaleUSI,'9/17/2019',
		   @ResultDatatypeTypeDescriptorLevel,GETDATE())
--*************************************************************************
INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_IRLA',@AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level',
		   'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale20192,@studentMaleUSI,'Pu',
		   @ResultDatatypeTypeDescriptorLevel,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_IRLA',@AssessmentReportingMethodDescriptorRawScore,'ARC Days on Current Power Goal',
		   'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale20192,@studentMaleUSI,22,
		   @ResultDatatypeTypeDescriptorInteger,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_IRLA',@AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level (Baseline)',
		   'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale20192,@studentMaleUSI,'Pu',
		   @ResultDatatypeTypeDescriptorLevel,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_IRLA',@AssessmentReportingMethodDescriptorRawScore,'ARC Score',
		   'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale20192,@studentMaleUSI,5.42,
		   @ResultDatatypeTypeDescriptorDecimal,GETDATE())

INSERT INTO [edfi].[StudentAssessmentStudentObjectiveAssessmentScoreResult]
           ([AssessmentIdentifier],[AssessmentReportingMethodDescriptorId],[IdentificationCode],[Namespace]
           ,[StudentAssessmentIdentifier],[StudentUSI],[Result],[ResultDatatypeTypeDescriptorId],[CreateDate])
     VALUES
           ('ARC_IRLA',@AssessmentReportingMethodDescriptorRawScore,'ARC Baseline Reporting Date',
		   'uri://ed-fi.org/Assessment/Assessment.xml',@AssesmentIdentifierMale20192,@studentMaleUSI,'9/17/2019',
		   @ResultDatatypeTypeDescriptorLevel,GETDATE())



go

declare @femaleSexDescriptorId int;
declare @maleSexDescriptorId int;

declare @staffUSIPrincipalGrandBenHighSchool int;
declare @electronictWorkMailDescriptor int

declare @fatherRelationDescriptor int;
declare @motherRelationDescriptor int;

--Roles's users ans USIs
declare @studentMaleUSI AS int
declare @studentFemaleUSI AS int

select  @studentMaleUSI = StudentUSI from edfi.Student where FirstName = 'Marshall' and LastSurname = 'Terrell'
select  @studentFemaleUSI = StudentUSI from edfi.Student where FirstName = 'Hannah' and LastSurname = 'Terrell'


declare @highSchoolId as int = 255901001
declare @middleSchoolId as int =255901044

declare @calendarType int;
declare @nonintructionalday int;

--select * FROM EDFI.Descriptor WHERE Namespace = 'uri://ed-fi.org/CalendarTypeDescriptor' and CodeValue = 'School' 
select @calendarType = DescriptorId FROM EDFI.Descriptor WHERE Namespace = 'uri://ed-fi.org/CalendarTypeDescriptor' and CodeValue = 'School' 
select @nonintructionalday =  DescriptorId FROM EDFI.Descriptor WHERE Namespace = 'uri://ed-fi.org/CalendarEventDescriptor' and CodeValue = 'Other' 

--Calendar for each school
INSERT INTO EDFI.Calendar VALUES(@highSchoolId,@highSchoolId,2011,@calendarType,null,GETDATE(),GETDATE(),NEWID(),11815)
INSERT INTO EDFI.Calendar VALUES(@middleSchoolId,@middleSchoolId,2011,@calendarType,null,GETDATE(),GETDATE(),NEWID(),11815)
--Dates for each school
INSERT INTO EDFI.CalendarDate VALUES(@highSchoolId,'20111124',@highSchoolId,2011,null,GETDATE(),GETDATE(),NEWID(),11815)
INSERT INTO EDFI.CalendarDate VALUES(@highSchoolId,'20111125',@highSchoolId,2011,null,GETDATE(),GETDATE(),NEWID(),11815)
INSERT INTO EDFI.CalendarDate VALUES(@highSchoolId,'20110425',@highSchoolId,2011,null,GETDATE(),GETDATE(),NEWID(),11815)
INSERT INTO EDFI.CalendarDate VALUES(@highSchoolId,'20110426',@highSchoolId,2011,null,GETDATE(),GETDATE(),NEWID(),11815)
INSERT INTO EDFI.CalendarDate VALUES(@highSchoolId,'20110427',@highSchoolId,2011,null,GETDATE(),GETDATE(),NEWID(),11815)
INSERT INTO EDFI.CalendarDate VALUES(@highSchoolId,'20110428',@highSchoolId,2011,null,GETDATE(),GETDATE(),NEWID(),11815)
INSERT INTO EDFI.CalendarDate VALUES(@highSchoolId,'20110429',@highSchoolId,2011,null,GETDATE(),GETDATE(),NEWID(),11815)

INSERT INTO EDFI.CalendarDate VALUES(@middleSchoolId,'20111124',@middleSchoolId,2011,null,GETDATE(),GETDATE(),NEWID(),11815)
INSERT INTO EDFI.CalendarDate VALUES(@middleSchoolId,'20111125',@middleSchoolId,2011,null,GETDATE(),GETDATE(),NEWID(),11815)
INSERT INTO EDFI.CalendarDate VALUES(@middleSchoolId,'20110425',@middleSchoolId,2011,null,GETDATE(),GETDATE(),NEWID(),11815)
INSERT INTO EDFI.CalendarDate VALUES(@middleSchoolId,'20110426',@middleSchoolId,2011,null,GETDATE(),GETDATE(),NEWID(),11815)
INSERT INTO EDFI.CalendarDate VALUES(@middleSchoolId,'20110427',@middleSchoolId,2011,null,GETDATE(),GETDATE(),NEWID(),11815)
INSERT INTO EDFI.CalendarDate VALUES(@middleSchoolId,'20110428',@middleSchoolId,2011,null,GETDATE(),GETDATE(),NEWID(),11815)
INSERT INTO EDFI.CalendarDate VALUES(@middleSchoolId,'20110429',@middleSchoolId,2011,null,GETDATE(),GETDATE(),NEWID(),11815)
--NonInstructionalDays for each school
INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(@highSchoolId,@nonintructionalday,'20111124',@highSchoolId,2011,GETDATE())
INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(@highSchoolId,@nonintructionalday,'20111125',@highSchoolId,2011,GETDATE())
INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(@highSchoolId,@nonintructionalday,'20110425',@highSchoolId,2011,GETDATE())
INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(@highSchoolId,@nonintructionalday,'20110426',@highSchoolId,2011,GETDATE())
INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(@highSchoolId,@nonintructionalday,'20110427',@highSchoolId,2011,GETDATE())
INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(@highSchoolId,@nonintructionalday,'20110428',@highSchoolId,2011,GETDATE())
INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(@highSchoolId,@nonintructionalday,'20110429',@highSchoolId,2011,GETDATE())

INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(@middleSchoolId,@nonintructionalday,'20111124',@middleSchoolId,2011,GETDATE())
INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(@middleSchoolId,@nonintructionalday,'20111125',@middleSchoolId,2011,GETDATE())
INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(@middleSchoolId,@nonintructionalday,'20110425',@middleSchoolId,2011,GETDATE())
INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(@middleSchoolId,@nonintructionalday,'20110426',@middleSchoolId,2011,GETDATE())
INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(@middleSchoolId,@nonintructionalday,'20110427',@middleSchoolId,2011,GETDATE())
INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(@middleSchoolId,@nonintructionalday,'20110428',@middleSchoolId,2011,GETDATE())
INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(@middleSchoolId,@nonintructionalday,'20110429',@middleSchoolId,2011,GETDATE())








GO



declare @highSchoolId as int = 255901001
declare @middleSchoolId as int =255901044

--STAR READING ASSESMENT 360
--select * from [edfi].[Assessment] where AssessmentIdentifier = 'STAR_Reading_2019'

INSERT INTO [edfi].[Assessment]
           ([AssessmentIdentifier],[Namespace],[AssessmentTitle],[AssessmentCategoryDescriptorId],[AssessmentForm],[AssessmentVersion],[RevisionDate],
		    [MaxRawScore],[Nomenclature],[AssessmentFamily],[EducationOrganizationId],[AdaptiveAssessment],[Discriminator],[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           (N'STAR_Reading_2019',N'http://ed-fi.org/Assessment/Assessment.xml',N'STAR Reading',NULL,NULL,2011
           ,NULL,NULL,NULL,NULL,@highSchoolId,NULL,NULL,GETDATE(),GETDATE(),NEWID(),19000)



--select * from edfi.ObjectiveAssessment where AssessmentIdentifier = 'STAR_Reading_2019'

INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Foundational Skills', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Foundational Skills', NULL, N'2020-01-16 12:07:54', N'2020-01-16 12:07:54', N'df59bc0c-ac52-4e23-9bb7-d273bf6666c8')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Informational Text', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Informational Text', NULL, N'2020-01-16 12:07:54', N'2020-01-16 12:07:54', N'a54be617-cc0f-4d17-b2ce-cff1163b7082')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Language', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Language', NULL, N'2020-01-16 12:07:54', N'2020-01-16 12:07:54', N'cdc0c889-f0e7-40e8-9a46-dbfce63e5ec2')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Literature', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Literature', NULL, N'2020-01-16 12:07:54', N'2020-01-16 12:07:54', N'd33576f6-1f4a-4179-a1be-b9358e8e13eb')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Foundational Skills_Fluency', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Fluency', N'Foundational Skills', N'2020-01-16 12:07:54', N'2020-01-16 12:07:54', N'2d98263c-e382-45c4-8adf-fe1484ac736d')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Foundational Skills_Phonics and Word Recognition', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Phonics and Word Recognition', N'Foundational Skills', N'2020-01-16 12:07:54', N'2020-01-16 12:07:54', N'c036728c-2544-4fad-8470-2d33fce270b9')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Foundational Skills_Fluency_Purpose for Reading', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Purpose for Reading', N'Foundational Skills_Fluency', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'e03071ff-cdf8-4c0e-9a69-e25015aa687e')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Foun_Phon_IrregularSpellings/High-FrequencyandExceptionWords', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Irregular Spellings / High-Frequency and Exception Words', N'Foundational Skills_Phonics and Word Recognition', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'29b703c6-af91-4192-9ba3-cb3a92e5b83b')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Foun_Phon_StructuralAnalysis', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Structural Analysis', N'Foundational Skills_Phonics and Word Recognition', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'b8e790d8-6cd6-49a2-ac83-cd5e5132feb4')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Info_RangeofReadingandLevelofTextComplexity_', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Range of Reading and Level of Text Complexity', N'Informational Text', N'2020-01-16 12:07:54', N'2020-01-16 12:07:54', N'110160fa-a05f-4cf2-9c72-3bfac5e96549')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Informational Text_Craft and Structure', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Craft and Structure', N'Informational Text', N'2020-01-16 12:07:54', N'2020-01-16 12:07:54', N'0cd6d739-23df-4a54-a794-6d3ddbd68a40')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Informational Text_Integration of Knowledge and Ideas', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Integration of Knowledge and Ideas', N'Informational Text', N'2020-01-16 12:07:54', N'2020-01-16 12:07:54', N'4a62a5d0-4e12-425f-8669-de1dcd29a4e8')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Key Ideas and Details', N'Informational Text', N'2020-01-16 12:07:54', N'2020-01-16 12:07:54', N'1f6791a4-0a66-47ff-9544-510a6d3ae279')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Informational Text_Craft and Structure_Argumentation', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Argumentation', N'Informational Text_Craft and Structure', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'1dba57bb-0f73-4b5e-a3e3-5dea92f9702f')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Informational Text_Craft and Structure_Text Features', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Text Features', N'Informational Text_Craft and Structure', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'cf413737-7e93-4441-8c93-863ce0cef2db')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Info_Craf_Author''sPurposeandPerspective', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Author''s Purpose and Perspective', N'Informational Text_Craft and Structure', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'5414185d-b974-4cf5-93c7-a8f6eb09f56a')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Info_Craf_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Author''s Word Choice and Figurative Language', N'Informational Text_Craft and Structure', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'22cb86b8-92ab-4785-a75f-afe5b484035d')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Info_Craf_StructureandOrganization', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Structure and Organization', N'Informational Text_Craft and Structure', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'3ebbed80-4df7-4a17-9cb9-6111593c130c')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Info_Inte_AnalysisandComparison', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Analysis and Comparison', N'Informational Text_Integration of Knowledge and Ideas', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'4e3a381c-c6e8-4e5b-9008-67e8f366f6df')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Info_Inte_Argumentation', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Argumentation', N'Informational Text_Integration of Knowledge and Ideas', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'4c4bf4fa-13e2-4d72-bf8f-4abf4bffac4f')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Info_Inte_Author''sPurposeandPerspective', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Author''s Purpose and Perspective', N'Informational Text_Integration of Knowledge and Ideas', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'a3ff84bf-59a9-405c-ab6c-ccbe76f1a047')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Info_Inte_ModesofRepresentation', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Modes of Representation', N'Informational Text_Integration of Knowledge and Ideas', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'e90fe3f4-7cd0-439f-9591-38dca770411f')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Info_Key _CompareandContrast', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Compare and Contrast', N'Informational Text_Key Ideas and Details', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'f5ef78f8-e052-461d-ad88-94a7fa92eef0')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Info_Key _InferenceandEvidence', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Inference and Evidence', N'Informational Text_Key Ideas and Details', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'b3e74f99-6dae-4f1a-ab4d-2b978684c172')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Info_Key _MainIdeaandDetails', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Main Idea and Details', N'Informational Text_Key Ideas and Details', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'76acb935-2fa1-429d-ab2c-d40a1600bc41')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Cause and Effect', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Cause and Effect', N'Informational Text_Key Ideas and Details', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'0a680e31-17ac-40e8-a610-c984cec23a04')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Prediction', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Prediction', N'Informational Text_Key Ideas and Details', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'df7d7ef9-7872-4a2d-932e-3114896af2c2')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Sequence', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Sequence', N'Informational Text_Key Ideas and Details', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'76069df1-0bc8-41ea-8eec-bdfa937853d4')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Summary', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Summary', N'Informational Text_Key Ideas and Details', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'5461b71a-a519-4f18-ac40-7e4b8292e3df')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Vocabulary Acquisition and Use', N'Language', N'2020-01-16 12:07:54', N'2020-01-16 12:07:54', N'03a3d44b-67b4-457c-b474-80b6fd703c33')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Connotation', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Connotation', N'Language_Vocabulary Acquisition and Use', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'57fb8410-f369-4f2f-8b7d-93aeb3a2e3c1')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Context Clues', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Context Clues', N'Language_Vocabulary Acquisition and Use', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'070629ff-a2f3-4f1a-a224-170b5a8d7e1a')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Figures of Speech', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Figures of Speech', N'Language_Vocabulary Acquisition and Use', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'5f6ad665-7093-416c-8dfa-c2372c5edc02')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Structural Analysis', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Structural Analysis', N'Language_Vocabulary Acquisition and Use', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'9dff77c8-0052-48fe-872e-5151551ef179')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Word Relationships', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Word Relationships', N'Language_Vocabulary Acquisition and Use', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'0999ac6a-4fca-4415-86f6-f22f6b32ea4a')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Lang_Voca_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Author''s Word Choice and Figurative Language', N'Language_Vocabulary Acquisition and Use', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'2dc87890-910d-4a13-955b-5af899b87a89')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Lang_Voca_Multiple-MeaningWords', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Multiple-Meaning Words', N'Language_Vocabulary Acquisition and Use', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'e1afb6b4-df12-47de-a46a-e989d4173599')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Lang_Voca_SynonymsandAntonyms', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Synonyms and Antonyms', N'Language_Vocabulary Acquisition and Use', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'd6e1f738-65ea-4a3c-ad51-b834a9f43957')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Lang_Voca_VocabularyinContext', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Vocabulary in Context', N'Language_Vocabulary Acquisition and Use', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'c6458353-964f-4e20-8b4e-1bc107261c53')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Lang_Voca_WordMeaningandReferenceMaterials', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Word Meaning and Reference Materials', N'Language_Vocabulary Acquisition and Use', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'fee11dd7-5095-4742-bb54-408aaa33be73')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Literature_Range of Reading and Level of Text Complexity', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Range of Reading and Level of Text Complexity', N'Literature', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'79487461-7e03-4b13-ba24-f8ae36d25a45')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Literature_Craft and Structure', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Craft and Structure', N'Literature', N'2020-01-16 12:07:54', N'2020-01-16 12:07:54', N'1de79531-9658-4f89-a08f-dd7c2f8b2ae1')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Literature_Integration of Knowledge and Ideas', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Integration of Knowledge and Ideas', N'Literature', N'2020-01-16 12:07:54', N'2020-01-16 12:07:54', N'7b81e6fb-2061-4ebb-a17d-bccaabdb9d96')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Key Ideas and Details', N'Literature', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'6a16202f-b0ae-432b-8d08-d473b2022552')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Literature_Craft and Structure_Character and Plot', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Character and Plot', N'Literature_Craft and Structure', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'c225ee84-516d-4a02-9551-9b65ef6d5850')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Literature_Craft and Structure_Connotation', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Connotation', N'Literature_Craft and Structure', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'6196fac3-cb36-4283-a48c-c685cb1115a3')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Literature_Craft and Structure_Point of View', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Point of View', N'Literature_Craft and Structure', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'f571d1bc-5c9e-4204-a24f-2b1e5b962fe8')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Literature_Craft and Structure_Structure and Organization', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Structure and Organization', N'Literature_Craft and Structure', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'3e5ab131-057c-4415-8a03-2bc7c2ab2cbe')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Lite_Craf_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Author''s Word Choice and Figurative Language', N'Literature_Craft and Structure', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'5b1d2850-14e0-4581-96d7-3925a0d206b6')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Lite_Craf_ConventionsandRangeofReading', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Conventions and Range of Reading', N'Literature_Craft and Structure', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'27b190e3-b17e-4318-9c7a-e0926894cbf3')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Lite_Inte_AnalysisandComparison', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Analysis and Comparison', N'Literature_Integration of Knowledge and Ideas', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'52cce551-9309-421a-80f6-b7dc0978f91d')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Character and Plot', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Character and Plot', N'Literature_Key Ideas and Details', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'7f6874bf-af49-4da6-8641-b3ef14f6fd26')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Inference and Evidence', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Inference and Evidence', N'Literature_Key Ideas and Details', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'628cfc0d-25fc-459c-9aad-fa4cbbef789f')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Setting', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Setting', N'Literature_Key Ideas and Details', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'0ba2b0fe-8b1e-4e31-a8bd-6a16cf8f76da')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Summary', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Summary', N'Literature_Key Ideas and Details', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'834bd035-b925-41bc-926c-7f3a358508f9')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Theme', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Theme', N'Literature_Key Ideas and Details', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'72ffba9a-2fef-4388-86b6-0c1fa0cf0017')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Reading_2019', N'Lite_Rang_ConventionsandRangeofReading', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Conventions and Range of Reading', N'Literature_Range of Reading and Level of Text Complexity', N'2020-01-16 12:07:55', N'2020-01-16 12:07:55', N'e126d961-2dec-459d-b55a-e5a69c5b8f72')


INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[AdministrationDate],[AdministrationEndDate],[SerialNumber],[AdministrationLanguageDescriptorId]
           ,[AdministrationEnvironmentDescriptorId],[RetestIndicatorDescriptorId],[ReasonNotTestedDescriptorId],[WhenAssessedGradeLevelDescriptorId],[EventCircumstanceDescriptorId]
           ,[EventDescription],[SchoolYear],[PlatformTypeDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           (N'STAR_Reading_2019',N'http://ed-fi.org/Assessment/Assessment.xml',561854,435,'20190912',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2011,NULL,NULL,GETDATE(),GETDATE(),NEWID(),19000)




INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Lite_Craf_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-16 16:22:45')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Literature_Craft and Structure_Point of View', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Informational Text_Integration of Knowledge and Ideas', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-16 16:22:45')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Info_RangeofReadingandLevelofTextComplexity_', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-16 16:22:45')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Context Clues', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Info_Key _CompareandContrast', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Summary', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Prediction', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Lang_Voca_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Lang_Voca_Multiple-MeaningWords', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Info_Inte_Argumentation', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Structural Analysis', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Lang_Voca_SynonymsandAntonyms', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Theme', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Character and Plot', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Literature_Craft and Structure', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Setting', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Sequence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Cause and Effect', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Info_Craf_Author''sPurposeandPerspective', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Summary', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Info_Key _MainIdeaandDetails', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Figures of Speech', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Lang_Voca_VocabularyinContext', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Lite_Craf_ConventionsandRangeofReading', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Literature_Range of Reading and Level of Text Complexity', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Lite_Rang_ConventionsandRangeofReading', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Info_Key _InferenceandEvidence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Informational Text_Craft and Structure', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-16 16:22:45')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Inference and Evidence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Info_Craf_StructureandOrganization', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'2020-01-20 01:47:14')


INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Lang_Voca_VocabularyinContext', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'53', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details_Summary', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'36', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Key Ideas and Details_Summary', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'31', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Info_Inte_Argumentation', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'35', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Language_Vocabulary Acquisition and Use_Context Clues', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'61', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Info_Key _CompareandContrast', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'45', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details_Theme', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'49', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Language_Vocabulary Acquisition and Use_Figures of Speech', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'66', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Craft and Structure', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'39', 2013, N'2020-01-16 16:22:45')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Lang_Voca_SynonymsandAntonyms', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'60', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Key Ideas and Details', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'48', 2013, N'2020-01-16 16:22:45')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Info_Craf_StructureandOrganization', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'48', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details_Setting', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'57', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Language_Vocabulary Acquisition and Use', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'55', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details_Inference and Evidence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'49', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Key Ideas and Details_Sequence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'54', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Literature_Craft and Structure_Point of View', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'38', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Lite_Craf_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'54', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Info_RangeofReadingandLevelofTextComplexity_', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'60', 2013, N'2020-01-16 16:22:45')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'52', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Lang_Voca_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'54', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Literature_Range of Reading and Level of Text Complexity', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'49', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Lite_Craf_ConventionsandRangeofReading', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'49', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Key Ideas and Details_Cause and Effect', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'54', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Info_Craf_Author''sPurposeandPerspective', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'38', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Language_Vocabulary Acquisition and Use_Structural Analysis', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'66', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Info_Key _MainIdeaandDetails', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'47', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Info_Key _InferenceandEvidence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'49', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Lang_Voca_Multiple-MeaningWords', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'48', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Lite_Rang_ConventionsandRangeofReading', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'49', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Key Ideas and Details_Prediction', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'52', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Literature_Craft and Structure', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'48', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Integration of Knowledge and Ideas', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'35', 2013, N'2020-01-16 16:22:45')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details_Character and Plot', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'56', 2013, N'2020-01-20 01:47:14')

---------------------------------------------------------------------------------
-- MATH


--declare @highSchoolId as int = 255901001
--declare @middleSchoolId as int =255901044

INSERT INTO [edfi].[Assessment]
           ([AssessmentIdentifier],[Namespace],[AssessmentTitle],[AssessmentCategoryDescriptorId],[AssessmentForm],[AssessmentVersion],[RevisionDate],
		    [MaxRawScore],[Nomenclature],[AssessmentFamily],[EducationOrganizationId],[AdaptiveAssessment],[Discriminator],[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           (N'STAR_Math_2019',N'http://ed-fi.org/Assessment/Assessment.xml',N'STAR Math',NULL,NULL,2011
           ,NULL,NULL,NULL,NULL,@highSchoolId,NULL,NULL,GETDATE(),GETDATE(),NEWID(),19000)


INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Algebra', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Algebra', NULL, N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'ae04b0c1-7c20-4eb4-ae24-bf6111c1cf80')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Functions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Functions', NULL, N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'b8497af3-c029-48b3-9f68-65a7080792df')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Geometry', NULL, N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'85f4fdec-3fac-4c60-ae67-ecaaec2fcd15')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Measurement and Data', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Measurement and Data', NULL, N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'5af50df8-5807-4ae9-928f-f4e9d65c0a50')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numbers and Operations', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Numbers and Operations', NULL, N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'a751a716-2b9f-41f5-9131-f149574eeb05')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Number and Quantity', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Number and Quantity', NULL, N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'ac421676-dccd-43c7-9a61-c63a80fce3ca')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Statistics and Probability', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Statistics and Probability', NULL, N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'c2b90b8c-3e1f-4d81-aee5-6f8755d5d8f5')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Algebra_Arithmetic with Polynomials and Rational Expressions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Arithmetic with Polynomials and Rational Expressions', N'Algebra', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'180d42f8-3e80-4cc0-9f43-ad00a9f1b61c')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Algebra_Creating Equations', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Creating Equations', N'Algebra', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'2cbc2ef0-93e9-4df0-8ea9-0ba6b8d7ec88')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Algebra_Expressions and Equations', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Expressions and Equations', N'Algebra', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'966751d3-1c57-458f-b852-7bf4dc11aff3')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Algebra_Operations and Algebraic Thinking', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Operations and Algebraic Thinking', N'Algebra', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'e4892fbc-37f7-45fe-b44e-0e552077c2ef')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Algebra_Reasoning with Equations and Inequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Reasoning with Equations and Inequalities', N'Algebra', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'262d2272-5b15-4bc9-931c-49b0cd47717b')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Algebra_Seeing Structure in Expressions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Seeing Structure in Expressions', N'Algebra', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'83d07ee4-07d7-4dfb-a6d6-a607395c5d82')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Alge_Arit_NonlinearExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Non linear Expressions Equations and Inequalities', N'Algebra_Arithmetic with Polynomials and Rational Expressions', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'f6fc9e85-e20a-4517-b9d6-54e66bcbcf70')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Alge_Arit_PolynomialExpressionsandFunctions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Polynomial Expressions and Functions', N'Algebra_Arithmetic with Polynomials and Rational Expressions', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'bacac006-caf2-4192-9643-9005a66fa6b7')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Alge_Crea_LinearExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Linear Expressions Equations and Inequalities', N'Algebra_Creating Equations', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'9e78b52f-c2d3-4e45-946e-4a183e65b24d')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Alge_Crea_QuadraticExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Quadratic Expressions Equations and Inequalities', N'Algebra_Creating Equations', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'3ec7ea94-9fa8-452f-9f30-bada7cdaeefe')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Algebra_Creating Equations_Relations and Functions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Relations and Functions', N'Algebra_Creating Equations', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'cf674a21-f578-4290-856a-6cfdda880acf')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Algebra_Expressions and Equations_Algebraic Thinking', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Algebraic Thinking', N'Algebra_Expressions and Equations', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'926f4b30-9d8b-4230-aa07-23ff5e035e4a')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Algebra_Expressions and Equations_Powers Roots and Radicals', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Powers Roots and Radicals', N'Algebra_Expressions and Equations', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'6405c75b-7e29-4c6a-8a3d-004912a29350')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Alge_Expr_LinearExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Linear Expressions Equations and Inequalities', N'Algebra_Expressions and Equations', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'de93da84-2b40-4c4b-b0a7-3ead90ea75f3')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Alge_Expr_NumericalandVariableExpressions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Numerical and Variable Expressions', N'Algebra_Expressions and Equations', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'e821cfed-3ee7-45ae-bc07-48f4fc523d89')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Alge_Expr_PositiveandNegativeRationalNumbers', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Positive and Negative Rational Numbers', N'Algebra_Expressions and Equations', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'c0602fc0-fb95-4381-8b2c-60d37407b4a5')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Alge_Oper_NumericalandVariableExpressions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Numerical and Variable Expressions', N'Algebra_Operations and Algebraic Thinking', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'ebc34c91-38f0-443b-8896-9762ad85fe9e')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Alge_Oper_WholeNumbers:AdditionandSubtraction', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Whole Numbers:Addition and Subtraction', N'Algebra_Operations and Algebraic Thinking', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'ba353a7b-0602-4cf6-8c8c-0e34620b3563')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Alge_Oper_WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Whole Numbers:Multiplication and Division', N'Algebra_Operations and Algebraic Thinking', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'924562c5-c4a1-4c96-9e30-749cfe0d18f8')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Algebra_Operations and Algebraic Thinking_Algebraic Thinking', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Algebraic Thinking', N'Algebra_Operations and Algebraic Thinking', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'21566e8f-43b0-4021-8775-6ad8c617e98f')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Alge_Reas_LinearExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Linear Expressions Equations and Inequalities', N'Algebra_Reasoning with Equations and Inequalities', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'00cbf876-8250-4ca8-8344-0399d8b7763e')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Alge_Reas_NonlinearExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Non linear Expressions Equations and Inequalities', N'Algebra_Reasoning with Equations and Inequalities', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'81e03509-9b3e-4a08-b41b-efc3f6de0980')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Alge_Reas_QuadraticExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Quadratic Expressions Equations and Inequalities', N'Algebra_Reasoning with Equations and Inequalities', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'4c7a632f-3635-4304-b64c-2787a8cdb861')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Alge_Reas_SystemsofEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Systems of Equations and Inequalities', N'Algebra_Reasoning with Equations and Inequalities', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'684cbe42-1696-4073-bd3a-b2a7ac2763de')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Alge_Seei_PatternsSequencesandSeries', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Patterns Sequences and Series', N'Algebra_Seeing Structure in Expressions', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'51a5c28d-f600-42c2-9e0c-bc41155c7ed8')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Alge_Seei_QuadraticExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Quadratic Expressions Equations and Inequalities', N'Algebra_Seeing Structure in Expressions', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'35d2f001-3da4-4bf1-8e05-2960ae03dd13')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Functions_Building Functions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Building Functions', N'Functions', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'2857c8d9-1076-4433-83aa-daf0a28d029b')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Functions_Functions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Functions', N'Functions', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'34214e82-8c92-4cf1-b805-650e8e5ae871')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Functions_Interpreting Functions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Interpreting Functions', N'Functions', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'17f17531-1f61-41dd-b695-3c53c7f430f9')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Functions_Linear Quadratic and Exponential Models', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Linear Quadratic and Exponential Models', N'Functions', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'cdc46313-b51f-487b-9de8-eabdf63801ea')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Functions_Trigonometric Functions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Trigonometric Functions', N'Functions', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'09ff1865-c3c8-4878-bc1e-6b27abdfb36d')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Functions_Building Functions_Patterns Sequences and Series', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Building Functions_Patterns Sequences and Series', N'Functions_Building Functions', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'd1ace955-39d3-4ad0-a763-ea4b6a12d3fb')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Functions_Building Functions_Relations and Functions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Relations and Functions', N'Functions_Building Functions', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'48df19e6-cdf1-441b-9800-bc86f4385ac4')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Func_Buil_QuadraticExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Quadratic Expressions Equations and Inequalities', N'Functions_Building Functions', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'fc52c074-3328-4fef-bef8-cdc9c9c23dd9')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Functions_Functions_Relations and Functions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Relations and Functions', N'Functions_Functions', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'94c3aa49-17c8-4ccd-8e1c-e60046d2f2f9')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Functions_Interpreting Functions_Relations and Functions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Relations and Functions', N'Functions_Interpreting Functions', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'51881442-eee9-4dac-8186-81c5a035d9dc')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Func_Inte_LinearExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Linear Expressions Equations and Inequalities', N'Functions_Interpreting Functions', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'e1df7695-4fb7-4357-860c-d078a02892af')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Func_Inte_PolynomialExpressionsandFunctions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Polynomial Expressions and Functions', N'Functions_Interpreting Functions', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'b97ac041-66bf-4236-af1e-19e600f436f8')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Func_Inte_QuadraticExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Quadratic Expressions Equations and Inequalities', N'Functions_Interpreting Functions', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'58d5c5d0-fae1-4512-9477-55a94cc1dc3b')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Func_Inte_RightTrianglesandTrigonometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Right Triangles and Trigonometry', N'Functions_Interpreting Functions', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'6c4136ce-6a64-41c1-b783-0dc4fe4f4839')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Func_Line_RelationsandFunctions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Relations and Functions', N'Functions_Linear Quadratic and Exponential Models', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'984c3f3b-91b0-4734-a778-00b2540a75f4')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Func_Trig_RightTrianglesandTrigonometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Right Triangles and Trigonometry', N'Functions_Trigonometric Functions', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'ada06180-73e5-4db3-baa1-51ad2d6024c2')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geometry_Circles', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Circles', N'Geometry', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'cbfca7b3-a815-4fab-ac55-b9eab512698d')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geometry_Modeling with Geometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Modeling with Geometry', N'Geometry', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'00214a67-625f-4461-ba81-47dc74714b25')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geometry_Similarity Right Triangles and Trigonometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Similarity Right Triangles and Trigonometry', N'Geometry', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'645d5831-ca02-49e2-bb5c-9c233be4488e')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geometry_Expressing Geometric Properties with Equations', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Expressing Geometric Properties with Equations', N'Geometry', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'0f9efc4a-36b8-45ad-9eec-0efdd4c40ca3')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geometry_Geometric Measurement and Dimension', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Geometric Measurement and Dimension', N'Geometry', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'4ce05505-0a0b-47f6-bdd2-d50512822fca')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geometry_Geometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Geometry', N'Geometry', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'd034ccbc-6b3c-4bcc-af98-222e7af790da')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geometry_Congruence', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Congruence', N'Geometry', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'3d5bd0ad-9c20-42e3-baad-1c01c3fe46d2')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geometry_Circles_Perimeter Circumference and Area', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Perimeter Circumference and Area', N'Geometry_Circles', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'b9e001eb-287a-4e69-a362-386297299d70')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geometry_Congruence_Angles Segments and Lines', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Angles Segments and Lines', N'Geometry_Congruence', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'533c8fd0-e2fd-4253-bf67-6bb1cb4e2c16')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geometry_Congruence_Polygons', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Polygons', N'Geometry_Congruence', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'50ee13e8-72a4-46cd-b8d9-d023f8f9c501')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geom_Expr_Circles', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Circles', N'Geometry_Expressing Geometric Properties with Equations', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'72ff96b5-43d8-45a9-8fbd-fb02150623d6')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geom_Expr_CoordinateGeometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Coordinate Geometry', N'Geometry_Expressing Geometric Properties with Equations', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'0fa860c2-a55f-427a-8565-cfddf5e09831')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geom_Geom_SurfaceAreaandVolume', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Surface Area and Volume', N'Geometry_Geometric Measurement and Dimension', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'602ec8f4-d1a2-4e85-bb22-e39235bd833e')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geom_Geom_Geometry:Three-DimensionalShapesandAttributes', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Geometry:Three-Dimensional Shapes and Attributes', N'Geometry_Geometric Measurement and Dimension', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'29f07803-2870-4f9e-bc58-5c6e2b6fedc7')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geom_Geom_Geometry:Two-DimensionalShapesandAttributes', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Geometry:Two-Dimensional Shapes and Attributes', N'Geometry_Geometry', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'ab0941e8-0130-4bfa-a277-37a28de47b1b')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geometry_Geometry_Angles Segments and Lines', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Angles Segments and Lines', N'Geometry_Geometry', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'483b807d-d653-4eb8-8674-9337d1d076c0')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geometry_Geometry_Coordinate Geometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Coordinate Geometry', N'Geometry_Geometry', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'4c9bbf94-5f59-4b5e-84c8-5bcba19b3a69')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geometry_Geometry_Fraction Concepts and Operations', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Fraction Concepts and Operations', N'Geometry_Geometry', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'3014abf0-71f9-415e-a908-f16c9a3f1b56')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geometry_Geometry_Measurement', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Measurement', N'Geometry_Geometry', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'52ca0832-c534-4778-83cc-4446d451035c')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geometry_Geometry_Perimeter Circumference and Area', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Perimeter Circumference and Area', N'Geometry_Geometry', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'0694e742-d99a-43eb-8a32-5720d548ee57')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geometry_Geometry_Right Triangles and Trigonometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Right Triangles and Trigonometry', N'Geometry_Geometry', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'7e48dd16-69ef-459f-b65f-f41ed4781b6f')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geometry_Geometry_Surface Area and Volume', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Surface Area and Volume', N'Geometry_Geometry', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'3bd7bc7d-b65a-42cf-bccc-ffa3b6a16de6')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geometry_Geometry_Transformations', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Transformations', N'Geometry_Geometry', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'82008242-a548-431a-93f6-00cd24b23b80')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geom_Geom_Geometry:Three DimensionalShapesandAttributes', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Geometry:Three-Dimensional Shapes and Attributes', N'Geometry_Geometry', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'25c9cec6-a5ce-40c7-8490-ed8aa0fee63f')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geom_Mode_PerimeterCircumferenceandArea', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Perimeter Circumference and Area', N'Geometry_Modeling with Geometry', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'80e62d85-450d-4d50-8f66-d770bac8d0b8')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geom_Simi_CongruenceandSimilarity', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Congruence and Similarity', N'Geometry_Similarity Right Triangles and Trigonometry', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'14e27f7b-b8b0-465d-a931-0c86dc40940f')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Geom_Simi_RightTrianglesandTrigonometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Right Triangles and Trigonometry', N'Geometry_Similarity Right Triangles and Trigonometry', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'3ef4c500-2a58-46e1-a25a-d559873e1c81')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Measurement and Data_Measurement and Data', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Measurement and Data', N'Measurement and Data', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'f7ca11e3-189c-4fda-8a7c-1212d4401307')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Measurement and Data_Measurement and Data_Measurement', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Measurement', N'Measurement and Data_Measurement and Data', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'9cd5b810-16e8-4040-9cc6-4632b03f1854')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Measurement and Data_Measurement and Data_Money and Time', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Money and Time', N'Measurement and Data_Measurement and Data', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'fe5d3e90-ca52-40ee-9ac0-1ba205f5072a')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Meas_Meas_DataRepresentationandAnalysis', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Data Representation and Analysis', N'Measurement and Data_Measurement and Data', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'8c176442-8d67-4fdf-b2c0-61244ef3d7d8')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Meas_Meas_PerimeterCircumferenceandArea', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Perimeter Circumference and Area', N'Measurement and Data_Measurement and Data', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'b5aed939-9155-42d2-88d5-838248681435')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Meas_Meas_SurfaceAreaandVolume', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Surface Area and Volume', N'Measurement and Data_Measurement and Data', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'6c500aab-c718-439b-a97c-5643a2df5d56')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Number and Quantity_The Complex Number System', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'The Complex Number System', N'Number and Quantity', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'1ebbb5cf-7b7d-440f-bb42-dd96dc573a13')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Number and Quantity_The Real Number System', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'The Real Number System', N'Number and Quantity', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'1ff3f203-f09a-4d65-9f72-3195e8524700')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Number and Quantity_Vector and Matrix Quantities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Vector and Matrix Quantities', N'Number and Quantity', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'b5c62d1d-d228-4ab4-a8b2-8f54fcf7ef35')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numb_The _MatricesVectorsandComplexNumbers', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Matrices Vectors and Complex Numbers', N'Number and Quantity_The Complex Number System', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'b5737dab-447c-4553-a9fe-38b3e98675c4')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numb_The _QuadraticExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Quadratic Expressions Equations and Inequalities', N'Number and Quantity_The Complex Number System', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'b1d786b3-d228-4ccd-9186-d8acced83faa')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numb_The _PowersRootsandRadicals', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Powers Roots and Radicals', N'Number and Quantity_The Real Number System', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'fdcb2d31-abd2-4d84-975f-d4d1bbec63b1')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numb_Vect_MatricesVectorsandComplexNumbers', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Matrices Vectors and Complex Numbers', N'Number and Quantity_Vector and Matrix Quantities', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'f35d0d77-1247-4d33-b234-62f2507632a9')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numbers and Operations_Counting and Cardinality', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Counting and Cardinality', N'Numbers and Operations', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'd3a9fdb6-71b4-4bf6-8561-70055637e326')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numbers and Operations_Number and Operations in Base Ten', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Number and Operations in Base Ten', N'Numbers and Operations', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'8b24d954-ea38-471c-ad07-3eba50303aa0')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numbers and Operations_Number and Operations—Fractions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Number and Operations—Fractions', N'Numbers and Operations', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'f84fb683-fa26-4d00-8d4f-fc0410d88432')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numbers and Operations_Ratios and Proportional Relationships', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Ratios and Proportional Relationships', N'Numbers and Operations', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'875dfef9-84e6-483f-9244-233cd313fefd')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numbers and Operations_The Number System', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'The Number System', N'Numbers and Operations', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'd92971c9-721a-4397-aa60-56cd94ce1d73')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numb_Coun_WholeNumbers:CountingComparingandOrdering', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Whole Numbers:Counting Comparing and Ordering', N'Numbers and Operations_Counting and Cardinality', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'0d820e13-7172-462f-bdb5-4e290f10a66b')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numb_Numb_DecimalConceptsandOperations', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Decimal Concepts and Operations', N'Numbers and Operations_Number and Operations in Base Ten', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'272564a8-85cd-4292-945a-e7d36dbd0223')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numb_Numb_WholeNumbers:AdditionandSubtraction', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Whole Numbers:Addition and Subtraction', N'Numbers and Operations_Number and Operations in Base Ten', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'21654b72-be72-46b8-95d8-e15116141250')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numb_Numb_WholeNumbers:CountingComparingandOrdering', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Whole Numbers:Counting Comparing and Ordering', N'Numbers and Operations_Number and Operations in Base Ten', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'76b2efba-9a0e-4351-8035-f89ad366eb43')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numb_Numb_WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Whole Numbers:Multiplication and Division', N'Numbers and Operations_Number and Operations in Base Ten', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'cbc24471-70c0-4ba6-a6cc-4728c108dcc0')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numb_Numb_WholeNumbers:PlaceValue', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Whole Numbers:Place Value', N'Numbers and Operations_Number and Operations in Base Ten', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'1489daf8-82c7-48e0-a1d1-d67fb9a5830d')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numb_Numb_FractionConceptsandOperations', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Fraction Concepts and Operations', N'Numbers and Operations_Number and Operations—Fractions', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'66c1033f-f130-44b8-b0fb-9ea94ea2e432')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numb_Numb_Decimal Concepts and Operations', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Decimal Concepts and Operations', N'Numbers and Operations_Number and Operations—Fractions', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'8c3c85f6-a1d0-4066-a3e2-e56fcb0af8a4')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numb_Rati_PercentsRatiosandProportions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Percents Ratios and Proportions', N'Numbers and Operations_Ratios and Proportional Relationships', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'd1946538-4b8f-4bce-970e-e413921316af')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numb_The _FractionConceptsandOperations', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Fraction Concepts and Operations', N'Numbers and Operations_The Number System', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'7c9714c6-0856-4971-87e6-0c0ba83b0c4d')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numb_The _WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Whole Numbers:Multiplication and Division', N'Numbers and Operations_The Number System', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'33aca465-6f9c-4814-9ad7-53822af6174b')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numb_The_PowersRootsandRadicals', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Powers Roots and Radicals', N'Numbers and Operations_The Number System', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'26de9e06-2aef-4a3e-b777-fffe54b4792c')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numb_The _PositiveandNegativeRationalNumbers', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Positive and Negative Rational Numbers', N'Numbers and Operations_The Number System', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'349623b0-4425-43d0-8471-9cb982c98841')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Numbers and Operations_The Number System_Coordinate Geometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Coordinate Geometry', N'Numbers and Operations_The Number System', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'444ba6e6-70c7-420e-b46e-c53743a1e21f')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Stat_MakingInferencesandJustifyingConclusions_', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Making Inferences and Justifying Conclusions', N'Statistics and Probability', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'e9862013-d8fb-4a48-9469-73359bac858f')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Statistics and Probability_Statistics and Probability', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Statistics and Probability', N'Statistics and Probability', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'eb491008-26b0-4165-bcac-ae957dc1e32e')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Stat_InterpretingCategoricalandQuantitativeData_', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Interpreting Categorical and Quantitative Data', N'Statistics and Probability', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'c350534c-4c84-4e94-9aac-33faabbf592d')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Stat_ConditionalProbabilityandtheRulesofProbability_', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Conditional Probability and the Rules of Probability', N'Statistics and Probability', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'423d60dd-c1fb-421e-9d8e-a7609bbd67a3')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Stat_Stat_CombinatoricsandProbability', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Combinatorics and Probability', N'Statistics and Probability_Statistics and Probability', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'd7aa2ce4-aac8-46a8-b624-40cceaa4f276')
INSERT INTO edfi.ObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [MaxRawScore], [PercentOfAssessment], [Nomenclature], [Description], [ParentIdentificationCode], [CreateDate], [LastModifiedDate], [Id]) VALUES (N'STAR_Math_2019', N'Stat_Stat_DataRepresentationandAnalysis', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Data Representation and Analysis', N'Statistics and Probability_Statistics and Probability', N'2020-01-28 20:04:00', N'2020-01-28 20:04:00', N'e2b5e940-ab2d-4fc5-8586-2a9be41f7c72')



INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[AdministrationDate],[AdministrationEndDate],[SerialNumber],[AdministrationLanguageDescriptorId]
           ,[AdministrationEnvironmentDescriptorId],[RetestIndicatorDescriptorId],[ReasonNotTestedDescriptorId],[WhenAssessedGradeLevelDescriptorId],[EventCircumstanceDescriptorId]
           ,[EventDescription],[SchoolYear],[PlatformTypeDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           (N'STAR_Math_2019',N'http://ed-fi.org/Assessment/Assessment.xml',561855,435,'20190912',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2011,NULL,NULL,GETDATE(),GETDATE(),NEWID(),19000)


INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Geometry_Geometry', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Algebra_Operations and Algebraic Thinking', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Numbers and Operations_Number and Operations in Base Ten', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Numb_Numb_WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Alge_Oper_WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Numb_Numb_WholeNumbers:PlaceValue', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Numb_Numb_Decimal Concepts and Operations', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Meas_Meas_PerimeterCircumferenceandArea', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Meas_Meas_DataRepresentationandAnalysis', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Numbers and Operations_Number and Operations—Fractions', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Geometry_Geometry_Angles Segments and Lines', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Measurement and Data_Measurement and Data', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Numb_Numb_FractionConceptsandOperations', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Numb_Numb_WholeNumbers:AdditionandSubtraction', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Measurement and Data_Measurement and Data_Measurement', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, N'2020-01-29 01:54:37')


INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Numb_Numb_WholeNumbers:PlaceValue', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'56', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Geometry_Geometry_Angles Segments and Lines', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'48', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Numb_Numb_Decimal Concepts and Operations', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'17', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Numb_Numb_FractionConceptsandOperations', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'25', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Meas_Meas_PerimeterCircumferenceandArea', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'39', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Numb_Numb_WholeNumbers:AdditionandSubtraction', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'18', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Measurement and Data_Measurement and Data_Measurement', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'49', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Geometry_Geometry', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'17', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Alge_Oper_WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'17', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Measurement and Data_Measurement and Data', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'33', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Numbers and Operations_Number and Operations in Base Ten', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'18', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Algebra_Operations and Algebraic Thinking', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'42', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Meas_Meas_DataRepresentationandAnalysis', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'33', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Numbers and Operations_Number and Operations—Fractions', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'20', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Numb_Numb_WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'35', 2013, N'2020-01-20 01:47:14')


----STAR ASSESMENT Marshal

INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[AdministrationDate],[AdministrationEndDate],[SerialNumber],[AdministrationLanguageDescriptorId]
           ,[AdministrationEnvironmentDescriptorId],[RetestIndicatorDescriptorId],[ReasonNotTestedDescriptorId],[WhenAssessedGradeLevelDescriptorId],[EventCircumstanceDescriptorId]
           ,[EventDescription],[SchoolYear],[PlatformTypeDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           (N'STAR_Reading_2019',N'http://ed-fi.org/Assessment/Assessment.xml',561856,721,'20190912',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2011,NULL,NULL,GETDATE(),GETDATE(),NEWID(),19000)

INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Lite_Craf_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-16 16:22:45')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Literature_Craft and Structure_Point of View', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Informational Text_Integration of Knowledge and Ideas', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-16 16:22:45')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Info_RangeofReadingandLevelofTextComplexity_', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-16 16:22:45')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Context Clues', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Info_Key _CompareandContrast', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Summary', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Prediction', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Lang_Voca_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Lang_Voca_Multiple-MeaningWords', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Info_Inte_Argumentation', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Structural Analysis', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Lang_Voca_SynonymsandAntonyms', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Theme', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Character and Plot', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Literature_Craft and Structure', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Setting', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Sequence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Cause and Effect', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Info_Craf_Author''sPurposeandPerspective', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Summary', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Info_Key _MainIdeaandDetails', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Figures of Speech', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Lang_Voca_VocabularyinContext', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Lite_Craf_ConventionsandRangeofReading', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Literature_Range of Reading and Level of Text Complexity', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Lite_Rang_ConventionsandRangeofReading', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Info_Key _InferenceandEvidence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Informational Text_Craft and Structure', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-16 16:22:45')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Inference and Evidence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Reading_2019', N'Info_Craf_StructureandOrganization', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'2020-01-20 01:47:14')

INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Lang_Voca_VocabularyinContext', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'53', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details_Summary', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'36', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Key Ideas and Details_Summary', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'31', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Info_Inte_Argumentation', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'35', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Language_Vocabulary Acquisition and Use_Context Clues', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'61', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Info_Key _CompareandContrast', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'45', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details_Theme', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'49', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Language_Vocabulary Acquisition and Use_Figures of Speech', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'66', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Craft and Structure', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'39', 2013, N'2020-01-16 16:22:45')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Lang_Voca_SynonymsandAntonyms', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'60', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Key Ideas and Details', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'48', 2013, N'2020-01-16 16:22:45')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Info_Craf_StructureandOrganization', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'48', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details_Setting', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'57', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Language_Vocabulary Acquisition and Use', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'55', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details_Inference and Evidence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'49', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Key Ideas and Details_Sequence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'54', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Literature_Craft and Structure_Point of View', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'38', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Lite_Craf_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'54', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Info_RangeofReadingandLevelofTextComplexity_', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'60', 2013, N'2020-01-16 16:22:45')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'52', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Lang_Voca_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'54', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Literature_Range of Reading and Level of Text Complexity', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'49', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Lite_Craf_ConventionsandRangeofReading', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'49', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Key Ideas and Details_Cause and Effect', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'54', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Info_Craf_Author''sPurposeandPerspective', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'38', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Language_Vocabulary Acquisition and Use_Structural Analysis', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'66', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Info_Key _MainIdeaandDetails', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'47', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Info_Key _InferenceandEvidence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'49', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Lang_Voca_Multiple-MeaningWords', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'48', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Lite_Rang_ConventionsandRangeofReading', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'49', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Key Ideas and Details_Prediction', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'52', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Literature_Craft and Structure', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'48', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Integration of Knowledge and Ideas', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'35', 2013, N'2020-01-16 16:22:45')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details_Character and Plot', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'56', 2013, N'2020-01-20 01:47:14')

INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier],[Namespace],[StudentAssessmentIdentifier],[StudentUSI],[AdministrationDate],[AdministrationEndDate],[SerialNumber],[AdministrationLanguageDescriptorId]
           ,[AdministrationEnvironmentDescriptorId],[RetestIndicatorDescriptorId],[ReasonNotTestedDescriptorId],[WhenAssessedGradeLevelDescriptorId],[EventCircumstanceDescriptorId]
           ,[EventDescription],[SchoolYear],[PlatformTypeDescriptorId],[Discriminator],[CreateDate],[LastModifiedDate],[Id],[ChangeVersion])
     VALUES
           (N'STAR_Math_2019',N'http://ed-fi.org/Assessment/Assessment.xml',561857,721,'20190912',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2011,NULL,NULL,GETDATE(),GETDATE(),NEWID(),19000)


INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Geometry_Geometry', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Algebra_Operations and Algebraic Thinking', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Numbers and Operations_Number and Operations in Base Ten', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Numb_Numb_WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Alge_Oper_WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Numb_Numb_WholeNumbers:PlaceValue', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Numb_Numb_Decimal Concepts and Operations', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Meas_Meas_PerimeterCircumferenceandArea', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Meas_Meas_DataRepresentationandAnalysis', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Numbers and Operations_Number and Operations—Fractions', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Geometry_Geometry_Angles Segments and Lines', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Measurement and Data_Measurement and Data', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Numb_Numb_FractionConceptsandOperations', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Numb_Numb_WholeNumbers:AdditionandSubtraction', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, N'2020-01-29 01:54:37')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment ([AssessmentIdentifier], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [CreateDate]) VALUES (N'STAR_Math_2019', N'Measurement and Data_Measurement and Data_Measurement', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, N'2020-01-29 01:54:37')


INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Numb_Numb_WholeNumbers:PlaceValue', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'56', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Geometry_Geometry_Angles Segments and Lines', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'48', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Numb_Numb_Decimal Concepts and Operations', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'17', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Numb_Numb_FractionConceptsandOperations', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'25', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Meas_Meas_PerimeterCircumferenceandArea', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'39', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Numb_Numb_WholeNumbers:AdditionandSubtraction', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'18', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Measurement and Data_Measurement and Data_Measurement', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'49', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Geometry_Geometry', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'17', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Alge_Oper_WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'17', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Measurement and Data_Measurement and Data', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'33', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Numbers and Operations_Number and Operations in Base Ten', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'18', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Algebra_Operations and Algebraic Thinking', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'42', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Meas_Meas_DataRepresentationandAnalysis', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'33', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Numbers and Operations_Number and Operations—Fractions', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'20', 2013, N'2020-01-20 01:47:14')
INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult ([AssessmentIdentifier], [AssessmentReportingMethodDescriptorId], [IdentificationCode], [Namespace], [StudentAssessmentIdentifier], [StudentUSI], [Result], [ResultDatatypeTypeDescriptorId], [CreateDate]) VALUES (N'STAR_Math_2019', 212, N'Numb_Numb_WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'35', 2013, N'2020-01-20 01:47:14')
