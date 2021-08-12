DO $$
DECLARE
      v_femaleSexDescriptorId int;
      v_maleSexDescriptorId int;
      v_staffUSIPrincipalGrandBenHighSchool int;
      v_electronictWorkMailDescriptor int;
      v_fatherRelationDescriptor int;
      v_motherRelationDescriptor int;
      v_principalEmail varchar = 'fred.lloyd@toolwise.onmicrosoft.com';
      v_principalStaffUSI int;
      v_teacherEmail varchar = 'alexander.kim@toolwise.onmicrosoft.com';
      v_teacherUSI int;
      v_studentMaleEmail varchar = 'chadwick.garner@toolwise.onmicrosoft.com';
      v_parentEmail varchar = 'perry.savage@toolwise.onmicrosoft.com';
      v_parentUSI int;
      v_studentFemaleEmail varchar = 'chadwick1.garner@toolwise.onmicrosoft.com';
      v_descriptorPrincial int;
      
      v_firstSixWeeks int;
      v_secondSixWeeks int;
      v_thirdSixWeeks int;
      v_fourthSixWeeks int;
      v_fifthSixWeeks int;
      v_sixthSixWeeks int;

      v_highSchoolId int = 255901001;
      v_middleSchoolId int = 255901044;
      v_disciplineDescriptor int;
      v_assessmentReportingMethodDescriptor int;

      v_absenceDescriptor int;
      v_absenceExcused int;
      v_absenceUnExcused int;
      v_absenceTardy int;

      v_perpetratorDisciplineDescriptor int;
      v_reporterDisciplineDescriptor int;

      v_perpetratorDisciplineStudentDescriptor int;
      v_reporterDisciplineStudentDescriptor int;
      v_assesmentCategoryDescriptor int;
      v_gradeLevelDescriptor int;
      v_2gradeLevelDescriptor int;
      v_resultDatatypeTypeDescriptor int;

      v_performanceLevelDescriptorMaster int;
      v_performanceLevelDescriptorApproaches int;
      v_performanceLevelDescriptorMeets int;
      v_performanceLevelDescriptorDidNotMeet int;

      v_homeWorkDescriptor int;

      v_studentMaleUSI int;
      v_studentFemaleUSI int;

      v_studentFemaleGoalAcademic int;
      v_studentFemaleGoalCareer int;
      v_studentFemaleGoalPersonal int;
      v_studentMaleGoalAcademic int;
      v_studentMaleGoalCareer int;
      v_studentMaleGoalPersonal int;
      
      v_AssesmentIdentifierFemale2018 uuid := uuid_generate_v4();
      v_AssesmentIdentifierFemale2019 uuid := uuid_generate_v4();
      v_AssesmentIdentifierMale2018 uuid := uuid_generate_v4();
      v_AssesmentIdentifierMale2019 uuid := uuid_generate_v4();
      v_AssessmentCategoryDescriptorId int;        -- 119 uri://ed-fi.org/AssessmentCategoryDescriptor State English proficiency test
      v_AcademicSubjectDescriptorId int;		    -- 31	uri://ed-fi.org/AcademicSubjectDescriptor	English	
      v_ResultDatatypeTypeDescriptorInteger int;	-- 2013 @ResultDatatypeTypeDescriptorInteger	uri://ed-fi.org/ResultDatatypeTypeDescriptor	Integer	
      v_ResultDatatypeTypeDescriptorDecimal int;     --@ResultDatatypeTypeDescriptorDecimal	uri://ed-fi.org/ResultDatatypeTypeDescriptor	Decimal
      v_AssessmentReportingMethodDescriptorProfencyLevel int;  --@ResultDatatypeTypeDescriptorDecimal	uri://ed-fi.org/AssessmentReportingMethodDescriptor	Proficiency level
      v_AssessmentReportingMethodDescriptorRawScore int;       --@AssessmentReportingMethodDescriptorRawScore	uri://ed-fi.org/AssessmentReportingMethodDescriptor	Raw score	Raw score
      v_AssessmentReportingMethodDescriptorScaleScore int;     --@AssessmentReportingMethodDescriptorScaleScore	uri://ed-fi.org/AssessmentReportingMethodDescriptor	Scale score
      v_PerformaceLevelDescriptor int;						 --@GradeLevelDescriptor	uri://ed-fi.org/PerformanceLevelDescriptor	Above Benchmark
      v_ResultDatatypeTypeDescriptorLevel int;
      v_AssesmentIdentifierFemale20192 uuid := uuid_generate_v4();
      v_AssesmentIdentifierMale20192 uuid := uuid_generate_v4();
      v_calendarType int;
      v_nonintructionalday int;
