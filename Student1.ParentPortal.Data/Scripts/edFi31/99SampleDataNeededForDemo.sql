-- Adding emails so that parent and teacher can login.
INSERT INTO [edfi].[ParentElectronicMail] ([ElectronicMailTypeDescriptorId],[ParentUSI],[ElectronicMailAddress],[PrimaryEmailAddressIndicator]) values (816,881,'perry.savage@toolwise.onmicrosoft.com',1);
INSERT INTO [edfi].[StaffElectronicMail] ([ElectronicMailTypeDescriptorId],[StaffUSI],[ElectronicMailAddress],[PrimaryEmailAddressIndicator]) values (818, 33,'alexander.kim@toolwise.onmicrosoft.com',1);
INSERT INTO [edfi].[StaffElectronicMail] ([ElectronicMailTypeDescriptorId],[StaffUSI],[ElectronicMailAddress],[PrimaryEmailAddressIndicator]) values (818, 28,'fred.lloyd@toolwise.onmicrosoft.com',1);

-- Adding Sex to students so that they show up.
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=1;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=29;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=553;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=798;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=910;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=886;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=922;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=870;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=814;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=817;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=745;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=884;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=945;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=889;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=841;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=932;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=951;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=942;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=892;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=781;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=943;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=811;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=772;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=885;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=960;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=504;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=849;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=877;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=578;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=672;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=755;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=474;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=750;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=424;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=724;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=460;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=894;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=459;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=467;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=834;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=954;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=479;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=590;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=893;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=558;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=488;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=473;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=415;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=659;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=765;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=761;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=788;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=673;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=752;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=545;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=458;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=604;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=824;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=435;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=776;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2018 WHERE [StudentUSI]=759;
UPDATE [edfi].[Student] SET [BirthSexDescriptorId]=2017 WHERE [StudentUSI]=661;


-- Changing Current School Year for the demo.

  UPDATE [edfi].[SchoolYearType] 
  set CurrentSchoolYear=1 
  where SchoolYear = 2011

    UPDATE [edfi].[SchoolYearType] 
  set CurrentSchoolYear=0 
  where SchoolYear = 2019

 -- Changing it back
  --UPDATE [edfi].[SchoolYearType] 
  --set CurrentSchoolYear=0 
  --where SchoolYear = 2011

  --  UPDATE [edfi].[SchoolYearType] 
  --set CurrentSchoolYear=1
  --where SchoolYear = 2019



-- Add Attendance event
INSERT INTO [edfi].StudentSchoolAttendanceEvent 
(AttendanceEventCategoryDescriptorId, EventDate, SchoolId, SchoolYear, SessionName, StudentUSI) 
VALUES (246,'2011-10-06',255901107, 2011,'2010-2011 Fall Semester', 553);

INSERT INTO [edfi].StudentSchoolAttendanceEvent 
(AttendanceEventCategoryDescriptorId, EventDate, SchoolId, SchoolYear, SessionName, StudentUSI) 
VALUES (246,'2011-10-06',255901107, 2011,'2010-2011 Spring Semester', 798);

-- Add Student Discipline incident Association with Actions

INSERT INTO [edfi].[StudentDisciplineIncidentAssociation] 
(IncidentIdentifier,SchoolId, StudentUSI, StudentParticipationCodeDescriptorId) 
VALUES (1,255901107,553,2180)

INSERT INTO [edfi].[DisciplineAction]
(DisciplineActionIdentifier, DisciplineDate, StudentUSI, ResponsibilitySchoolId) 
VALUES (26,'2011-10-20',553,255901107)

INSERT INTO [edfi].[DisciplineActionStudentDisciplineIncidentAssociation]
(DisciplineActionIdentifier, DisciplineDate,IncidentIdentifier,SchoolId,StudentUSI)
VALUES (26,'2011-10-20',1,255901107,553)

INSERT INTO [edfi].[DisciplineActionDiscipline]
(DisciplineActionIdentifier,DisciplineDate,DisciplineDescriptorId,StudentUSI)
VALUES (26,'2011-10-20',768,553)

UPDATE  [edfi].[DisciplineIncident] 
SET IncidentDescription = 'Student fought with another student'
WHERE IncidentIdentifier = 1

INSERT INTO [edfi].[StudentDisciplineIncidentAssociation] 
(IncidentIdentifier,SchoolId, StudentUSI, StudentParticipationCodeDescriptorId) 
VALUES (1,255901107,910,2180)

INSERT INTO [edfi].[DisciplineAction]
(DisciplineActionIdentifier, DisciplineDate, StudentUSI, ResponsibilitySchoolId) 
VALUES (27,'2011-10-20',910,255901107)

INSERT INTO [edfi].[DisciplineActionStudentDisciplineIncidentAssociation]
(DisciplineActionIdentifier, DisciplineDate,IncidentIdentifier,SchoolId,StudentUSI)
VALUES (27,'2011-10-20',1,255901107,910)

INSERT INTO [edfi].[DisciplineActionDiscipline]
(DisciplineActionIdentifier,DisciplineDate,DisciplineDescriptorId,StudentUSI)
VALUES (27,'2011-10-20',768,910)

-- Add Student GPA

UPDATE [edfi].[StudentAcademicRecord]
SET CumulativeGradePointAverage = 3.9
WHERE StudentUSI = 553

UPDATE [edfi].[StudentAcademicRecord]
SET CumulativeGradePointAverage = 3.2
WHERE StudentUSI = 798

UPDATE [edfi].[StudentAcademicRecord]
SET CumulativeGradePointAverage = 3.5
WHERE StudentUSI = 910
UPDATE [edfi].[StudentAcademicRecord]
SET CumulativeGradePointAverage = 3.9
WHERE StudentUSI = 886

