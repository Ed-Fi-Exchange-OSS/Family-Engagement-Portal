﻿--Descriptors variables

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

--descriptors Assignment 
select @femaleSexDescriptorId = DescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/SexDescriptor' and CodeValue = 'Female' -- 2091
select @maleSexDescriptorId = DescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/SexDescriptor' and CodeValue = 'Male' -- 2090
select @electronictWorkMailDescriptor = DescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/ElectronicMailTypeDescriptor' and CodeValue = 'Work'
select @fatherRelationDescriptor = DescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/RelationDescriptor' and Description = 'Father'
select @motherRelationDescriptor = DescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/RelationDescriptor' and Description = 'Mother'


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
 select @absenceDescriptor = DescriptorId from edfi.Descriptor where Namespace like 'uri://ed-fi.org/AttendanceEventCategoryDescriptor' and Description = 'Unexcused Absence'


--Adding Student Absences
 insert into edfi.StudentSchoolAttendanceEvent(AttendanceEventCategoryDescriptorId, EventDate, SchoolId, SchoolYear, SessionName, StudentUSI, AttendanceEventReason)
values 
(@absenceDescriptor, '2011-01-04',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-01-05',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-01-26',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-02-09',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-02-15',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-02-25',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-03-07',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-03-17',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-04-20',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-04-21',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-04-22',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-04-27',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-04-28',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-05-02',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-05-05',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-05-17',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-05-18',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-05-26',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-05-27',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-05-30',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-05-31',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-05-16',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-05-09',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-05-10',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-05-11',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-05-12',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-05-13',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-06-06',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-06-28',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-07-20',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-08-22',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-08-23',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-08-30',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-08-31',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-09-20',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-09-21',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-10-03',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-10-04',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-10-05',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-11-14',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-11-15',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-11-16',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-11-28',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-11-29',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,''),
(@absenceDescriptor, '2011-12-08',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentFemaleUSI ,'');


insert into edfi.StudentSchoolAttendanceEvent(AttendanceEventCategoryDescriptorId, EventDate, SchoolId, SchoolYear, SessionName, StudentUSI, AttendanceEventReason)
values
(@absenceDescriptor, '2011-01-04',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-01-05',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-01-26',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-02-09',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-02-15',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-02-25',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-03-07',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-03-17',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-04-20',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-04-21',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-04-22',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-04-27',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-04-28',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-05-02',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-05-05',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-05-17',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-05-18',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-05-26',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-05-27',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-05-30',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-05-31',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-05-16',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-05-09',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-05-10',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-05-11',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-05-12',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-05-13',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-06-06',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-06-28',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-07-20',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-08-22',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-08-23',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-08-30',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-08-31',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-09-20',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-09-21',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-10-03',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-10-04',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-10-05',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-11-14',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-11-15',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-11-16',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-11-28',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-11-29',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,''),
(@absenceDescriptor, '2011-12-08',@highSchoolId, 2011, '2010-2011 Spring Semester', @studentMaleUSI ,'');

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
values (22, @highSchoolId, '2011-04-21', 'Student playing with a toy in class.');
insert into edfi.DisciplineIncident(IncidentIdentifier, SchoolId, IncidentDate, IncidentDescription)
values (23, @middleSchoolId, '2011-04-20', 'Student missbehaving in class.');

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



INSERT INTO [ParentPortal].[Admin]([ElectronicMailAddress],[CreateDate],[LastModifiedDate],[Id]) VALUES ('trent.newton@toolwise.onmicrosoft.com' ,GETDATE() ,GETDATE(),newid())

 update edfi.StaffElectronicMail set ElectronicMailAddress= 'trent.newton@toolwise.onmicrosoft.com' where StaffUSI = 58 
 update edfi.StaffElectronicMail set StaffUSI = 51  where ElectronicMailAddress= 'trent.newton@toolwise.onmicrosoft.com'


 --Update relationshisp incidents 
insert into edfi.StudentDisciplineIncidentAssociation(IncidentIdentifier, SchoolId, StudentUSI, StudentParticipationCodeDescriptorId)
values (22, @middleSchoolId, @studentMaleUSI, @perpetratorDisciplineStudentDescriptor);
insert into edfi.StudentDisciplineIncidentAssociation(IncidentIdentifier, SchoolId, StudentUSI, StudentParticipationCodeDescriptorId)
values (23, @highSchoolId, @studentFemaleUSI, @perpetratorDisciplineStudentDescriptor);
insert into edfi.StudentDisciplineIncidentAssociation(IncidentIdentifier, SchoolId, StudentUSI, StudentParticipationCodeDescriptorId)
values (24, @middleSchoolId, @studentMaleUSI, @perpetratorDisciplineStudentDescriptor);
insert into edfi.StudentDisciplineIncidentAssociation(IncidentIdentifier, SchoolId, StudentUSI, StudentParticipationCodeDescriptorId)
values (25, @highSchoolId, @studentFemaleUSI, @perpetratorDisciplineStudentDescriptor);


insert into edfi.DisciplineActionStudentDisciplineIncidentAssociation(DisciplineActionIdentifier, DisciplineDate, IncidentIdentifier, SchoolId, StudentUSI)
values(22, '2011-04-22', 22, @highSchoolId, @studentMaleUSI);
insert into edfi.DisciplineActionStudentDisciplineIncidentAssociation(DisciplineActionIdentifier, DisciplineDate, IncidentIdentifier, SchoolId, StudentUSI)
values(23, '2011-04-22', 22, @highSchoolId, @studentMaleUSI);
--insert into edfi.DisciplineActionStudentDisciplineIncidentAssociation(DisciplineActionIdentifier, DisciplineDate, IncidentIdentifier, SchoolId, StudentUSI)
--values(24, '2011-04-22', 23, @highSchoolId, @studentFemaleUSI);




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