BEGIN
      CREATE EXTENSION IF NOT EXISTS "uuid-ossp"; -- load module

      select DescriptorId into v_femaleSexDescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/SexDescriptor' and CodeValue = 'Female'; -- 2091

      select DescriptorId into v_maleSexDescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/SexDescriptor' and CodeValue = 'Male'; -- 2090

      select DescriptorId into v_electronictWorkMailDescriptor from edfi.Descriptor where Namespace = 'uri://ed-fi.org/ElectronicMailTypeDescriptor' and CodeValue = 'Work';

      select DescriptorId into v_fatherRelationDescriptor from edfi.Descriptor where Namespace = 'uri://ed-fi.org/RelationDescriptor' and Description = 'Father';

      select DescriptorId into v_motherRelationDescriptor from edfi.Descriptor where Namespace = 'uri://ed-fi.org/RelationDescriptor' and Description = 'Mother';

      select DescriptorId into v_descriptorPrincial from edfi.Descriptor where Namespace = 'uri://ed-fi.org/StaffClassificationDescriptor' and Description = 'Principal';

      select StaffUSI into v_principalStaffUSI from edfi.Staff where FirstName = 'Fred' and LastSurname = 'Lloyd';

      select StaffUSI into v_teacherUSI from edfi.Staff where FirstName = 'Russell' and LastSurname = 'Gomez';

      select ParentUSI into v_parentUSI from edfi.Parent where FirstName = 'April' and LastSurname = 'Terrell';

      update edfi.StaffEducationOrganizationAssignmentAssociation set StaffClassificationDescriptorId = v_descriptorPrincial where StaffUSI = v_principalStaffUSI;

      INSERT INTO ParentPortal.Admin(ElectronicMailAddress,CreateDate,LastModifiedDate,Id) VALUES ('trent.newton@toolwise.onmicrosoft.com' , CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, uuid_generate_v4());

      update edfi.StaffElectronicMail set ElectronicMailAddress= 'trent.newton@toolwise.onmicrosoft.com' where StaffUSI = 58;
      update edfi.StaffElectronicMail set StaffUSI = 51  where ElectronicMailAddress= 'trent.newton@toolwise.onmicrosoft.com';
      update edfi.Student set FirstName = 'Hannah', MiddleName= 'Valeria', LastSurname ='Terrell', BirthSexDescriptorId = v_femaleSexDescriptorId where StudentUSI = 435;

      select  StudentUSI into v_studentMaleUSI from edfi.Student where FirstName = 'Marshall' and LastSurname = 'Terrell';

      select  StudentUSI into v_studentFemaleUSI from edfi.Student where FirstName = 'Hannah' and LastSurname = 'Terrell';
      update edfi.StudentEducationOrganizationAssociationElectronicMail set ElectronicMailAddress = 'chadwick.garner@toolwise.onmicrosoft.com' where StudentUSI = 435;

      update edfi.StaffElectronicMail  set StaffUSI = 15 where ElectronicMailAddress = 'fred.lloyd@toolwise.onmicrosoft.com';
      update edfi.StaffElectronicMail set ElectronicMailAddress = 'alexander.kim@toolwise.onmicrosoft.com' where StaffUSI = 57; --@teacherUSI;

      update edfi.ParentElectronicMail set ElectronicMailAddress = 'perry.savage@toolwise.onmicrosoft.com' where ParentUSI = v_parentUSI;
      update edfi.Student set BirthSexDescriptorId = v_femaleSexDescriptorId where StudentUSI = v_studentFemaleUSI;
      update edfi.Student set BirthSexDescriptorId = v_maleSexDescriptorId where StudentUSI = v_studentMaleUSI;

      update edfi.SchoolYearType set CurrentSchoolYear = FALSE;
      update edfi.SchoolYearType set CurrentSchoolYear = TRUE where SchoolYear = 2011;

      /* liveswith */
      /*insert into edfi.StudentParentAssociation(ParentUSI, StudentUSI, RelationDescriptorId, PrimaryContactStatus, LivesWith, EmergencyContactStatus)
            Values(v_parentUSI,v_studentFemaleUSI,v_fatherRelationDescriptor,TRUE,TRUE,TRUE);*/
      update edfi.StudentSchoolAssociation set SchoolYear = 2011 where StudentUSI in (v_studentMaleUSI, v_studentFemaleUSI);

      select DescriptorId into v_firstSixWeeks from edfi.Descriptor where Namespace like 'uri://ed-fi.org/GradingPeriodDescriptor' and CodeValue = 'First Six Weeks';

      select DescriptorId into v_secondSixWeeks from edfi.Descriptor where Namespace like 'uri://ed-fi.org/GradingPeriodDescriptor' and CodeValue = 'Second Six Weeks';

      select DescriptorId into v_thirdSixWeeks from edfi.Descriptor where Namespace like 'uri://ed-fi.org/GradingPeriodDescriptor' and CodeValue = 'Third Six Weeks';

      select DescriptorId into v_fourthSixWeeks from edfi.Descriptor where Namespace like 'uri://ed-fi.org/GradingPeriodDescriptor' and CodeValue = 'Fourth Six Weeks';

      select DescriptorId into v_fifthSixWeeks from edfi.Descriptor where Namespace like 'uri://ed-fi.org/GradingPeriodDescriptor' and CodeValue = 'Fifth Six Weeks';

      select DescriptorId into v_sixthSixWeeks from edfi.Descriptor where Namespace like 'uri://ed-fi.org/GradingPeriodDescriptor' and CodeValue = 'Sixth Six Weeks';

      select DescriptorId into v_assessmentReportingMethodDescriptor from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/AssessmentReportingMethodDescriptor' and CodeValue = 'Scale score';

      select DescriptorId into v_absenceExcused from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AttendanceEventCategoryDescriptor' and CodeValue = 'Excused Absence';

      select DescriptorId into v_absenceTardy from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AttendanceEventCategoryDescriptor' and CodeValue = 'Tardy';

      select DescriptorId into v_absenceUnExcused from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AttendanceEventCategoryDescriptor' and CodeValue = 'Unexcused Absence';

      select DescriptorId into v_absenceDescriptor from edfi.Descriptor where Namespace like 'uri://ed-fi.org/AttendanceEventCategoryDescriptor' and Description = 'Unexcused Absence';

      insert into edfi.StudentSchoolAttendanceEvent(AttendanceEventCategoryDescriptorId, EventDate, SchoolId, SchoolYear, SessionName, StudentUSI, AttendanceEventReason)
      values 
            (v_absenceExcused, '2011-01-07',v_highSchoolId, 2011, '2010-2011 Spring Semester', v_studentFemaleUSI ,'Dental appointment'),
            (v_absenceExcused, '2011-01-11',v_highSchoolId, 2011, '2010-2011 Spring Semester', v_studentFemaleUSI ,'Dental appointment'),
            (v_absenceTardy, '2011-01-28',v_highSchoolId, 2011, '2010-2011 Spring Semester', v_studentFemaleUSI ,''),
            (v_absenceTardy, '2011-02-09',v_highSchoolId, 2011, '2010-2011 Spring Semester', v_studentFemaleUSI ,''),
            (v_absenceTardy, '2011-06-16',v_highSchoolId, 2011, '2010-2011 Spring Semester', v_studentFemaleUSI ,''),
            (v_absenceTardy, '2011-08-24',v_highSchoolId, 2011, '2010-2011 Spring Semester', v_studentFemaleUSI ,''),
            (v_absenceTardy, '2011-12-01',v_highSchoolId, 2011, '2010-2011 Spring Semester', v_studentFemaleUSI ,'');
            
      --StudentSchoolAttendanceEvent where StudentUSI = 721
      insert into edfi.StudentSchoolAttendanceEvent(AttendanceEventCategoryDescriptorId, EventDate, SchoolId, SchoolYear, SessionName, StudentUSI, AttendanceEventReason)
      values 
            (v_absenceTardy, '2011-01-10',v_middleSchoolId, 2011, '2010-2011 Spring Semester', v_studentMaleUSI ,''),
            (v_absenceTardy, '2011-02-14',v_middleSchoolId, 2011, '2010-2011 Spring Semester', v_studentMaleUSI ,''),
            (v_absenceTardy, '2011-04-11',v_middleSchoolId, 2011, '2010-2011 Spring Semester', v_studentMaleUSI ,''),
            (v_absenceTardy, '2011-05-23',v_middleSchoolId, 2011, '2010-2011 Spring Semester', v_studentMaleUSI ,''),
            (v_absenceTardy, '2011-06-20',v_middleSchoolId, 2011, '2010-2011 Spring Semester', v_studentMaleUSI ,''),

            (v_absenceTardy, '2011-07-11',v_middleSchoolId, 2011, '2010-2011 Spring Semester', v_studentMaleUSI ,''),
            (v_absenceTardy, '2011-08-15',v_middleSchoolId, 2011, '2010-2011 Spring Semester', v_studentMaleUSI ,''),
            (v_absenceTardy, '2011-09-12',v_middleSchoolId, 2011, '2010-2011 Spring Semester', v_studentMaleUSI ,''),
            (v_absenceTardy, '2011-10-24',v_middleSchoolId, 2011, '2010-2011 Spring Semester', v_studentMaleUSI ,''),
            (v_absenceTardy, '2011-11-07',v_middleSchoolId, 2011, '2010-2011 Spring Semester', v_studentMaleUSI ,''),
            (v_absenceTardy, '2011-12-06',v_middleSchoolId, 2011, '2010-2011 Spring Semester', v_studentMaleUSI ,''),

            (v_absenceExcused, '2011-01-07',v_middleSchoolId, 2011, '2010-2011 Spring Semester', v_studentMaleUSI ,'Dental appointment'),
            (v_absenceExcused, '2011-02-11',v_middleSchoolId, 2011, '2010-2011 Spring Semester', v_studentMaleUSI ,'Dental appointment'),
            (v_absenceExcused, '2011-03-07',v_middleSchoolId, 2011, '2010-2011 Spring Semester', v_studentMaleUSI ,''),
            (v_absenceExcused, '2011-04-12',v_middleSchoolId, 2011, '2010-2011 Spring Semester', v_studentMaleUSI ,''),
            (v_absenceExcused, '2011-05-07',v_middleSchoolId, 2011, '2010-2011 Spring Semester', v_studentMaleUSI ,''),
            (v_absenceExcused, '2011-06-11',v_middleSchoolId, 2011, '2010-2011 Spring Semester', v_studentMaleUSI ,''),

            (v_absenceUnExcused, '2011-06-14',v_middleSchoolId, 2011, '2010-2011 Spring Semester', v_studentMaleUSI ,''),
            (v_absenceUnExcused, '2011-03-15',v_middleSchoolId, 2011, '2010-2011 Spring Semester', v_studentMaleUSI ,'');

      INSERT INTO ParentPortal.StudentAllAbout 
      (StudentUSI, PrefferedName, FunFact, TypesOfBook, FavoriteAnimal, FavoriteThingToDo, FavoriteSubjectSchool, OneThingWant, LearnToDo, LearningThings, DateCreated, DateUpdated) 
      VALUES (435, N'Hannah', N'I am funny', N'Sci-Fi', N'Dogs are cute', N'Reading', N'Math', N'Travel', N'Math', N'Yes', CAST(N'2021-02-24T17:49:04.427' AS TIMESTAMP(3)), CAST(N'2021-02-24T17:49:04.427' AS TIMESTAMP(3)));

      INSERT INTO ParentPortal.Admin (ElectronicMailAddress, CreateDate, LastModifiedDate, Id) VALUES (N'trent.newton@toolwise.onmicrosoft.com', CAST('2020-06-03T00:00:00.0000000' AS TIMESTAMP(6)), CAST('2020-06-03T00:00:00.0000000' AS TIMESTAMP(6)), 'a3b7e2df-de0c-43ce-8e6d-2da37e3b0ab3');

      select DescriptorId into v_perpetratorDisciplineDescriptor from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/DisciplineIncidentParticipationCodeDescriptor' and CodeValue = 'Perpetrator';

      select DescriptorId into v_reporterDisciplineDescriptor from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/DisciplineIncidentParticipationCodeDescriptor' and CodeValue = 'Reporter';

      insert into edfi.DisciplineIncident(IncidentIdentifier, SchoolId, IncidentDate, IncidentDescription)
      values (30, v_middleSchoolId, '2011-06-04', 'Student playing with a toy in class.');

      INSERT INTO edfi.DisciplineAction
            (DisciplineActionIdentifier,DisciplineDate,StudentUSI,DisciplineActionLength,ActualDisciplineActionLength
            ,DisciplineActionLengthDifferenceReasonDescriptorId,RelatedToZeroTolerancePolicy,ResponsibilitySchoolId
            ,AssignmentSchoolId,ReceivedEducationServicesDuringExpulsion,IEPPlacementMeetingIndicator,Discriminator
            ,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            (30,'2011-06-04',v_studentMaleUSI,1,1,787,NULL,v_middleSchoolId,NULL,NULL,NULL,NULL,NOW(),NOW(),uuid_generate_v4(),47760);

      INSERT INTO edfi.DisciplineActionDiscipline
            (DisciplineActionIdentifier,DisciplineDate,DisciplineDescriptorId,StudentUSI,CreateDate)
      VALUES
            (30,'2011-06-04',797,v_studentMaleUSI,NOW());


      INSERT INTO edfi.StudentDisciplineIncidentAssociation
            (IncidentIdentifier,SchoolId,StudentUSI,StudentParticipationCodeDescriptorId,Discriminator
            ,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES                                    -- TODO replace 2240 for 2284
            (30,v_middleSchoolId,v_studentMaleUSI,2284,null,NOW(),NOW(),uuid_generate_v4(),17743);

      INSERT INTO edfi.DisciplineActionStudentDisciplineIncidentAssociation
            (DisciplineActionIdentifier,DisciplineDate,IncidentIdentifier,SchoolId,StudentUSI,CreateDate)
      VALUES
            (30,'2011-06-04',30,v_middleSchoolId,v_studentMaleUSI,NOW());

      select DescriptorId into v_perpetratorDisciplineStudentDescriptor from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/StudentParticipationCodeDescriptor' and CodeValue = 'Perpetrator';

      select DescriptorId into v_reporterDisciplineStudentDescriptor from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/StudentParticipationCodeDescriptor' and CodeValue = 'Reporter';

      select DescriptorId into v_assesmentCategoryDescriptor from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/AssessmentCategoryDescriptor' and CodeValue = 'College entrance exam';

      select DescriptorId into v_gradeLevelDescriptor from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/GradeLevelDescriptor' and CodeValue = '1th Grade';

      select DescriptorId into v_2gradeLevelDescriptor from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/GradeLevelDescriptor' and CodeValue = '2nd Grade';

      select DescriptorId into v_resultDatatypeTypeDescriptor from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/ResultDatatypeTypeDescriptor' and CodeValue = 'Integer';

      --  Homework

      select DescriptorId into v_homeWorkDescriptor from edfi.Descriptor where Namespace =  'uri://ed-fi.org/GradebookEntryTypeDescriptor' and Description = 'Homework';
      update edfi.Descriptor set CodeValue = 'HMWK' where DescriptorId = v_homeWorkDescriptor;

      insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
      values('2011-04-12', 'Assigment 1', 'ALG-2', v_highSchoolId, 2011, '25590100106Trad220ALG222011', '2010-2011 Spring Semester', v_homeWorkDescriptor);

      insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
      values('2011-04-20', 'Assigment 2', 'SS-06', v_middleSchoolId, 2011,'25590104406Trad112SS0622011', '2010-2011 Spring Semester', v_homeWorkDescriptor);
      insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
      values('2011-04-20', 'Assigment 1', 'SS-06', v_middleSchoolId, 2011,'25590104406Trad112SS0622011', '2010-2011 Spring Semester', v_homeWorkDescriptor);

      insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
      values('2011-04-20', 'Assigment 2', 'SCI-06', v_middleSchoolId, 2011, '25590104405Trad212SCI0622011', '2010-2011 Spring Semester', v_homeWorkDescriptor);
      insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
      values('2011-04-10', 'Assigment 1', 'SCI-06', v_middleSchoolId, 2011, '25590104405Trad212SCI0622011', '2010-2011 Spring Semester', v_homeWorkDescriptor);

      -- Add GPA
      update edfi.StudentAcademicRecord set CumulativeGradePointAverage = '3.5' where StudentUSI = v_studentMaleUSI;
      update edfi.StudentAcademicRecord set CumulativeGradePointAverage = '4.0' where StudentUSI = v_studentFemaleUSI;

      insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
      values('Normal Schedule', '2011-05-02', v_highSchoolId);
      insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
      values('Normal Schedule', '2011-05-03', v_highSchoolId);
      insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
      values('Normal Schedule', '2011-05-04', v_highSchoolId);
      insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
      values('Normal Schedule', '2011-05-05', v_highSchoolId);
      insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
      values('Normal Schedule', '2011-05-06', v_highSchoolId);

      insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
      values('Normal Schedule', '2011-05-02', v_middleSchoolId);
      insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
      values('Normal Schedule', '2011-05-03', v_middleSchoolId);
      insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
      values('Normal Schedule', '2011-05-04', v_middleSchoolId);
      insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
      values('Normal Schedule', '2011-05-05', v_middleSchoolId);
      insert into edfi.BellScheduleDate(BellScheduleName, Date, SchoolId)
      values('Normal Schedule', '2011-05-06', v_middleSchoolId);

      -- ADDING ASSESSMENTS

      insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
      values('SAT MATH', 'uri://ed-fi.org/Assessment/Assessment.xml', 'SAT', v_assesmentCategoryDescriptor, 2011,'2012-05-03',550);
      insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
      values('SAT EBRW', 'uri://ed-fi.org/Assessment/Assessment.xml', 'SAT', v_assesmentCategoryDescriptor, 2011,'2012-05-03',550);

      insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
      values('PSAT MATH', 'uri://ed-fi.org/Assessment/Assessment.xml', 'PSAT', v_assesmentCategoryDescriptor, 2011,'2012-05-03',550);
      insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
      values('PSAT EBRW', 'uri://ed-fi.org/Assessment/Assessment.xml', 'PSAT', v_assesmentCategoryDescriptor, 2011,'2012-05-03',550);

      insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
      values('STAAR English I', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', v_assesmentCategoryDescriptor, 2011,'2012-05-03',550);
      insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
      values('STAAR Algebra I', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', v_assesmentCategoryDescriptor, 2011,'2012-05-03',550);
      insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
      values('STAAR English II', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', v_assesmentCategoryDescriptor, 2011,'2012-05-03',550);
      insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
      values('STAAR Biology', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', v_assesmentCategoryDescriptor, 2011,'2012-05-03',550);
      insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
      values('STAAR U.S. History', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', v_assesmentCategoryDescriptor, 2011,'2012-05-03',550);

      insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
      values('STAAR READING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', v_assesmentCategoryDescriptor, 2011,'2012-05-03',550);
      insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
      values('STAAR MATHEMATICS', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', v_assesmentCategoryDescriptor, 2011,'2012-05-03',550);
      insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
      values('STAAR WRITING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', v_assesmentCategoryDescriptor, 2011,'2012-05-03',550);
      insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
      values('STAAR SCIENCE', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', v_assesmentCategoryDescriptor, 2011,'2012-05-03',550);
      insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentVersion, RevisionDate, MaxRawScore)
      values('STAAR SOCIAL STUDIES', 'uri://ed-fi.org/Assessment/Assessment.xml', 'STAAR', v_assesmentCategoryDescriptor, 2011,'2012-05-03',550);


      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
      values('SAT MATH', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, '2012-10-29');
      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
      values('SAT EBRW', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, '2012-10-29');

      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
      values('PSAT MATH', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, '2012-10-29');
      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
      values('PSAT EBRW', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, '2012-10-29');

      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
      values('STAAR English I', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, '2012-10-29');
      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
      values('STAAR Algebra I', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, '2012-10-29');
      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
      values('STAAR English II', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, '2012-10-29');
      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
      values('STAAR Biology', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, '2012-10-29');
      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate)
      values('STAAR U.S. History', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, '2012-10-29');

      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
      values('STAAR READING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentMaleUSI, '2011-10-29', v_gradeLevelDescriptor);
      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
      values('STAAR MATHEMATICS', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentMaleUSI, '2011-10-29', v_gradeLevelDescriptor);
      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
      values('STAAR WRITING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentMaleUSI, '2011-10-29', v_gradeLevelDescriptor);
      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
      values('STAAR SCIENCE', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentMaleUSI, '2011-10-29', v_gradeLevelDescriptor);
      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
      values('STAAR SOCIAL STUDIES', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentMaleUSI, '2011-10-29', v_gradeLevelDescriptor);

      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
      values('STAAR READING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq1', v_studentMaleUSI, '2012-10-29', v_2gradeLevelDescriptor);
      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
      values('STAAR MATHEMATICS', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq1', v_studentMaleUSI, '2012-10-29', v_2gradeLevelDescriptor);
      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
      values('STAAR WRITING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq1', v_studentMaleUSI, '2012-10-29', v_2gradeLevelDescriptor);
      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
      values('STAAR SCIENCE', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq1', v_studentMaleUSI, '2012-10-29', v_2gradeLevelDescriptor);
      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
      values('STAAR SOCIAL STUDIES', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq1', v_studentMaleUSI, '2012-10-29', v_2gradeLevelDescriptor);


      -- SCORE RESULTS

      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('SAT MATH', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, 500, v_resultDatatypeTypeDescriptor);
      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('SAT EBRW', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, 450, v_resultDatatypeTypeDescriptor);

      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('PSAT MATH', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, 500, v_resultDatatypeTypeDescriptor);
      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('PSAT EBRW', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, 450, v_resultDatatypeTypeDescriptor);

      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('STAAR English I', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, 500, v_resultDatatypeTypeDescriptor);
      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('STAAR Algebra I', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, 450, v_resultDatatypeTypeDescriptor);
      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('STAAR English II', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, 500, v_resultDatatypeTypeDescriptor);
      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('STAAR Biology', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, 450, v_resultDatatypeTypeDescriptor);
      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('STAAR U.S. History', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, 500, v_resultDatatypeTypeDescriptor);


      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('STAAR READING', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentMaleUSI, 500, v_resultDatatypeTypeDescriptor);
      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('STAAR MATHEMATICS', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentMaleUSI, 450, v_resultDatatypeTypeDescriptor);
      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('STAAR WRITING', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentMaleUSI, 500, v_resultDatatypeTypeDescriptor);
      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('STAAR SCIENCE', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentMaleUSI, 450, v_resultDatatypeTypeDescriptor);
      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('STAAR SOCIAL STUDIES', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentMaleUSI, 500, v_resultDatatypeTypeDescriptor);

      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('STAAR READING', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq1', v_studentMaleUSI, 500, v_resultDatatypeTypeDescriptor);
      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('STAAR MATHEMATICS', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq1', v_studentMaleUSI, 450, v_resultDatatypeTypeDescriptor);
      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('STAAR WRITING', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq1', v_studentMaleUSI, 500, v_resultDatatypeTypeDescriptor);
      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('STAAR SCIENCE', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq1', v_studentMaleUSI, 450, v_resultDatatypeTypeDescriptor);
      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('STAAR SOCIAL STUDIES', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq1', v_studentMaleUSI, 500, v_resultDatatypeTypeDescriptor);

      -- Performance Levels

      select DescriptorId into v_performanceLevelDescriptorMaster from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/PerformanceLevelDescriptor' and Description = 'Above Benchmark';

      select DescriptorId into v_performanceLevelDescriptorApproaches from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/PerformanceLevelDescriptor' and Description = 'Advanced';

      select DescriptorId into v_performanceLevelDescriptorMeets from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/PerformanceLevelDescriptor' and Description = 'Basic';

      select DescriptorId into v_performanceLevelDescriptorDidNotMeet from  edfi.Descriptor where Namespace =  'uri://ed-fi.org/PerformanceLevelDescriptor' and Description = 'Below Basic';


      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('SAT MATH', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorMaster, 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, true );
      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('SAT EBRW', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorApproaches, 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, true );

      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('PSAT MATH', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorMaster, 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, true );
      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('PSAT EBRW', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorApproaches, 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, true );

      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('STAAR English I', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorMaster, 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, true );
      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('STAAR Algebra I', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorApproaches, 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, true );
      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('STAAR English II', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorMeets, 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, true );
      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('STAAR Biology', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorDidNotMeet, 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, true );
      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('STAAR U.S. History', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorMaster, 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentFemaleUSI, true );

      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('STAAR READING', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorMaster, 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentMaleUSI, true );
      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('STAAR MATHEMATICS', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorApproaches, 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentMaleUSI, true );
      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('STAAR WRITING', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorMeets, 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentMaleUSI, true );
      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('STAAR SCIENCE', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorDidNotMeet, 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentMaleUSI, true );
      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('STAAR SOCIAL STUDIES', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorMaster, 'iwenfwf319r9r9v8noAWWDQN9dq', v_studentMaleUSI, true );

      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('STAAR READING', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorMaster, 'iwenfwf319r9r9v8noAWWDQN9dq1', v_studentMaleUSI, true );
      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('STAAR MATHEMATICS', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorApproaches, 'iwenfwf319r9r9v8noAWWDQN9dq1', v_studentMaleUSI, true );
      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('STAAR WRITING', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorMeets, 'iwenfwf319r9r9v8noAWWDQN9dq1', v_studentMaleUSI, true );
      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('STAAR SCIENCE', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorDidNotMeet, 'iwenfwf319r9r9v8noAWWDQN9dq1', v_studentMaleUSI, true );
      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('STAAR SOCIAL STUDIES', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorMaster, 'iwenfwf319r9r9v8noAWWDQN9dq1', v_studentMaleUSI, true );

      -- Assessment-
      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
      values('STAAR READING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq2', v_studentFemaleUSI, '2011-10-29', v_gradeLevelDescriptor);
      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
      values('STAAR MATHEMATICS', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq2', v_studentFemaleUSI, '2011-10-29', v_gradeLevelDescriptor);
      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
      values('STAAR WRITING', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq2', v_studentFemaleUSI, '2011-10-29', v_gradeLevelDescriptor);
      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
      values('STAAR SCIENCE', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq2', v_studentFemaleUSI, '2011-10-29', v_gradeLevelDescriptor);
      insert into edfi.StudentAssessment(AssessmentIdentifier, Namespace, StudentAssessmentIdentifier, StudentUSI, AdministrationDate, WhenAssessedGradeLevelDescriptorId)
      values('STAAR SOCIAL STUDIES', 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq2', v_studentFemaleUSI, '2011-10-29', v_gradeLevelDescriptor);


      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('STAAR READING', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq2', v_studentFemaleUSI, 500, v_resultDatatypeTypeDescriptor);
      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('STAAR MATHEMATICS', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq2', v_studentFemaleUSI, 450, v_resultDatatypeTypeDescriptor);
      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('STAAR WRITING', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq2', v_studentFemaleUSI, 500, v_resultDatatypeTypeDescriptor);
      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('STAAR SCIENCE', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq2', v_studentFemaleUSI, 450, v_resultDatatypeTypeDescriptor);
      insert into edfi.StudentAssessmentScoreResult(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId)
      values('STAAR SOCIAL STUDIES', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', 'iwenfwf319r9r9v8noAWWDQN9dq2', v_studentFemaleUSI, 500, v_resultDatatypeTypeDescriptor);

      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('STAAR READING', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorDidNotMeet, 'iwenfwf319r9r9v8noAWWDQN9dq2', v_studentFemaleUSI, true );
      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('STAAR MATHEMATICS', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorApproaches, 'iwenfwf319r9r9v8noAWWDQN9dq2', v_studentFemaleUSI, true );
      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('STAAR WRITING', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorDidNotMeet, 'iwenfwf319r9r9v8noAWWDQN9dq2', v_studentFemaleUSI, true );
      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('STAAR SCIENCE', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorDidNotMeet, 'iwenfwf319r9r9v8noAWWDQN9dq2', v_studentFemaleUSI, true );
      insert into edfi.StudentAssessmentPerformanceLevel(AssessmentIdentifier, AssessmentReportingMethodDescriptorId, Namespace, PerformanceLevelDescriptorId, StudentAssessmentIdentifier, StudentUSI, PerformanceLevelMet)
      values('STAAR SOCIAL STUDIES', v_assessmentReportingMethodDescriptor, 'uri://ed-fi.org/Assessment/Assessment.xml', v_performanceLevelDescriptorMaster, 'iwenfwf319r9r9v8noAWWDQN9dq2', v_studentFemaleUSI, true );

      update edfi.Assessment  set AssessmentTitle = 'STAAR Math' where AssessmentIdentifier = 'STAAR MATHEMATICS';
      update edfi.Assessment  set AssessmentTitle = 'STAAR Reading' where AssessmentIdentifier = 'STAAR READING';
      -- Adding Messages
      insert into ParentPortal.ChatLog(StudentUniqueId, SenderTypeId, SenderUniqueId, RecipientTypeId, RecipientUniqueId, EnglishMessage, DateSent, RecipientHasRead)
      values(605541, 2, 207260, 1, 777779, 'Message for Demo', '2011-04-2', false);

      insert into ParentPortal.ChatLog(StudentUniqueId, SenderTypeId, SenderUniqueId, RecipientTypeId, RecipientUniqueId, EnglishMessage, DateSent, RecipientHasRead)
      values(605255, 2, 207272, 1, 777779, 'Hello', '2011-04-2', false);
      insert into ParentPortal.ChatLog(StudentUniqueId, SenderTypeId, SenderUniqueId, RecipientTypeId, RecipientUniqueId, EnglishMessage, DateSent, RecipientHasRead)
      values(605255, 2, 207272, 1, 777779, 'This is a message', '2011-04-3', false);

      -- Adding Alerts
      insert into ParentPortal.AlertLog(SchoolYear, AlertTypeId, ParentUniqueId, StudentUniqueId, Value, Read, UTCSentDate)
      values(2011, 1, 777779, 605255, 2, false, '2011-05-20');
      insert into ParentPortal.AlertLog(SchoolYear, AlertTypeId, ParentUniqueId, StudentUniqueId, Value, Read, UTCSentDate)
      values(2011, 1, 777779, 605541, 1, false, '2011-05-10');

      -- Students

      update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 1;
      update edfi.Grade set NumericGradeEarned = 91 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 2;
      update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 3;
      update edfi.Grade set NumericGradeEarned = 93 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 4;
      update edfi.Grade set NumericGradeEarned = 94 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 5;
      update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ENG-2' and  GradingPeriodSequence = 6;

      update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 1;
      update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 2;
      update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 3;
      update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 4;
      update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 5;
      update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ALG-2' and  GradingPeriodSequence = 6;

      update edfi.Grade set NumericGradeEarned = 80 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 1;
      update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 2;
      update edfi.Grade set NumericGradeEarned = 82 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 3;
      update edfi.Grade set NumericGradeEarned = 83 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 4;
      update edfi.Grade set NumericGradeEarned = 84 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 5;
      update edfi.Grade set NumericGradeEarned = 85 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ENVIRSYS' and  GradingPeriodSequence = 6;

      update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'VT' and  GradingPeriodSequence = 1;
      update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'VT' and  GradingPeriodSequence = 2;
      update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'VT' and  GradingPeriodSequence = 3;
      update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'VT' and  GradingPeriodSequence = 4;
      update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'VT' and  GradingPeriodSequence = 5;
      update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'VT' and  GradingPeriodSequence = 6;

      update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 1;
      update edfi.Grade set NumericGradeEarned = 71 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 2;
      update edfi.Grade set NumericGradeEarned = 72 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 3;
      update edfi.Grade set NumericGradeEarned = 73 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 4;
      update edfi.Grade set NumericGradeEarned = 74 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 5;
      update edfi.Grade set NumericGradeEarned = 75 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'SPAN-1' and  GradingPeriodSequence = 6;

      update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 1;
      update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 2;
      update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 3;
      update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 4;
      update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 5;
      update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'ART2-EM' and  GradingPeriodSequence = 6;


      update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 1;
      update edfi.Grade set NumericGradeEarned = 61 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 2;
      update edfi.Grade set NumericGradeEarned = 62 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 3;
      update edfi.Grade set NumericGradeEarned = 63 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 4;
      update edfi.Grade set NumericGradeEarned = 64 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 5;
      update edfi.Grade set NumericGradeEarned = 65 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'CREAT-WR' and  GradingPeriodSequence = 6;

      update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 1;
      update edfi.Grade set NumericGradeEarned = 91 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 2;
      update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 3;
      update edfi.Grade set NumericGradeEarned = 93 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 4;
      update edfi.Grade set NumericGradeEarned = 94 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 5;
      update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'PE-06' and  GradingPeriodSequence = 6;

      update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 1;
      update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 2;
      update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 3;
      update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 4;
      update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 5;
      update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'MATH-06' and  GradingPeriodSequence = 6;

      update edfi.Grade set NumericGradeEarned = 80 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 1;
      update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 2;
      update edfi.Grade set NumericGradeEarned = 82 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 3;
      update edfi.Grade set NumericGradeEarned = 83 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 4;
      update edfi.Grade set NumericGradeEarned = 84 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 5;
      update edfi.Grade set NumericGradeEarned = 85 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'MUS-06' and  GradingPeriodSequence = 6;

      update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 1;
      update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 2;
      update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 3;
      update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 4;
      update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 5;
      update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'ART-06' and  GradingPeriodSequence = 6;

      update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 1;
      update edfi.Grade set NumericGradeEarned = 71 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 2;
      update edfi.Grade set NumericGradeEarned = 72 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 3;
      update edfi.Grade set NumericGradeEarned = 73 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 4;
      update edfi.Grade set NumericGradeEarned = 74 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 5;
      update edfi.Grade set NumericGradeEarned = 75 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'ELA-06' and  GradingPeriodSequence = 6;

      update edfi.Grade set NumericGradeEarned = 70 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 1;
      update edfi.Grade set NumericGradeEarned = 81 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 2;
      update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 3;
      update edfi.Grade set NumericGradeEarned = 90 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 4;
      update edfi.Grade set NumericGradeEarned = 92 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 5;
      update edfi.Grade set NumericGradeEarned = 95 where StudentUSI = v_studentMaleUSI and LocalCourseCode = 'SCI-06' and  GradingPeriodSequence = 6;


      update edfi.Grade set NumericGradeEarned = 60 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 1;
      update edfi.Grade set NumericGradeEarned = 61 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 2;
      update edfi.Grade set NumericGradeEarned = 62 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 3;
      update edfi.Grade set NumericGradeEarned = 63 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 4;
      update edfi.Grade set NumericGradeEarned = 64 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 5;
      update edfi.Grade set NumericGradeEarned = 65 where StudentUSI = v_studentFemaleUSI and LocalCourseCode = 'SS-06' and  GradingPeriodSequence = 6;

      --- Update CourseTitle to more descriptive definition
      /*
      update edfi.CourseOffering set localcoursetitle = 'Algebra 1' where CourseCode = 'ALG-1';
      update edfi.CourseOffering set LocalCourseTitle = 'Algebra 2' where CourseCode = 'ALG-2';
      update edfi.CourseOffering set LocalCourseTitle = 'Arts 1' where CourseCode = 'ART-01';
      update edfi.CourseOffering set LocalCourseTitle = 'Arts 2' where CourseCode = 'ART-02';
      update edfi.CourseOffering set LocalCourseTitle = 'Arts 3' where CourseCode = 'ART-03';
      update edfi.CourseOffering set LocalCourseTitle = 'Arts 4' where CourseCode = 'ART-04';
      update edfi.CourseOffering set LocalCourseTitle = 'Arts 5' where CourseCode = 'ART-05';
      update edfi.CourseOffering set LocalCourseTitle = 'Arts 6' where CourseCode = 'ART-06';
      update edfi.CourseOffering set LocalCourseTitle = 'Arts' where CourseCode = 'ART-1';
      update edfi.CourseOffering set LocalCourseTitle = 'Biology' where CourseCode = 'BIO';
      update edfi.CourseOffering set LocalCourseTitle = 'Chemistry' where CourseCode = 'CHEM';
      update edfi.CourseOffering set LocalCourseTitle = 'English 1' where CourseCode = 'ENG-1';
      update edfi.CourseOffering set LocalCourseTitle = 'English 2' where CourseCode = 'ENG-2';
      update edfi.CourseOffering set LocalCourseTitle = 'English 3' where CourseCode = 'ENG-3';
      update edfi.CourseOffering set LocalCourseTitle = 'English 4' where CourseCode = 'ENG-4';
      update edfi.CourseOffering set LocalCourseTitle = 'Environmental Systems' where CourseCode = 'ENVIRSYS';
      update edfi.CourseOffering set LocalCourseTitle = 'Geometry' where CourseCode = 'GEOM';
      update edfi.CourseOffering set LocalCourseTitle = 'Mathematics 1' where CourseCode = 'MATH-01';
      update edfi.CourseOffering set LocalCourseTitle = 'Mathematics 2' where CourseCode = 'MATH-02';
      update edfi.CourseOffering set LocalCourseTitle = 'Mathematics 3' where CourseCode = 'MATH-03';
      update edfi.CourseOffering set LocalCourseTitle = 'Mathematics 4' where CourseCode = 'MATH-04';
      update edfi.CourseOffering set LocalCourseTitle = 'Mathematics 5' where CourseCode = 'MATH-05';
      update edfi.CourseOffering set LocalCourseTitle = 'Mathematics 6' where CourseCode = 'MATH-06';
      update edfi.CourseOffering set LocalCourseTitle = 'Mathematics 7' where CourseCode = 'MATH-07';
      update edfi.CourseOffering set LocalCourseTitle = 'Mathematics 8' where CourseCode = 'MATH-08';
      update edfi.CourseOffering set LocalCourseTitle = 'Music 1' where CourseCode = 'MUS-01';
      update edfi.CourseOffering set LocalCourseTitle = 'Music 2' where CourseCode = 'MUS-02';
      update edfi.CourseOffering set LocalCourseTitle = 'Music 3' where CourseCode = 'MUS-03';
      update edfi.CourseOffering set LocalCourseTitle = 'Music 4' where CourseCode = 'MUS-04';
      update edfi.CourseOffering set LocalCourseTitle = 'Music 5' where CourseCode = 'MUS-05';
      update edfi.CourseOffering set LocalCourseTitle = 'Music 6' where CourseCode = 'MUS-06';
      update edfi.CourseOffering set LocalCourseTitle = 'Science 1' where CourseCode = 'SCI-01';
      update edfi.CourseOffering set LocalCourseTitle = 'Science 2' where CourseCode = 'SCI-02';
      update edfi.CourseOffering set LocalCourseTitle = 'Science 3' where CourseCode = 'SCI-03';
      update edfi.CourseOffering set LocalCourseTitle = 'Science 4' where CourseCode = 'SCI-04';
      update edfi.CourseOffering set LocalCourseTitle = 'Science 5' where CourseCode = 'SCI-05';
      update edfi.CourseOffering set LocalCourseTitle = 'Science 6' where CourseCode = 'SCI-06';
      update edfi.CourseOffering set LocalCourseTitle = 'Science 7' where CourseCode = 'SCI-07';
      update edfi.CourseOffering set LocalCourseTitle = 'Science 8' where CourseCode = 'SCI-08';
      update edfi.CourseOffering set LocalCourseTitle = 'Spanish 1' where CourseCode = 'SPAN-1';
      update edfi.CourseOffering set LocalCourseTitle = 'Spanish 2' where CourseCode = 'SPAN-2';
      update edfi.CourseOffering set LocalCourseTitle = 'Spanish 3' where CourseCode = 'SPAN-3';
      */
      --Goals students|

      select  StudentUSI into v_studentMaleUSI from edfi.Student where FirstName = 'Marshall' and LastSurname = 'Terrell';

      select  StudentUSI into v_studentFemaleUSI from edfi.Student where FirstName = 'Hannah' and LastSurname = 'Terrell';

      INSERT INTO ParentPortal.StudentGoal 
      (StudentUSI,GoalType,Goal,GradeLevel,
      DateGoalCreated,DateScheduled,DateCompleted,
      Additional,Completed,DateCreated,DateUpdated,Labels)
      values
      (v_studentFemaleUSI,'A', 'Decode most 2 syllable words','Tenth grade', NOW(), INTERVAL '31 day' +NOW(),null,'','NA',NOW(),  NOW(),null),
      (v_studentFemaleUSI,'C', 'SELF-MANAGEMENT: manage my emotions, thoughts, and behaviors effectively in different situations and to achieve goals.','Tengh grade', NOW(), interval '31 day' +now(),null,'','NA', NOW(), NOW(),null),
      (v_studentFemaleUSI,'P', 'Demonstrate awareness of career options in the community','Tenth grade', NOW(), interval '31 day' +now(),null,'','NA',NOW(),NOW(),null);

      INSERT INTO ParentPortal.StudentGoal 
      (StudentUSI,GoalType,Goal,GradeLevel,
      DateGoalCreated,DateScheduled,DateCompleted,
      Additional,Completed,DateCreated,DateUpdated,Labels)
      values
      (v_studentMaleUSI,'A', 'Decode most 2 syllable words','Tenth grade', NOW(), INTERVAL '31 day' +NOW(),null,'','NA',NOW(),  NOW(),null),
      (v_studentMaleUSI,'C', 'SELF-MANAGEMENT: manage my emotions, thoughts, and behaviors effectively in different situations and to achieve goals.','Tengh grade', NOW(), interval '31 day' +now(),null,'','NA', NOW(), NOW(),null),
      (v_studentMaleUSI,'P', 'Demonstrate awareness of career options in the community','Tenth grade', NOW(), interval '31 day' +now(),null,'','NA',NOW(),NOW(),null);

      SELECT StudentUSI INTO v_studentMaleUSI FROM edfi.Student WHERE FirstName = 'Marshall' AND LastSurname = 'Terrell';

      select StudentUSI into v_studentFemaleUSI from edfi.Student where FirstName = 'Hannah' and LastSurname = 'Terrell';

      select StudentGoalId into v_studentFemaleGoalAcademic from ParentPortal.StudentGoal where StudentUSI = v_studentFemaleUSI and GoalType = 'A';

      select StudentGoalId into v_studentFemaleGoalCareer from ParentPortal.StudentGoal where StudentUSI = v_studentFemaleUSI and GoalType = 'C';

      select StudentGoalId into v_studentFemaleGoalPersonal from ParentPortal.StudentGoal where StudentUSI = v_studentFemaleUSI and GoalType = 'P';

      select StudentGoalId into v_studentMaleGoalAcademic from ParentPortal.StudentGoal where StudentUSI = v_studentMaleUSI and GoalType = 'A';

      select StudentGoalId into v_studentMaleGoalCareer from ParentPortal.StudentGoal where StudentUSI = v_studentMaleUSI and GoalType = 'C';

      select StudentGoalId into v_studentMaleGoalPersonal  from ParentPortal.StudentGoal where StudentUSI = v_studentMaleUSI and GoalType = 'P';

      INSERT INTO ParentPortal.StudentGoalStep
            (StudentGoalId,StepName,Completed,DateCreated
            ,DateUpdated,IsActive,StudentGoalInterventionId)
      VALUES
            (v_studentFemaleGoalAcademic,'identify all consonant and vowel sounds',true,NOW(),NOW(),true,NULL),
                  (v_studentFemaleGoalAcademic,'identify beginning, middle and ending sounds',true,NOW(),NOW(),true,NULL),
                  (v_studentFemaleGoalAcademic,'be able to cumulativley blend 2 and 3 phoneme words',true,NOW(),NOW(),true,NULL),

                  (v_studentFemaleGoalCareer,'Use planning and organizational tools such as checklists and picture schedules to stay on track',false,NOW(),NOW(),false,NULL),
                  (v_studentFemaleGoalCareer,'Goal for completion of work; use of paper tracker or google form to track completed assignemnts',false,NOW(),NOW(),true,NULL),
                  (v_studentFemaleGoalCareer,'use of stress management strategies such as short breaks and use of cool down station in classroom',false,NOW(),NOW(),true,NULL),
                  (v_studentFemaleGoalPersonal,'Identify career clusters in occupations within the community that I would be interested in',false,NOW(),NOW(),true,NULL);


      INSERT INTO ParentPortal.StudentGoalStep
            (StudentGoalId,StepName,Completed,DateCreated
            ,DateUpdated,IsActive,StudentGoalInterventionId)
      VALUES
            (v_studentMaleGoalAcademic,'identify all consonant and vowel sounds',true,NOW(),NOW(),true,NULL),
                  (v_studentMaleGoalAcademic,'identify beginning, middle and ending sounds',true,NOW(),NOW(),true,NULL),
                  (v_studentMaleGoalAcademic,'be able to cumulativley blend 2 and 3 phoneme words',true,NOW(),NOW(),true,NULL),
                  (v_studentMaleGoalCareer,'Use planning and organizational tools such as checklists and picture schedules to stay on track',false,NOW(),NOW(),true,NULL),
                  (v_studentMaleGoalCareer,'Goal for completion of work; use of paper tracker or google form to track completed assignemnts',false,NOW(),NOW(),true,NULL),
                  (v_studentMaleGoalCareer,'use of stress management strategies such as short breaks and use of cool down station in classroom',false,NOW(),NOW(),true,NULL),
                  (v_studentMaleGoalPersonal,'Identify career clusters in occupations within the community that I would be interested in',false,NOW(),NOW(),true,NULL);

            

      --255901001  - Grand Bend High School
      --@AssessmentCategoryDescriptorId    State English proficiency test

      --AssesmentIdentifier : AccessScores_2019
      --Namespace : uri://ed-fi.org/Assessment/Assessment.xml
      
      --Descriptor

      select  StudentUSI into v_studentMaleUSI from edfi.Student where FirstName = 'Marshall' and LastSurname = 'Terrell';

      select  StudentUSI into v_studentFemaleUSI from edfi.Student where FirstName = 'Hannah' and LastSurname = 'Terrell';

      --select  @studentMaleUSI = 69
      --select  @studentFemaleUSI = 70

      select descriptorid into v_AssessmentCategoryDescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AssessmentCategoryDescriptor' and CodeValue like '%English proficiency%' limit 1;

      select  descriptorid into v_AcademicSubjectDescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AcademicSubjectDescriptor' and CodeValue = 'English';

      select  descriptorid into v_ResultDatatypeTypeDescriptorInteger from edfi.Descriptor where Namespace = 'uri://ed-fi.org/ResultDatatypeTypeDescriptor' and CodeValue = 'Integer';

      select  descriptorid into v_ResultDatatypeTypeDescriptorDecimal from edfi.Descriptor where Namespace = 'uri://ed-fi.org/ResultDatatypeTypeDescriptor' and CodeValue = 'Decimal';

      select  descriptorid into v_AssessmentReportingMethodDescriptorProfencyLevel from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AssessmentReportingMethodDescriptor' and CodeValue = 'Proficiency level';

      select  descriptorid into v_AssessmentReportingMethodDescriptorRawScore from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AssessmentReportingMethodDescriptor' and CodeValue = 'Raw score';

      select  descriptorid into v_AssessmentReportingMethodDescriptorScaleScore from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AssessmentReportingMethodDescriptor' and CodeValue = 'Scale score';

      select  descriptorid into v_gradeLevelDescriptor from edfi.Descriptor where Namespace = 'uri://ed-fi.org/GradeLevelDescriptor' and CodeValue = 'First grade';

      select  descriptorid into v_PerformaceLevelDescriptor from edfi.Descriptor where Namespace = 'uri://ed-fi.org/PerformanceLevelDescriptor' and CodeValue = 'Above Benchmark';

      INSERT INTO edfi.Assessment (AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentForm, AssessmentVersion, RevisionDate, MaxRawScore, Nomenclature, AssessmentFamily, EducationOrganizationId, AdaptiveAssessment, CreateDate, LastModifiedDate, Id) 
      VALUES 
      (N'AccessScores_2019', N'uri://ed-fi.org/Assessment/Assessment.xml', N'Access Scores', v_AssessmentCategoryDescriptorId, NULL, 2019, NULL, 6.0, NULL, NULL, 255901001, NULL, CAST(N'2019-10-31T13:36:16.000' AS TIMESTAMP(3)), CAST(N'2019-10-31T13:36:16.250' AS TIMESTAMP(3)), 'e6b0a3b2-4866-4050-a69e-6e9ea0df9682');
      --(N'AccessScores_2018', N'uri://ed-fi.org/Assessment/Assessment.xml', N'Access Scores', @AssessmentCategoryDescriptorId, NULL, 2018, NULL, 6.0, NULL, NULL, 255901001, NULL, CAST(N'2019-12-11T15:05:39.000' AS DateTime), CAST(N'2019-12-11T15:05:39.300' AS DateTime), N'785e03b2-a06d-480b-8f9a-92803f8e8787'),

      INSERT INTO edfi.Assessment (AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentCategoryDescriptorId, AssessmentForm, AssessmentVersion, RevisionDate, MaxRawScore, Nomenclature, AssessmentFamily, EducationOrganizationId, AdaptiveAssessment, CreateDate, LastModifiedDate, Id) 
      VALUES 
      (N'AccessScores_2018', N'uri://ed-fi.org/Assessment/Assessment.xml', N'Access Scores', v_AssessmentCategoryDescriptorId, NULL, 2018, NULL, 6.0, NULL, NULL, 255901001, NULL, CAST(N'2019-12-11T15:05:39.000' AS TIMESTAMP(3)), CAST(N'2019-12-11T15:05:39.300' AS TIMESTAMP(3)), '785e03b2-a06d-480b-8f9a-92803f8e8787');

      INSERT INTO edfi.ObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,MaxRawScore
            ,PercentOfAssessment,Nomenclature,Description,ParentIdentificationCode
            ,AcademicSubjectDescriptorId,Discriminator,CreateDate,LastModifiedDate
            ,Id,ChangeVersion)
      VALUES
            (N'AccessScores_2019',N'STAAR Reading',N'uri://ed-fi.org/Assessment/Assessment.xml'
            ,6.0,0.25,null,null,null,v_AcademicSubjectDescriptorId,null,NOW(),NOW(),uuid_generate_v4(),15000);

      INSERT INTO edfi.ObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,MaxRawScore
            ,PercentOfAssessment,Nomenclature,Description,ParentIdentificationCode
            ,AcademicSubjectDescriptorId,Discriminator,CreateDate,LastModifiedDate
            ,Id,ChangeVersion)
      VALUES
            ('AccessScores_2018','STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml'
            ,6.0,0.25,null,null,null,v_AcademicSubjectDescriptorId,null,NOW(),NOW(),uuid_generate_v4(),15001);


      INSERT INTO edfi.ObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,MaxRawScore
            ,PercentOfAssessment,Nomenclature,Description,ParentIdentificationCode
            ,AcademicSubjectDescriptorId,Discriminator,CreateDate,LastModifiedDate
            ,Id,ChangeVersion)
      VALUES
            ('AccessScores_2019','STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml'
            ,6.0,0.25,null,null,null,v_AcademicSubjectDescriptorId,null,NOW(),NOW(),uuid_generate_v4(),15000);

      INSERT INTO edfi.ObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,MaxRawScore
            ,PercentOfAssessment,Nomenclature,Description,ParentIdentificationCode
            ,AcademicSubjectDescriptorId,Discriminator,CreateDate,LastModifiedDate
            ,Id,ChangeVersion)
      VALUES
            ('AccessScores_2018','STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml'
            ,6.0,0.25,null,null,null,v_AcademicSubjectDescriptorId,null,NOW(),NOW(),uuid_generate_v4(),15001);

      INSERT INTO edfi.ObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,MaxRawScore
            ,PercentOfAssessment,Nomenclature,Description,ParentIdentificationCode
            ,AcademicSubjectDescriptorId,Discriminator,CreateDate,LastModifiedDate
            ,Id,ChangeVersion)
      VALUES
            ('AccessScores_2019','STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml'
            ,6.0,0.25,null,null,null,v_AcademicSubjectDescriptorId,null,NOW(),NOW(),uuid_generate_v4(),15000);

      INSERT INTO edfi.ObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,MaxRawScore
            ,PercentOfAssessment,Nomenclature,Description,ParentIdentificationCode
            ,AcademicSubjectDescriptorId,Discriminator,CreateDate,LastModifiedDate
            ,Id,ChangeVersion)
      VALUES
            ('AccessScores_2018','STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml'
            ,6.0,0.25,null,null,null,v_AcademicSubjectDescriptorId,null,NOW(),NOW(),uuid_generate_v4(),15001);

      INSERT INTO edfi.ObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,MaxRawScore
            ,PercentOfAssessment,Nomenclature,Description,ParentIdentificationCode
            ,AcademicSubjectDescriptorId,Discriminator,CreateDate,LastModifiedDate
            ,Id,ChangeVersion)
      VALUES
            ('AccessScores_2019','STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml'
            ,6.0,0.25,null,null,null,v_AcademicSubjectDescriptorId,null,NOW(),NOW(),uuid_generate_v4(),15000);


      INSERT INTO edfi.ObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,MaxRawScore
            ,PercentOfAssessment,Nomenclature,Description,ParentIdentificationCode
            ,AcademicSubjectDescriptorId,Discriminator,CreateDate,LastModifiedDate
            ,Id,ChangeVersion)
      VALUES
            ('AccessScores_2018','STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml'
            ,6.0,0.25,null,null,null,v_AcademicSubjectDescriptorId,null,NOW(),NOW(),uuid_generate_v4(),15001);

      INSERT INTO edfi.AssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,Namespace
            ,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2019',v_AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml','0','6.0',v_ResultDatatypeTypeDescriptorDecimal,CURRENT_TIMESTAMP);
      INSERT INTO edfi.AssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,Namespace
            ,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2018',v_AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml','0','6.0',v_ResultDatatypeTypeDescriptorDecimal,CURRENT_TIMESTAMP);

      -- Assessment Score

      INSERT INTO edfi.ObjectiveAssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode
            ,Namespace,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2019',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml','0','6.0',v_ResultDatatypeTypeDescriptorDecimal,CURRENT_TIMESTAMP);

      INSERT INTO edfi.ObjectiveAssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode
            ,Namespace,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2018',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml','0','6.0',v_ResultDatatypeTypeDescriptorDecimal,CURRENT_TIMESTAMP);

      INSERT INTO edfi.ObjectiveAssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode
            ,Namespace,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2019',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml','0','6.0',v_ResultDatatypeTypeDescriptorDecimal,CURRENT_TIMESTAMP);

      INSERT INTO edfi.ObjectiveAssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode
            ,Namespace,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2018',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml','0','6.0',v_ResultDatatypeTypeDescriptorDecimal,CURRENT_TIMESTAMP);


      INSERT INTO edfi.ObjectiveAssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode
            ,Namespace,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2019',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml','0','6.0',v_ResultDatatypeTypeDescriptorDecimal,CURRENT_TIMESTAMP);

      INSERT INTO edfi.ObjectiveAssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode
            ,Namespace,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2018',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml','0','6.0',v_ResultDatatypeTypeDescriptorDecimal,CURRENT_TIMESTAMP);

      INSERT INTO edfi.ObjectiveAssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode
            ,Namespace,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2019',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml','0','6.0',v_ResultDatatypeTypeDescriptorDecimal,CURRENT_TIMESTAMP);

      INSERT INTO edfi.ObjectiveAssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode
            ,Namespace,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2018',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml','0','6.0',v_ResultDatatypeTypeDescriptorDecimal,CURRENT_TIMESTAMP);

      --Student assesment
      INSERT INTO edfi.StudentAssessment
            (AssessmentIdentifier,Namespace,StudentAssessmentIdentifier,StudentUSI,AdministrationDate,AdministrationEndDate
                  ,SerialNumber,AdministrationLanguageDescriptorId,AdministrationEnvironmentDescriptorId,RetestIndicatorDescriptorId
            ,ReasonNotTestedDescriptorId,WhenAssessedGradeLevelDescriptorId,EventCircumstanceDescriptorId,EventDescription
            ,SchoolYear,PlatformTypeDescriptorId,Discriminator,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            ('AccessScores_2019','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2019,v_studentMaleUSI,'20170502',null
            ,null,null,null,null,null,v_gradeLevelDescriptor
            ,null,null,null,null,null,NOW(),NOW(),uuid_generate_v4(),103939);

      INSERT INTO edfi.StudentAssessment
            (AssessmentIdentifier,Namespace,StudentAssessmentIdentifier,StudentUSI,AdministrationDate,AdministrationEndDate
                  ,SerialNumber,AdministrationLanguageDescriptorId,AdministrationEnvironmentDescriptorId,RetestIndicatorDescriptorId
            ,ReasonNotTestedDescriptorId,WhenAssessedGradeLevelDescriptorId,EventCircumstanceDescriptorId,EventDescription
            ,SchoolYear,PlatformTypeDescriptorId,Discriminator,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            ('AccessScores_2018','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2018,v_studentMaleUSI,'20170502',null
            ,null,null,null,null,null,v_gradeLevelDescriptor
            ,null,null,null,null,null,NOW(),NOW(),uuid_generate_v4(),103938);


      --  Student Assessment Score Result

      INSERT INTO edfi.StudentAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,Namespace,StudentAssessmentIdentifier
            ,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2019',v_AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2019,v_studentMaleUSI,3.9,v_ResultDatatypeTypeDescriptorDecimal,CURRENT_TIMESTAMP);

      INSERT INTO edfi.StudentAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,Namespace,StudentAssessmentIdentifier
            ,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2018',v_AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2018,v_studentMaleUSI,4.9,v_ResultDatatypeTypeDescriptorDecimal,CURRENT_TIMESTAMP);

      --student assesment objetice assesment

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('AccessScores_2019','STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2019,v_studentMaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('AccessScores_2018','STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2018,v_studentMaleUSI,NOW());


      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('AccessScores_2019','STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2019,v_studentMaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('AccessScores_2018','STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2018,v_studentMaleUSI,NOW());


      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('AccessScores_2019','STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2019,v_studentMaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('AccessScores_2018','STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2018,v_studentMaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('AccessScores_2019','STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2019,v_studentMaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('AccessScores_2018','STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2018,v_studentMaleUSI,NOW());

      -- student objective score result

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2019',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2019,v_studentMaleUSI,'2.5',v_ResultDatatypeTypeDescriptorDecimal,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2018',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2018,v_studentMaleUSI,'5.5',v_ResultDatatypeTypeDescriptorDecimal,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2019',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2019,v_studentMaleUSI,'2.5',v_ResultDatatypeTypeDescriptorDecimal,NOW());
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2018',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2018,v_studentMaleUSI,'5.8',v_ResultDatatypeTypeDescriptorDecimal,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2019',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2019,v_studentMaleUSI,'2.5',v_ResultDatatypeTypeDescriptorDecimal,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2018',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2018,v_studentMaleUSI,'2.1',v_ResultDatatypeTypeDescriptorDecimal,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2019',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2019,v_studentMaleUSI,'2.5',v_ResultDatatypeTypeDescriptorDecimal,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2018',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2018,v_studentMaleUSI,'3.5',v_ResultDatatypeTypeDescriptorDecimal,NOW());

      -- STUDENT FEMALE 

      --Student assesment
      INSERT INTO edfi.StudentAssessment
            (AssessmentIdentifier,Namespace,StudentAssessmentIdentifier,StudentUSI,AdministrationDate,AdministrationEndDate
                  ,SerialNumber,AdministrationLanguageDescriptorId,AdministrationEnvironmentDescriptorId,RetestIndicatorDescriptorId
            ,ReasonNotTestedDescriptorId,WhenAssessedGradeLevelDescriptorId,EventCircumstanceDescriptorId,EventDescription
            ,SchoolYear,PlatformTypeDescriptorId,Discriminator,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            ('AccessScores_2019','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,'20170502',null
            ,null,null,null,null,null,v_gradeLevelDescriptor
            ,null,null,null,null,null,NOW(),NOW(),uuid_generate_v4(),103939);

      INSERT INTO edfi.StudentAssessment
            (AssessmentIdentifier,Namespace,StudentAssessmentIdentifier,StudentUSI,AdministrationDate,AdministrationEndDate
                  ,SerialNumber,AdministrationLanguageDescriptorId,AdministrationEnvironmentDescriptorId,RetestIndicatorDescriptorId
            ,ReasonNotTestedDescriptorId,WhenAssessedGradeLevelDescriptorId,EventCircumstanceDescriptorId,EventDescription
            ,SchoolYear,PlatformTypeDescriptorId,Discriminator,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            ('AccessScores_2018','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2018,v_studentFemaleUSI,'20170502',null
            ,null,null,null,null,null,v_gradeLevelDescriptor
            ,null,null,null,null,null,NOW(),NOW(),uuid_generate_v4(),103938);


      INSERT INTO edfi.StudentAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,Namespace,StudentAssessmentIdentifier
            ,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2019',v_AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,3.9,v_ResultDatatypeTypeDescriptorDecimal,NOW());

      INSERT INTO edfi.StudentAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,Namespace,StudentAssessmentIdentifier
            ,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2018',v_AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2018,v_studentFemaleUSI,4.9,v_ResultDatatypeTypeDescriptorDecimal,NOW());


      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('AccessScores_2019','STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('AccessScores_2018','STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2018,v_studentFemaleUSI,NOW());


      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('AccessScores_2019','STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('AccessScores_2018','STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2018,v_studentFemaleUSI,NOW());


      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('AccessScores_2019','STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('AccessScores_2018','STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2018,v_studentFemaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('AccessScores_2019','STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('AccessScores_2018','STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2018,v_studentFemaleUSI,NOW());

      --   student objective score result

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2019',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,'2.5',v_ResultDatatypeTypeDescriptorDecimal,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2018',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Reading','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2018,v_studentFemaleUSI,'5.5',v_ResultDatatypeTypeDescriptorDecimal,NOW());



      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2019',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,'2.5',v_ResultDatatypeTypeDescriptorDecimal,NOW());
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2018',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Speaking','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2018,v_studentFemaleUSI,'5.8',v_ResultDatatypeTypeDescriptorDecimal,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2019',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,'2.5',v_ResultDatatypeTypeDescriptorDecimal,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2018',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Listening','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2018,v_studentFemaleUSI,'2.1',v_ResultDatatypeTypeDescriptorDecimal,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2019',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,'2.5',v_ResultDatatypeTypeDescriptorDecimal,NOW());
      --
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('AccessScores_2018',v_AssessmentReportingMethodDescriptorRawScore,'STAAR Writing','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2018,v_studentFemaleUSI,'3.5',v_ResultDatatypeTypeDescriptorDecimal,NOW());

      --Insert Assigments

      insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
      values('2010-08-23', '20 Exercises', 'ART2-EM', 255901001, 2011, '25590100104Trad322ART2EM12011', '2010-2011 Fall Semester', 933);

      insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
      values('2011-04-12', 'Essay 3 Rough Draft', 'CREAT-WR', 255901001, 2011, '25590100102Trad321CREATWR22011', '2010-2011 Spring Semester', 933);


      insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
      values('2011-04-12', 'Essay Delivery', 'ENVIRSYS', 255901001, 2011, '25590100107Trad222ENVIRSYS2201', '2010-2011 Spring Semester', 933);


      insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
      values('2011-04-12', 'Ch. 10 Exercises', 'SPAN-1', 255901001, 2011, '25590100103Trad324SPAN122011', '2010-2011 Spring Semester', 933);

      insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
      values('2011-04-20', 'Worksheet 22 Simple Physics', 'SS-06', 255901044, 2011,'25590104406Trad112SS0622011', '2010-2011 Spring Semester', 933);
      insert into edfi.GradebookEntry(DateAssigned, GradebookEntryTitle, LocalCourseCode, SchoolId, SchoolYear, SectionIdentifier, SessionName, GradebookEntryTypeDescriptorId)
      values('2011-04-20', 'Essay Delivery', 'SCI-06', 255901044, 2011,'25590104405Trad212SCI0622011', '2010-2011 Spring Semester', 933);


      INSERT INTO edfi.StudentGradebookEntry
            (BeginDate,DateAssigned,GradebookEntryTitle,LocalCourseCode,SchoolId,SchoolYear
            ,SectionIdentifier,SessionName,StudentUSI,DateFulfilled,LetterGradeEarned,NumericGradeEarned
            ,CompetencyLevelDescriptorId,DiagnosticStatement,Discriminator,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            ('2011-01-04','2011-04-12','Assigment 1','ALG-2','255901001','2011','25590100106Trad220ALG222011'
            ,'2010-2011 Spring Semester',435,NULL,'M',92.00,NULL,NULL,NULL,NOW(),NOW(),uuid_generate_v4(),88348);


      INSERT INTO edfi.StudentGradebookEntry
            (BeginDate,DateAssigned,GradebookEntryTitle,LocalCourseCode,SchoolId,SchoolYear
            ,SectionIdentifier,SessionName,StudentUSI,DateFulfilled,LetterGradeEarned,NumericGradeEarned
            ,CompetencyLevelDescriptorId,DiagnosticStatement,Discriminator,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            ('2010-08-23','2010-08-23','20 Exercises','ART2-EM','255901001','2011','25590100104Trad322ART2EM12011'
            ,'2010-2011 Fall Semester',435,NULL,'M',92.00,NULL,NULL,NULL,NOW(),NOW(),uuid_generate_v4(),88348);


      INSERT INTO edfi.StudentGradebookEntry
            (BeginDate,DateAssigned,GradebookEntryTitle,LocalCourseCode,SchoolId,SchoolYear
            ,SectionIdentifier,SessionName,StudentUSI,DateFulfilled,LetterGradeEarned,NumericGradeEarned
            ,CompetencyLevelDescriptorId,DiagnosticStatement,Discriminator,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            ('2011-01-04','2011-04-12','Essay 3 Rough Draft','CREAT-WR','255901001','2011','25590100102Trad321CREATWR22011'
            ,'2010-2011 Spring Semester',435,NULL,'M',92.00,NULL,NULL,NULL,NOW(),NOW(),uuid_generate_v4(),88348);


      INSERT INTO edfi.StudentGradebookEntry
            (BeginDate,DateAssigned,GradebookEntryTitle,LocalCourseCode,SchoolId,SchoolYear
            ,SectionIdentifier,SessionName,StudentUSI,DateFulfilled,LetterGradeEarned,NumericGradeEarned
            ,CompetencyLevelDescriptorId,DiagnosticStatement,Discriminator,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            ('2011-01-04','2011-04-12','Essay Delivery','ENVIRSYS','255901001','2011','25590100107Trad222ENVIRSYS2201'
            ,'2010-2011 Spring Semester',435,NULL,'M',92.00,NULL,NULL,NULL,NOW(),NOW(),uuid_generate_v4(),88348);


      INSERT INTO edfi.StudentGradebookEntry
            (BeginDate,DateAssigned,GradebookEntryTitle,LocalCourseCode,SchoolId,SchoolYear
            ,SectionIdentifier,SessionName,StudentUSI,DateFulfilled,LetterGradeEarned,NumericGradeEarned
            ,CompetencyLevelDescriptorId,DiagnosticStatement,Discriminator,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            ('2011-01-04','2011-04-12','Ch. 10 Exercises','SPAN-1','255901001','2011','25590100103Trad324SPAN122011'
            ,'2010-2011 Spring Semester',435,NULL,'M',92.00,NULL,NULL,NULL,NOW(),NOW(),uuid_generate_v4(),88348);


      INSERT INTO edfi.StudentGradebookEntry
            (BeginDate,DateAssigned,GradebookEntryTitle,LocalCourseCode,SchoolId,SchoolYear
            ,SectionIdentifier,SessionName,StudentUSI,DateFulfilled,LetterGradeEarned,NumericGradeEarned
            ,CompetencyLevelDescriptorId,DiagnosticStatement,Discriminator,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            ('2011-01-04','2011-04-20','Worksheet 22 Simple Physics','SS-06','255901044','2011','25590104406Trad112SS0622011'
            ,'2010-2011 Spring Semester',721,NULL,'M',92.00,NULL,NULL,NULL,NOW(),NOW(),uuid_generate_v4(),88348);

      INSERT INTO edfi.StudentGradebookEntry
            (BeginDate,DateAssigned,GradebookEntryTitle,LocalCourseCode,SchoolId,SchoolYear
            ,SectionIdentifier,SessionName,StudentUSI,DateFulfilled,LetterGradeEarned,NumericGradeEarned
            ,CompetencyLevelDescriptorId,DiagnosticStatement,Discriminator,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            ('2011-01-04','2011-04-20','Essay Delivery','SCI-06','255901044','2011','25590104405Trad212SCI0622011'
            ,'2010-2011 Spring Semester',721,NULL,'M',92.00,NULL,NULL,NULL,NOW(),NOW(),uuid_generate_v4(),88348);

      --Gender Descriptors
      select DescriptorId into v_femaleSexDescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/SexDescriptor' and CodeValue = 'Female'; -- 2091

      select DescriptorId into v_maleSexDescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/SexDescriptor' and CodeValue = 'Male'; -- 2090

      select DescriptorId into v_electronictWorkMailDescriptor from edfi.Descriptor where Namespace = 'uri://ed-fi.org/ElectronicMailTypeDescriptor' and CodeValue = 'Work';

      select DescriptorId into v_fatherRelationDescriptor from edfi.Descriptor where Namespace = 'uri://ed-fi.org/RelationDescriptor' and Description = 'Father';

      select DescriptorId into v_motherRelationDescriptor from edfi.Descriptor where Namespace = 'uri://ed-fi.org/RelationDescriptor' and Description = 'Mother';

      select  descriptorid into v_ResultDatatypeTypeDescriptorLevel from edfi.Descriptor where Namespace = 'uri://ed-fi.org/ResultDatatypeTypeDescriptor' and CodeValue = 'Level';

      select  descriptorid into v_AssessmentCategoryDescriptorId from edfi.Descriptor where Namespace = 'AssessmentCategoryDescriptor' and CodeValue = 'English proficiency test';

      select  descriptorid into v_AcademicSubjectDescriptorId from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AcademicSubjectDescriptor' and CodeValue = 'English';

      select  descriptorid into v_ResultDatatypeTypeDescriptorInteger from edfi.Descriptor where Namespace = 'uri://ed-fi.org/ResultDatatypeTypeDescriptor' and CodeValue = 'Integer';

      select  descriptorid into v_ResultDatatypeTypeDescriptorDecimal from edfi.Descriptor where Namespace = 'uri://ed-fi.org/ResultDatatypeTypeDescriptor' and CodeValue = 'Decimal';

      select  descriptorid into v_AssessmentReportingMethodDescriptorProfencyLevel from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AssessmentReportingMethodDescriptor' and CodeValue = 'Proficiency level';

      select  descriptorid into v_AssessmentReportingMethodDescriptorRawScore from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AssessmentReportingMethodDescriptor' and CodeValue = 'Raw score';

      select  descriptorid into v_AssessmentReportingMethodDescriptorScaleScore from edfi.Descriptor where Namespace = 'uri://ed-fi.org/AssessmentReportingMethodDescriptor' and CodeValue = 'Scale score';

      select  descriptorid into v_gradeLevelDescriptor from edfi.Descriptor where Namespace = 'uri://ed-fi.org/GradeLevelDescriptor' and CodeValue = 'First grade';

      select  descriptorid into v_PerformaceLevelDescriptor from edfi.Descriptor where Namespace = 'uri://ed-fi.org/PerformanceLevelDescriptor' and CodeValue = 'Above Benchmark';


      select  StudentUSI into v_studentMaleUSI from edfi.Student where FirstName = 'Marshall' and LastSurname = 'Terrell';

      select  StudentUSI into v_studentFemaleUSI from edfi.Student where FirstName = 'Hannah' and LastSurname = 'Terrell';
      -----------------------------------------------------------------------------------------------
      --Assesment
      insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentVersion)
      values('ARC_ENIL', 'uri://ed-fi.org/Assessment/Assessment.xml', 'ARC ENIL Scores', 2019);

      insert into edfi.Assessment(AssessmentIdentifier, Namespace, AssessmentTitle, AssessmentVersion)
      values('ARC_IRLA', 'uri://ed-fi.org/Assessment/Assessment.xml', 'ARC IRLA Scores',  2019);


      -------------Assesment Score
      INSERT INTO edfi.AssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,Namespace
            ,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_ENIL',v_AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml',null,null,
                  v_ResultDatatypeTypeDescriptorDecimal,NOW());

      INSERT INTO edfi.AssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,Namespace
            ,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_IRLA',v_AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml',null,null,
                  v_ResultDatatypeTypeDescriptorDecimal,NOW());



      -----------------------Objetive Assesment
      INSERT INTO edfi.ObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,MaxRawScore
            ,PercentOfAssessment,Nomenclature,Description,ParentIdentificationCode
            ,AcademicSubjectDescriptorId,Discriminator,CreateDate,LastModifiedDate
            ,Id,ChangeVersion)
      VALUES
            ('ARC_ENIL','ARC Reading Level','uri://ed-fi.org/Assessment/Assessment.xml',null,
                  null,null,null,null,null,null,NOW(),NOW(),uuid_generate_v4(),15000);
      INSERT INTO edfi.ObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,MaxRawScore
            ,PercentOfAssessment,Nomenclature,Description,ParentIdentificationCode
            ,AcademicSubjectDescriptorId,Discriminator,CreateDate,LastModifiedDate
            ,Id,ChangeVersion)
      VALUES
            ('ARC_ENIL','ARC Days on Current Power Goal','uri://ed-fi.org/Assessment/Assessment.xml',null,
                  null,null,null,null,null,null,NOW(),NOW(),uuid_generate_v4(),15000);
      INSERT INTO edfi.ObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,MaxRawScore
            ,PercentOfAssessment,Nomenclature,Description,ParentIdentificationCode
            ,AcademicSubjectDescriptorId,Discriminator,CreateDate,LastModifiedDate
            ,Id,ChangeVersion)
      VALUES
            ('ARC_ENIL','ARC Reading Level (Baseline)','uri://ed-fi.org/Assessment/Assessment.xml',null,
                  null,null,null,null,null,null,NOW(),NOW(),uuid_generate_v4(),15000);
      INSERT INTO edfi.ObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,MaxRawScore
            ,PercentOfAssessment,Nomenclature,Description,ParentIdentificationCode
            ,AcademicSubjectDescriptorId,Discriminator,CreateDate,LastModifiedDate
            ,Id,ChangeVersion)
      VALUES
            ('ARC_ENIL','ARC Score','uri://ed-fi.org/Assessment/Assessment.xml',null,
                  null,null,null,null,null,null,NOW(),NOW(),uuid_generate_v4(),15000);
      INSERT INTO edfi.ObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,MaxRawScore
            ,PercentOfAssessment,Nomenclature,Description,ParentIdentificationCode
            ,AcademicSubjectDescriptorId,Discriminator,CreateDate,LastModifiedDate
            ,Id,ChangeVersion)
      VALUES
            ('ARC_ENIL','ARC Baseline Reporting Date','uri://ed-fi.org/Assessment/Assessment.xml',null,
                  null,null,null,null,null,null,NOW(),NOW(),uuid_generate_v4(),15000);

      INSERT INTO edfi.ObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,MaxRawScore
            ,PercentOfAssessment,Nomenclature,Description,ParentIdentificationCode
            ,AcademicSubjectDescriptorId,Discriminator,CreateDate,LastModifiedDate
            ,Id,ChangeVersion)
      VALUES
            ('ARC_IRLA','ARC Reading Level','uri://ed-fi.org/Assessment/Assessment.xml',null,
                  null,null,null,null,null,null,NOW(),NOW(),uuid_generate_v4(),15000);
      INSERT INTO edfi.ObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,MaxRawScore
            ,PercentOfAssessment,Nomenclature,Description,ParentIdentificationCode
            ,AcademicSubjectDescriptorId,Discriminator,CreateDate,LastModifiedDate
            ,Id,ChangeVersion)
      VALUES
            ('ARC_IRLA','ARC Days on Current Power Goal','uri://ed-fi.org/Assessment/Assessment.xml',null,
                  null,null,null,null,null,null,NOW(),NOW(),uuid_generate_v4(),15000);
      INSERT INTO edfi.ObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,MaxRawScore
            ,PercentOfAssessment,Nomenclature,Description,ParentIdentificationCode
            ,AcademicSubjectDescriptorId,Discriminator,CreateDate,LastModifiedDate
            ,Id,ChangeVersion)
      VALUES
            ('ARC_IRLA','ARC Reading Level (Baseline)','uri://ed-fi.org/Assessment/Assessment.xml',null,
                  null,null,null,null,null,null,NOW(),NOW(),uuid_generate_v4(),15000);
      INSERT INTO edfi.ObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,MaxRawScore
            ,PercentOfAssessment,Nomenclature,Description,ParentIdentificationCode
            ,AcademicSubjectDescriptorId,Discriminator,CreateDate,LastModifiedDate
            ,Id,ChangeVersion)
      VALUES
            ('ARC_IRLA','ARC Score','uri://ed-fi.org/Assessment/Assessment.xml',null,
                  null,null,null,null,null,null,NOW(),NOW(),uuid_generate_v4(),15000);
      INSERT INTO edfi.ObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,MaxRawScore
            ,PercentOfAssessment,Nomenclature,Description,ParentIdentificationCode
            ,AcademicSubjectDescriptorId,Discriminator,CreateDate,LastModifiedDate
            ,Id,ChangeVersion)
      VALUES
            ('ARC_IRLA','ARC Baseline Reporting Date','uri://ed-fi.org/Assessment/Assessment.xml',null,
                  null,null,null,null,null,null,NOW(),NOW(),uuid_generate_v4(),15000);

      -----------------------Objetive AssesmentScore
      INSERT INTO edfi.ObjectiveAssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode
            ,Namespace,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_ENIL',v_AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level',
                  'uri://ed-fi.org/Assessment/Assessment.xml',null,null,v_ResultDatatypeTypeDescriptorLevel,NOW());

      INSERT INTO edfi.ObjectiveAssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode
            ,Namespace,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_ENIL',v_AssessmentReportingMethodDescriptorRawScore,'ARC Days on Current Power Goal',
                  'uri://ed-fi.org/Assessment/Assessment.xml',null,null,v_ResultDatatypeTypeDescriptorInteger,NOW());

      INSERT INTO edfi.ObjectiveAssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode
            ,Namespace,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_ENIL',v_AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level (Baseline)',
                  'uri://ed-fi.org/Assessment/Assessment.xml',null,null,v_ResultDatatypeTypeDescriptorLevel,NOW());

      INSERT INTO edfi.ObjectiveAssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode
            ,Namespace,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_ENIL',v_AssessmentReportingMethodDescriptorRawScore,'ARC Score',
                  'uri://ed-fi.org/Assessment/Assessment.xml',null,null,v_ResultDatatypeTypeDescriptorDecimal,NOW());

      INSERT INTO edfi.ObjectiveAssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode
            ,Namespace,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_ENIL',v_AssessmentReportingMethodDescriptorRawScore,'ARC Baseline Reporting Date',
                  'uri://ed-fi.org/Assessment/Assessment.xml',null,null,v_ResultDatatypeTypeDescriptorDecimal,NOW());

      INSERT INTO edfi.ObjectiveAssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode
            ,Namespace,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_IRLA',v_AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level',
                  'uri://ed-fi.org/Assessment/Assessment.xml',null,null,v_ResultDatatypeTypeDescriptorLevel,NOW());

      INSERT INTO edfi.ObjectiveAssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode
            ,Namespace,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_IRLA',v_AssessmentReportingMethodDescriptorRawScore,'ARC Days on Current Power Goal',
                  'uri://ed-fi.org/Assessment/Assessment.xml',null,null,v_ResultDatatypeTypeDescriptorInteger,NOW());

      INSERT INTO edfi.ObjectiveAssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode
            ,Namespace,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_IRLA',v_AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level (Baseline)',
                  'uri://ed-fi.org/Assessment/Assessment.xml',null,null,v_ResultDatatypeTypeDescriptorLevel,NOW());

      INSERT INTO edfi.ObjectiveAssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode
            ,Namespace,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_IRLA',v_AssessmentReportingMethodDescriptorRawScore,'ARC Score',
                  'uri://ed-fi.org/Assessment/Assessment.xml',null,null,v_ResultDatatypeTypeDescriptorDecimal,NOW());

      INSERT INTO edfi.ObjectiveAssessmentScore
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode
            ,Namespace,MinimumScore,MaximumScore,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_IRLA',v_AssessmentReportingMethodDescriptorRawScore,'ARC Baseline Reporting Date',
                  'uri://ed-fi.org/Assessment/Assessment.xml',null,null,v_ResultDatatypeTypeDescriptorDecimal,NOW());

      --Student assesment
      INSERT INTO edfi.StudentAssessment
            (AssessmentIdentifier,Namespace,StudentAssessmentIdentifier,StudentUSI,AdministrationDate,AdministrationEndDate
                  ,SerialNumber,AdministrationLanguageDescriptorId,AdministrationEnvironmentDescriptorId,RetestIndicatorDescriptorId
            ,ReasonNotTestedDescriptorId,WhenAssessedGradeLevelDescriptorId,EventCircumstanceDescriptorId,EventDescription
            ,SchoolYear,PlatformTypeDescriptorId,Discriminator,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            ('ARC_ENIL','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,'20170502',null
            ,null,null,null,null,null,null
            ,null,null,null,null,null,NOW(),NOW(),uuid_generate_v4(),103939);

      INSERT INTO edfi.StudentAssessment
            (AssessmentIdentifier,Namespace,StudentAssessmentIdentifier,StudentUSI,AdministrationDate,AdministrationEndDate
                  ,SerialNumber,AdministrationLanguageDescriptorId,AdministrationEnvironmentDescriptorId,RetestIndicatorDescriptorId
            ,ReasonNotTestedDescriptorId,WhenAssessedGradeLevelDescriptorId,EventCircumstanceDescriptorId,EventDescription
            ,SchoolYear,PlatformTypeDescriptorId,Discriminator,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            ('ARC_IRLA','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale20192,v_studentFemaleUSI,'20170502',null
            ,null,null,null,null,null,null
            ,null,null,null,null,null,NOW(),NOW(),uuid_generate_v4(),103939);

      INSERT INTO edfi.StudentAssessment
            (AssessmentIdentifier,Namespace,StudentAssessmentIdentifier,StudentUSI,AdministrationDate,AdministrationEndDate
                  ,SerialNumber,AdministrationLanguageDescriptorId,AdministrationEnvironmentDescriptorId,RetestIndicatorDescriptorId
            ,ReasonNotTestedDescriptorId,WhenAssessedGradeLevelDescriptorId,EventCircumstanceDescriptorId,EventDescription
            ,SchoolYear,PlatformTypeDescriptorId,Discriminator,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            ('ARC_ENIL','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2019,v_studentMaleUSI,'20170502',null
            ,null,null,null,null,null,null
            ,null,null,null,null,null,NOW(),NOW(),uuid_generate_v4(),103939);

      INSERT INTO edfi.StudentAssessment
            (AssessmentIdentifier,Namespace,StudentAssessmentIdentifier,StudentUSI,AdministrationDate,AdministrationEndDate
                  ,SerialNumber,AdministrationLanguageDescriptorId,AdministrationEnvironmentDescriptorId,RetestIndicatorDescriptorId
            ,ReasonNotTestedDescriptorId,WhenAssessedGradeLevelDescriptorId,EventCircumstanceDescriptorId,EventDescription
            ,SchoolYear,PlatformTypeDescriptorId,Discriminator,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            ('ARC_IRLA','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale20192,v_studentMaleUSI,'20170502',null
            ,null,null,null,null,null,null
            ,null,null,null,null,null,NOW(),NOW(),uuid_generate_v4(),103939);

      ----------------------
      INSERT INTO edfi.StudentAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,Namespace,StudentAssessmentIdentifier
            ,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_ENIL',v_AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml',
                  v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,3.9,v_ResultDatatypeTypeDescriptorDecimal,NOW());

      INSERT INTO edfi.StudentAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,Namespace,StudentAssessmentIdentifier
            ,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_IRLA',v_AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml',
                  v_AssesmentIdentifierFemale20192,v_studentFemaleUSI,4.9,v_ResultDatatypeTypeDescriptorDecimal,NOW());

      --boy assesments
      INSERT INTO edfi.StudentAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,Namespace,StudentAssessmentIdentifier
            ,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_ENIL',v_AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml',
                  v_AssesmentIdentifierMale2019,v_studentMaleUSI,3.9,v_ResultDatatypeTypeDescriptorDecimal,NOW());

      INSERT INTO edfi.StudentAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,Namespace,StudentAssessmentIdentifier
            ,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_IRLA',v_AssessmentReportingMethodDescriptorRawScore,'uri://ed-fi.org/Assessment/Assessment.xml',
                  v_AssesmentIdentifierMale20192,v_studentMaleUSI,5.9,v_ResultDatatypeTypeDescriptorDecimal,NOW());


      --student assesmnet objteinces
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('ARC_ENIL','ARC Reading Level','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('ARC_ENIL','ARC Days on Current Power Goal','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('ARC_ENIL','ARC Reading Level (Baseline)','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('ARC_ENIL','ARC Score','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('ARC_ENIL','ARC Baseline Reporting Date','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,NOW());

      ---------


      --  DEMO *** oy assesment
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('ARC_ENIL','ARC Reading Level','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2019,v_studentMaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('ARC_ENIL','ARC Days on Current Power Goal','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2019,v_studentMaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('ARC_ENIL','ARC Reading Level (Baseline)','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2019,v_studentMaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('ARC_ENIL','ARC Score','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2019,v_studentMaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('ARC_ENIL','ARC Baseline Reporting Date','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2019,v_studentMaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('ARC_IRLA','ARC Reading Level','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale20192,v_studentMaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('ARC_IRLA','ARC Days on Current Power Goal','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale20192,v_studentMaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('ARC_IRLA','ARC Reading Level (Baseline)','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale20192,v_studentMaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('ARC_IRLA','ARC Score','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale20192,v_studentMaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('ARC_IRLA','ARC Baseline Reporting Date','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale20192,v_studentMaleUSI,NOW());


      --  Demo Student Assessments
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('ARC_IRLA','ARC Reading Level','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale20192,v_studentFemaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('ARC_IRLA','ARC Days on Current Power Goal','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale20192,v_studentFemaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('ARC_IRLA','ARC Reading Level (Baseline)','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale20192,v_studentFemaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('ARC_IRLA','ARC Score','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale20192,v_studentFemaleUSI,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment
            (AssessmentIdentifier,IdentificationCode,Namespace,StudentAssessmentIdentifier,StudentUSI,CreateDate)
      VALUES
            ('ARC_IRLA','ARC Baseline Reporting Date','uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale20192,v_studentFemaleUSI,NOW());




      --  Demo Student Score

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_ENIL',v_AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level',
                  'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,'PI',
                  v_ResultDatatypeTypeDescriptorLevel,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_ENIL',v_AssessmentReportingMethodDescriptorRawScore,'ARC Days on Current Power Goal',
                  'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,10,
                  v_ResultDatatypeTypeDescriptorInteger,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_ENIL',v_AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level (Baseline)',
                  'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,'PI',
                  v_ResultDatatypeTypeDescriptorLevel,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_ENIL',v_AssessmentReportingMethodDescriptorRawScore,'ARC Score',
                  'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,10,
                  v_ResultDatatypeTypeDescriptorDecimal,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_ENIL',v_AssessmentReportingMethodDescriptorRawScore,'ARC Baseline Reporting Date',
                  'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale2019,v_studentFemaleUSI,'9/17/2019',
                  v_ResultDatatypeTypeDescriptorLevel,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_IRLA',v_AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level',
                  'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale20192,v_studentFemaleUSI,'Si',
                  v_ResultDatatypeTypeDescriptorLevel,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_IRLA',v_AssessmentReportingMethodDescriptorRawScore,'ARC Days on Current Power Goal',
                  'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale20192,v_studentFemaleUSI,22,
                  v_ResultDatatypeTypeDescriptorInteger,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_IRLA',v_AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level (Baseline)',
                  'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale20192,v_studentFemaleUSI,'Si',
                  v_ResultDatatypeTypeDescriptorLevel,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_IRLA',v_AssessmentReportingMethodDescriptorRawScore,'ARC Score',
                  'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale20192,v_studentFemaleUSI,5.42,
                  v_ResultDatatypeTypeDescriptorDecimal,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_IRLA',v_AssessmentReportingMethodDescriptorRawScore,'ARC Baseline Reporting Date',
                  'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierFemale20192,v_studentFemaleUSI,'9/17/2019',
                  v_ResultDatatypeTypeDescriptorLevel,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_ENIL',v_AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level',
                  'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2019,v_studentMaleUSI,'Pu',
                  v_ResultDatatypeTypeDescriptorLevel,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_ENIL',v_AssessmentReportingMethodDescriptorRawScore,'ARC Days on Current Power Goal',
                  'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2019,v_studentMaleUSI,80,
                  v_ResultDatatypeTypeDescriptorInteger,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_ENIL',v_AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level (Baseline)',
                  'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2019,v_studentMaleUSI,'Pu',
                  v_ResultDatatypeTypeDescriptorLevel,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_ENIL',v_AssessmentReportingMethodDescriptorRawScore,'ARC Score',
                  'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2019,v_studentMaleUSI,10,
                  v_ResultDatatypeTypeDescriptorDecimal,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_ENIL',v_AssessmentReportingMethodDescriptorRawScore,'ARC Baseline Reporting Date',
                  'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale2019,v_studentMaleUSI,'9/17/2019',
                  v_ResultDatatypeTypeDescriptorLevel,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_IRLA',v_AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level',
                  'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale20192,v_studentMaleUSI,'Pu',
                  v_ResultDatatypeTypeDescriptorLevel,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_IRLA',v_AssessmentReportingMethodDescriptorRawScore,'ARC Days on Current Power Goal',
                  'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale20192,v_studentMaleUSI,22,
                  v_ResultDatatypeTypeDescriptorInteger,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_IRLA',v_AssessmentReportingMethodDescriptorRawScore,'ARC Reading Level (Baseline)',
                  'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale20192,v_studentMaleUSI,'Pu',
                  v_ResultDatatypeTypeDescriptorLevel,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_IRLA',v_AssessmentReportingMethodDescriptorRawScore,'ARC Score',
                  'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale20192,v_studentMaleUSI,5.42,
                  v_ResultDatatypeTypeDescriptorDecimal,NOW());

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult
            (AssessmentIdentifier,AssessmentReportingMethodDescriptorId,IdentificationCode,Namespace
            ,StudentAssessmentIdentifier,StudentUSI,Result,ResultDatatypeTypeDescriptorId,CreateDate)
      VALUES
            ('ARC_IRLA',v_AssessmentReportingMethodDescriptorRawScore,'ARC Baseline Reporting Date',
                  'uri://ed-fi.org/Assessment/Assessment.xml',v_AssesmentIdentifierMale20192,v_studentMaleUSI,'9/17/2019',
                  v_ResultDatatypeTypeDescriptorLevel,NOW());

      select  StudentUSI into v_studentMaleUSI from edfi.Student where FirstName = 'Marshall' and LastSurname = 'Terrell';

      select  StudentUSI into v_studentFemaleUSI from edfi.Student where FirstName = 'Hannah' and LastSurname = 'Terrell';

      --select * FROM EDFI.Descriptor WHERE Namespace = 'uri://ed-fi.org/CalendarTypeDescriptor' and CodeValue = 'School' 

      select DescriptorId into v_calendarType FROM EDFI.Descriptor WHERE Namespace = 'uri://ed-fi.org/CalendarTypeDescriptor' and CodeValue = 'School';

      select  DescriptorId into v_nonintructionalday FROM EDFI.Descriptor WHERE Namespace = 'uri://ed-fi.org/CalendarEventDescriptor' and CodeValue = 'Other';

      --Calendar for each school
      INSERT INTO EDFI.Calendar VALUES(v_highSchoolId,v_highSchoolId,2011,v_calendarType,null,NOW(),NOW(),uuid_generate_v4(),11815);
      INSERT INTO EDFI.Calendar VALUES(v_middleSchoolId,v_middleSchoolId,2011,v_calendarType,null,NOW(),NOW(),uuid_generate_v4(),11815);
      --Dates for each school
      INSERT INTO EDFI.CalendarDate VALUES(v_highSchoolId,'20111124',v_highSchoolId,2011,null,NOW(),NOW(),uuid_generate_v4(),11815);
      INSERT INTO EDFI.CalendarDate VALUES(v_highSchoolId,'20111125',v_highSchoolId,2011,null,NOW(),NOW(),uuid_generate_v4(),11815);
      INSERT INTO EDFI.CalendarDate VALUES(v_highSchoolId,'20110425',v_highSchoolId,2011,null,NOW(),NOW(),uuid_generate_v4(),11815);
      INSERT INTO EDFI.CalendarDate VALUES(v_highSchoolId,'20110426',v_highSchoolId,2011,null,NOW(),NOW(),uuid_generate_v4(),11815);
      INSERT INTO EDFI.CalendarDate VALUES(v_highSchoolId,'20110427',v_highSchoolId,2011,null,NOW(),NOW(),uuid_generate_v4(),11815);
      INSERT INTO EDFI.CalendarDate VALUES(v_highSchoolId,'20110428',v_highSchoolId,2011,null,NOW(),NOW(),uuid_generate_v4(),11815);
      INSERT INTO EDFI.CalendarDate VALUES(v_highSchoolId,'20110429',v_highSchoolId,2011,null,NOW(),NOW(),uuid_generate_v4(),11815);

      INSERT INTO EDFI.CalendarDate VALUES(v_middleSchoolId,'20111124',v_middleSchoolId,2011,null,NOW(),NOW(),uuid_generate_v4(),11815);
      INSERT INTO EDFI.CalendarDate VALUES(v_middleSchoolId,'20111125',v_middleSchoolId,2011,null,NOW(),NOW(),uuid_generate_v4(),11815);
      INSERT INTO EDFI.CalendarDate VALUES(v_middleSchoolId,'20110425',v_middleSchoolId,2011,null,NOW(),NOW(),uuid_generate_v4(),11815);
      INSERT INTO EDFI.CalendarDate VALUES(v_middleSchoolId,'20110426',v_middleSchoolId,2011,null,NOW(),NOW(),uuid_generate_v4(),11815);
      INSERT INTO EDFI.CalendarDate VALUES(v_middleSchoolId,'20110427',v_middleSchoolId,2011,null,NOW(),NOW(),uuid_generate_v4(),11815);
      INSERT INTO EDFI.CalendarDate VALUES(v_middleSchoolId,'20110428',v_middleSchoolId,2011,null,NOW(),NOW(),uuid_generate_v4(),11815);
      INSERT INTO EDFI.CalendarDate VALUES(v_middleSchoolId,'20110429',v_middleSchoolId,2011,null,NOW(),NOW(),uuid_generate_v4(),11815);
      --NonInstructionalDays for each school
      INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(v_highSchoolId,v_nonintructionalday,'20111124',v_highSchoolId,2011,NOW());
      INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(v_highSchoolId,v_nonintructionalday,'20111125',v_highSchoolId,2011,NOW());
      INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(v_highSchoolId,v_nonintructionalday,'20110425',v_highSchoolId,2011,NOW());
      INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(v_highSchoolId,v_nonintructionalday,'20110426',v_highSchoolId,2011,NOW());
      INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(v_highSchoolId,v_nonintructionalday,'20110427',v_highSchoolId,2011,NOW());
      INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(v_highSchoolId,v_nonintructionalday,'20110428',v_highSchoolId,2011,NOW());
      INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(v_highSchoolId,v_nonintructionalday,'20110429',v_highSchoolId,2011,NOW());

      INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(v_middleSchoolId,v_nonintructionalday,'20111124',v_middleSchoolId,2011,NOW());
      INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(v_middleSchoolId,v_nonintructionalday,'20111125',v_middleSchoolId,2011,NOW());
      INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(v_middleSchoolId,v_nonintructionalday,'20110425',v_middleSchoolId,2011,NOW());
      INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(v_middleSchoolId,v_nonintructionalday,'20110426',v_middleSchoolId,2011,NOW());
      INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(v_middleSchoolId,v_nonintructionalday,'20110427',v_middleSchoolId,2011,NOW());
      INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(v_middleSchoolId,v_nonintructionalday,'20110428',v_middleSchoolId,2011,NOW());
      INSERT INTO EDFI.CalendarDateCalendarEvent VALUES(v_middleSchoolId,v_nonintructionalday,'20110429',v_middleSchoolId,2011,NOW());

      --STAR READING ASSESMENT 360
      --select * from edfi.[Assessment] where AssessmentIdentifier = 'STAR_Reading_2019'

      INSERT INTO edfi.Assessment
            (AssessmentIdentifier,Namespace,AssessmentTitle,AssessmentCategoryDescriptorId,AssessmentForm,AssessmentVersion,RevisionDate,
                  MaxRawScore,Nomenclature,AssessmentFamily,EducationOrganizationId,AdaptiveAssessment,Discriminator,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            (N'STAR_Reading_2019',N'http://ed-fi.org/Assessment/Assessment.xml',N'STAR Reading',NULL,NULL,2011
            ,NULL,NULL,NULL,NULL,v_highSchoolId,NULL,NULL,NOW(),NOW(),uuid_generate_v4(),19000);

      --select * from edfi.ObjectiveAssessment where AssessmentIdentifier = 'STAR_Reading_2019'

      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Foundational Skills', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Foundational Skills', NULL, '2020-01-16 12:07:54', '2020-01-16 12:07:54', 'df59bc0c-ac52-4e23-9bb7-d273bf6666c8');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Informational Text', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Informational Text', NULL, '2020-01-16 12:07:54', '2020-01-16 12:07:54', 'a54be617-cc0f-4d17-b2ce-cff1163b7082');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Language', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Language', NULL, '2020-01-16 12:07:54', '2020-01-16 12:07:54', 'cdc0c889-f0e7-40e8-9a46-dbfce63e5ec2');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Literature', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Literature', NULL, '2020-01-16 12:07:54', '2020-01-16 12:07:54', 'd33576f6-1f4a-4179-a1be-b9358e8e13eb');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Foundational Skills_Fluency', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Fluency', N'Foundational Skills', '2020-01-16 12:07:54', '2020-01-16 12:07:54', '2d98263c-e382-45c4-8adf-fe1484ac736d');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Foundational Skills_Phonics and Word Recognition', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Phonics and Word Recognition', N'Foundational Skills', '2020-01-16 12:07:54', '2020-01-16 12:07:54', 'c036728c-2544-4fad-8470-2d33fce270b9');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Foundational Skills_Fluency_Purpose for Reading', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Purpose for Reading', N'Foundational Skills_Fluency', '2020-01-16 12:07:55', '2020-01-16 12:07:55', 'e03071ff-cdf8-4c0e-9a69-e25015aa687e');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Foun_Phon_IrregularSpellings/High-FrequencyandExceptionWords', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Irregular Spellings / High-Frequency and Exception Words', N'Foundational Skills_Phonics and Word Recognition', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '29b703c6-af91-4192-9ba3-cb3a92e5b83b');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Foun_Phon_StructuralAnalysis', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Structural Analysis', N'Foundational Skills_Phonics and Word Recognition', '2020-01-16 12:07:55', '2020-01-16 12:07:55', 'b8e790d8-6cd6-49a2-ac83-cd5e5132feb4');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Info_RangeofReadingandLevelofTextComplexity_', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Range of Reading and Level of Text Complexity', N'Informational Text', '2020-01-16 12:07:54', '2020-01-16 12:07:54', '110160fa-a05f-4cf2-9c72-3bfac5e96549');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Informational Text_Craft and Structure', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Craft and Structure', N'Informational Text', '2020-01-16 12:07:54', '2020-01-16 12:07:54', '0cd6d739-23df-4a54-a794-6d3ddbd68a40');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Informational Text_Integration of Knowledge and Ideas', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Integration of Knowledge and Ideas', N'Informational Text', '2020-01-16 12:07:54', '2020-01-16 12:07:54', '4a62a5d0-4e12-425f-8669-de1dcd29a4e8');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Key Ideas and Details', N'Informational Text', '2020-01-16 12:07:54', '2020-01-16 12:07:54', '1f6791a4-0a66-47ff-9544-510a6d3ae279');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Informational Text_Craft and Structure_Argumentation', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Argumentation', N'Informational Text_Craft and Structure', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '1dba57bb-0f73-4b5e-a3e3-5dea92f9702f');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Informational Text_Craft and Structure_Text Features', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Text Features', N'Informational Text_Craft and Structure', '2020-01-16 12:07:55', '2020-01-16 12:07:55', 'cf413737-7e93-4441-8c93-863ce0cef2db');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Info_Craf_Author''sPurposeandPerspective', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Author''s Purpose and Perspective', N'Informational Text_Craft and Structure', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '5414185d-b974-4cf5-93c7-a8f6eb09f56a');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Info_Craf_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Author''s Word Choice and Figurative Language', N'Informational Text_Craft and Structure', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '22cb86b8-92ab-4785-a75f-afe5b484035d');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Info_Craf_StructureandOrganization', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Structure and Organization', N'Informational Text_Craft and Structure', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '3ebbed80-4df7-4a17-9cb9-6111593c130c');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Info_Inte_AnalysisandComparison', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Analysis and Comparison', N'Informational Text_Integration of Knowledge and Ideas', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '4e3a381c-c6e8-4e5b-9008-67e8f366f6df');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Info_Inte_Argumentation', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Argumentation', N'Informational Text_Integration of Knowledge and Ideas', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '4c4bf4fa-13e2-4d72-bf8f-4abf4bffac4f');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Info_Inte_Author''sPurposeandPerspective', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Author''s Purpose and Perspective', N'Informational Text_Integration of Knowledge and Ideas', '2020-01-16 12:07:55', '2020-01-16 12:07:55', 'a3ff84bf-59a9-405c-ab6c-ccbe76f1a047');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Info_Inte_ModesofRepresentation', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Modes of Representation', N'Informational Text_Integration of Knowledge and Ideas', '2020-01-16 12:07:55', '2020-01-16 12:07:55', 'e90fe3f4-7cd0-439f-9591-38dca770411f');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Info_Key _CompareandContrast', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Compare and Contrast', N'Informational Text_Key Ideas and Details', '2020-01-16 12:07:55', '2020-01-16 12:07:55', 'f5ef78f8-e052-461d-ad88-94a7fa92eef0');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Info_Key _InferenceandEvidence', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Inference and Evidence', N'Informational Text_Key Ideas and Details', '2020-01-16 12:07:55', '2020-01-16 12:07:55', 'b3e74f99-6dae-4f1a-ab4d-2b978684c172');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Info_Key _MainIdeaandDetails', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Main Idea and Details', N'Informational Text_Key Ideas and Details', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '76acb935-2fa1-429d-ab2c-d40a1600bc41');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Cause and Effect', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Cause and Effect', N'Informational Text_Key Ideas and Details', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '0a680e31-17ac-40e8-a610-c984cec23a04');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Prediction', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Prediction', N'Informational Text_Key Ideas and Details', '2020-01-16 12:07:55', '2020-01-16 12:07:55', 'df7d7ef9-7872-4a2d-932e-3114896af2c2');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Sequence', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Sequence', N'Informational Text_Key Ideas and Details', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '76069df1-0bc8-41ea-8eec-bdfa937853d4');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Summary', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Summary', N'Informational Text_Key Ideas and Details', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '5461b71a-a519-4f18-ac40-7e4b8292e3df');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Vocabulary Acquisition and Use', N'Language', '2020-01-16 12:07:54', '2020-01-16 12:07:54', '03a3d44b-67b4-457c-b474-80b6fd703c33');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Connotation', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Connotation', N'Language_Vocabulary Acquisition and Use', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '57fb8410-f369-4f2f-8b7d-93aeb3a2e3c1');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Context Clues', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Context Clues', N'Language_Vocabulary Acquisition and Use', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '070629ff-a2f3-4f1a-a224-170b5a8d7e1a');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Figures of Speech', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Figures of Speech', N'Language_Vocabulary Acquisition and Use', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '5f6ad665-7093-416c-8dfa-c2372c5edc02');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Structural Analysis', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Structural Analysis', N'Language_Vocabulary Acquisition and Use', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '9dff77c8-0052-48fe-872e-5151551ef179');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Word Relationships', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Word Relationships', N'Language_Vocabulary Acquisition and Use', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '0999ac6a-4fca-4415-86f6-f22f6b32ea4a');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Lang_Voca_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Author''s Word Choice and Figurative Language', N'Language_Vocabulary Acquisition and Use', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '2dc87890-910d-4a13-955b-5af899b87a89');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Lang_Voca_Multiple-MeaningWords', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Multiple-Meaning Words', N'Language_Vocabulary Acquisition and Use', '2020-01-16 12:07:55', '2020-01-16 12:07:55', 'e1afb6b4-df12-47de-a46a-e989d4173599');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Lang_Voca_SynonymsandAntonyms', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Synonyms and Antonyms', N'Language_Vocabulary Acquisition and Use', '2020-01-16 12:07:55', '2020-01-16 12:07:55', 'd6e1f738-65ea-4a3c-ad51-b834a9f43957');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Lang_Voca_VocabularyinContext', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Vocabulary in Context', N'Language_Vocabulary Acquisition and Use', '2020-01-16 12:07:55', '2020-01-16 12:07:55', 'c6458353-964f-4e20-8b4e-1bc107261c53');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Lang_Voca_WordMeaningandReferenceMaterials', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Word Meaning and Reference Materials', N'Language_Vocabulary Acquisition and Use', '2020-01-16 12:07:55', '2020-01-16 12:07:55', 'fee11dd7-5095-4742-bb54-408aaa33be73');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Literature_Range of Reading and Level of Text Complexity', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Range of Reading and Level of Text Complexity', N'Literature', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '79487461-7e03-4b13-ba24-f8ae36d25a45');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Literature_Craft and Structure', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Craft and Structure', N'Literature', '2020-01-16 12:07:54', '2020-01-16 12:07:54', '1de79531-9658-4f89-a08f-dd7c2f8b2ae1');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Literature_Integration of Knowledge and Ideas', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Integration of Knowledge and Ideas', N'Literature', '2020-01-16 12:07:54', '2020-01-16 12:07:54', '7b81e6fb-2061-4ebb-a17d-bccaabdb9d96');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Key Ideas and Details', N'Literature', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '6a16202f-b0ae-432b-8d08-d473b2022552');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Literature_Craft and Structure_Character and Plot', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Character and Plot', N'Literature_Craft and Structure', '2020-01-16 12:07:55', '2020-01-16 12:07:55', 'c225ee84-516d-4a02-9551-9b65ef6d5850');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Literature_Craft and Structure_Connotation', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Connotation', N'Literature_Craft and Structure', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '6196fac3-cb36-4283-a48c-c685cb1115a3');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Literature_Craft and Structure_Point of View', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Point of View', N'Literature_Craft and Structure', '2020-01-16 12:07:55', '2020-01-16 12:07:55', 'f571d1bc-5c9e-4204-a24f-2b1e5b962fe8');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Literature_Craft and Structure_Structure and Organization', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Structure and Organization', N'Literature_Craft and Structure', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '3e5ab131-057c-4415-8a03-2bc7c2ab2cbe');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Lite_Craf_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Author''s Word Choice and Figurative Language', N'Literature_Craft and Structure', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '5b1d2850-14e0-4581-96d7-3925a0d206b6');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Lite_Craf_ConventionsandRangeofReading', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Conventions and Range of Reading', N'Literature_Craft and Structure', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '27b190e3-b17e-4318-9c7a-e0926894cbf3');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Lite_Inte_AnalysisandComparison', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Analysis and Comparison', N'Literature_Integration of Knowledge and Ideas', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '52cce551-9309-421a-80f6-b7dc0978f91d');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Character and Plot', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Character and Plot', N'Literature_Key Ideas and Details', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '7f6874bf-af49-4da6-8641-b3ef14f6fd26');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Inference and Evidence', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Inference and Evidence', N'Literature_Key Ideas and Details', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '628cfc0d-25fc-459c-9aad-fa4cbbef789f');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Setting', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Setting', N'Literature_Key Ideas and Details', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '0ba2b0fe-8b1e-4e31-a8bd-6a16cf8f76da');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Summary', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Summary', N'Literature_Key Ideas and Details', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '834bd035-b925-41bc-926c-7f3a358508f9');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Theme', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Theme', N'Literature_Key Ideas and Details', '2020-01-16 12:07:55', '2020-01-16 12:07:55', '72ffba9a-2fef-4388-86b6-0c1fa0cf0017');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Reading_2019', N'Lite_Rang_ConventionsandRangeofReading', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Conventions and Range of Reading', N'Literature_Range of Reading and Level of Text Complexity', '2020-01-16 12:07:55', '2020-01-16 12:07:55', 'e126d961-2dec-459d-b55a-e5a69c5b8f72');

      INSERT INTO edfi.StudentAssessment
            (AssessmentIdentifier,Namespace,StudentAssessmentIdentifier,StudentUSI,AdministrationDate,AdministrationEndDate,SerialNumber,AdministrationLanguageDescriptorId
            ,AdministrationEnvironmentDescriptorId,RetestIndicatorDescriptorId,ReasonNotTestedDescriptorId,WhenAssessedGradeLevelDescriptorId,EventCircumstanceDescriptorId
            ,EventDescription,SchoolYear,PlatformTypeDescriptorId,Discriminator,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            (N'STAR_Reading_2019',N'http://ed-fi.org/Assessment/Assessment.xml',561854,435,'20190912',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2011,NULL,NULL,NOW(),NOW(),uuid_generate_v4(),19000);

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Lite_Craf_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-16 16:22:45');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Literature_Craft and Structure_Point of View', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Informational Text_Integration of Knowledge and Ideas', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-16 16:22:45');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Info_RangeofReadingandLevelofTextComplexity_', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-16 16:22:45');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Context Clues', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Info_Key _CompareandContrast', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Summary', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Prediction', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Lang_Voca_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Lang_Voca_Multiple-MeaningWords', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Info_Inte_Argumentation', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Structural Analysis', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Lang_Voca_SynonymsandAntonyms', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Theme', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Character and Plot', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Literature_Craft and Structure', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Setting', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Sequence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Cause and Effect', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Info_Craf_Author''sPurposeandPerspective', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Summary', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Info_Key _MainIdeaandDetails', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Figures of Speech', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Lang_Voca_VocabularyinContext', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Lite_Craf_ConventionsandRangeofReading', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Literature_Range of Reading and Level of Text Complexity', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Lite_Rang_ConventionsandRangeofReading', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Info_Key _InferenceandEvidence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Informational Text_Craft and Structure', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-16 16:22:45');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Inference and Evidence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Info_Craf_StructureandOrganization', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, '2020-01-20 01:47:14');

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Lang_Voca_VocabularyinContext', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'53', 2023, '2020-01-20 01:47:14'); -- TODO change 2023 for 2013
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details_Summary', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'36', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Key Ideas and Details_Summary', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'31', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Info_Inte_Argumentation', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'35', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Language_Vocabulary Acquisition and Use_Context Clues', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'61', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Info_Key _CompareandContrast', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'45', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details_Theme', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'49', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Language_Vocabulary Acquisition and Use_Figures of Speech', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'66', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Craft and Structure', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'39', 2023, '2020-01-16 16:22:45');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Lang_Voca_SynonymsandAntonyms', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'60', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Key Ideas and Details', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'48', 2023, '2020-01-16 16:22:45');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Info_Craf_StructureandOrganization', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'48', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details_Setting', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'57', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Language_Vocabulary Acquisition and Use', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'55', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details_Inference and Evidence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'49', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Key Ideas and Details_Sequence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'54', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Literature_Craft and Structure_Point of View', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'38', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Lite_Craf_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'54', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Info_RangeofReadingandLevelofTextComplexity_', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'60', 2023, '2020-01-16 16:22:45');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'52', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Lang_Voca_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'54', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Literature_Range of Reading and Level of Text Complexity', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'49', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Lite_Craf_ConventionsandRangeofReading', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'49', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Key Ideas and Details_Cause and Effect', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'54', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Info_Craf_Author''sPurposeandPerspective', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'38', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Language_Vocabulary Acquisition and Use_Structural Analysis', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'66', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Info_Key _MainIdeaandDetails', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'47', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Info_Key _InferenceandEvidence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'49', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Lang_Voca_Multiple-MeaningWords', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'48', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Lite_Rang_ConventionsandRangeofReading', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'49', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Key Ideas and Details_Prediction', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'52', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Literature_Craft and Structure', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'48', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Integration of Knowledge and Ideas', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'35', 2023, '2020-01-16 16:22:45');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details_Character and Plot', N'http://ed-fi.org/Assessment/Assessment.xml', N'561854', 435, N'56', 2023, '2020-01-20 01:47:14');

      ---------------------------------------------------------------------------------
      -- MATH


      --declare @highSchoolId as int = 255901001
      --declare @middleSchoolId as int =255901044

      INSERT INTO edfi.Assessment
            (AssessmentIdentifier,Namespace,AssessmentTitle,AssessmentCategoryDescriptorId,AssessmentForm,AssessmentVersion,RevisionDate,
                  MaxRawScore,Nomenclature,AssessmentFamily,EducationOrganizationId,AdaptiveAssessment,Discriminator,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            (N'STAR_Math_2019',N'http://ed-fi.org/Assessment/Assessment.xml',N'STAR Math',NULL,NULL,2011
            ,NULL,NULL,NULL,NULL,v_highSchoolId,NULL,NULL,NOW(),NOW(),uuid_generate_v4(),19000);


      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Algebra', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Algebra', NULL, '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'ae04b0c1-7c20-4eb4-ae24-bf6111c1cf80');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Functions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Functions', NULL, '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'b8497af3-c029-48b3-9f68-65a7080792df');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Geometry', NULL, '2020-01-28 20:04:00', '2020-01-28 20:04:00', '85f4fdec-3fac-4c60-ae67-ecaaec2fcd15');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Measurement and Data', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Measurement and Data', NULL, '2020-01-28 20:04:00', '2020-01-28 20:04:00', '5af50df8-5807-4ae9-928f-f4e9d65c0a50');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numbers and Operations', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Numbers and Operations', NULL, '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'a751a716-2b9f-41f5-9131-f149574eeb05');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Number and Quantity', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Number and Quantity', NULL, '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'ac421676-dccd-43c7-9a61-c63a80fce3ca');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Statistics and Probability', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Statistics and Probability', NULL, '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'c2b90b8c-3e1f-4d81-aee5-6f8755d5d8f5');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Algebra_Arithmetic with Polynomials and Rational Expressions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Arithmetic with Polynomials and Rational Expressions', N'Algebra', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '180d42f8-3e80-4cc0-9f43-ad00a9f1b61c');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Algebra_Creating Equations', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Creating Equations', N'Algebra', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '2cbc2ef0-93e9-4df0-8ea9-0ba6b8d7ec88');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Algebra_Expressions and Equations', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Expressions and Equations', N'Algebra', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '966751d3-1c57-458f-b852-7bf4dc11aff3');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Algebra_Operations and Algebraic Thinking', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Operations and Algebraic Thinking', N'Algebra', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'e4892fbc-37f7-45fe-b44e-0e552077c2ef');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Algebra_Reasoning with Equations and Inequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Reasoning with Equations and Inequalities', N'Algebra', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '262d2272-5b15-4bc9-931c-49b0cd47717b');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Algebra_Seeing Structure in Expressions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Seeing Structure in Expressions', N'Algebra', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '83d07ee4-07d7-4dfb-a6d6-a607395c5d82');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Alge_Arit_NonlinearExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Non linear Expressions Equations and Inequalities', N'Algebra_Arithmetic with Polynomials and Rational Expressions', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'f6fc9e85-e20a-4517-b9d6-54e66bcbcf70');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Alge_Arit_PolynomialExpressionsandFunctions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Polynomial Expressions and Functions', N'Algebra_Arithmetic with Polynomials and Rational Expressions', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'bacac006-caf2-4192-9643-9005a66fa6b7');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Alge_Crea_LinearExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Linear Expressions Equations and Inequalities', N'Algebra_Creating Equations', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '9e78b52f-c2d3-4e45-946e-4a183e65b24d');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Alge_Crea_QuadraticExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Quadratic Expressions Equations and Inequalities', N'Algebra_Creating Equations', '2020-01-28 20:04:00', '2020-01-28 20:04:00','3ec7ea94-9fa8-452f-9f30-bada7cdaeefe');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Algebra_Creating Equations_Relations and Functions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Relations and Functions', N'Algebra_Creating Equations', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'cf674a21-f578-4290-856a-6cfdda880acf');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Algebra_Expressions and Equations_Algebraic Thinking', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Algebraic Thinking', N'Algebra_Expressions and Equations', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '926f4b30-9d8b-4230-aa07-23ff5e035e4a');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Algebra_Expressions and Equations_Powers Roots and Radicals', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Powers Roots and Radicals', N'Algebra_Expressions and Equations', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '6405c75b-7e29-4c6a-8a3d-004912a29350');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Alge_Expr_LinearExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Linear Expressions Equations and Inequalities', N'Algebra_Expressions and Equations', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'de93da84-2b40-4c4b-b0a7-3ead90ea75f3');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Alge_Expr_NumericalandVariableExpressions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Numerical and Variable Expressions', N'Algebra_Expressions and Equations', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'e821cfed-3ee7-45ae-bc07-48f4fc523d89');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Alge_Expr_PositiveandNegativeRationalNumbers', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Positive and Negative Rational Numbers', N'Algebra_Expressions and Equations', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'c0602fc0-fb95-4381-8b2c-60d37407b4a5');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Alge_Oper_NumericalandVariableExpressions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Numerical and Variable Expressions', N'Algebra_Operations and Algebraic Thinking', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'ebc34c91-38f0-443b-8896-9762ad85fe9e');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Alge_Oper_WholeNumbers:AdditionandSubtraction', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Whole Numbers:Addition and Subtraction', N'Algebra_Operations and Algebraic Thinking', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'ba353a7b-0602-4cf6-8c8c-0e34620b3563');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Alge_Oper_WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Whole Numbers:Multiplication and Division', N'Algebra_Operations and Algebraic Thinking', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '924562c5-c4a1-4c96-9e30-749cfe0d18f8');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Algebra_Operations and Algebraic Thinking_Algebraic Thinking', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Algebraic Thinking', N'Algebra_Operations and Algebraic Thinking', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '21566e8f-43b0-4021-8775-6ad8c617e98f');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Alge_Reas_LinearExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Linear Expressions Equations and Inequalities', N'Algebra_Reasoning with Equations and Inequalities', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '4a966dc1-2326-421d-8927-6b825eb71400');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Alge_Reas_NonlinearExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Non linear Expressions Equations and Inequalities', N'Algebra_Reasoning with Equations and Inequalities', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '81e03509-9b3e-4a08-b41b-efc3f6de0980');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Alge_Reas_QuadraticExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Quadratic Expressions Equations and Inequalities', N'Algebra_Reasoning with Equations and Inequalities', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '4c7a632f-3635-4304-b64c-2787a8cdb861');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Alge_Reas_SystemsofEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Systems of Equations and Inequalities', N'Algebra_Reasoning with Equations and Inequalities', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '684cbe42-1696-4073-bd3a-b2a7ac2763de');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Alge_Seei_PatternsSequencesandSeries', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Patterns Sequences and Series', N'Algebra_Seeing Structure in Expressions', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '51a5c28d-f600-42c2-9e0c-bc41155c7ed8');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Alge_Seei_QuadraticExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Quadratic Expressions Equations and Inequalities', N'Algebra_Seeing Structure in Expressions', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '35d2f001-3da4-4bf1-8e05-2960ae03dd13');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Functions_Building Functions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Building Functions', N'Functions', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '2857c8d9-1076-4433-83aa-daf0a28d029b');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Functions_Functions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Functions', N'Functions', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '34214e82-8c92-4cf1-b805-650e8e5ae871');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Functions_Interpreting Functions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Interpreting Functions', N'Functions', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '17f17531-1f61-41dd-b695-3c53c7f430f9');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Functions_Linear Quadratic and Exponential Models', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Linear Quadratic and Exponential Models', N'Functions', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'cdc46313-b51f-487b-9de8-eabdf63801ea');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Functions_Trigonometric Functions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Trigonometric Functions', N'Functions', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '09ff1865-c3c8-4878-bc1e-6b27abdfb36d');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Functions_Building Functions_Patterns Sequences and Series', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Building Functions_Patterns Sequences and Series', N'Functions_Building Functions', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'd1ace955-39d3-4ad0-a763-ea4b6a12d3fb');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Functions_Building Functions_Relations and Functions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Relations and Functions', N'Functions_Building Functions', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '48df19e6-cdf1-441b-9800-bc86f4385ac4');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Func_Buil_QuadraticExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Quadratic Expressions Equations and Inequalities', N'Functions_Building Functions', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'fc52c074-3328-4fef-bef8-cdc9c9c23dd9');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Functions_Functions_Relations and Functions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Relations and Functions', N'Functions_Functions', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '94c3aa49-17c8-4ccd-8e1c-e60046d2f2f9');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Functions_Interpreting Functions_Relations and Functions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Relations and Functions', N'Functions_Interpreting Functions', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '51881442-eee9-4dac-8186-81c5a035d9dc');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Func_Inte_LinearExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Linear Expressions Equations and Inequalities', N'Functions_Interpreting Functions', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'e1df7695-4fb7-4357-860c-d078a02892af');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Func_Inte_PolynomialExpressionsandFunctions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Polynomial Expressions and Functions', N'Functions_Interpreting Functions', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'b97ac041-66bf-4236-af1e-19e600f436f8');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Func_Inte_QuadraticExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Quadratic Expressions Equations and Inequalities', N'Functions_Interpreting Functions', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '58d5c5d0-fae1-4512-9477-55a94cc1dc3b');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Func_Inte_RightTrianglesandTrigonometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Right Triangles and Trigonometry', N'Functions_Interpreting Functions', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '6c4136ce-6a64-41c1-b783-0dc4fe4f4839');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Func_Line_RelationsandFunctions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Relations and Functions', N'Functions_Linear Quadratic and Exponential Models', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '984c3f3b-91b0-4734-a778-00b2540a75f4');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Func_Trig_RightTrianglesandTrigonometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Right Triangles and Trigonometry', N'Functions_Trigonometric Functions', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'ada06180-73e5-4db3-baa1-51ad2d6024c2');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geometry_Circles', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Circles', N'Geometry', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'cbfca7b3-a815-4fab-ac55-b9eab512698d');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geometry_Modeling with Geometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Modeling with Geometry', N'Geometry', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '00214a67-625f-4461-ba81-47dc74714b25');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geometry_Similarity Right Triangles and Trigonometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Similarity Right Triangles and Trigonometry', N'Geometry', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '645d5831-ca02-49e2-bb5c-9c233be4488e');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geometry_Expressing Geometric Properties with Equations', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Expressing Geometric Properties with Equations', N'Geometry', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '0f9efc4a-36b8-45ad-9eec-0efdd4c40ca3');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geometry_Geometric Measurement and Dimension', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Geometric Measurement and Dimension', N'Geometry', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '4ce05505-0a0b-47f6-bdd2-d50512822fca');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geometry_Geometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Geometry', N'Geometry', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'd034ccbc-6b3c-4bcc-af98-222e7af790da');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geometry_Congruence', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Congruence', N'Geometry', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '3d5bd0ad-9c20-42e3-baad-1c01c3fe46d2');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geometry_Circles_Perimeter Circumference and Area', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Perimeter Circumference and Area', N'Geometry_Circles', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'b9e001eb-287a-4e69-a362-386297299d70');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geometry_Congruence_Angles Segments and Lines', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Angles Segments and Lines', N'Geometry_Congruence', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '533c8fd0-e2fd-4253-bf67-6bb1cb4e2c16');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geometry_Congruence_Polygons', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Polygons', N'Geometry_Congruence', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '50ee13e8-72a4-46cd-b8d9-d023f8f9c501');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geom_Expr_Circles', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Circles', N'Geometry_Expressing Geometric Properties with Equations', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '72ff96b5-43d8-45a9-8fbd-fb02150623d6');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geom_Expr_CoordinateGeometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Coordinate Geometry', N'Geometry_Expressing Geometric Properties with Equations', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '0fa860c2-a55f-427a-8565-cfddf5e09831');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geom_Geom_SurfaceAreaandVolume', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Surface Area and Volume', N'Geometry_Geometric Measurement and Dimension', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '602ec8f4-d1a2-4e85-bb22-e39235bd833e');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geom_Geom_Geometry:Three-DimensionalShapesandAttributes', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Geometry:Three-Dimensional Shapes and Attributes', N'Geometry_Geometric Measurement and Dimension', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '29f07803-2870-4f9e-bc58-5c6e2b6fedc7');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geom_Geom_Geometry:Two-DimensionalShapesandAttributes', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Geometry:Two-Dimensional Shapes and Attributes', N'Geometry_Geometry', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'ab0941e8-0130-4bfa-a277-37a28de47b1b');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geometry_Geometry_Angles Segments and Lines', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Angles Segments and Lines', N'Geometry_Geometry', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '483b807d-d653-4eb8-8674-9337d1d076c0');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geometry_Geometry_Coordinate Geometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Coordinate Geometry', N'Geometry_Geometry', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '4c9bbf94-5f59-4b5e-84c8-5bcba19b3a69');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geometry_Geometry_Fraction Concepts and Operations', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Fraction Concepts and Operations', N'Geometry_Geometry', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '3014abf0-71f9-415e-a908-f16c9a3f1b56');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geometry_Geometry_Measurement', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Measurement', N'Geometry_Geometry', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '52ca0832-c534-4778-83cc-4446d451035c');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geometry_Geometry_Perimeter Circumference and Area', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Perimeter Circumference and Area', N'Geometry_Geometry', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '0694e742-d99a-43eb-8a32-5720d548ee57');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geometry_Geometry_Right Triangles and Trigonometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Right Triangles and Trigonometry', N'Geometry_Geometry', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '7e48dd16-69ef-459f-b65f-f41ed4781b6f');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geometry_Geometry_Surface Area and Volume', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Surface Area and Volume', N'Geometry_Geometry', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '3bd7bc7d-b65a-42cf-bccc-ffa3b6a16de6');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geometry_Geometry_Transformations', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Transformations', N'Geometry_Geometry', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '82008242-a548-431a-93f6-00cd24b23b80');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geom_Geom_Geometry:Three DimensionalShapesandAttributes', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Geometry:Three-Dimensional Shapes and Attributes', N'Geometry_Geometry', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '25c9cec6-a5ce-40c7-8490-ed8aa0fee63f');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geom_Mode_PerimeterCircumferenceandArea', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Perimeter Circumference and Area', N'Geometry_Modeling with Geometry', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '80e62d85-450d-4d50-8f66-d770bac8d0b8');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geom_Simi_CongruenceandSimilarity', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Congruence and Similarity', N'Geometry_Similarity Right Triangles and Trigonometry', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '14e27f7b-b8b0-465d-a931-0c86dc40940f');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Geom_Simi_RightTrianglesandTrigonometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Right Triangles and Trigonometry', N'Geometry_Similarity Right Triangles and Trigonometry', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '3ef4c500-2a58-46e1-a25a-d559873e1c81');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Measurement and Data_Measurement and Data', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Measurement and Data', N'Measurement and Data', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'f7ca11e3-189c-4fda-8a7c-1212d4401307');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Measurement and Data_Measurement and Data_Measurement', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Measurement', N'Measurement and Data_Measurement and Data', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '9cd5b810-16e8-4040-9cc6-4632b03f1854');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Measurement and Data_Measurement and Data_Money and Time', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Money and Time', N'Measurement and Data_Measurement and Data', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'fe5d3e90-ca52-40ee-9ac0-1ba205f5072a');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Meas_Meas_DataRepresentationandAnalysis', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Data Representation and Analysis', N'Measurement and Data_Measurement and Data', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '8c176442-8d67-4fdf-b2c0-61244ef3d7d8');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Meas_Meas_PerimeterCircumferenceandArea', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Perimeter Circumference and Area', N'Measurement and Data_Measurement and Data', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'b5aed939-9155-42d2-88d5-838248681435');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Meas_Meas_SurfaceAreaandVolume', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Surface Area and Volume', N'Measurement and Data_Measurement and Data', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '6c500aab-c718-439b-a97c-5643a2df5d56');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Number and Quantity_The Complex Number System', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'The Complex Number System', N'Number and Quantity', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '1ebbb5cf-7b7d-440f-bb42-dd96dc573a13');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Number and Quantity_The Real Number System', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'The Real Number System', N'Number and Quantity', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '1ff3f203-f09a-4d65-9f72-3195e8524700');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Number and Quantity_Vector and Matrix Quantities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Vector and Matrix Quantities', N'Number and Quantity', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'b5c62d1d-d228-4ab4-a8b2-8f54fcf7ef35');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numb_The _MatricesVectorsandComplexNumbers', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Matrices Vectors and Complex Numbers', N'Number and Quantity_The Complex Number System', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'b5737dab-447c-4553-a9fe-38b3e98675c4');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numb_The _QuadraticExpressionsEquationsandInequalities', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Quadratic Expressions Equations and Inequalities', N'Number and Quantity_The Complex Number System', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'b1d786b3-d228-4ccd-9186-d8acced83faa');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numb_The _PowersRootsandRadicals', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Powers Roots and Radicals', N'Number and Quantity_The Real Number System', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'fdcb2d31-abd2-4d84-975f-d4d1bbec63b1');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numb_Vect_MatricesVectorsandComplexNumbers', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Matrices Vectors and Complex Numbers', N'Number and Quantity_Vector and Matrix Quantities', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'f35d0d77-1247-4d33-b234-62f2507632a9');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numbers and Operations_Counting and Cardinality', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Counting and Cardinality', N'Numbers and Operations', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'd3a9fdb6-71b4-4bf6-8561-70055637e326');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numbers and Operations_Number and Operations in Base Ten', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Number and Operations in Base Ten', N'Numbers and Operations', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '8b24d954-ea38-471c-ad07-3eba50303aa0');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numbers and Operations_Number and Operations—Fractions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Number and Operations—Fractions', N'Numbers and Operations', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'f84fb683-fa26-4d00-8d4f-fc0410d88432');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numbers and Operations_Ratios and Proportional Relationships', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Ratios and Proportional Relationships', N'Numbers and Operations', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '875dfef9-84e6-483f-9244-233cd313fefd');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numbers and Operations_The Number System', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'The Number System', N'Numbers and Operations', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'd92971c9-721a-4397-aa60-56cd94ce1d73');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numb_Coun_WholeNumbers:CountingComparingandOrdering', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Whole Numbers:Counting Comparing and Ordering', N'Numbers and Operations_Counting and Cardinality', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '0d820e13-7172-462f-bdb5-4e290f10a66b');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numb_Numb_DecimalConceptsandOperations', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Decimal Concepts and Operations', N'Numbers and Operations_Number and Operations in Base Ten', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '272564a8-85cd-4292-945a-e7d36dbd0223');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numb_Numb_WholeNumbers:AdditionandSubtraction', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Whole Numbers:Addition and Subtraction', N'Numbers and Operations_Number and Operations in Base Ten', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '21654b72-be72-46b8-95d8-e15116141250');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numb_Numb_WholeNumbers:CountingComparingandOrdering', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Whole Numbers:Counting Comparing and Ordering', N'Numbers and Operations_Number and Operations in Base Ten', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '76b2efba-9a0e-4351-8035-f89ad366eb43');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numb_Numb_WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Whole Numbers:Multiplication and Division', N'Numbers and Operations_Number and Operations in Base Ten', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'cbc24471-70c0-4ba6-a6cc-4728c108dcc0');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numb_Numb_WholeNumbers:PlaceValue', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Whole Numbers:Place Value', N'Numbers and Operations_Number and Operations in Base Ten', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '1489daf8-82c7-48e0-a1d1-d67fb9a5830d');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numb_Numb_FractionConceptsandOperations', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Fraction Concepts and Operations', N'Numbers and Operations_Number and Operations—Fractions', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '66c1033f-f130-44b8-b0fb-9ea94ea2e432');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numb_Numb_Decimal Concepts and Operations', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Decimal Concepts and Operations', N'Numbers and Operations_Number and Operations—Fractions', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '8c3c85f6-a1d0-4066-a3e2-e56fcb0af8a4');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numb_Rati_PercentsRatiosandProportions', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Percents Ratios and Proportions', N'Numbers and Operations_Ratios and Proportional Relationships', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'd1946538-4b8f-4bce-970e-e413921316af');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numb_The _FractionConceptsandOperations', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Fraction Concepts and Operations', N'Numbers and Operations_The Number System', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '7c9714c6-0856-4971-87e6-0c0ba83b0c4d');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numb_The _WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Whole Numbers:Multiplication and Division', N'Numbers and Operations_The Number System', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '33aca465-6f9c-4814-9ad7-53822af6174b');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numb_The_PowersRootsandRadicals', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Powers Roots and Radicals', N'Numbers and Operations_The Number System', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '26de9e06-2aef-4a3e-b777-fffe54b4792c');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numb_The _PositiveandNegativeRationalNumbers', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Positive and Negative Rational Numbers', N'Numbers and Operations_The Number System', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '349623b0-4425-43d0-8471-9cb982c98841');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Numbers and Operations_The Number System_Coordinate Geometry', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Coordinate Geometry', N'Numbers and Operations_The Number System', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '444ba6e6-70c7-420e-b46e-c53743a1e21f');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Stat_MakingInferencesandJustifyingConclusions_', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Making Inferences and Justifying Conclusions', N'Statistics and Probability', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'e9862013-d8fb-4a48-9469-73359bac858f');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Statistics and Probability_Statistics and Probability', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Statistics and Probability', N'Statistics and Probability', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'eb491008-26b0-4165-bcac-ae957dc1e32e');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Stat_InterpretingCategoricalandQuantitativeData_', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Interpreting Categorical and Quantitative Data', N'Statistics and Probability', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'c350534c-4c84-4e94-9aac-33faabbf592d');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Stat_ConditionalProbabilityandtheRulesofProbability_', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Conditional Probability and the Rules of Probability', N'Statistics and Probability', '2020-01-28 20:04:00', '2020-01-28 20:04:00', '423d60dd-c1fb-421e-9d8e-a7609bbd67a3');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Stat_Stat_CombinatoricsandProbability', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Combinatorics and Probability', N'Statistics and Probability_Statistics and Probability', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'd7aa2ce4-aac8-46a8-b624-40cceaa4f276');
      INSERT INTO edfi.ObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, MaxRawScore, PercentOfAssessment, Nomenclature, Description, ParentIdentificationCode, CreateDate, LastModifiedDate, Id) VALUES (N'STAR_Math_2019', N'Stat_Stat_DataRepresentationandAnalysis', N'http://ed-fi.org/Assessment/Assessment.xml', NULL, NULL, NULL, N'Data Representation and Analysis', N'Statistics and Probability_Statistics and Probability', '2020-01-28 20:04:00', '2020-01-28 20:04:00', 'e2b5e940-ab2d-4fc5-8586-2a9be41f7c72');

      INSERT INTO edfi.StudentAssessment
            (AssessmentIdentifier,Namespace,StudentAssessmentIdentifier,StudentUSI,AdministrationDate,AdministrationEndDate,SerialNumber,AdministrationLanguageDescriptorId
            ,AdministrationEnvironmentDescriptorId,RetestIndicatorDescriptorId,ReasonNotTestedDescriptorId,WhenAssessedGradeLevelDescriptorId,EventCircumstanceDescriptorId
            ,EventDescription,SchoolYear,PlatformTypeDescriptorId,Discriminator,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            (N'STAR_Math_2019',N'http://ed-fi.org/Assessment/Assessment.xml',561855,435,'20190912',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2011,NULL,NULL,NOW(),NOW(),uuid_generate_v4(),19000);

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Geometry_Geometry', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Algebra_Operations and Algebraic Thinking', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Numbers and Operations_Number and Operations in Base Ten', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Numb_Numb_WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Alge_Oper_WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Numb_Numb_WholeNumbers:PlaceValue', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Numb_Numb_Decimal Concepts and Operations', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Meas_Meas_PerimeterCircumferenceandArea', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Meas_Meas_DataRepresentationandAnalysis', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Numbers and Operations_Number and Operations—Fractions', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Geometry_Geometry_Angles Segments and Lines', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Measurement and Data_Measurement and Data', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Numb_Numb_FractionConceptsandOperations', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Numb_Numb_WholeNumbers:AdditionandSubtraction', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Measurement and Data_Measurement and Data_Measurement', N'http://ed-fi.org/Assessment/Assessment.xml',561855, 435, '2020-01-29 01:54:37');

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Numb_Numb_WholeNumbers:PlaceValue', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'56', 2023, '2020-01-20 01:47:14'); -- TODO replace 2000 for 2013
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Geometry_Geometry_Angles Segments and Lines', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'48', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Numb_Numb_Decimal Concepts and Operations', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'17', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Numb_Numb_FractionConceptsandOperations', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'25', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Meas_Meas_PerimeterCircumferenceandArea', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'39', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Numb_Numb_WholeNumbers:AdditionandSubtraction', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'18', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Measurement and Data_Measurement and Data_Measurement', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'49', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Geometry_Geometry', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'17', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Alge_Oper_WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'17', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Measurement and Data_Measurement and Data', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'33', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Numbers and Operations_Number and Operations in Base Ten', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'18', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Algebra_Operations and Algebraic Thinking', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'42', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Meas_Meas_DataRepresentationandAnalysis', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'33', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Numbers and Operations_Number and Operations—Fractions', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'20', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Numb_Numb_WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml', N'561855', 435, N'35', 2023, '2020-01-20 01:47:14');

      INSERT INTO edfi.StudentAssessment
            (AssessmentIdentifier,Namespace,StudentAssessmentIdentifier,StudentUSI,AdministrationDate,AdministrationEndDate,SerialNumber,AdministrationLanguageDescriptorId
            ,AdministrationEnvironmentDescriptorId,RetestIndicatorDescriptorId,ReasonNotTestedDescriptorId,WhenAssessedGradeLevelDescriptorId,EventCircumstanceDescriptorId
            ,EventDescription,SchoolYear,PlatformTypeDescriptorId,Discriminator,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            (N'STAR_Reading_2019',N'http://ed-fi.org/Assessment/Assessment.xml',561856,721,'20190912',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2011,NULL,NULL,NOW(),NOW(),uuid_generate_v4(),19000);

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Lite_Craf_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-16 16:22:45');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Literature_Craft and Structure_Point of View', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Informational Text_Integration of Knowledge and Ideas', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-16 16:22:45');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Info_RangeofReadingandLevelofTextComplexity_', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-16 16:22:45');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Context Clues', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Info_Key _CompareandContrast', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Summary', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Prediction', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Lang_Voca_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Lang_Voca_Multiple-MeaningWords', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Info_Inte_Argumentation', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Structural Analysis', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Lang_Voca_SynonymsandAntonyms', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Theme', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Character and Plot', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Literature_Craft and Structure', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Setting', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Sequence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Cause and Effect', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Info_Craf_Author''sPurposeandPerspective', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Informational Text_Key Ideas and Details_Summary', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Info_Key _MainIdeaandDetails', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use_Figures of Speech', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Lang_Voca_VocabularyinContext', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Lite_Craf_ConventionsandRangeofReading', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Literature_Range of Reading and Level of Text Complexity', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Lite_Rang_ConventionsandRangeofReading', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Info_Key _InferenceandEvidence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Informational Text_Craft and Structure', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-16 16:22:45');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Literature_Key Ideas and Details_Inference and Evidence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Language_Vocabulary Acquisition and Use', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Reading_2019', N'Info_Craf_StructureandOrganization', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, '2020-01-20 01:47:14');

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Lang_Voca_VocabularyinContext', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'53', 2023, '2020-01-20 01:47:14'); -- TODO replace 2023 for 2013
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details_Summary', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'36', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Key Ideas and Details_Summary', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'31', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Info_Inte_Argumentation', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'35', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Language_Vocabulary Acquisition and Use_Context Clues', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'61', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Info_Key _CompareandContrast', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'45', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details_Theme', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'49', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Language_Vocabulary Acquisition and Use_Figures of Speech', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'66', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Craft and Structure', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'39', 2023, '2020-01-16 16:22:45');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Lang_Voca_SynonymsandAntonyms', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'60', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Key Ideas and Details', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'48', 2023, '2020-01-16 16:22:45');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Info_Craf_StructureandOrganization', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'48', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details_Setting', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'57', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Language_Vocabulary Acquisition and Use', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'55', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details_Inference and Evidence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'49', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Key Ideas and Details_Sequence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'54', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Literature_Craft and Structure_Point of View', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'38', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Lite_Craf_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'54', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Info_RangeofReadingandLevelofTextComplexity_', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'60', 2023, '2020-01-16 16:22:45');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'52', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Lang_Voca_Author''sWordChoiceandFigurativeLanguage', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'54', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Literature_Range of Reading and Level of Text Complexity', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'49', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Lite_Craf_ConventionsandRangeofReading', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'49', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Key Ideas and Details_Cause and Effect', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'54', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Info_Craf_Author''sPurposeandPerspective', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'38', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Language_Vocabulary Acquisition and Use_Structural Analysis', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'66', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Info_Key _MainIdeaandDetails', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'47', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Info_Key _InferenceandEvidence', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'49', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Lang_Voca_Multiple-MeaningWords', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'48', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Lite_Rang_ConventionsandRangeofReading', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'49', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Key Ideas and Details_Prediction', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'52', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Literature_Craft and Structure', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'48', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Informational Text_Integration of Knowledge and Ideas', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'35', 2023, '2020-01-16 16:22:45');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Reading_2019', 212, N'Literature_Key Ideas and Details_Character and Plot', N'http://ed-fi.org/Assessment/Assessment.xml', N'561856', 721, N'56', 2023, '2020-01-20 01:47:14');

      INSERT INTO edfi.StudentAssessment
            (AssessmentIdentifier,Namespace,StudentAssessmentIdentifier,StudentUSI,AdministrationDate,AdministrationEndDate,SerialNumber,AdministrationLanguageDescriptorId
            ,AdministrationEnvironmentDescriptorId,RetestIndicatorDescriptorId,ReasonNotTestedDescriptorId,WhenAssessedGradeLevelDescriptorId,EventCircumstanceDescriptorId
            ,EventDescription,SchoolYear,PlatformTypeDescriptorId,Discriminator,CreateDate,LastModifiedDate,Id,ChangeVersion)
      VALUES
            (N'STAR_Math_2019',N'http://ed-fi.org/Assessment/Assessment.xml',561857,721,'20190912',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2011,NULL,NULL,NOW(),NOW(),uuid_generate_v4(),19000);

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Geometry_Geometry', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Algebra_Operations and Algebraic Thinking', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Numbers and Operations_Number and Operations in Base Ten', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Numb_Numb_WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Alge_Oper_WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Numb_Numb_WholeNumbers:PlaceValue', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Numb_Numb_Decimal Concepts and Operations', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Meas_Meas_PerimeterCircumferenceandArea', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Meas_Meas_DataRepresentationandAnalysis', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Numbers and Operations_Number and Operations—Fractions', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Geometry_Geometry_Angles Segments and Lines', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Measurement and Data_Measurement and Data', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Numb_Numb_FractionConceptsandOperations', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Numb_Numb_WholeNumbers:AdditionandSubtraction', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, '2020-01-29 01:54:37');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessment (AssessmentIdentifier, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, CreateDate) VALUES (N'STAR_Math_2019', N'Measurement and Data_Measurement and Data_Measurement', N'http://ed-fi.org/Assessment/Assessment.xml',561857, 721, '2020-01-29 01:54:37');

      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Numb_Numb_WholeNumbers:PlaceValue', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'56', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Geometry_Geometry_Angles Segments and Lines', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'48', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Numb_Numb_Decimal Concepts and Operations', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'17', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Numb_Numb_FractionConceptsandOperations', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'25', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Meas_Meas_PerimeterCircumferenceandArea', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'39', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Numb_Numb_WholeNumbers:AdditionandSubtraction', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'18', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Measurement and Data_Measurement and Data_Measurement', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'49', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Geometry_Geometry', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'17', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Alge_Oper_WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'17', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Measurement and Data_Measurement and Data', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'33', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Numbers and Operations_Number and Operations in Base Ten', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'18', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Algebra_Operations and Algebraic Thinking', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'42', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Meas_Meas_DataRepresentationandAnalysis', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'33', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Numbers and Operations_Number and Operations—Fractions', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'20', 2023, '2020-01-20 01:47:14');
      INSERT INTO edfi.StudentAssessmentStudentObjectiveAssessmentScoreResult (AssessmentIdentifier, AssessmentReportingMethodDescriptorId, IdentificationCode, Namespace, StudentAssessmentIdentifier, StudentUSI, Result, ResultDatatypeTypeDescriptorId, CreateDate) VALUES (N'STAR_Math_2019', 212, N'Numb_Numb_WholeNumbers:MultiplicationandDivision', N'http://ed-fi.org/Assessment/Assessment.xml', N'561857', 721, N'35', 2023, '2020-01-20 01:47:14');

END $$