UPDATE [edfi].[StudentAcademicRecord]
SET CumulativeGradePointAverage = 3.7
WHERE StudentUSI = 922

UPDATE [edfi].[StudentAcademicRecord]
SET CumulativeGradePointAverage = 3.0
WHERE StudentUSI = 870

UPDATE [edfi].[StudentAcademicRecord]
SET CumulativeGradePointAverage = 3.1
WHERE StudentUSI = 814

UPDATE [edfi].[StudentAcademicRecord]
SET CumulativeGradePointAverage = 3.3
WHERE StudentUSI = 817

UPDATE [edfi].[StudentAcademicRecord]
SET CumulativeGradePointAverage = 3.9
WHERE StudentUSI = 745

UPDATE [edfi].[StudentAcademicRecord]
SET CumulativeGradePointAverage = 3.4
WHERE StudentUSI = 884

UPDATE [edfi].[StudentAcademicRecord]
SET CumulativeGradePointAverage = 3.7
WHERE StudentUSI = 945

UPDATE [edfi].[StudentAcademicRecord]
SET CumulativeGradePointAverage = 3.7
WHERE StudentUSI = 889

UPDATE [edfi].[StudentAcademicRecord]
SET CumulativeGradePointAverage = 3.8
WHERE StudentUSI = 841

UPDATE [edfi].[StudentAcademicRecord]
SET CumulativeGradePointAverage = 3.2
WHERE StudentUSI = 932

UPDATE [edfi].[StudentAcademicRecord]
SET CumulativeGradePointAverage = 3.2
WHERE StudentUSI = 951

UPDATE [edfi].[StudentAcademicRecord]
SET CumulativeGradePointAverage = 3.0
WHERE StudentUSI = 942

UPDATE [edfi].[StudentAcademicRecord]
SET CumulativeGradePointAverage = 3.0
WHERE StudentUSI = 892

UPDATE [edfi].[StudentAcademicRecord]
SET CumulativeGradePointAverage = 3.1
WHERE StudentUSI = 781

UPDATE [edfi].[StudentAcademicRecord]
SET CumulativeGradePointAverage = 3.2
WHERE StudentUSI = 943

UPDATE [edfi].[StudentAcademicRecord]
SET CumulativeGradePointAverage = 3.3
WHERE StudentUSI = 811

UPDATE [edfi].[StudentAcademicRecord]
SET CumulativeGradePointAverage = 3.9
WHERE StudentUSI = 772

--Add Missing Assignment

INSERT INTO [edfi].[GradebookEntry] 
  (DateAssigned,GradebookEntryTitle,LocalCourseCode,SchoolId,SchoolYear,SectionIdentifier,SessionName, GradebookEntryTypeDescriptorId)
  VALUES ('2010-08-29', 'Assignment 1','ART-01', 255901107, 2011,'25590110705Trad504ART0112011','2010-2011 Fall Semester',895)

  INSERT INTO [edfi].[StudentGradebookEntry]
  (BeginDate,DateAssigned,GradebookEntryTitle,LocalCourseCode,SchoolId,SchoolYear, SectionIdentifier, SessionName, StudentUSI)
  VALUES ('2010-08-23','2010-08-29','Assignment 1','ART-01',255901107,2011,'25590110705Trad504ART0112011','2010-2011 Fall Semester',553)

INSERT INTO [edfi].[GradebookEntry] 
  (DateAssigned,GradebookEntryTitle,LocalCourseCode,SchoolId,SchoolYear,SectionIdentifier,SessionName, GradebookEntryTypeDescriptorId)
  VALUES ('2011-02-20', 'Assignment 1','ART-03', 255901107, 2011,'25590110702Trad505ART0322011','2010-2011 Spring Semester',895)

  INSERT INTO [edfi].[StudentGradebookEntry]
  (BeginDate,DateAssigned,GradebookEntryTitle,LocalCourseCode,SchoolId,SchoolYear, SectionIdentifier, SessionName, StudentUSI)
  VALUES ('2011-02-19','2011-02-20','Assignment 1','ART-03',255901107,2011,'25590110702Trad505ART0322011','2010-2011 Spring Semester',798)


-- Student Schedule

 INSERT INTO [edfi].[BellScheduleDate]
  (BellScheduleName, Date, SchoolId)
  VALUES ('Normal Schedule', '2011-01-16', 255901107)
 INSERT INTO [edfi].[BellScheduleDate]
  (BellScheduleName, Date, SchoolId)
  VALUES ('Normal Schedule', '2011-01-17', 255901107)
 INSERT INTO [edfi].[BellScheduleDate]
  (BellScheduleName, Date, SchoolId)
  VALUES ('Normal Schedule', '2011-01-18', 255901107)
  INSERT INTO [edfi].[BellScheduleDate]
  (BellScheduleName, Date, SchoolId)
  VALUES ('Normal Schedule', '2011-01-19', 255901107)
  INSERT INTO [edfi].[BellScheduleDate]
  (BellScheduleName, Date, SchoolId)
  VALUES ('Normal Schedule', '2011-01-20', 255901107)
  INSERT INTO [edfi].[BellScheduleDate]
  (BellScheduleName, Date, SchoolId)
  VALUES ('Normal Schedule', '2011-01-21', 255901107)

  UPDATE [edfi].[StudentSchoolAttendanceEvent]
  set AttendanceEventCategoryDescriptorId = 245
  WHERE Id = '96F30BF2-113A-47AC-A839-5AF9CEDD5975'

  UPDATE [edfi].[StudentParentAssociation]
  SET EmergencyContactStatus = 1
  WHERE ParentUSI = 881