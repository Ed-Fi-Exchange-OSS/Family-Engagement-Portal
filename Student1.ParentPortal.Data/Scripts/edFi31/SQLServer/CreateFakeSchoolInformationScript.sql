BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
	declare @LocalEducationAgencyId int = 111111;
	declare @SchoolId int = 255909999;
	
	declare @EducationServiceCenterId int = 222222;
	declare @LocalEducationAgencyName nvarchar(75)= 'Example ISD';
	declare @LocalEducationAgencyShortName nvarchar(50)= 'EISD';
	declare @LocalEducationAgencySite nvarchar(50)= 'www.example.com';
	declare @EducationServiceCenterName nvarchar(25) = 'Region XX Education Service Center';
	declare @SchoolName nvarchar(25) = 'Example High School';
	declare @SchoolShortName nvarchar(25) = 'EHS';
	declare @SchoolWebSite nvarchar(25) = 'www.example.com/EHS';
	declare @DiscriminatorLocalEdAgency nvarchar(50)= 'edfi.LocalEducationAgency';
	declare @DiscriminatorEducationService nvarchar(50)= 'edfi.EducationServiceCenter';
	declare @DiscriminatorSchool nvarchar(50)= 'edfi.School';
	declare @InstituteStreetNumberName nvarchar(50) = '45698 Holly Day Test Street';

	declare @SessionNameSpring nvarchar(50) = '2010-2011 Spring Semester';
	declare @SessionNameFall nvarchar(50) = '2010-2011 Fall Semester';

	
	declare @StudentUSI1 int = null;
	declare @StudentUSI2 int = null;
	declare @StudentUSI3 int = null;
	declare @StudentUSI4 int = null;
	declare @StudentUSI5 int = null;
	declare @StudentUSI6 int = null;
	declare @StudentUSI7 int = null;
	declare @ParentUSI1 int = null;
	declare @ParentUSI2 int = null;
	declare @ParentUSI3 int = null;
	declare @ParentUSI4 int = null;
	declare @ParentUSI5 int = null;
	declare @ParentUSI6 int = null;
	declare @ParentUSI7 int = null;


	declare @@CurrentSchoolYear int = null;
	declare @StaffUSI1 int = null;
	declare @StaffUSI2 int = null;
	declare @StaffUSI3 int = null;
	declare @StaffUSI4 int = null;
	declare @StaffUSI5 int = null;
	declare @StaffUSI6 int = null;
	declare @StaffUSI7 int = null;


	-- ** Student Identification, Names and Demographics ** --
	declare @@StudentUniqueId1 nvarchar(50) = '989898';
	declare @StudentPrefix1 nvarchar(3) = 'Mrs';
	declare @@StudentFirstName1 nvarchar(10) = 'Maria';
	declare @@StudentMiddleName1 nvarchar(10) = 'Fernanda';
	declare @@StudentLastSurname1 nvarchar(10) = 'Perez';
	
	declare @@StudentUniqueId2 nvarchar(50) = '979797';
	declare @StudentPrefix2 nvarchar(3) = 'Mr';
	declare @@StudentFirstName2 nvarchar(10) = 'John';
	declare @@StudentMiddleName2 nvarchar(10) = 'Peralta';
	declare @@StudentLastSurname2 nvarchar(10) = 'Gomez';

	declare @@StudentUniqueId3 nvarchar(50) = '969696';
	declare @StudentPrefix3 nvarchar(3) = 'Mr';
	declare @@StudentFirstName3 nvarchar(10) = 'Eduard';
	declare @@StudentMiddleName3 nvarchar(10) = null;
	declare @@StudentLastSurname3 nvarchar(10) = 'Colling';

	declare @@StudentUniqueId4 nvarchar(50) = '959595';
	declare @StudentPrefix4 nvarchar(3) = 'Mrs';
	declare @@StudentFirstName4 nvarchar(10) = 'Fernanda';
	declare @@StudentMiddleName4 nvarchar(10) = null;
	declare @@StudentLastSurname4 nvarchar(10) = 'Jhonson';

	declare @@StudentUniqueId5 nvarchar(50) = '949494';
	declare @StudentPrefix5 nvarchar(3) = 'Mr';
	declare @@StudentFirstName5 nvarchar(10) = 'John';
	declare @@StudentMiddleName5 nvarchar(10) = null;
	declare @@StudentLastSurname5 nvarchar(10) = 'McDonal';

	declare @@StudentUniqueId6 nvarchar(50) = '939393';
	declare @StudentPrefix6 nvarchar(3) = 'Mr';
	declare @@StudentFirstName6 nvarchar(10) = 'Alejandro';
	declare @@StudentMiddleName6 nvarchar(10) = null;
	declare @@StudentLastSurname6 nvarchar(10) = 'Perez';

	declare @@StudentUniqueId7 nvarchar(50) = '929292';
	declare @StudentPrefix7 nvarchar(3) = 'Mr';
	declare @@StudentFirstName7 nvarchar(10) = 'Melwin';
	declare @@StudentMiddleName7 nvarchar(10) = null;
	declare @@StudentLastSurname7 nvarchar(10) = 'Barreto';
	
	-- ** Parent Name and Demographics ** --
	declare @@ParentUniqueId1 nvarchar(50) = '979797';
	declare @@ParentFirstName1 nvarchar(10) = 'Melchor';
	declare @@ParentLastSurname1 nvarchar(10) = 'Ripoll';
	declare @@EmailLogin1 nvarchar(50) = 'perry.savage@toolwise.onmicrosoft.com';

	declare @@ParentUniqueId2 nvarchar(50) = '979796';
	declare @@ParentFirstName2 nvarchar(10) = 'Julen';
	declare @@ParentLastSurname2 nvarchar(10) = 'Puerto';
	declare @@EmailLogin2 nvarchar(50) = 'julen.puerto@gmail.com';

	declare @@ParentUniqueId3 nvarchar(50) = '979795';
	declare @@ParentFirstName3 nvarchar(10) = 'Ibrahim';
	declare @@ParentLastSurname3 nvarchar(10) = 'Wang';
	declare @@EmailLogin3 nvarchar(50) = 'wang@gmail.com';

	declare @@ParentUniqueId4 nvarchar(50) = '979794';
	declare @@ParentFirstName4 nvarchar(10) = 'Eulalia';
	declare @@ParentLastSurname4 nvarchar(10) = 'Bonet';
	declare @@EmailLogin4 nvarchar(50) = 'bonet@gmail.com';

	declare @@ParentUniqueId5 nvarchar(50) = '979793';
	declare @@ParentFirstName5 nvarchar(10) = 'Oriol';
	declare @@ParentLastSurname5 nvarchar(10) = 'Ye';
	declare @@EmailLogin5 nvarchar(50) = 'oriol.ye@gmail.com';

	declare @@ParentUniqueId6 nvarchar(50) = '979792';
	declare @@ParentFirstName6 nvarchar(10) = 'Florencia';
	declare @@ParentLastSurname6 nvarchar(10) = 'Ferrer';
	declare @@EmailLogin6 nvarchar(50) = 'ferrer@example.com';

	declare @@ParentUniqueId7 nvarchar(50) = '979791';
	declare @@ParentFirstName7 nvarchar(10) = 'Francisca';
	declare @@ParentLastSurname7 nvarchar(10) = 'Rio';
	declare @@EmailLogin7 nvarchar(50) = 'rio@gmail.com';
	
	-- ** Student Enrollment Courses **--
	declare @@GradeLevelDescriptorId int = 904;               -- 8th Grade
	declare @@EntryTypeDescriptorId int = 842                 -- Promoted to Next Grade
	declare @@GraduationPlanTypeDescriptorId int = 954;        -- Graduation Plan (YES Foundation HS Prog w/Endorsements)
	declare @@StudentParticipationCodeDescriptorId int = 2180; -- Perpetrator
	declare @AttendanceEventCategoryDescriptorId int = 246     -- Absent
	declare @TardyEventCategoryDescriptorId int = 245          -- Tardy
	declare @@GradeTypeDescriptorId int = 927;                -- Semester
	declare @GradingPeriodDescriptorId int = 1356              -- A1
	declare @IncidentIdentifier1 nvarchar(20) = '99';
	declare @IncidentIdentifier2 nvarchar(20) = '98';

	-- **  Staff Identification, Names and Demographics**--
	declare @StaffPersonalPrefix1 nvarchar(30) = 'Mr';
	declare @StaffFirstName1 nvarchar(75) = 'John';
	declare @StaffMiddleName1 nvarchar(75) = '';
	declare @StaffLastName1 nvarchar(75) = 'Cena';
	declare @StaffBirthDate1 date = GETDATE();
	declare @StaffHispanicLatinoEthnicity1 int = 0;
	declare @YearsOfPriorProfessionalExperience1 decimal(5,2) = 30.00;
	declare @YearsOfPriorTeachingExperience1 decimal(5,2) = 25.00;
	declare @LoginId1 nvarchar(60) = 'jcena';
	declare @HighlyQualifiedTeacher1 bit = 0;
	declare @StaffUniqueId1 nvarchar(32) = '989801';
	declare @StaffEmail1 nvarchar(128) = 'jcena@example.com';

	declare @StaffPersonalPrefix2 nvarchar(30) = 'Mr';
	declare @StaffFirstName2 nvarchar(75) = 'Pablo';
	declare @StaffMiddleName2 nvarchar(75) = '';
	declare @StaffLastName2 nvarchar(75) = 'Morales';
	declare @StaffBirthDate2 date = GETDATE();
	declare @StaffHispanicLatinoEthnicity2 int = 0;
	declare @YearsOfPriorProfessionalExperience2 decimal(5,2) = 30.00;
	declare @YearsOfPriorTeachingExperience2 decimal(5,2) = 25.00;
	declare @LoginId2 nvarchar(60) = 'pmorales';
	declare @HighlyQualifiedTeacher2 bit = 0;
	declare @StaffUniqueId2 nvarchar(32) = '989802';
	declare @StaffEmail2 nvarchar(128) = 'pmorales@example.com';

	declare @StaffPersonalPrefix3 nvarchar(30) = 'Ms';
	declare @StaffFirstName3 nvarchar(75) = 'Ashley';
	declare @StaffMiddleName3 nvarchar(75) = '';
	declare @StaffLastName3 nvarchar(75) = 'Town';
	declare @StaffBirthDate3 date = GETDATE();
	declare @StaffHispanicLatinoEthnicity3 int = 0;
	declare @YearsOfPriorProfessionalExperience3 decimal(5,2) = 30.00;
	declare @YearsOfPriorTeachingExperience3 decimal(5,2) = 25.00;
	declare @LoginId3 nvarchar(60) = 'atown';
	declare @HighlyQualifiedTeacher3 bit = 0;
	declare @StaffUniqueId3 nvarchar(32) = '989803';
	declare @StaffEmail3 nvarchar(128) = 'atown@example.com';

	declare @StaffPersonalPrefix4 nvarchar(30) = 'Mr';
	declare @StaffFirstName4 nvarchar(75) = 'Eduard';
	declare @StaffMiddleName4 nvarchar(75) = '';
	declare @StaffLastName4 nvarchar(75) = 'Erlic';
	declare @StaffBirthDate4 date = GETDATE();
	declare @StaffHispanicLatinoEthnicity4 int = 0;
	declare @YearsOfPriorProfessionalExperience4 decimal(5,2) = 30.00;
	declare @YearsOfPriorTeachingExperience4 decimal(5,2) = 25.00;
	declare @LoginId4 nvarchar(60) = 'eelric';
	declare @HighlyQualifiedTeacher4 bit = 0;
	declare @StaffUniqueId4 nvarchar(32) = '989804';
	declare @StaffEmail4 nvarchar(128) = 'eelric@example.com';

	declare @StaffPersonalPrefix5 nvarchar(30) = 'Dr';
	declare @StaffFirstName5 nvarchar(75) = 'Brennan';
	declare @StaffMiddleName5 nvarchar(75) = '';
	declare @StaffLastName5 nvarchar(75) = 'Heart';
	declare @StaffBirthDate5 date = GETDATE();
	declare @StaffHispanicLatinoEthnicity5 int = 0;
	declare @YearsOfPriorProfessionalExperience5 decimal(5,2) = 30.00;
	declare @YearsOfPriorTeachingExperience5 decimal(5,2) = 25.00;
	declare @LoginId5 nvarchar(60) = 'bheart';
	declare @HighlyQualifiedTeacher5 bit = 0;
	declare @StaffUniqueId5 nvarchar(32) = '989805';
	declare @StaffEmail5 nvarchar(128) = 'bhearth@example.com';

	declare @StaffPersonalPrefix6 nvarchar(30) = 'Ms';
	declare @StaffFirstName6 nvarchar(75) = 'Lyria';
	declare @StaffMiddleName6 nvarchar(75) = '';
	declare @StaffLastName6 nvarchar(75) = 'Korsako';
	declare @StaffBirthDate6 date = GETDATE();
	declare @StaffHispanicLatinoEthnicity6 int = 0;
	declare @YearsOfPriorProfessionalExperience6 decimal(5,2) = 30.00;
	declare @YearsOfPriorTeachingExperience6 decimal(5,2) = 25.00;
	declare @LoginId6 nvarchar(60) = 'lkorsako';
	declare @HighlyQualifiedTeacher6 bit = 0;
	declare @StaffUniqueId6 nvarchar(32) = '989806';
	declare @StaffEmail6 nvarchar(128) = 'lkorsako@example.com';

	declare @StaffPersonalPrefix7 nvarchar(30) = 'Mr';
	declare @StaffFirstName7 nvarchar(75) = 'Ron';
	declare @StaffMiddleName7 nvarchar(75) = '';
	declare @StaffLastName7 nvarchar(75) = 'Jhonson';
	declare @StaffBirthDate7 date = GETDATE();
	declare @StaffHispanicLatinoEthnicity7 int = 0;
	declare @YearsOfPriorProfessionalExperience7 decimal(5,2) = 30.00;
	declare @YearsOfPriorTeachingExperience7 decimal(5,2) = 25.00;
	declare @LoginId7 nvarchar(60) = 'rjhonson';
	declare @HighlyQualifiedTeacher7 bit = 0;
	declare @StaffUniqueId7 nvarchar(32) = '989807';
	declare @StaffEmail7 nvarchar(128) = 'rjhonson@example.com';


	declare @PositionTitleELATeacher  nvarchar(100) = 'High School ELA teacher';
	declare @PositionTitlePrincipal  nvarchar(100) = 'Principal';
	declare @CalendarCode nvarchar(10) = '11111'; -- Calendar Code
	declare @HighSchoolCourseRequirement int = 1;

	declare @AssessmentIdentifier1 nvarchar(20) = 'STAAR Algebra I';
	declare @AssessmentIdentifier2 nvarchar(20) = 'STAAR Biology';
	declare @AssessmentIdentifier3 nvarchar(20) = 'STAAR English I';
	declare @AssessmentIdentifier4 nvarchar(20) = 'STAAR English II';
	declare @AssessmentIdentifier5 nvarchar(20) = 'STAAR U.S. History';
	declare @AssessmentIdentifier6 nvarchar(20) = 'PSAT EBRW';
	declare @AssessmentIdentifier7 nvarchar(20) = 'PSAT MATH';
	declare @AssessmentIdentifier8 nvarchar(20) = 'SAT EBRW';
	declare @AssessmentIdentifier9 nvarchar(20) = 'SAT MATH';

	declare @AssesmentNamespace nvarchar(20) = 'uri://ed-fi.org/Assessment/Assessment.xml';
	declare @StudentAssessmentIdentifier nvarchar(50) = 'goiwenfwf319r9r9v8noAWWDQN9dq';
	declare @AssesmentTitleSAT nvarchar(10) = 'SAT';
	declare @AssesmentTitleSTAAR nvarchar(10) = 'STAAR';
	declare @AssesmentTitlePSAT nvarchar(10) = 'PSAT';
	declare @AssessmentCategoryDescriptorId int = 113;
	declare @MaxRawScoreSAT int = 550;
	declare @MaxRawScorePSAT int = 550;
	declare @MaxRawScoreSTAAR int = 550;
 
	--Descriptors
	declare @ActiveDescriptor int = 1627;
	declare @LocalEducationAgencyCategoryDescriptorId int = 785;
	declare @CharterStatusDescriptorId int = 790;
	declare @SchoolTypeDescriptorId int = 1983;
	declare @TitleIPartASchoolDesignationDescriptorId int = 2243;
	declare @EducationalEnvironmentDescriptorId int = 772;
	declare @TermDescriptorIdSpring int = 2228
	declare @TermDescriptorIdFall int = 2218
	declare @GradebookEntryTypeDescriptorId int = 897;
	declare @SexDescriptorIdWomen int = 2017;
	declare @SexDescriptorIdMen int = 2018;
	declare @CitizenshipStatusDescriptorIdHispanic int = 1625; --Hispanic
	declare @CitizenshipStatusDescriptorIdAPI int = 1623; --Asian Or Pacific Islander
	declare @HighestCompletedLevelOfEducationDescriptorIdB int = 1532; -- Bachelor's
	declare @HighestCompletedLevelOfEducationDescriptorIdD int = 1534; -- Doctorate
	declare @HighestCompletedLevelOfEducationDescriptorIdM int = 1536; -- Master's
	declare @HighestCompletedLevelOfEducationDescriptorIdS int = 1537; -- Some College No Degree
	declare @EmailTypeWork int = 818;
	declare @ProgramAssignmentDescriptorId int = 1709;
	declare @GradeLevelDescriptorIdTenthGrade int = 920;
	declare @GradeLevelDescriptorIdEleventhGrade int = 905;
	declare @GradeLevelDescriptorIdTwelfthgrade int = 922;
	declare @StaffClassificationDescriptorIdTeacher int = 2059;
	declare @StaffClassificationDescriptorIdPrincipal int = 2051;
	declare @BirthSexDescriptorId int = 2017;                  -- Female
	declare @SexDescriptorId int = 1453;                       -- Female
	declare @TelephoneNumberTypeDescriptorId int = 769;        -- Home
	declare @RaceDescriptorId int = 1479;                      -- American Indian or Alaskan Native
	declare @ClassroomPositionDescriptorId int = 295;
	declare @IncidentLocationDescriptorOfficeId int = 975;      --Administrative offices area
	declare @IncidentLocationDescriptorClassroomId int = 980;      --Classroom
	declare @ReporterDescriptionDescriptorId int = 1916;
	declare @IncidentOutOfSchoolSuspension int = 770				--Suspension
	declare @ElectronicMailTypeDescriptorId int = 815;         -- Home/Personal
	declare @RelationDescriptorIdFather int = 1863;             -- father    
	declare @RealationdescriporIdMother int = 1881;				-- mother
	declare @AddressTypeDescriptorId int = 82;                 -- contact
	declare @StateAbbreviationDescriptorId int = 2146;           -- Texas
	declare @CalendarTypeDescriptorId int = 261;
	declare @CourseGPAApplicabilityDescriptorId int = 603;
	declare @CourseDefinedByDescriptorId int = 602;
	declare @AdministrativeFundingControlDescriptorId int = 104;       --Public School
	declare @MastersGradeLevelDescriptorId int = 1650;
	declare @ApproachesGradeLevelDescriptorId int = 1651;
	declare @MeetsGradeLevelDescriptorId int = 1652;
	declare @DitNotMeetGradeLevelDescriptorId int = 1653;
	declare @AssessmentReportingMethodDescriptorId int = 218;
	declare @ResultDatatypeTypeDescriptorId int = 1938

	--Current Year
	select @@CurrentSchoolYear = CAST(SchoolYear AS int) from edfi.SchoolYearType where CurrentSchoolYear = 1

	declare @BeginDate nvarchar(10) = CONVERT(varchar(10), @@CurrentSchoolYear) + '-05-02';
	declare @EndDate nvarchar(10) = CONVERT(varchar(10), @@CurrentSchoolYear) + '-05-06';
	
	INSERT INTO [edfi].[LocalEducationAgencyCategoryDescriptor]
           ([LocalEducationAgencyCategoryDescriptorId])
     VALUES
           (@LocalEducationAgencyCategoryDescriptorId)

	INSERT INTO [edfi].[CharterStatusDescriptor]
           ([CharterStatusDescriptorId])
     VALUES
           (@CharterStatusDescriptorId)

	INSERT INTO [edfi].[AddressTypeDescriptor]
           ([AddressTypeDescriptorId])
     VALUES
           (@AddressTypeDescriptorId)

    INSERT INTO [edfi].[EducationOrganization]
           ([EducationOrganizationId]
           ,[NameOfInstitution]
           ,[ShortNameOfInstitution]
           ,[WebSite]
           ,[OperationalStatusDescriptorId]
           ,[Discriminator])
     VALUES
           (@LocalEducationAgencyId
           ,@LocalEducationAgencyName
           ,@LocalEducationAgencyShortName
           ,@LocalEducationAgencySite
           ,@ActiveDescriptor -- Active descriptor
           ,@DiscriminatorLocalEdAgency)

	 INSERT INTO [edfi].[EducationOrganization]
           ([EducationOrganizationId]
           ,[NameOfInstitution]
           ,[ShortNameOfInstitution]
           ,[WebSite]
           ,[OperationalStatusDescriptorId]
           ,[Discriminator])
     VALUES
           (@SchoolId
           ,@SchoolName
           ,@SchoolShortName
           ,@SchoolWebSite
           ,@ActiveDescriptor -- Active descriptor
           ,@DiscriminatorSchool)

		  
	INSERT INTO [edfi].[EducationOrganization]
           ([EducationOrganizationId]
           ,[NameOfInstitution]
           ,[Discriminator])
     VALUES
           (@EducationServiceCenterId
           ,@EducationServiceCenterName
           ,@DiscriminatorEducationService)

	INSERT INTO [edfi].[EducationServiceCenter]
           ([EducationServiceCenterId])
     VALUES
           (@EducationServiceCenterId)

	INSERT INTO [edfi].[LocalEducationAgency]
           ([LocalEducationAgencyId]
           ,[LocalEducationAgencyCategoryDescriptorId]
           ,[CharterStatusDescriptorId]
		   ,[EducationServiceCenterId])
     VALUES
           (@LocalEducationAgencyId
           ,@LocalEducationAgencyCategoryDescriptorId
           ,@CharterStatusDescriptorId
		   ,@EducationServiceCenterId)
		   
	INSERT INTO [edfi].[EducationOrganizationAddress]
           ([AddressTypeDescriptorId]
           ,[EducationOrganizationId]
           ,[StreetNumberName]
           ,[City]
           ,[StateAbbreviationDescriptorId]
           ,[PostalCode])
     VALUES
           (@AddressTypeDescriptorId
           ,@SchoolId
           ,@InstituteStreetNumberName
           ,'Houston'
           ,@StateAbbreviationDescriptorId
           ,'12345')

	INSERT INTO [edfi].[School]
           ([SchoolId]
           ,[SchoolTypeDescriptorId]
           ,[CharterStatusDescriptorId]
           ,[TitleIPartASchoolDesignationDescriptorId]
		   ,[AdministrativeFundingControlDescriptorId]
           ,[LocalEducationAgencyId])
     VALUES
           (@SchoolId
           ,@SchoolTypeDescriptorId
           ,@CharterStatusDescriptorId
           ,@TitleIPartASchoolDesignationDescriptorId
		   ,@AdministrativeFundingControlDescriptorId
           ,@LocalEducationAgencyId)
		     
	--Student and Parent info

	INSERT INTO [edfi].[Student]
		           ([PersonalTitlePrefix]
		           ,[FirstName]
		           ,[MiddleName]
		           ,[LastSurname]
		           ,[BirthDate]
		           ,[BirthSexDescriptorId]
		           ,[StudentUniqueId])
		     VALUES
		           (@StudentPrefix1
		           ,@@StudentFirstName1
		           ,@@StudentMiddleName1
		           ,@@StudentLastSurname1
		           ,'2000-07-29'
		           ,@BirthSexDescriptorId
		           ,@@StudentUniqueId1)
	
	set @StudentUSI1 = SCOPE_IDENTITY();

	INSERT INTO [edfi].[Student]
		           ([PersonalTitlePrefix]
		           ,[FirstName]
		           ,[MiddleName]
		           ,[LastSurname]
		           ,[BirthDate]
		           ,[BirthSexDescriptorId]
		           ,[StudentUniqueId])
		     VALUES
		           (@StudentPrefix2
		           ,@@StudentFirstName2
		           ,@@StudentMiddleName2
		           ,@@StudentLastSurname2
		           ,'1999-07-29'
		           ,@BirthSexDescriptorId
		           ,@@StudentUniqueId2)
	
	set @StudentUSI2 = SCOPE_IDENTITY();

	INSERT INTO [edfi].[Student]
		           ([PersonalTitlePrefix]
		           ,[FirstName]
		           ,[MiddleName]
		           ,[LastSurname]
		           ,[BirthDate]
		           ,[BirthSexDescriptorId]
		           ,[StudentUniqueId])
		     VALUES
		           (@StudentPrefix3
		           ,@@StudentFirstName3
		           ,@@StudentMiddleName3
		           ,@@StudentLastSurname3
		           ,'2003-09-03'
		           ,@BirthSexDescriptorId
		           ,@@StudentUniqueId3)
	
	set @StudentUSI3 = SCOPE_IDENTITY();

	INSERT INTO [edfi].[Student]
		           ([PersonalTitlePrefix]
		           ,[FirstName]
		           ,[MiddleName]
		           ,[LastSurname]
		           ,[BirthDate]
		           ,[BirthSexDescriptorId]
		           ,[StudentUniqueId])
		     VALUES
		           (@StudentPrefix4
		           ,@@StudentFirstName4
		           ,@@StudentMiddleName4
		           ,@@StudentLastSurname4
		           ,'2001-02-02'
		           ,@BirthSexDescriptorId
		           ,@@StudentUniqueId4)
	
	set @StudentUSI4 = SCOPE_IDENTITY();

	INSERT INTO [edfi].[Student]
		           ([PersonalTitlePrefix]
		           ,[FirstName]
		           ,[MiddleName]
		           ,[LastSurname]
		           ,[BirthDate]
		           ,[BirthSexDescriptorId]
		           ,[StudentUniqueId])
		     VALUES
		           (@StudentPrefix5
		           ,@@StudentFirstName5
		           ,@@StudentMiddleName5
		           ,@@StudentLastSurname5
		           ,'2003-05-15'
		           ,@BirthSexDescriptorId
		           ,@@StudentUniqueId5)
	
	set @StudentUSI5 = SCOPE_IDENTITY();

	INSERT INTO [edfi].[Student]
		           ([PersonalTitlePrefix]
		           ,[FirstName]
		           ,[MiddleName]
		           ,[LastSurname]
		           ,[BirthDate]
		           ,[BirthSexDescriptorId]
		           ,[StudentUniqueId])
		     VALUES
		           (@StudentPrefix6
		           ,@@StudentFirstName6
		           ,@@StudentMiddleName6
		           ,@@StudentLastSurname6
		           ,'2005-01-29'
		           ,@BirthSexDescriptorId
		           ,@@StudentUniqueId6)
	
	set @StudentUSI6 = SCOPE_IDENTITY();

	INSERT INTO [edfi].[Student]
		           ([PersonalTitlePrefix]
		           ,[FirstName]
		           ,[MiddleName]
		           ,[LastSurname]
		           ,[BirthDate]
		           ,[BirthSexDescriptorId]
		           ,[StudentUniqueId])
		     VALUES
		           (@StudentPrefix7
		           ,@@StudentFirstName7
		           ,@@StudentMiddleName7
		           ,@@StudentLastSurname7
		           ,'2006-09-17'
		           ,@BirthSexDescriptorId
		           ,@@StudentUniqueId7)
	
	set @StudentUSI7 = SCOPE_IDENTITY();
	
	declare @RegisterStudentInSchool nvarchar(10) = null;
	select @RegisterStudentInSchool = format(getDate(), 'yyyy-MM-dd');
	
	INSERT INTO [edfi].[Calendar]
           ([CalendarCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[CalendarTypeDescriptorId])
     VALUES
           (@CalendarCode
           ,@SchoolId
           ,@@CurrentSchoolYear
           ,@CalendarTypeDescriptorId)
	
	INSERT INTO [edfi].[Parent]
		           ([PersonalTitlePrefix]
		           ,[FirstName]
		           ,[LastSurname]
		           ,[SexDescriptorId]
		           ,[ParentUniqueId])
		     VALUES
		          ('Ms'
		           ,@@ParentFirstName1
		           ,@@ParentLastSurname1
		           ,@SexDescriptorIdMen
		           ,@@ParentUniqueId1)

	set @ParentUSI1 = SCOPE_IDENTITY();

	INSERT INTO [edfi].[Parent]
		           ([PersonalTitlePrefix]
		           ,[FirstName]
		           ,[LastSurname]
		           ,[SexDescriptorId]
		           ,[ParentUniqueId])
		     VALUES
		          ('Ms'
		           ,@@ParentFirstName2
		           ,@@ParentLastSurname2
		           ,@SexDescriptorIdMen
		           ,@@ParentUniqueId2)

	set @ParentUSI2 = SCOPE_IDENTITY();

	INSERT INTO [edfi].[Parent]
		           ([PersonalTitlePrefix]
		           ,[FirstName]
		           ,[LastSurname]
		           ,[SexDescriptorId]
		           ,[ParentUniqueId])
		     VALUES
		          ('Ms'
		           ,@@ParentFirstName3
		           ,@@ParentLastSurname3
		           ,@SexDescriptorIdMen
		           ,@@ParentUniqueId3)

	set @ParentUSI3 = SCOPE_IDENTITY();

	INSERT INTO [edfi].[Parent]
		           ([PersonalTitlePrefix]
		           ,[FirstName]
		           ,[LastSurname]
		           ,[SexDescriptorId]
		           ,[ParentUniqueId])
		     VALUES
		          ('Ms'
		           ,@@ParentFirstName4
		           ,@@ParentLastSurname4
		           ,@SexDescriptorIdWomen
		           ,@@ParentUniqueId4)

	set @ParentUSI4 = SCOPE_IDENTITY();

	INSERT INTO [edfi].[Parent]
		           ([PersonalTitlePrefix]
		           ,[FirstName]
		           ,[LastSurname]
		           ,[SexDescriptorId]
		           ,[ParentUniqueId])
		     VALUES
		          ('Ms'
		           ,@@ParentFirstName5
		           ,@@ParentLastSurname5
		           ,@SexDescriptorIdMen
		           ,@@ParentUniqueId5)

	set @ParentUSI5 = SCOPE_IDENTITY();

	INSERT INTO [edfi].[Parent]
		           ([PersonalTitlePrefix]
		           ,[FirstName]
		           ,[LastSurname]
		           ,[SexDescriptorId]
		           ,[ParentUniqueId])
		     VALUES
		          ('Ms'
		           ,@@ParentFirstName6
		           ,@@ParentLastSurname6
		           ,@SexDescriptorIdWomen
		           ,@@ParentUniqueId6)

	set @ParentUSI6 = SCOPE_IDENTITY();

	INSERT INTO [edfi].[Parent]
		           ([PersonalTitlePrefix]
		           ,[FirstName]
		           ,[LastSurname]
		           ,[SexDescriptorId]
		           ,[ParentUniqueId])
		     VALUES
		          ('Ms'
		           ,@@ParentFirstName7
		           ,@@ParentLastSurname7
		           ,@SexDescriptorIdWomen
		           ,@@ParentUniqueId7)

	set @ParentUSI7 = SCOPE_IDENTITY();
		
	INSERT INTO [edfi].[StudentParentAssociation] 
					([ParentUSI]
					,[StudentUSI]
					,[RelationDescriptorId]
					,[PrimaryContactStatus]
					,[LivesWith]
					,[EmergencyContactStatus]) 
			VALUES 
					(@ParentUSI1 
					,@StudentUSI1 
					,@RelationDescriptorIdFather
					,1
		            ,1
		            ,1);

	INSERT INTO [edfi].[StudentParentAssociation] 
					([ParentUSI]
					,[StudentUSI]
					,[RelationDescriptorId]
					,[PrimaryContactStatus]
					,[LivesWith]
					,[EmergencyContactStatus]) 
			VALUES 
					(@ParentUSI2 
					,@StudentUSI2
					,@RelationDescriptorIdFather
					,1
		            ,1
		            ,1)

	INSERT INTO [edfi].[StudentParentAssociation] 
					([ParentUSI]
					,[StudentUSI]
					,[RelationDescriptorId]
					,[PrimaryContactStatus]
					,[LivesWith]
					,[EmergencyContactStatus]) 
			VALUES 
					(@ParentUSI3 
					,@StudentUSI3
					,@RelationDescriptorIdFather
					,1
		            ,1
		            ,1)

	INSERT INTO [edfi].[StudentParentAssociation] 
					([ParentUSI]
					,[StudentUSI]
					,[RelationDescriptorId]
					,[PrimaryContactStatus]
					,[LivesWith]
					,[EmergencyContactStatus]) 
			VALUES 
					(@ParentUSI4
					,@StudentUSI4 
					,@RealationdescriporIdMother
					,1
		            ,1
		            ,1)

	INSERT INTO [edfi].[StudentParentAssociation] 
					([ParentUSI]
					,[StudentUSI]
					,[RelationDescriptorId]
					,[PrimaryContactStatus]
					,[LivesWith]
					,[EmergencyContactStatus]) 
			VALUES 
					(@ParentUSI5 
					,@StudentUSI5
					,@RelationDescriptorIdFather
					,1
		            ,1
		            ,1)

	INSERT INTO [edfi].[StudentParentAssociation] 
					([ParentUSI]
					,[StudentUSI]
					,[RelationDescriptorId]
					,[PrimaryContactStatus]
					,[LivesWith]
					,[EmergencyContactStatus]) 
			VALUES 
					(@ParentUSI6 
					,@StudentUSI6
					,@RealationdescriporIdMother
					,1
		            ,1
		            ,1)

	INSERT INTO [edfi].[StudentParentAssociation] 
					([ParentUSI]
					,[StudentUSI]
					,[RelationDescriptorId]
					,[PrimaryContactStatus]
					,[LivesWith]
					,[EmergencyContactStatus]) 
			VALUES 
					(@ParentUSI7
					,@StudentUSI7 
					,@RealationdescriporIdMother
					,1
		            ,1
		            ,1)
				   
		
		
		--INSERT INTO [edfi].[ParentAddress]
		--           ([AddressTypeDescriptorId]
		--           ,[ParentUSI]
		--           ,[StreetNumberName]
		--           ,[City]
		--           ,[StateAbbreviationDescriptorId]
		--           ,[PostalCode]
		--           ,[NameOfCounty])
		--     VALUES
		--           (@AddressTypeDescriptorId
		--           ,@@ParentUSI
		--           ,'123 Red Jay St'
		--           ,'Houston'
		--           ,@StateAbbreviationDescriptorId
		--           ,12123
		--           ,'United States')
		
	INSERT INTO [edfi].[ParentElectronicMail]
		           ([ElectronicMailTypeDescriptorId]
		           ,[ParentUSI]
		           ,[ElectronicMailAddress]
		           ,[PrimaryEmailAddressIndicator])
		     VALUES
		           (@ElectronicMailTypeDescriptorId
		           ,@ParentUSI1
		           ,@@EmailLogin1
		           ,1)

	INSERT INTO [edfi].[ParentElectronicMail]
		           ([ElectronicMailTypeDescriptorId]
		           ,[ParentUSI]
		           ,[ElectronicMailAddress]
		           ,[PrimaryEmailAddressIndicator])
		     VALUES
		           (@ElectronicMailTypeDescriptorId
		           ,@ParentUSI2
		           ,@@EmailLogin2
		           ,1)

	INSERT INTO [edfi].[ParentElectronicMail]
		           ([ElectronicMailTypeDescriptorId]
		           ,[ParentUSI]
		           ,[ElectronicMailAddress]
		           ,[PrimaryEmailAddressIndicator])
		     VALUES
		           (@ElectronicMailTypeDescriptorId
		           ,@ParentUSI3
		           ,@@EmailLogin3
		           ,1)

	INSERT INTO [edfi].[ParentElectronicMail]
		           ([ElectronicMailTypeDescriptorId]
		           ,[ParentUSI]
		           ,[ElectronicMailAddress]
		           ,[PrimaryEmailAddressIndicator])
		     VALUES
		           (@ElectronicMailTypeDescriptorId
		           ,@ParentUSI4
		           ,@@EmailLogin4
		           ,1)

	INSERT INTO [edfi].[ParentElectronicMail]
		           ([ElectronicMailTypeDescriptorId]
		           ,[ParentUSI]
		           ,[ElectronicMailAddress]
		           ,[PrimaryEmailAddressIndicator])
		     VALUES
		           (@ElectronicMailTypeDescriptorId
		           ,@ParentUSI5
		           ,@@EmailLogin5
		           ,1)

	INSERT INTO [edfi].[ParentElectronicMail]
		           ([ElectronicMailTypeDescriptorId]
		           ,[ParentUSI]
		           ,[ElectronicMailAddress]
		           ,[PrimaryEmailAddressIndicator])
		     VALUES
		           (@ElectronicMailTypeDescriptorId
		           ,@ParentUSI6
		           ,@@EmailLogin6
		           ,1)

	INSERT INTO [edfi].[ParentElectronicMail]
		           ([ElectronicMailTypeDescriptorId]
		           ,[ParentUSI]
		           ,[ElectronicMailAddress]
		           ,[PrimaryEmailAddressIndicator])
		     VALUES
		           (@ElectronicMailTypeDescriptorId
		           ,@ParentUSI7
		           ,@@EmailLogin7
		           ,1)
		
	declare @LocalClassroomIdentificationCode1 nvarchar(10) = 'test001';
	declare @LocalCourseCode1 nvarchar(10) = 'ART-01TEST';
	declare @LocalCourseTitle1 nvarchar(50) = 'Arts 1';
	declare @AcademicSubjectDescriptor1 int = 36;
	declare @SectionIdentifier1 nvarchar(50) = Concat(@SchoolId, 'Trad', @LocalClassroomIdentificationCode1 , 'ART01TEST' , CONVERT(varchar(10), @@CurrentSchoolYear));

	declare @LocalClassroomIdentificationCode2 nvarchar(10) = 'test002';
	declare @LocalCourseCode2 nvarchar(10) = 'SPA-01TEST';
	declare @LocalCourseTitle2 nvarchar(50) = 'Spanish 1';
	declare @AcademicSubjectDescriptor2 int = 38;
	declare @SectionIdentifier2 nvarchar(50) = Concat(@SchoolId,'Trad', @LocalClassroomIdentificationCode1 , 'SPA01TEST' , CONVERT(varchar(10), @@CurrentSchoolYear));

	declare @LocalClassroomIdentificationCode3 nvarchar(10) = 'test003';
	declare @LocalCourseCode3 nvarchar(10) = 'GEO-01TEST';
	declare @LocalCourseTitle3 nvarchar(50) = 'Geography 1';
	declare @AcademicSubjectDescriptor3 int = 48;
	declare @SectionIdentifier3 nvarchar(50) = Concat(@SchoolId,'Trad', @LocalClassroomIdentificationCode1 , 'GEO01TEST' , CONVERT(varchar(10), @@CurrentSchoolYear));

	declare @LocalClassroomIdentificationCode4 nvarchar(10) = 'test004';
	declare @LocalCourseCode4 nvarchar(10) = 'ENV-01TEST';
	declare @LocalCourseTitle4 nvarchar(50) = 'Enviroment 1';
	declare @AcademicSubjectDescriptor4 int = 31;
	declare @SectionIdentifier4 nvarchar(50) = Concat(@SchoolId,'Trad', @LocalClassroomIdentificationCode1 , 'ENV01TEST' , CONVERT(varchar(10), @@CurrentSchoolYear));

	declare @LocalClassroomIdentificationCode5 nvarchar(10) = 'test005';
	declare @LocalCourseCode5 nvarchar(10) = 'MAT-01TEST';
	declare @LocalCourseTitle5 nvarchar(50) = 'Math 1';
	declare @AcademicSubjectDescriptor5 int = 40;
	declare @SectionIdentifier5 nvarchar(50) = Concat(@SchoolId,'Trad', @LocalClassroomIdentificationCode1 , 'MAT01TEST' , CONVERT(varchar(10), @@CurrentSchoolYear));

	declare @LocalClassroomIdentificationCode6 nvarchar(10) = 'test006';
	declare @LocalCourseCode6 nvarchar(10) = 'ALG-01TEST';
	declare @LocalCourseTitle6 nvarchar(50) = 'Algebra 1';
	declare @AcademicSubjectDescriptor6 int = 40;
	declare @SectionIdentifier6 nvarchar(50) = Concat(@SchoolId,'Trad', @LocalClassroomIdentificationCode1 , 'ALG01TEST' , CONVERT(varchar(10), @@CurrentSchoolYear));

	declare @LocalClassroomIdentificationCode7 nvarchar(10) = 'test007';
	declare @LocalCourseCode7 nvarchar(10) = 'ENG-01TEST';
	declare @LocalCourseTitle7 nvarchar(50) = 'English 1';
	declare @AcademicSubjectDescriptor7 int = 36;
	declare @SectionIdentifier7 nvarchar(50) = Concat(@SchoolId,'Trad', @LocalClassroomIdentificationCode1 , 'ENG01TEST' , CONVERT(varchar(10), @@CurrentSchoolYear));

	--Sessions
	INSERT INTO [edfi].[Session]
           ([SchoolId]
           ,[SchoolYear]
           ,[SessionName]
           ,[BeginDate]
           ,[EndDate]
           ,[TermDescriptorId]
           ,[TotalInstructionalDays])
		VALUES
           (@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SessionNameSpring
           ,@BeginDate
           ,@EndDate
           ,@TermDescriptorIdSpring
           ,88)

	INSERT INTO [edfi].[Session]
           ([SchoolId]
           ,[SchoolYear]
           ,[SessionName]
           ,[BeginDate]
           ,[EndDate]
           ,[TermDescriptorId]
           ,[TotalInstructionalDays])
		VALUES
           (@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SessionNameFall
           ,@BeginDate
           ,@EndDate
           ,@TermDescriptorIdFall
           ,81)

	--Location Section

	INSERT INTO [edfi].[Location]
           ([ClassroomIdentificationCode]
           ,[SchoolId]
           ,[MaximumNumberOfSeats]
           ,[OptimalNumberOfSeats])
     VALUES
           (@LocalClassroomIdentificationCode1
           ,@SchoolId
           ,20
           ,18)

	INSERT INTO [edfi].[Location]
           ([ClassroomIdentificationCode]
           ,[SchoolId]
           ,[MaximumNumberOfSeats]
           ,[OptimalNumberOfSeats])
     VALUES
           (@LocalClassroomIdentificationCode2
           ,@SchoolId
           ,20
           ,18)

	INSERT INTO [edfi].[Location]
           ([ClassroomIdentificationCode]
           ,[SchoolId]
           ,[MaximumNumberOfSeats]
           ,[OptimalNumberOfSeats])
     VALUES
           (@LocalClassroomIdentificationCode3
           ,@SchoolId
           ,20
           ,18)

	INSERT INTO [edfi].[Location]
           ([ClassroomIdentificationCode]
           ,[SchoolId]
           ,[MaximumNumberOfSeats]
           ,[OptimalNumberOfSeats])
     VALUES
           (@LocalClassroomIdentificationCode4
           ,@SchoolId
           ,20
           ,18)

	INSERT INTO [edfi].[Location]
           ([ClassroomIdentificationCode]
           ,[SchoolId]
           ,[MaximumNumberOfSeats]
           ,[OptimalNumberOfSeats])
     VALUES
           (@LocalClassroomIdentificationCode5
           ,@SchoolId
           ,20
           ,18)

	INSERT INTO [edfi].[Location]
           ([ClassroomIdentificationCode]
           ,[SchoolId]
           ,[MaximumNumberOfSeats]
           ,[OptimalNumberOfSeats])
     VALUES
           (@LocalClassroomIdentificationCode6
           ,@SchoolId
           ,20
           ,18)

	INSERT INTO [edfi].[Location]
           ([ClassroomIdentificationCode]
           ,[SchoolId]
           ,[MaximumNumberOfSeats]
           ,[OptimalNumberOfSeats])
     VALUES
           (@LocalClassroomIdentificationCode7
           ,@SchoolId
           ,20
           ,18)

	--courses
	INSERT INTO [edfi].[Course]
           ([CourseCode]
           ,[EducationOrganizationId]
           ,[CourseTitle]
           ,[NumberOfParts]
           ,[AcademicSubjectDescriptorId]
           ,[CourseDescription]
           ,[HighSchoolCourseRequirement]
           ,[CourseGPAApplicabilityDescriptorId]
           ,[CourseDefinedByDescriptorId])
     VALUES
           (@LocalCourseCode1
           ,@SchoolId
           ,@LocalCourseTitle1
           ,1
           ,@AcademicSubjectDescriptor1
           ,@LocalCourseTitle1
           ,@HighSchoolCourseRequirement
           ,@CourseGPAApplicabilityDescriptorId
           ,@CourseDefinedByDescriptorId)

	INSERT INTO [edfi].[Course]
           ([CourseCode]
           ,[EducationOrganizationId]
           ,[CourseTitle]
           ,[NumberOfParts]
           ,[AcademicSubjectDescriptorId]
           ,[CourseDescription]
           ,[HighSchoolCourseRequirement]
           ,[CourseGPAApplicabilityDescriptorId]
           ,[CourseDefinedByDescriptorId])
     VALUES
           (@LocalCourseCode2
           ,@SchoolId
           ,@LocalCourseTitle2
           ,1
           ,@AcademicSubjectDescriptor2
           ,@LocalCourseTitle2
           ,@HighSchoolCourseRequirement
           ,@CourseGPAApplicabilityDescriptorId
           ,@CourseDefinedByDescriptorId)

	INSERT INTO [edfi].[Course]
           ([CourseCode]
           ,[EducationOrganizationId]
           ,[CourseTitle]
           ,[NumberOfParts]
           ,[AcademicSubjectDescriptorId]
           ,[CourseDescription]
           ,[HighSchoolCourseRequirement]
           ,[CourseGPAApplicabilityDescriptorId]
           ,[CourseDefinedByDescriptorId])
     VALUES
           (@LocalCourseCode3
           ,@SchoolId
           ,@LocalCourseTitle3
           ,1
           ,@AcademicSubjectDescriptor3
           ,@LocalCourseTitle3
           ,@HighSchoolCourseRequirement
           ,@CourseGPAApplicabilityDescriptorId
           ,@CourseDefinedByDescriptorId)

	INSERT INTO [edfi].[Course]
           ([CourseCode]
           ,[EducationOrganizationId]
           ,[CourseTitle]
           ,[NumberOfParts]
           ,[AcademicSubjectDescriptorId]
           ,[CourseDescription]
           ,[HighSchoolCourseRequirement]
           ,[CourseGPAApplicabilityDescriptorId]
           ,[CourseDefinedByDescriptorId])
     VALUES
           (@LocalCourseCode4
           ,@SchoolId
           ,@LocalCourseTitle4
           ,1
           ,@AcademicSubjectDescriptor4
           ,@LocalCourseTitle4
           ,@HighSchoolCourseRequirement
           ,@CourseGPAApplicabilityDescriptorId
           ,@CourseDefinedByDescriptorId)

	INSERT INTO [edfi].[Course]
           ([CourseCode]
           ,[EducationOrganizationId]
           ,[CourseTitle]
           ,[NumberOfParts]
           ,[AcademicSubjectDescriptorId]
           ,[CourseDescription]
           ,[HighSchoolCourseRequirement]
           ,[CourseGPAApplicabilityDescriptorId]
           ,[CourseDefinedByDescriptorId])
     VALUES
           (@LocalCourseCode5
           ,@SchoolId
           ,@LocalCourseTitle5
           ,1
           ,@AcademicSubjectDescriptor5
           ,@LocalCourseTitle5
           ,@HighSchoolCourseRequirement
           ,@CourseGPAApplicabilityDescriptorId
           ,@CourseDefinedByDescriptorId)

	INSERT INTO [edfi].[Course]
           ([CourseCode]
           ,[EducationOrganizationId]
           ,[CourseTitle]
           ,[NumberOfParts]
           ,[AcademicSubjectDescriptorId]
           ,[CourseDescription]
           ,[HighSchoolCourseRequirement]
           ,[CourseGPAApplicabilityDescriptorId]
           ,[CourseDefinedByDescriptorId])
     VALUES
           (@LocalCourseCode6
           ,@SchoolId
           ,@LocalCourseTitle6
           ,1
           ,@AcademicSubjectDescriptor6
           ,@LocalCourseTitle6
           ,@HighSchoolCourseRequirement
           ,@CourseGPAApplicabilityDescriptorId
           ,@CourseDefinedByDescriptorId)

	INSERT INTO [edfi].[Course]
           ([CourseCode]
           ,[EducationOrganizationId]
           ,[CourseTitle]
           ,[NumberOfParts]
           ,[AcademicSubjectDescriptorId]
           ,[CourseDescription]
           ,[HighSchoolCourseRequirement]
           ,[CourseGPAApplicabilityDescriptorId]
           ,[CourseDefinedByDescriptorId])
     VALUES
           (@LocalCourseCode7
           ,@SchoolId
           ,@LocalCourseTitle7
           ,1
           ,@AcademicSubjectDescriptor7
           ,@LocalCourseTitle7
           ,@HighSchoolCourseRequirement
           ,@CourseGPAApplicabilityDescriptorId
           ,@CourseDefinedByDescriptorId)

	--course offering

	INSERT INTO [edfi].[CourseOffering]
           ([LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SessionName]
           ,[LocalCourseTitle]
           ,[CourseCode]
           ,[EducationOrganizationId])
     VALUES
           (@LocalCourseCode1 
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SessionNameSpring
           ,@LocalCourseTitle1
           ,@LocalCourseCode1
		   ,@SchoolId)

	INSERT INTO [edfi].[CourseOffering]
           ([LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SessionName]
           ,[LocalCourseTitle]
           ,[CourseCode]
           ,[EducationOrganizationId])
     VALUES
           (@LocalCourseCode2
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SessionNameSpring
           ,@LocalCourseTitle2
           ,@LocalCourseCode2
		   ,@SchoolId)

	INSERT INTO [edfi].[CourseOffering]
           ([LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SessionName]
           ,[LocalCourseTitle]
           ,[CourseCode]
           ,[EducationOrganizationId])
     VALUES
           (@LocalCourseCode3 
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SessionNameSpring
           ,@LocalCourseTitle3
           ,@LocalCourseCode3
		   ,@SchoolId)

	INSERT INTO [edfi].[CourseOffering]
           ([LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SessionName]
           ,[LocalCourseTitle]
           ,[CourseCode]
           ,[EducationOrganizationId])
     VALUES
           (@LocalCourseCode4
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SessionNameSpring
           ,@LocalCourseTitle4
           ,@LocalCourseCode4
		   ,@SchoolId)

	INSERT INTO [edfi].[CourseOffering]
           ([LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SessionName]
           ,[LocalCourseTitle]
           ,[CourseCode]
           ,[EducationOrganizationId])
     VALUES
           (@LocalCourseCode5 
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SessionNameSpring
           ,@LocalCourseTitle5
           ,@LocalCourseCode5
		   ,@SchoolId)

	INSERT INTO [edfi].[CourseOffering]
           ([LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SessionName]
           ,[LocalCourseTitle]
           ,[CourseCode]
           ,[EducationOrganizationId])
     VALUES
           (@LocalCourseCode6
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SessionNameSpring
           ,@LocalCourseTitle6
           ,@LocalCourseCode6
		   ,@SchoolId)

	INSERT INTO [edfi].[CourseOffering]
           ([LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SessionName]
           ,[LocalCourseTitle]
           ,[CourseCode]
           ,[EducationOrganizationId])
     VALUES
           (@LocalCourseCode7
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SessionNameSpring
           ,@LocalCourseTitle7
           ,@LocalCourseCode7
		   ,@SchoolId)

	--Sections
	INSERT INTO [edfi].[Section]
           ([LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName]
           ,[SequenceOfCourse]
           ,[EducationalEnvironmentDescriptorId]
           ,[AvailableCredits]
           ,[LocationSchoolId]
           ,[LocationClassroomIdentificationCode])
     VALUES
           (@LocalCourseCode1
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SectionIdentifier1
           ,@SessionNameSpring
           ,1
           ,@EducationalEnvironmentDescriptorId
           ,1.000
           ,@SchoolId
           ,@LocalClassroomIdentificationCode1)

	INSERT INTO [edfi].[Section]
           ([LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName]
           ,[SequenceOfCourse]
           ,[EducationalEnvironmentDescriptorId]
           ,[AvailableCredits]
           ,[LocationSchoolId]
           ,[LocationClassroomIdentificationCode])
     VALUES
           (@LocalCourseCode2
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SectionIdentifier2
           ,@SessionNameSpring
           ,1
           ,@EducationalEnvironmentDescriptorId
           ,1.000
           ,@SchoolId
           ,@LocalClassroomIdentificationCode2)

	INSERT INTO [edfi].[Section]
           ([LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName]
           ,[SequenceOfCourse]
           ,[EducationalEnvironmentDescriptorId]
           ,[AvailableCredits]
           ,[LocationSchoolId]
           ,[LocationClassroomIdentificationCode])
     VALUES
           (@LocalCourseCode3
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SectionIdentifier3
           ,@SessionNameSpring
           ,1
           ,@EducationalEnvironmentDescriptorId
           ,1.000
           ,@SchoolId
           ,@LocalClassroomIdentificationCode3)

	INSERT INTO [edfi].[Section]
           ([LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName]
           ,[SequenceOfCourse]
           ,[EducationalEnvironmentDescriptorId]
           ,[AvailableCredits]
           ,[LocationSchoolId]
           ,[LocationClassroomIdentificationCode])
     VALUES
           (@LocalCourseCode4
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SectionIdentifier4
           ,@SessionNameSpring
           ,1
           ,@EducationalEnvironmentDescriptorId
           ,1.000
           ,@SchoolId
           ,@LocalClassroomIdentificationCode4)

	INSERT INTO [edfi].[Section]
	           ([LocalCourseCode]
	           ,[SchoolId]
	           ,[SchoolYear]
	           ,[SectionIdentifier]
	           ,[SessionName]
	           ,[SequenceOfCourse]
	           ,[EducationalEnvironmentDescriptorId]
	           ,[AvailableCredits]
	           ,[LocationSchoolId]
	           ,[LocationClassroomIdentificationCode])
	     VALUES
	           (@LocalCourseCode5
	           ,@SchoolId
	           ,CONVERT(varchar(10), @@CurrentSchoolYear)
	           ,@SectionIdentifier5
	           ,@SessionNameSpring
	           ,1
	           ,@EducationalEnvironmentDescriptorId
	           ,1.000
	           ,@SchoolId
	           ,@LocalClassroomIdentificationCode5)

	INSERT INTO [edfi].[Section]
           ([LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName]
           ,[SequenceOfCourse]
           ,[EducationalEnvironmentDescriptorId]
           ,[AvailableCredits]
           ,[LocationSchoolId]
           ,[LocationClassroomIdentificationCode])
     VALUES
           (@LocalCourseCode6
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SectionIdentifier6
           ,@SessionNameSpring
           ,1
           ,@EducationalEnvironmentDescriptorId
           ,1.000
           ,@SchoolId
           ,@LocalClassroomIdentificationCode6)

	INSERT INTO [edfi].[Section]
           ([LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName]
           ,[SequenceOfCourse]
           ,[EducationalEnvironmentDescriptorId]
           ,[AvailableCredits]
           ,[LocationSchoolId]
           ,[LocationClassroomIdentificationCode])
     VALUES
           (@LocalCourseCode7
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SectionIdentifier7
           ,@SessionNameSpring
           ,1
           ,@EducationalEnvironmentDescriptorId
           ,1.000
           ,@SchoolId
           ,@LocalClassroomIdentificationCode7)

	--Courses entrys
	INSERT INTO [edfi].[GradebookEntry]
           ([DateAssigned]
           ,[GradebookEntryTitle]
           ,[LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName]
           ,[GradebookEntryTypeDescriptorId])
     VALUES
           (@RegisterStudentInSchool
           ,'Assigment 1'
           ,@LocalCourseCode1
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SectionIdentifier1
           ,@SessionNameSpring
           ,@GradebookEntryTypeDescriptorId)

	INSERT INTO [edfi].[GradebookEntry]
           ([DateAssigned]
           ,[GradebookEntryTitle]
           ,[LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName]
           ,[GradebookEntryTypeDescriptorId])
     VALUES
           (@RegisterStudentInSchool
           ,'Assigment 1'
           ,@LocalCourseCode2
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SectionIdentifier2
           ,@SessionNameSpring
           ,@GradebookEntryTypeDescriptorId)

	INSERT INTO [edfi].[GradebookEntry]
           ([DateAssigned]
           ,[GradebookEntryTitle]
           ,[LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName]
           ,[GradebookEntryTypeDescriptorId])
     VALUES
           (@RegisterStudentInSchool
           ,'Assigment 1'
           ,@LocalCourseCode3
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SectionIdentifier3
           ,@SessionNameSpring
           ,@GradebookEntryTypeDescriptorId)

	INSERT INTO [edfi].[GradebookEntry]
           ([DateAssigned]
           ,[GradebookEntryTitle]
           ,[LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName]
           ,[GradebookEntryTypeDescriptorId])
     VALUES
           (@RegisterStudentInSchool
           ,'Assigment 1'
           ,@LocalCourseCode4
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SectionIdentifier4
           ,@SessionNameSpring
           ,@GradebookEntryTypeDescriptorId)

	INSERT INTO [edfi].[GradebookEntry]
           ([DateAssigned]
           ,[GradebookEntryTitle]
           ,[LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName]
           ,[GradebookEntryTypeDescriptorId])
     VALUES
           (@RegisterStudentInSchool
           ,'Assigment 1'
           ,@LocalCourseCode5
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SectionIdentifier5
           ,@SessionNameSpring
           ,@GradebookEntryTypeDescriptorId)

	INSERT INTO [edfi].[GradebookEntry]
           ([DateAssigned]
           ,[GradebookEntryTitle]
           ,[LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName]
           ,[GradebookEntryTypeDescriptorId])
     VALUES
           (@RegisterStudentInSchool
           ,'Assigment 1'
           ,@LocalCourseCode6
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SectionIdentifier6
           ,@SessionNameSpring
           ,@GradebookEntryTypeDescriptorId)

	INSERT INTO [edfi].[GradebookEntry]
           ([DateAssigned]
           ,[GradebookEntryTitle]
           ,[LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName]
           ,[GradebookEntryTypeDescriptorId])
     VALUES
           (@RegisterStudentInSchool
           ,'Assigment 1'
           ,@LocalCourseCode7
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SectionIdentifier7
           ,@SessionNameSpring
           ,@GradebookEntryTypeDescriptorId)


	--Student GradebookEntry

	
	--INSERT INTO [edfi].[StudentGradebookEntry]
 --          ([BeginDate]
 --          ,[DateAssigned]
 --          ,[GradebookEntryTitle]
 --          ,[LocalCourseCode]
 --          ,[SchoolId]
 --          ,[SchoolYear]
 --          ,[SectionIdentifier]
 --          ,[SessionName]
 --          ,[StudentUSI]
 --          ,[NumericGradeEarned])
 --    VALUES
 --          (@RegisterStudentInSchool
 --          ,@RegisterStudentInSchool
 --          ,'Assigment 1'
 --          ,@LocalCourseCode1
 --          ,@SchoolId
 --          ,@@CurrentSchoolYear
 --          ,@SectionIdentifier1
 --          ,@SessionNameSpring
 --          ,@StudentUSI1
 --          ,74.00)

	--staff
	
	INSERT INTO [edfi].[Staff]
           ([PersonalTitlePrefix]
           ,[FirstName]
           ,[MiddleName]
           ,[LastSurname]
           ,[SexDescriptorId]
           ,[BirthDate]
           ,[HispanicLatinoEthnicity]
           ,[OldEthnicityDescriptorId]
           ,[HighestCompletedLevelOfEducationDescriptorId]
           ,[YearsOfPriorProfessionalExperience]
           ,[YearsOfPriorTeachingExperience]
           ,[LoginId]
           ,[HighlyQualifiedTeacher]
           ,[StaffUniqueId])
     VALUES
           (@StaffPersonalPrefix1
           ,@StaffFirstName1
           ,@StaffMiddleName1
           ,@StaffLastName1
           ,@SexDescriptorIdMen
           ,@StaffBirthDate1
           ,@StaffHispanicLatinoEthnicity1
           ,@CitizenshipStatusDescriptorIdHispanic
           ,@HighestCompletedLevelOfEducationDescriptorIdB
           ,@YearsOfPriorProfessionalExperience1
           ,@YearsOfPriorTeachingExperience1
           ,@LoginId1
           ,@HighlyQualifiedTeacher1
           ,@StaffUniqueId1)

	set @StaffUSI1 = SCOPE_IDENTITY();

	INSERT INTO [edfi].[Staff]
           ([PersonalTitlePrefix]
           ,[FirstName]
           ,[MiddleName]
           ,[LastSurname]
           ,[SexDescriptorId]
           ,[BirthDate]
           ,[HispanicLatinoEthnicity]
           ,[OldEthnicityDescriptorId]
           ,[HighestCompletedLevelOfEducationDescriptorId]
           ,[YearsOfPriorProfessionalExperience]
           ,[YearsOfPriorTeachingExperience]
           ,[LoginId]
           ,[HighlyQualifiedTeacher]
           ,[StaffUniqueId])
     VALUES
           (@StaffPersonalPrefix2
           ,@StaffFirstName2
           ,@StaffMiddleName2
           ,@StaffLastName2
           ,@SexDescriptorIdMen
           ,@StaffBirthDate2
           ,@StaffHispanicLatinoEthnicity2
           ,@CitizenshipStatusDescriptorIdHispanic
           ,@HighestCompletedLevelOfEducationDescriptorIdB
           ,@YearsOfPriorProfessionalExperience2
           ,@YearsOfPriorTeachingExperience2
           ,@LoginId2
           ,@HighlyQualifiedTeacher2
           ,@StaffUniqueId2)

	set @StaffUSI2 = SCOPE_IDENTITY();
	
	INSERT INTO [edfi].[Staff]
           ([PersonalTitlePrefix]
           ,[FirstName]
           ,[MiddleName]
           ,[LastSurname]
           ,[SexDescriptorId]
           ,[BirthDate]
           ,[HispanicLatinoEthnicity]
           ,[OldEthnicityDescriptorId]
           ,[HighestCompletedLevelOfEducationDescriptorId]
           ,[YearsOfPriorProfessionalExperience]
           ,[YearsOfPriorTeachingExperience]
           ,[LoginId]
           ,[HighlyQualifiedTeacher]
           ,[StaffUniqueId])
     VALUES
           (@StaffPersonalPrefix3
           ,@StaffFirstName3
           ,@StaffMiddleName3
           ,@StaffLastName3
           ,@SexDescriptorIdMen
           ,@StaffBirthDate3
           ,@StaffHispanicLatinoEthnicity3
           ,@CitizenshipStatusDescriptorIdHispanic
           ,@HighestCompletedLevelOfEducationDescriptorIdB
           ,@YearsOfPriorProfessionalExperience3
           ,@YearsOfPriorTeachingExperience3
           ,@LoginId3
           ,@HighlyQualifiedTeacher3
           ,@StaffUniqueId3)

	set @StaffUSI3 = SCOPE_IDENTITY();

	INSERT INTO [edfi].[Staff]
           ([PersonalTitlePrefix]
           ,[FirstName]
           ,[MiddleName]
           ,[LastSurname]
           ,[SexDescriptorId]
           ,[BirthDate]
           ,[HispanicLatinoEthnicity]
           ,[OldEthnicityDescriptorId]
           ,[HighestCompletedLevelOfEducationDescriptorId]
           ,[YearsOfPriorProfessionalExperience]
           ,[YearsOfPriorTeachingExperience]
           ,[LoginId]
           ,[HighlyQualifiedTeacher]
           ,[StaffUniqueId])
     VALUES
           (@StaffPersonalPrefix4
           ,@StaffFirstName4
           ,@StaffMiddleName4
           ,@StaffLastName4
           ,@SexDescriptorIdMen
           ,@StaffBirthDate4
           ,@StaffHispanicLatinoEthnicity4
           ,@CitizenshipStatusDescriptorIdHispanic
           ,@HighestCompletedLevelOfEducationDescriptorIdB
           ,@YearsOfPriorProfessionalExperience4
           ,@YearsOfPriorTeachingExperience4
           ,@LoginId4
           ,@HighlyQualifiedTeacher4
           ,@StaffUniqueId4)

	set @StaffUSI4 = SCOPE_IDENTITY();
	
	INSERT INTO [edfi].[Staff]
           ([PersonalTitlePrefix]
           ,[FirstName]
           ,[MiddleName]
           ,[LastSurname]
           ,[SexDescriptorId]
           ,[BirthDate]
           ,[HispanicLatinoEthnicity]
           ,[OldEthnicityDescriptorId]
           ,[HighestCompletedLevelOfEducationDescriptorId]
           ,[YearsOfPriorProfessionalExperience]
           ,[YearsOfPriorTeachingExperience]
           ,[LoginId]
           ,[HighlyQualifiedTeacher]
           ,[StaffUniqueId])
     VALUES
           (@StaffPersonalPrefix5
           ,@StaffFirstName5
           ,@StaffMiddleName5
           ,@StaffLastName5
           ,@SexDescriptorIdMen
           ,@StaffBirthDate5
           ,@StaffHispanicLatinoEthnicity5
           ,@CitizenshipStatusDescriptorIdHispanic
           ,@HighestCompletedLevelOfEducationDescriptorIdB
           ,@YearsOfPriorProfessionalExperience5
           ,@YearsOfPriorTeachingExperience5
           ,@LoginId5
           ,@HighlyQualifiedTeacher5
           ,@StaffUniqueId5)

	set @StaffUSI5 = SCOPE_IDENTITY();

	INSERT INTO [edfi].[Staff]
           ([PersonalTitlePrefix]
           ,[FirstName]
           ,[MiddleName]
           ,[LastSurname]
           ,[SexDescriptorId]
           ,[BirthDate]
           ,[HispanicLatinoEthnicity]
           ,[OldEthnicityDescriptorId]
           ,[HighestCompletedLevelOfEducationDescriptorId]
           ,[YearsOfPriorProfessionalExperience]
           ,[YearsOfPriorTeachingExperience]
           ,[LoginId]
           ,[HighlyQualifiedTeacher]
           ,[StaffUniqueId])
     VALUES
           (@StaffPersonalPrefix6
           ,@StaffFirstName6
           ,@StaffMiddleName6
           ,@StaffLastName6
           ,@SexDescriptorIdMen
           ,@StaffBirthDate6
           ,@StaffHispanicLatinoEthnicity6
           ,@CitizenshipStatusDescriptorIdHispanic
           ,@HighestCompletedLevelOfEducationDescriptorIdB
           ,@YearsOfPriorProfessionalExperience6
           ,@YearsOfPriorTeachingExperience6
           ,@LoginId6
           ,@HighlyQualifiedTeacher6
           ,@StaffUniqueId6)

	set @StaffUSI6 = SCOPE_IDENTITY();

	INSERT INTO [edfi].[Staff]
           ([PersonalTitlePrefix]
           ,[FirstName]
           ,[MiddleName]
           ,[LastSurname]
           ,[SexDescriptorId]
           ,[BirthDate]
           ,[HispanicLatinoEthnicity]
           ,[OldEthnicityDescriptorId]
           ,[HighestCompletedLevelOfEducationDescriptorId]
           ,[YearsOfPriorProfessionalExperience]
           ,[YearsOfPriorTeachingExperience]
           ,[LoginId]
           ,[HighlyQualifiedTeacher]
           ,[StaffUniqueId])
     VALUES
           (@StaffPersonalPrefix7
           ,@StaffFirstName7
           ,@StaffMiddleName7
           ,@StaffLastName7
           ,@SexDescriptorIdMen
           ,@StaffBirthDate7
           ,@StaffHispanicLatinoEthnicity7
           ,@CitizenshipStatusDescriptorIdHispanic
           ,@HighestCompletedLevelOfEducationDescriptorIdB
           ,@YearsOfPriorProfessionalExperience7
           ,@YearsOfPriorTeachingExperience7
           ,@LoginId7
           ,@HighlyQualifiedTeacher7
           ,@StaffUniqueId7)

	set @StaffUSI7 = SCOPE_IDENTITY();

	-- Staff Email
	INSERT INTO [edfi].[StaffElectronicMail]
           ([ElectronicMailTypeDescriptorId]
           ,[StaffUSI]
           ,[ElectronicMailAddress])
     VALUES
           (@EmailTypeWork
           ,@StaffUSI1
           ,@StaffEmail1)

	INSERT INTO [edfi].[StaffElectronicMail]
           ([ElectronicMailTypeDescriptorId]
           ,[StaffUSI]
           ,[ElectronicMailAddress])
     VALUES
           (@EmailTypeWork
           ,@StaffUSI2
           ,@StaffEmail2)

	INSERT INTO [edfi].[StaffElectronicMail]
           ([ElectronicMailTypeDescriptorId]
           ,[StaffUSI]
           ,[ElectronicMailAddress])
     VALUES
           (@EmailTypeWork
           ,@StaffUSI3
           ,@StaffEmail3)

	INSERT INTO [edfi].[StaffElectronicMail]
           ([ElectronicMailTypeDescriptorId]
           ,[StaffUSI]
           ,[ElectronicMailAddress])
     VALUES
           (@EmailTypeWork
           ,@StaffUSI4
           ,@StaffEmail4)

	INSERT INTO [edfi].[StaffElectronicMail]
           ([ElectronicMailTypeDescriptorId]
           ,[StaffUSI]
           ,[ElectronicMailAddress])
     VALUES
           (@EmailTypeWork
           ,@StaffUSI5
           ,@StaffEmail5)

	INSERT INTO [edfi].[StaffElectronicMail]
           ([ElectronicMailTypeDescriptorId]
           ,[StaffUSI]
           ,[ElectronicMailAddress])
     VALUES
           (@EmailTypeWork
           ,@StaffUSI6
           ,@StaffEmail6)

	INSERT INTO [edfi].[StaffElectronicMail]
           ([ElectronicMailTypeDescriptorId]
           ,[StaffUSI]
           ,[ElectronicMailAddress])
     VALUES
           (@EmailTypeWork
           ,@StaffUSI7
           ,@StaffEmail7)

	-- Staff School Association
	INSERT INTO [edfi].[StaffSchoolAssociation]
           ([ProgramAssignmentDescriptorId]
           ,[SchoolId]
           ,[StaffUSI])
     VALUES
           (@ProgramAssignmentDescriptorId
           ,@SchoolId
           ,@StaffUSI1);

	INSERT INTO [edfi].[StaffSchoolAssociation]
           ([ProgramAssignmentDescriptorId]
           ,[SchoolId]
           ,[StaffUSI])
     VALUES
           (@ProgramAssignmentDescriptorId
           ,@SchoolId
           ,@StaffUSI2);

	INSERT INTO [edfi].[StaffSchoolAssociation]
           ([ProgramAssignmentDescriptorId]
           ,[SchoolId]
           ,[StaffUSI])
     VALUES
           (@ProgramAssignmentDescriptorId
           ,@SchoolId
           ,@StaffUSI3);

	INSERT INTO [edfi].[StaffSchoolAssociation]
           ([ProgramAssignmentDescriptorId]
           ,[SchoolId]
           ,[StaffUSI])
     VALUES
           (@ProgramAssignmentDescriptorId
           ,@SchoolId
           ,@StaffUSI4);

	INSERT INTO [edfi].[StaffSchoolAssociation]
           ([ProgramAssignmentDescriptorId]
           ,[SchoolId]
           ,[StaffUSI])
     VALUES
           (@ProgramAssignmentDescriptorId
           ,@SchoolId
           ,@StaffUSI5);

	INSERT INTO [edfi].[StaffSchoolAssociation]
           ([ProgramAssignmentDescriptorId]
           ,[SchoolId]
           ,[StaffUSI])
     VALUES
           (@ProgramAssignmentDescriptorId
           ,@SchoolId
           ,@StaffUSI6);

	INSERT INTO [edfi].[StaffSchoolAssociation]
           ([ProgramAssignmentDescriptorId]
           ,[SchoolId]
           ,[StaffUSI])
     VALUES
           (@ProgramAssignmentDescriptorId
           ,@SchoolId
           ,@StaffUSI7);

	-- Staff School Association GradeLevel
	
	INSERT INTO [edfi].[StaffSchoolAssociationGradeLevel]
           ([GradeLevelDescriptorId]
           ,[ProgramAssignmentDescriptorId]
           ,[SchoolId]
           ,[StaffUSI])
     VALUES
           (@GradeLevelDescriptorIdTenthGrade
           ,@ProgramAssignmentDescriptorId
           ,@SchoolId
           ,@StaffUSI1)

	INSERT INTO [edfi].[StaffSchoolAssociationGradeLevel]
           ([GradeLevelDescriptorId]
           ,[ProgramAssignmentDescriptorId]
           ,[SchoolId]
           ,[StaffUSI])
     VALUES
           (@GradeLevelDescriptorIdTenthGrade
           ,@ProgramAssignmentDescriptorId
           ,@SchoolId
           ,@StaffUSI2)

	INSERT INTO [edfi].[StaffSchoolAssociationGradeLevel]
           ([GradeLevelDescriptorId]
           ,[ProgramAssignmentDescriptorId]
           ,[SchoolId]
           ,[StaffUSI])
     VALUES
           (@GradeLevelDescriptorIdTenthGrade
           ,@ProgramAssignmentDescriptorId
           ,@SchoolId
           ,@StaffUSI3)

	INSERT INTO [edfi].[StaffSchoolAssociationGradeLevel]
           ([GradeLevelDescriptorId]
           ,[ProgramAssignmentDescriptorId]
           ,[SchoolId]
           ,[StaffUSI])
     VALUES
           (@GradeLevelDescriptorIdTenthGrade
           ,@ProgramAssignmentDescriptorId
           ,@SchoolId
           ,@StaffUSI4)

	INSERT INTO [edfi].[StaffSchoolAssociationGradeLevel]
           ([GradeLevelDescriptorId]
           ,[ProgramAssignmentDescriptorId]
           ,[SchoolId]
           ,[StaffUSI])
     VALUES
           (@GradeLevelDescriptorIdTenthGrade
           ,@ProgramAssignmentDescriptorId
           ,@SchoolId
           ,@StaffUSI5)

	INSERT INTO [edfi].[StaffSchoolAssociationGradeLevel]
           ([GradeLevelDescriptorId]
           ,[ProgramAssignmentDescriptorId]
           ,[SchoolId]
           ,[StaffUSI])
     VALUES
           (@GradeLevelDescriptorIdTenthGrade
           ,@ProgramAssignmentDescriptorId
           ,@SchoolId
           ,@StaffUSI6)

	INSERT INTO [edfi].[StaffSchoolAssociationGradeLevel]
           ([GradeLevelDescriptorId]
           ,[ProgramAssignmentDescriptorId]
           ,[SchoolId]
           ,[StaffUSI])
     VALUES
           (@GradeLevelDescriptorIdTenthGrade
           ,@ProgramAssignmentDescriptorId
           ,@SchoolId
           ,@StaffUSI7)

	-- Staff Education Organization Assigment Association
	INSERT INTO [edfi].[StaffEducationOrganizationAssignmentAssociation]
           ([BeginDate]
           ,[EducationOrganizationId]
           ,[StaffClassificationDescriptorId]
           ,[StaffUSI]
           ,[PositionTitle])
     VALUES
           (@RegisterStudentInSchool
           ,@SchoolId
           ,@StaffClassificationDescriptorIdPrincipal
           ,@StaffUSI1
           ,@PositionTitlePrincipal)

	INSERT INTO [edfi].[StaffEducationOrganizationAssignmentAssociation]
           ([BeginDate]
           ,[EducationOrganizationId]
           ,[StaffClassificationDescriptorId]
           ,[StaffUSI]
           ,[PositionTitle])
     VALUES
           (@RegisterStudentInSchool
           ,@SchoolId
           ,@StaffClassificationDescriptorIdTeacher
           ,@StaffUSI2
           ,@PositionTitleELATeacher)

	INSERT INTO [edfi].[StaffEducationOrganizationAssignmentAssociation]
           ([BeginDate]
           ,[EducationOrganizationId]
           ,[StaffClassificationDescriptorId]
           ,[StaffUSI]
           ,[PositionTitle])
     VALUES
           (@RegisterStudentInSchool
           ,@SchoolId
           ,@StaffClassificationDescriptorIdTeacher
           ,@StaffUSI3
           ,@PositionTitleELATeacher)

	INSERT INTO [edfi].[StaffEducationOrganizationAssignmentAssociation]
           ([BeginDate]
           ,[EducationOrganizationId]
           ,[StaffClassificationDescriptorId]
           ,[StaffUSI]
           ,[PositionTitle])
     VALUES
           (@RegisterStudentInSchool
           ,@SchoolId
           ,@StaffClassificationDescriptorIdTeacher
           ,@StaffUSI4
           ,@PositionTitleELATeacher)

	INSERT INTO [edfi].[StaffEducationOrganizationAssignmentAssociation]
           ([BeginDate]
           ,[EducationOrganizationId]
           ,[StaffClassificationDescriptorId]
           ,[StaffUSI]
           ,[PositionTitle])
     VALUES
           (@RegisterStudentInSchool
           ,@SchoolId
           ,@StaffClassificationDescriptorIdTeacher
           ,@StaffUSI5
           ,@PositionTitleELATeacher)

	INSERT INTO [edfi].[StaffEducationOrganizationAssignmentAssociation]
           ([BeginDate]
           ,[EducationOrganizationId]
           ,[StaffClassificationDescriptorId]
           ,[StaffUSI]
           ,[PositionTitle])
     VALUES
           (@RegisterStudentInSchool
           ,@SchoolId
           ,@StaffClassificationDescriptorIdTeacher
           ,@StaffUSI6
           ,@PositionTitleELATeacher)

	INSERT INTO [edfi].[StaffEducationOrganizationAssignmentAssociation]
           ([BeginDate]
           ,[EducationOrganizationId]
           ,[StaffClassificationDescriptorId]
           ,[StaffUSI]
           ,[PositionTitle])
     VALUES
           (@RegisterStudentInSchool
           ,@SchoolId
           ,@StaffClassificationDescriptorIdTeacher
           ,@StaffUSI7
           ,@PositionTitleELATeacher)

	
	-- Staff section association 	
	INSERT INTO [edfi].[StaffSectionAssociation]
           ([LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName]
           ,[StaffUSI]
           ,[ClassroomPositionDescriptorId]
           ,[BeginDate]
           ,[EndDate])
     VALUES
           (@LocalCourseCode1
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SectionIdentifier1
           ,@SessionNameSpring
           ,@StaffUSI1
           ,@ClassroomPositionDescriptorId
           ,CONVERT(varchar(10), @@CurrentSchoolYear) + '-01-04'
           ,CONVERT(varchar(10), @@CurrentSchoolYear) + '-05-27')

	INSERT INTO [edfi].[StaffSectionAssociation]
           ([LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName]
           ,[StaffUSI]
           ,[ClassroomPositionDescriptorId]
           ,[BeginDate]
           ,[EndDate])
     VALUES
           (@LocalCourseCode2
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SectionIdentifier2
           ,@SessionNameSpring
           ,@StaffUSI2
           ,@ClassroomPositionDescriptorId
           ,CONVERT(varchar(10), @@CurrentSchoolYear) + '-01-04'
           ,CONVERT(varchar(10), @@CurrentSchoolYear) + '-05-27')

	INSERT INTO [edfi].[StaffSectionAssociation]
           ([LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName]
           ,[StaffUSI]
           ,[ClassroomPositionDescriptorId]
           ,[BeginDate]
           ,[EndDate])
     VALUES
           (@LocalCourseCode3
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SectionIdentifier3
           ,@SessionNameSpring
           ,@StaffUSI3
           ,@ClassroomPositionDescriptorId
           ,CONVERT(varchar(10), @@CurrentSchoolYear) + '-01-04'
           ,CONVERT(varchar(10), @@CurrentSchoolYear) + '-05-27')

	INSERT INTO [edfi].[StaffSectionAssociation]
           ([LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName]
           ,[StaffUSI]
           ,[ClassroomPositionDescriptorId]
           ,[BeginDate]
           ,[EndDate])
     VALUES
           (@LocalCourseCode4
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SectionIdentifier4
           ,@SessionNameSpring
           ,@StaffUSI4
           ,@ClassroomPositionDescriptorId
           ,CONVERT(varchar(10), @@CurrentSchoolYear) + '-01-04'
           ,CONVERT(varchar(10), @@CurrentSchoolYear) + '-05-27')

	INSERT INTO [edfi].[StaffSectionAssociation]
           ([LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName]
           ,[StaffUSI]
           ,[ClassroomPositionDescriptorId]
           ,[BeginDate]
           ,[EndDate])
     VALUES
           (@LocalCourseCode5
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SectionIdentifier5
           ,@SessionNameSpring
           ,@StaffUSI5
           ,@ClassroomPositionDescriptorId
           ,CONVERT(varchar(10), @@CurrentSchoolYear) + '-01-04'
           ,CONVERT(varchar(10), @@CurrentSchoolYear) + '-05-27')

	INSERT INTO [edfi].[StaffSectionAssociation]
           ([LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName]
           ,[StaffUSI]
           ,[ClassroomPositionDescriptorId]
           ,[BeginDate]
           ,[EndDate])
     VALUES
           (@LocalCourseCode6
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SectionIdentifier6
           ,@SessionNameSpring
           ,@StaffUSI6
           ,@ClassroomPositionDescriptorId
           ,CONVERT(varchar(10), @@CurrentSchoolYear) + '-01-04'
           ,CONVERT(varchar(10), @@CurrentSchoolYear) + '-05-27')

	INSERT INTO [edfi].[StaffSectionAssociation]
           ([LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName]
           ,[StaffUSI]
           ,[ClassroomPositionDescriptorId]
           ,[BeginDate]
           ,[EndDate])
     VALUES
           (@LocalCourseCode7
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear)
           ,@SectionIdentifier7
           ,@SessionNameSpring
           ,@StaffUSI7
           ,@ClassroomPositionDescriptorId
           ,CONVERT(varchar(10), @@CurrentSchoolYear) + '-01-04'
           ,CONVERT(varchar(10), @@CurrentSchoolYear) + '-05-27')
		

	--Student School Association
	INSERT INTO [edfi].[StudentSchoolAssociation]
		           ([EntryDate]
		           ,[SchoolId]
		           ,[StudentUSI]
		           ,[EntryGradeLevelDescriptorId]
		           ,[EntryTypeDescriptorId]
		           ,[GraduationPlanTypeDescriptorId]
		           ,[EducationOrganizationId]
		           ,[CalendarCode]
		           ,[SchoolYear])
		     VALUES
		           (@RegisterStudentInSchool
		           ,@SchoolId
		           ,@StudentUSI1
		           ,@@GradeLevelDescriptorId -- Grade Level
		           ,@@EntryTypeDescriptorId -- Promoted to Next Grade
		           ,@@GraduationPlanTypeDescriptorId -- Graduation Plan
		           ,@SchoolId
			       ,@CalendarCode -- Calendar Code
		           ,@@CurrentSchoolYear)

	INSERT INTO [edfi].[StudentSchoolAssociation]
		           ([EntryDate]
		           ,[SchoolId]
		           ,[StudentUSI]
		           ,[EntryGradeLevelDescriptorId]
		           ,[EntryTypeDescriptorId]
		           ,[GraduationPlanTypeDescriptorId]
		           ,[EducationOrganizationId]
		           ,[CalendarCode]
		           ,[SchoolYear])
		     VALUES
		           (@RegisterStudentInSchool
		           ,@SchoolId
		           ,@StudentUSI2
		           ,@@GradeLevelDescriptorId -- Grade Level
		           ,@@EntryTypeDescriptorId -- Promoted to Next Grade
		           ,@@GraduationPlanTypeDescriptorId -- Graduation Plan
		           ,@SchoolId
			       ,@CalendarCode -- Calendar Code
		           ,@@CurrentSchoolYear)

	INSERT INTO [edfi].[StudentSchoolAssociation]
		           ([EntryDate]
		           ,[SchoolId]
		           ,[StudentUSI]
		           ,[EntryGradeLevelDescriptorId]
		           ,[EntryTypeDescriptorId]
		           ,[GraduationPlanTypeDescriptorId]
		           ,[EducationOrganizationId]
		           ,[CalendarCode]
		           ,[SchoolYear])
		     VALUES
		           (@RegisterStudentInSchool
		           ,@SchoolId
		           ,@StudentUSI3
		           ,@@GradeLevelDescriptorId -- Grade Level
		           ,@@EntryTypeDescriptorId -- Promoted to Next Grade
		           ,@@GraduationPlanTypeDescriptorId -- Graduation Plan
		           ,@SchoolId
			       ,@CalendarCode -- Calendar Code
		           ,@@CurrentSchoolYear)

	INSERT INTO [edfi].[StudentSchoolAssociation]
		           ([EntryDate]
		           ,[SchoolId]
		           ,[StudentUSI]
		           ,[EntryGradeLevelDescriptorId]
		           ,[EntryTypeDescriptorId]
		           ,[GraduationPlanTypeDescriptorId]
		           ,[EducationOrganizationId]
		           ,[CalendarCode]
		           ,[SchoolYear])
		     VALUES
		           (@RegisterStudentInSchool
		           ,@SchoolId
		           ,@StudentUSI4
		           ,@@GradeLevelDescriptorId -- Grade Level
		           ,@@EntryTypeDescriptorId -- Promoted to Next Grade
		           ,@@GraduationPlanTypeDescriptorId -- Graduation Plan
		           ,@SchoolId
			       ,@CalendarCode -- Calendar Code
		           ,@@CurrentSchoolYear)

	INSERT INTO [edfi].[StudentSchoolAssociation]
		           ([EntryDate]
		           ,[SchoolId]
		           ,[StudentUSI]
		           ,[EntryGradeLevelDescriptorId]
		           ,[EntryTypeDescriptorId]
		           ,[GraduationPlanTypeDescriptorId]
		           ,[EducationOrganizationId]
		           ,[CalendarCode]
		           ,[SchoolYear])
		     VALUES
		           (@RegisterStudentInSchool
		           ,@SchoolId
		           ,@StudentUSI5
		           ,@@GradeLevelDescriptorId -- Grade Level
		           ,@@EntryTypeDescriptorId -- Promoted to Next Grade
		           ,@@GraduationPlanTypeDescriptorId -- Graduation Plan
		           ,@SchoolId
			       ,@CalendarCode -- Calendar Code
		           ,@@CurrentSchoolYear)

	INSERT INTO [edfi].[StudentSchoolAssociation]
		           ([EntryDate]
		           ,[SchoolId]
		           ,[StudentUSI]
		           ,[EntryGradeLevelDescriptorId]
		           ,[EntryTypeDescriptorId]
		           ,[GraduationPlanTypeDescriptorId]
		           ,[EducationOrganizationId]
		           ,[CalendarCode]
		           ,[SchoolYear])
		     VALUES
		           (@RegisterStudentInSchool
		           ,@SchoolId
		           ,@StudentUSI6
		           ,@@GradeLevelDescriptorId -- Grade Level
		           ,@@EntryTypeDescriptorId -- Promoted to Next Grade
		           ,@@GraduationPlanTypeDescriptorId -- Graduation Plan
		           ,@SchoolId
			       ,@CalendarCode -- Calendar Code
		           ,@@CurrentSchoolYear)

	INSERT INTO [edfi].[StudentSchoolAssociation]
		           ([EntryDate]
		           ,[SchoolId]
		           ,[StudentUSI]
		           ,[EntryGradeLevelDescriptorId]
		           ,[EntryTypeDescriptorId]
		           ,[GraduationPlanTypeDescriptorId]
		           ,[EducationOrganizationId]
		           ,[CalendarCode]
		           ,[SchoolYear])
		     VALUES
		           (@RegisterStudentInSchool
		           ,@SchoolId
		           ,@StudentUSI7
		           ,@@GradeLevelDescriptorId -- Grade Level
		           ,@@EntryTypeDescriptorId -- Promoted to Next Grade
		           ,@@GraduationPlanTypeDescriptorId -- Graduation Plan
		           ,@SchoolId
			       ,@CalendarCode -- Calendar Code
		           ,@@CurrentSchoolYear)

	-- Student section association
	-- Student 1
	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode1
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier1
		           ,@SessionNameSpring
		           ,@StudentUSI1
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode2
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier2
		           ,@SessionNameSpring
		           ,@StudentUSI1
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode3
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier3
		           ,@SessionNameSpring
		           ,@StudentUSI1
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode4
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier4
		           ,@SessionNameSpring
		           ,@StudentUSI1
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode5
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier5
		           ,@SessionNameSpring
		           ,@StudentUSI1
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode6
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier6
		           ,@SessionNameSpring
		           ,@StudentUSI1
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode7
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier7
		           ,@SessionNameSpring
		           ,@StudentUSI1
		           ,@EndDate
		           ,0);

	-- Student 2
	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode1
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier1
		           ,@SessionNameSpring
		           ,@StudentUSI2
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode2
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier2
		           ,@SessionNameSpring
		           ,@StudentUSI2
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode3
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier3
		           ,@SessionNameSpring
		           ,@StudentUSI2
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode4
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier4
		           ,@SessionNameSpring
		           ,@StudentUSI2
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode5
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier5
		           ,@SessionNameSpring
		           ,@StudentUSI2
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode6
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier6
		           ,@SessionNameSpring
		           ,@StudentUSI2
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode7
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier7
		           ,@SessionNameSpring
		           ,@StudentUSI2
		           ,@EndDate
		           ,0);
		
	-- Student 3
	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode1
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier1
		           ,@SessionNameSpring
		           ,@StudentUSI3
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode2
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier2
		           ,@SessionNameSpring
		           ,@StudentUSI3
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode3
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier3
		           ,@SessionNameSpring
		           ,@StudentUSI3
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode4
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier4
		           ,@SessionNameSpring
		           ,@StudentUSI3
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode5
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier5
		           ,@SessionNameSpring
		           ,@StudentUSI3
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode6
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier6
		           ,@SessionNameSpring
		           ,@StudentUSI3
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode7
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier7
		           ,@SessionNameSpring
		           ,@StudentUSI3
		           ,@EndDate
		           ,0);
		
	-- Student 4
	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode1
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier1
		           ,@SessionNameSpring
		           ,@StudentUSI4
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode2
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier2
		           ,@SessionNameSpring
		           ,@StudentUSI4
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode3
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier3
		           ,@SessionNameSpring
		           ,@StudentUSI4
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode4
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier4
		           ,@SessionNameSpring
		           ,@StudentUSI4
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode5
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier5
		           ,@SessionNameSpring
		           ,@StudentUSI4
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode6
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier6
		           ,@SessionNameSpring
		           ,@StudentUSI4
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode7
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier7
		           ,@SessionNameSpring
		           ,@StudentUSI4
		           ,@EndDate
		           ,0);

	-- Student 5
	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode1
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier1
		           ,@SessionNameSpring
		           ,@StudentUSI5
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode2
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier2
		           ,@SessionNameSpring
		           ,@StudentUSI5
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode3
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier3
		           ,@SessionNameSpring
		           ,@StudentUSI5
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode4
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier4
		           ,@SessionNameSpring
		           ,@StudentUSI5
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode5
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier5
		           ,@SessionNameSpring
		           ,@StudentUSI5
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode6
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier6
		           ,@SessionNameSpring
		           ,@StudentUSI5
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode7
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier7
		           ,@SessionNameSpring
		           ,@StudentUSI5
		           ,@EndDate
		           ,0);

	-- Student 6
	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode1
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier1
		           ,@SessionNameSpring
		           ,@StudentUSI6
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode2
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier2
		           ,@SessionNameSpring
		           ,@StudentUSI6
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode3
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier3
		           ,@SessionNameSpring
		           ,@StudentUSI6
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode4
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier4
		           ,@SessionNameSpring
		           ,@StudentUSI6
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode5
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier5
		           ,@SessionNameSpring
		           ,@StudentUSI6
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode6
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier6
		           ,@SessionNameSpring
		           ,@StudentUSI6
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode7
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier7
		           ,@SessionNameSpring
		           ,@StudentUSI6
		           ,@EndDate
		           ,0);

	-- Student 7
	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode1
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier1
		           ,@SessionNameSpring
		           ,@StudentUSI7
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode2
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier2
		           ,@SessionNameSpring
		           ,@StudentUSI7
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode3
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier3
		           ,@SessionNameSpring
		           ,@StudentUSI7
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode4
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier4
		           ,@SessionNameSpring
		           ,@StudentUSI7
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode5
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier5
		           ,@SessionNameSpring
		           ,@StudentUSI7
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode6
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier6
		           ,@SessionNameSpring
		           ,@StudentUSI7
		           ,@EndDate
		           ,0);

	INSERT INTO [edfi].[StudentSectionAssociation]
		           ([BeginDate]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[EndDate]
		           ,[HomeroomIndicator])
		     VALUES
		           (@BeginDate
		           ,@LocalCourseCode7
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier7
		           ,@SessionNameSpring
		           ,@StudentUSI7
		           ,@EndDate
		           ,0);
		
	-- student education organization associations
	INSERT INTO [edfi].[StudentEducationOrganizationAssociation]
		           ([EducationOrganizationId]
		           ,[StudentUSI]
		           ,[SexDescriptorId]
		           ,[HispanicLatinoEthnicity])
		     VALUES
		           (@SchoolId
		           ,@StudentUSI1
		           ,@SexDescriptorIdWomen
		           ,1);

	INSERT INTO [edfi].[StudentEducationOrganizationAssociation]
		           ([EducationOrganizationId]
		           ,[StudentUSI]
		           ,[SexDescriptorId]
		           ,[HispanicLatinoEthnicity])
		     VALUES
		           (@SchoolId
		           ,@StudentUSI2
		           ,@SexDescriptorIdMen
		           ,1)

	INSERT INTO [edfi].[StudentEducationOrganizationAssociation]
		           ([EducationOrganizationId]
		           ,[StudentUSI]
		           ,[SexDescriptorId]
		           ,[HispanicLatinoEthnicity])
		     VALUES
		           (@SchoolId
		           ,@StudentUSI3
		           ,@SexDescriptorIdMen
		           ,1)

	INSERT INTO [edfi].[StudentEducationOrganizationAssociation]
		           ([EducationOrganizationId]
		           ,[StudentUSI]
		           ,[SexDescriptorId]
		           ,[HispanicLatinoEthnicity])
		     VALUES
		           (@SchoolId
		           ,@StudentUSI4
		           ,@SexDescriptorIdMen
		           ,1)

	INSERT INTO [edfi].[StudentEducationOrganizationAssociation]
		           ([EducationOrganizationId]
		           ,[StudentUSI]
		           ,[SexDescriptorId]
		           ,[HispanicLatinoEthnicity])
		     VALUES
		           (@SchoolId
		           ,@StudentUSI5
		           ,@SexDescriptorIdMen
		           ,1)

	INSERT INTO [edfi].[StudentEducationOrganizationAssociation]
		           ([EducationOrganizationId]
		           ,[StudentUSI]
		           ,[SexDescriptorId]
		           ,[HispanicLatinoEthnicity])
		     VALUES
		           (@SchoolId
		           ,@StudentUSI6
		           ,@SexDescriptorIdMen
		           ,1)

	INSERT INTO [edfi].[StudentEducationOrganizationAssociation]
		           ([EducationOrganizationId]
		           ,[StudentUSI]
		           ,[SexDescriptorId]
		           ,[HispanicLatinoEthnicity])
		     VALUES
		           (@SchoolId
		           ,@StudentUSI7
		           ,@SexDescriptorIdMen
		           ,1)
		
	-- Student education organization electronic mail
	INSERT INTO [edfi].[StudentEducationOrganizationAssociationElectronicMail]
		           ([EducationOrganizationId]
		           ,[ElectronicMailTypeDescriptorId]
		           ,[StudentUSI]
		           ,[ElectronicMailAddress])
		     VALUES
		           (@SchoolId
		           ,@ElectronicMailTypeDescriptorId
		           ,@StudentUSI1
		           ,@@StudentFirstName1 + @@StudentLastSurname1+ '@yesprep.com')

	INSERT INTO [edfi].[StudentEducationOrganizationAssociationElectronicMail]
		           ([EducationOrganizationId]
		           ,[ElectronicMailTypeDescriptorId]
		           ,[StudentUSI]
		           ,[ElectronicMailAddress])
		     VALUES
		           (@SchoolId
		           ,@ElectronicMailTypeDescriptorId
		           ,@StudentUSI2
		           ,@@StudentFirstName2 + @@StudentLastSurname2+ '@yesprep.com')

	INSERT INTO [edfi].[StudentEducationOrganizationAssociationElectronicMail]
		           ([EducationOrganizationId]
		           ,[ElectronicMailTypeDescriptorId]
		           ,[StudentUSI]
		           ,[ElectronicMailAddress])
		     VALUES
		           (@SchoolId
		           ,@ElectronicMailTypeDescriptorId
		           ,@StudentUSI3
		           ,@@StudentFirstName3 + @@StudentLastSurname3+ '@yesprep.com')

	INSERT INTO [edfi].[StudentEducationOrganizationAssociationElectronicMail]
		           ([EducationOrganizationId]
		           ,[ElectronicMailTypeDescriptorId]
		           ,[StudentUSI]
		           ,[ElectronicMailAddress])
		     VALUES
		           (@SchoolId
		           ,@ElectronicMailTypeDescriptorId
		           ,@StudentUSI4
		           ,@@StudentFirstName4 + @@StudentLastSurname4+ '@yesprep.com')

	INSERT INTO [edfi].[StudentEducationOrganizationAssociationElectronicMail]
		           ([EducationOrganizationId]
		           ,[ElectronicMailTypeDescriptorId]
		           ,[StudentUSI]
		           ,[ElectronicMailAddress])
		     VALUES
		           (@SchoolId
		           ,@ElectronicMailTypeDescriptorId
		           ,@StudentUSI5
		           ,@@StudentFirstName5 + @@StudentLastSurname5+ '@yesprep.com')

	INSERT INTO [edfi].[StudentEducationOrganizationAssociationElectronicMail]
		           ([EducationOrganizationId]
		           ,[ElectronicMailTypeDescriptorId]
		           ,[StudentUSI]
		           ,[ElectronicMailAddress])
		     VALUES
		           (@SchoolId
		           ,@ElectronicMailTypeDescriptorId
		           ,@StudentUSI6
		           ,@@StudentFirstName6 + @@StudentLastSurname6+ '@yesprep.com')

	INSERT INTO [edfi].[StudentEducationOrganizationAssociationElectronicMail]
		           ([EducationOrganizationId]
		           ,[ElectronicMailTypeDescriptorId]
		           ,[StudentUSI]
		           ,[ElectronicMailAddress])
		     VALUES
		           (@SchoolId
		           ,@ElectronicMailTypeDescriptorId
		           ,@StudentUSI7
		           ,@@StudentFirstName7 + @@StudentLastSurname7+ '@yesprep.com')
		
		--INSERT INTO [edfi].[StudentEducationOrganizationAssociationTelephone]
		--           ([EducationOrganizationId]
		--           ,[StudentUSI]
		--           ,[TelephoneNumberTypeDescriptorId]
		--           ,[TelephoneNumber])
		--     VALUES
		--           (@@SchoolId
		--           ,@@StudentUSI
		--           ,@TelephoneNumberTypeDescriptorId
		--           ,'(123) 456 7890')
		
		--INSERT INTO [edfi].[StudentEducationOrganizationAssociationRace]
		--           ([EducationOrganizationId]
		--		   ,[RaceDescriptorId]
		--		   ,[StudentUSI])
		--    VALUES (@@SchoolId
		--			,@RaceDescriptorId
		--			,@@StudentUSI)
		
		-- Attendance student
		INSERT INTO [edfi].[StudentSchoolAttendanceEvent]
		           ([AttendanceEventCategoryDescriptorId]
		           ,[EventDate]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[AttendanceEventReason])
		     VALUES
		           (@AttendanceEventCategoryDescriptorId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear) + '-04-04' 
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SessionNameSpring
		           ,@StudentUSI1
		           ,'The student left the school.')

		-- Dicipline
		INSERT INTO [edfi].[DisciplineIncident]
           ([IncidentIdentifier]
           ,[SchoolId]
           ,[IncidentDate]
           ,[IncidentTime]
           ,[IncidentLocationDescriptorId]
           ,[ReporterDescriptionDescriptorId]
           ,[ReporterName]
           ,[ReportedToLawEnforcement]
           ,[CaseNumber]
           ,[IncidentCost]
           ,[StaffUSI])
     VALUES
           (@IncidentIdentifier1
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear) + '-01-16' 
           ,CONVERT(VARCHAR(8),GETDATE(),108)
           ,@IncidentLocationDescriptorClassroomId
           ,@ReporterDescriptionDescriptorId
           ,@StaffLastName1 + ', '+ @StaffFirstName1
           ,0
           ,null
           ,null
           ,@StaffUSI1)

		INSERT INTO [edfi].[StudentDisciplineIncidentAssociation]
		           ([IncidentIdentifier]
		           ,[SchoolId]
		           ,[StudentUSI]
		           ,[StudentParticipationCodeDescriptorId])
		     VALUES
		           (@IncidentIdentifier1
		           ,@SchoolId
		           ,@StudentUSI1
		           ,@@StudentParticipationCodeDescriptorId)

		INSERT INTO [edfi].[DisciplineIncident]
           ([IncidentIdentifier]
           ,[SchoolId]
           ,[IncidentDate]
           ,[IncidentTime]
           ,[IncidentLocationDescriptorId]
           ,[ReporterDescriptionDescriptorId]
           ,[ReporterName]
           ,[ReportedToLawEnforcement]
           ,[CaseNumber]
           ,[IncidentCost]
           ,[StaffUSI])
     VALUES
           (@IncidentIdentifier2
           ,@SchoolId
           ,CONVERT(varchar(10), @@CurrentSchoolYear) + '-03-26' 
           ,CONVERT(VARCHAR(8),GETDATE(),108)
           ,@IncidentLocationDescriptorClassroomId
           ,@ReporterDescriptionDescriptorId
           ,@StaffLastName1 + ', '+ @StaffFirstName1
           ,0
           ,null
           ,null
           ,@StaffUSI2)

		INSERT INTO [edfi].[StudentDisciplineIncidentAssociation]
		           ([IncidentIdentifier]
		           ,[SchoolId]
		           ,[StudentUSI]
		           ,[StudentParticipationCodeDescriptorId])
		     VALUES
		           (@IncidentIdentifier2
		           ,@SchoolId
		           ,@StudentUSI1
		           ,@@StudentParticipationCodeDescriptorId)
		

		declare @GradingPeriodDescriptorId1 int = 935;
		declare @TotalInstructionalDays1 int = 29;
		declare @PeriodSequence1 int = 1;
		declare @GradingPeriodDescriptorId2 int = 942;
		declare @TotalInstructionalDays2 int = 25;
		declare @PeriodSequence2 int = 2;
		declare @GradingPeriodDescriptorId3 int = 948;
		declare @TotalInstructionalDays3 int = 27;
		declare @PeriodSequence3 int = 3;
		declare @GradingPeriodDescriptorId4 int = 939;
		declare @TotalInstructionalDays4 int = 33;
		declare @PeriodSequence4 int = 4;
		declare @GradingPeriodDescriptorId5 int = 932;
		declare @TotalInstructionalDays5 int = 29;
		declare @PeriodSequence5 int = 5;
		declare @GradingPeriodDescriptorId6 int = 945;
		declare @TotalInstructionalDays6 int = 34;
		declare @PeriodSequence6 int = 6;

	INSERT INTO [edfi].[GradingPeriod]
           ([GradingPeriodDescriptorId]
           ,[PeriodSequence]
           ,[SchoolId]
           ,[SchoolYear]
           ,[BeginDate]
           ,[EndDate]
           ,[TotalInstructionalDays])
     VALUES
           (@GradingPeriodDescriptorId1
           ,@PeriodSequence1
           ,@SchoolId
           ,@@CurrentSchoolYear
           ,CONCAT(@@CurrentSchoolYear, '-08-23')
           ,CONCAT(@@CurrentSchoolYear, '-10-03')
           ,@TotalInstructionalDays1)

	INSERT INTO [edfi].[GradingPeriod]
           ([GradingPeriodDescriptorId]
           ,[PeriodSequence]
           ,[SchoolId]
           ,[SchoolYear]
           ,[BeginDate]
           ,[EndDate]
           ,[TotalInstructionalDays])
     VALUES
           (@GradingPeriodDescriptorId2
           ,@PeriodSequence2
           ,@SchoolId
           ,@@CurrentSchoolYear
           ,CONCAT(@@CurrentSchoolYear, '-10-04')
           ,CONCAT(@@CurrentSchoolYear, '-11-07')
           ,@TotalInstructionalDays2)

	INSERT INTO [edfi].[GradingPeriod]
           ([GradingPeriodDescriptorId]
           ,[PeriodSequence]
           ,[SchoolId]
           ,[SchoolYear]
           ,[BeginDate]
           ,[EndDate]
           ,[TotalInstructionalDays])
     VALUES
           (@GradingPeriodDescriptorId3
           ,@PeriodSequence3
           ,@SchoolId
           ,@@CurrentSchoolYear
          ,CONCAT(@@CurrentSchoolYear, '-11-08')
           ,CONCAT(@@CurrentSchoolYear, '-12-17')
           ,@TotalInstructionalDays3)

	INSERT INTO [edfi].[GradingPeriod]
           ([GradingPeriodDescriptorId]
           ,[PeriodSequence]
           ,[SchoolId]
           ,[SchoolYear]
           ,[BeginDate]
           ,[EndDate]
           ,[TotalInstructionalDays])
     VALUES
           (@GradingPeriodDescriptorId4
           ,@PeriodSequence4
           ,@SchoolId
           ,@@CurrentSchoolYear
          ,CONCAT(@@CurrentSchoolYear, '-01-04')
           ,CONCAT(@@CurrentSchoolYear, '-02-21')
           ,@TotalInstructionalDays4)

	INSERT INTO [edfi].[GradingPeriod]
           ([GradingPeriodDescriptorId]
           ,[PeriodSequence]
           ,[SchoolId]
           ,[SchoolYear]
           ,[BeginDate]
           ,[EndDate]
           ,[TotalInstructionalDays])
     VALUES
           (@GradingPeriodDescriptorId5
           ,@PeriodSequence5
           ,@SchoolId
           ,@@CurrentSchoolYear
          ,CONCAT(@@CurrentSchoolYear, '-02-22')
           ,CONCAT(@@CurrentSchoolYear, '-04-10')
           ,@TotalInstructionalDays5)

	INSERT INTO [edfi].[GradingPeriod]
           ([GradingPeriodDescriptorId]
           ,[PeriodSequence]
           ,[SchoolId]
           ,[SchoolYear]
           ,[BeginDate]
           ,[EndDate]
           ,[TotalInstructionalDays])
     VALUES
           (@GradingPeriodDescriptorId6
           ,@PeriodSequence6
           ,@SchoolId
           ,@@CurrentSchoolYear
          ,CONCAT(@@CurrentSchoolYear, '-04-11')
           ,CONCAT(@@CurrentSchoolYear, '-05-27')
           ,@TotalInstructionalDays6)

		-- Course Grades
		--Student 1
		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,@@CurrentSchoolYear-- year of period
		           ,@PeriodSequence1
		           ,@LocalCourseCode1
		           ,@SchoolId
		           ,@@CurrentSchoolYear
		           ,@SectionIdentifier1
		           ,@SessionNameSpring
		           ,@StudentUSI1
		           ,90.00)
		
		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,@@CurrentSchoolYear-- year of period
		           ,@PeriodSequence1
		           ,@LocalCourseCode2
		           ,@SchoolId
		           ,@@CurrentSchoolYear
		           ,@SectionIdentifier2
		           ,@SessionNameSpring
		           ,@StudentUSI1
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode3
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier3
		           ,@SessionNameSpring
		           ,@StudentUSI1
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode4
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier4
		           ,@SessionNameSpring
		           ,@StudentUSI1
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode5
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier5
		           ,@SessionNameSpring
		           ,@StudentUSI1
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode6
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier6
		           ,@SessionNameSpring
		           ,@StudentUSI1
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode7
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier7
		           ,@SessionNameSpring
		           ,@StudentUSI1
		           ,90.00)

		-- student 2
		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode1
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier1
		           ,@SessionNameSpring
		           ,@StudentUSI2
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode2
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier2
		           ,@SessionNameSpring
		           ,@StudentUSI2
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode3
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier3
		           ,@SessionNameSpring
		           ,@StudentUSI2
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode4
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier4
		           ,@SessionNameSpring
		           ,@StudentUSI2
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode5
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier5
		           ,@SessionNameSpring
		           ,@StudentUSI2
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode6
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier6
		           ,@SessionNameSpring
		           ,@StudentUSI2
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode7
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier7
		           ,@SessionNameSpring
		           ,@StudentUSI2
		           ,90.00)

		-- student 3
		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode1
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier1
		           ,@SessionNameSpring
		           ,@StudentUSI3
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode2
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier2
		           ,@SessionNameSpring
		           ,@StudentUSI3
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode3
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier3
		           ,@SessionNameSpring
		           ,@StudentUSI3
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode4
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier4
		           ,@SessionNameSpring
		           ,@StudentUSI3
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode5
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier5
		           ,@SessionNameSpring
		           ,@StudentUSI3
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode6
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier6
		           ,@SessionNameSpring
		           ,@StudentUSI3
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode7
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier7
		           ,@SessionNameSpring
		           ,@StudentUSI3
		           ,90.00)

		-- student 4
		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode1
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier1
		           ,@SessionNameSpring
		           ,@StudentUSI4
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode2
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier2
		           ,@SessionNameSpring
		           ,@StudentUSI4
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode3
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier3
		           ,@SessionNameSpring
		           ,@StudentUSI4
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode4
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier4
		           ,@SessionNameSpring
		           ,@StudentUSI4
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode5
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier5
		           ,@SessionNameSpring
		           ,@StudentUSI4
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode6
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier6
		           ,@SessionNameSpring
		           ,@StudentUSI4
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode7
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier7
		           ,@SessionNameSpring
		           ,@StudentUSI4
		           ,90.00)

		-- student 5
		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode1
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier1
		           ,@SessionNameSpring
		           ,@StudentUSI5
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode2
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier2
		           ,@SessionNameSpring
		           ,@StudentUSI5
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode3
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier3
		           ,@SessionNameSpring
		           ,@StudentUSI5
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode4
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier4
		           ,@SessionNameSpring
		           ,@StudentUSI5
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode5
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier5
		           ,@SessionNameSpring
		           ,@StudentUSI5
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode6
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier6
		           ,@SessionNameSpring
		           ,@StudentUSI5
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode7
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier7
		           ,@SessionNameSpring
		           ,@StudentUSI5
		           ,90.00)

		-- student 6
		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode1
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier1
		           ,@SessionNameSpring
		           ,@StudentUSI6
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode2
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier2
		           ,@SessionNameSpring
		           ,@StudentUSI6
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode3
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier3
		           ,@SessionNameSpring
		           ,@StudentUSI6
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode4
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier4
		           ,@SessionNameSpring
		           ,@StudentUSI6
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode5
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier5
		           ,@SessionNameSpring
		           ,@StudentUSI6
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode6
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier6
		           ,@SessionNameSpring
		           ,@StudentUSI6
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode7
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier7
		           ,@SessionNameSpring
		           ,@StudentUSI6
		           ,90.00)

		-- student 7
		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode1
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier1
		           ,@SessionNameSpring
		           ,@StudentUSI7
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode2
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier2
		           ,@SessionNameSpring
		           ,@StudentUSI7
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode3
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier3
		           ,@SessionNameSpring
		           ,@StudentUSI7
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode4
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier4
		           ,@SessionNameSpring
		           ,@StudentUSI7
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode5
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier5
		           ,@SessionNameSpring
		           ,@StudentUSI7
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode6
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier6
		           ,@SessionNameSpring
		           ,@StudentUSI7
		           ,90.00)

		INSERT INTO [edfi].[Grade]
		           ([BeginDate]
		           ,[GradeTypeDescriptorId]
		           ,[GradingPeriodDescriptorId]
		           ,[GradingPeriodSchoolYear]
		           ,[GradingPeriodSequence]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[NumericGradeEarned])
		     VALUES
		           (@BeginDate
		           ,@@GradeTypeDescriptorId -- Semester
		           ,@GradingPeriodDescriptorId1 -- A1
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)-- year of period
		           ,1
		           ,@LocalCourseCode7
		           ,@SchoolId
		           ,CONVERT(varchar(10), @@CurrentSchoolYear)
		           ,@SectionIdentifier7
		           ,@SessionNameSpring
		           ,@StudentUSI7
		           ,90.00)

	-- Assessments

	--SAT
	INSERT INTO [edfi].[Assessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[AssessmentTitle]
           ,[AssessmentCategoryDescriptorId]
           ,[AssessmentVersion]
           ,[RevisionDate]
           ,[MaxRawScore])
     VALUES
           (@AssessmentIdentifier8
           ,@AssesmentNamespace
           ,@AssesmentTitleSAT
           ,@AssessmentCategoryDescriptorId
           ,@@CurrentSchoolYear
           ,GETDATE()
           ,@MaxRawScoreSAT)

	INSERT INTO [edfi].[Assessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[AssessmentTitle]
           ,[AssessmentCategoryDescriptorId]
           ,[AssessmentVersion]
           ,[RevisionDate]
           ,[MaxRawScore])
     VALUES
           (@AssessmentIdentifier9
           ,@AssesmentNamespace
           ,@AssesmentTitleSAT
           ,@AssessmentCategoryDescriptorId
           ,@@CurrentSchoolYear
           ,GETDATE()
           ,@MaxRawScoreSAT)
	--PSAT
	INSERT INTO [edfi].[Assessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[AssessmentTitle]
           ,[AssessmentCategoryDescriptorId]
           ,[AssessmentVersion]
           ,[RevisionDate]
           ,[MaxRawScore])
     VALUES
           (@AssessmentIdentifier6
           ,@AssesmentNamespace
           ,@AssesmentTitlePSAT
           ,@AssessmentCategoryDescriptorId
           ,@@CurrentSchoolYear
           ,GETDATE()
           ,@MaxRawScorePSAT)

	INSERT INTO [edfi].[Assessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[AssessmentTitle]
           ,[AssessmentCategoryDescriptorId]
           ,[AssessmentVersion]
           ,[RevisionDate]
           ,[MaxRawScore])
     VALUES
           (@AssessmentIdentifier7
           ,@AssesmentNamespace
           ,@AssesmentTitlePSAT
           ,@AssessmentCategoryDescriptorId
           ,@@CurrentSchoolYear
           ,GETDATE()
           ,@MaxRawScorePSAT)
	--STAAR
	INSERT INTO [edfi].[Assessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[AssessmentTitle]
           ,[AssessmentCategoryDescriptorId]
           ,[AssessmentVersion]
           ,[RevisionDate]
           ,[MaxRawScore])
     VALUES
           (@AssessmentIdentifier1
           ,@AssesmentNamespace
           ,@AssesmentTitleSTAAR
           ,@AssessmentCategoryDescriptorId
           ,@@CurrentSchoolYear
           ,GETDATE()
           ,@MaxRawScoreSTAAR)

	INSERT INTO [edfi].[Assessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[AssessmentTitle]
           ,[AssessmentCategoryDescriptorId]
           ,[AssessmentVersion]
           ,[RevisionDate]
           ,[MaxRawScore])
     VALUES
           (@AssessmentIdentifier2
           ,@AssesmentNamespace
           ,@AssesmentTitleSTAAR
           ,@AssessmentCategoryDescriptorId
           ,@@CurrentSchoolYear
           ,GETDATE()
           ,@MaxRawScoreSTAAR)

	INSERT INTO [edfi].[Assessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[AssessmentTitle]
           ,[AssessmentCategoryDescriptorId]
           ,[AssessmentVersion]
           ,[RevisionDate]
           ,[MaxRawScore])
     VALUES
           (@AssessmentIdentifier3
           ,@AssesmentNamespace
           ,@AssesmentTitleSTAAR
           ,@AssessmentCategoryDescriptorId
           ,@@CurrentSchoolYear
           ,GETDATE()
           ,@MaxRawScoreSTAAR)

	INSERT INTO [edfi].[Assessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[AssessmentTitle]
           ,[AssessmentCategoryDescriptorId]
           ,[AssessmentVersion]
           ,[RevisionDate]
           ,[MaxRawScore])
     VALUES
           (@AssessmentIdentifier4
           ,@AssesmentNamespace
           ,@AssesmentTitleSTAAR
           ,@AssessmentCategoryDescriptorId
           ,@@CurrentSchoolYear
           ,GETDATE()
           ,@MaxRawScoreSTAAR)
		   
	INSERT INTO [edfi].[Assessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[AssessmentTitle]
           ,[AssessmentCategoryDescriptorId]
           ,[AssessmentVersion]
           ,[RevisionDate]
           ,[MaxRawScore])
     VALUES
           (@AssessmentIdentifier5
           ,@AssesmentNamespace
           ,@AssesmentTitleSTAAR
           ,@AssessmentCategoryDescriptorId
           ,@@CurrentSchoolYear
           ,GETDATE()
           ,@MaxRawScoreSTAAR)

	-- Student 1 Assesments
	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier1
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
			   ([AssessmentIdentifier]
			   ,[Namespace]
			   ,[StudentAssessmentIdentifier]
			   ,[StudentUSI]
			   ,[AdministrationDate])
		 VALUES
			   (@AssessmentIdentifier2
			   ,@AssesmentNamespace
			  ,@StudentAssessmentIdentifier
			   ,@StudentUSI1
			   ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier3
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier4
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier5
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier6
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier7
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier8
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,GETDATE())
		
	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier9
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,GETDATE())

	-- Student 1 Assesments Score

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier1
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier2
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier3
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier4
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier5
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier6
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier7
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier8
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier9
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	-- Student 1 Performance Level

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier1
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@ApproachesGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier2
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@DitNotMeetGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier3
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier4
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MeetsGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier5
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier6
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@ApproachesGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier6
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier8
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@ApproachesGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier9
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI1
           ,1)

	-- Student 2 Assesments
	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier1
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
			   ([AssessmentIdentifier]
			   ,[Namespace]
			   ,[StudentAssessmentIdentifier]
			   ,[StudentUSI]
			   ,[AdministrationDate])
		 VALUES
			   (@AssessmentIdentifier2
			   ,@AssesmentNamespace
			  ,@StudentAssessmentIdentifier
			   ,@StudentUSI2
			   ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier3
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier4
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier5
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier6
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier7
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier8
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,GETDATE())
		
	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier9
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,GETDATE())

	-- Student 2 Assesments Score

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier1
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier2
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier3
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier4
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier5
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier6
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier7
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier8
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier9
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	-- Student 2 Performance Level

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier1
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@ApproachesGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier2
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@DitNotMeetGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier3
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier4
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MeetsGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier5
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier6
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@ApproachesGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier6
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier8
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@ApproachesGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier9
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI2
           ,1)

	-- Student 3 Assesments
	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier1
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
			   ([AssessmentIdentifier]
			   ,[Namespace]
			   ,[StudentAssessmentIdentifier]
			   ,[StudentUSI]
			   ,[AdministrationDate])
		 VALUES
			   (@AssessmentIdentifier2
			   ,@AssesmentNamespace
			  ,@StudentAssessmentIdentifier
			   ,@StudentUSI3
			   ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier3
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier4
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier5
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier6
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier7
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier8
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,GETDATE())
		
	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier9
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,GETDATE())

	-- Student 3 Assesments Score

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier1
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier2
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier3
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier4
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier5
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier6
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier7
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier8
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier9
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	-- Student 3 Performance Level

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier1
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@ApproachesGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier2
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@DitNotMeetGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier3
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier4
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MeetsGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier5
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier6
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@ApproachesGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier6
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier8
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@ApproachesGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier9
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI3
           ,1)

	-- Student 4 Assesments
	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier1
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
			   ([AssessmentIdentifier]
			   ,[Namespace]
			   ,[StudentAssessmentIdentifier]
			   ,[StudentUSI]
			   ,[AdministrationDate])
		 VALUES
			   (@AssessmentIdentifier2
			   ,@AssesmentNamespace
			  ,@StudentAssessmentIdentifier
			   ,@StudentUSI4
			   ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier3
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier4
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier5
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier6
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier7
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier8
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,GETDATE())
		
	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier9
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,GETDATE())

	-- Student 4 Assesments Score

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier1
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier2
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier3
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier4
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier5
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier6
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier7
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier8
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier9
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	-- Student 4 Performance Level

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier1
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@ApproachesGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier2
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@DitNotMeetGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier3
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier4
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MeetsGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier5
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier6
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@ApproachesGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier6
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier8
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@ApproachesGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier9
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI4
           ,1)

	-- Student 5 Assesments
	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier1
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
			   ([AssessmentIdentifier]
			   ,[Namespace]
			   ,[StudentAssessmentIdentifier]
			   ,[StudentUSI]
			   ,[AdministrationDate])
		 VALUES
			   (@AssessmentIdentifier2
			   ,@AssesmentNamespace
			  ,@StudentAssessmentIdentifier
			   ,@StudentUSI5
			   ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier3
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier4
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier5
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier6
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier7
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier8
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,GETDATE())
		
	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier9
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,GETDATE())

	-- Student 5 Assesments Score

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier1
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier2
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier3
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier4
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier5
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier6
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier7
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier8
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier9
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	-- Student 5 Performance Level

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier1
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@ApproachesGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier2
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@DitNotMeetGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier3
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier4
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MeetsGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier5
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier6
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@ApproachesGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier6
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier8
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@ApproachesGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier9
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI5
           ,1)

	-- Student 6 Assesments

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier1
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
			   ([AssessmentIdentifier]
			   ,[Namespace]
			   ,[StudentAssessmentIdentifier]
			   ,[StudentUSI]
			   ,[AdministrationDate])
		 VALUES
			   (@AssessmentIdentifier2
			   ,@AssesmentNamespace
			  ,@StudentAssessmentIdentifier
			   ,@StudentUSI6
			   ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier3
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier4
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier5
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier6
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier7
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier8
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,GETDATE())
		
	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier9
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,GETDATE())

	-- Student 6 Assesments Score

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier1
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier2
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier3
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier4
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier5
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier6
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier7
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier8
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier9
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	-- Student 6 Performance Level

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier1
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@ApproachesGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier2
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@DitNotMeetGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier3
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier4
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MeetsGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier5
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier6
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@ApproachesGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier6
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier8
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@ApproachesGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier9
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI6
           ,1)

	-- Student 7 Assesments

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier1
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
			   ([AssessmentIdentifier]
			   ,[Namespace]
			   ,[StudentAssessmentIdentifier]
			   ,[StudentUSI]
			   ,[AdministrationDate])
		 VALUES
			   (@AssessmentIdentifier2
			   ,@AssesmentNamespace
			  ,@StudentAssessmentIdentifier
			   ,@StudentUSI7
			   ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier3
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier4
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier5
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier6
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier7
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,GETDATE())

	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier8
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,GETDATE())
		
	INSERT INTO [edfi].[StudentAssessment]
           ([AssessmentIdentifier]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[AdministrationDate])
     VALUES
           (@AssessmentIdentifier9
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,GETDATE())

	-- Student 7 Assesments Score

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier1
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier2
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier3
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier4
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier5
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier6
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier7
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier8
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,500
           ,@ResultDatatypeTypeDescriptorId)

	INSERT INTO [edfi].[StudentAssessmentScoreResult]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[Result]
           ,[ResultDatatypeTypeDescriptorId])
     VALUES
           (@AssessmentIdentifier9
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,450
           ,@ResultDatatypeTypeDescriptorId)

	-- Student 7 Performance Level

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier1
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@ApproachesGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier2
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@DitNotMeetGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier3
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier4
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MeetsGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier5
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier6
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@ApproachesGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier6
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier8
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@ApproachesGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,1)

	INSERT INTO [edfi].[StudentAssessmentPerformanceLevel]
           ([AssessmentIdentifier]
           ,[AssessmentReportingMethodDescriptorId]
           ,[Namespace]
           ,[PerformanceLevelDescriptorId]
           ,[StudentAssessmentIdentifier]
           ,[StudentUSI]
           ,[PerformanceLevelMet])
     VALUES
           (@AssessmentIdentifier9
           ,@AssessmentReportingMethodDescriptorId
           ,@AssesmentNamespace
           ,@MastersGradeLevelDescriptorId
           ,@StudentAssessmentIdentifier
           ,@StudentUSI7
           ,1)
	-- schedule

	declare @ClassPeriodName1 nvarchar(60) = '01 - Traditional';
	declare @ClassPeriodName2 nvarchar(60) = '02 - Traditional';
	declare @ClassPeriodName3 nvarchar(60) = '03 - Traditional';
	declare @ClassPeriodName4 nvarchar(60) = '04 - Traditional';
	declare @ClassPeriodName5 nvarchar(60) = '05 - Traditional';
	declare @ClassPeriodName6 nvarchar(60) = '06 - Traditional';
	declare @ClassPeriodName7 nvarchar(60) = '07 - Traditional';

	declare @BellScheduleName nvarchar(60) = 'Normal Schedule';

	INSERT INTO [edfi].[ClassPeriod]
           ([ClassPeriodName]
           ,[SchoolId])
     VALUES
           (@ClassPeriodName1
           ,@SchoolId)

	INSERT INTO [edfi].[ClassPeriod]
           ([ClassPeriodName]
           ,[SchoolId])
     VALUES
           (@ClassPeriodName2
           ,@SchoolId)

	INSERT INTO [edfi].[ClassPeriod]
           ([ClassPeriodName]
           ,[SchoolId])
     VALUES
           (@ClassPeriodName3
           ,@SchoolId)

	INSERT INTO [edfi].[ClassPeriod]
           ([ClassPeriodName]
           ,[SchoolId])
     VALUES
           (@ClassPeriodName4
           ,@SchoolId)

	INSERT INTO [edfi].[ClassPeriod]
           ([ClassPeriodName]
           ,[SchoolId])
     VALUES
           (@ClassPeriodName5
           ,@SchoolId)

	INSERT INTO [edfi].[ClassPeriod]
           ([ClassPeriodName]
           ,[SchoolId])
     VALUES
           (@ClassPeriodName6
           ,@SchoolId)

	INSERT INTO [edfi].[ClassPeriod]
           ([ClassPeriodName]
           ,[SchoolId])
     VALUES
           (@ClassPeriodName7
           ,@SchoolId)

	INSERT INTO [edfi].[BellSchedule]
           ([BellScheduleName]
           ,[SchoolId])
     VALUES
           (@BellScheduleName
           ,@SchoolId)

	INSERT INTO [edfi].[BellScheduleClassPeriod]
           ([BellScheduleName]
           ,[ClassPeriodName]
           ,[SchoolId])
     VALUES
           (@BellScheduleName
           ,@ClassPeriodName1
           ,@SchoolId)

	INSERT INTO [edfi].[BellScheduleClassPeriod]
           ([BellScheduleName]
           ,[ClassPeriodName]
           ,[SchoolId])
     VALUES
           (@BellScheduleName
           ,@ClassPeriodName2
           ,@SchoolId)

	INSERT INTO [edfi].[BellScheduleClassPeriod]
           ([BellScheduleName]
           ,[ClassPeriodName]
           ,[SchoolId])
     VALUES
           (@BellScheduleName
           ,@ClassPeriodName3
           ,@SchoolId)

	INSERT INTO [edfi].[BellScheduleClassPeriod]
           ([BellScheduleName]
           ,[ClassPeriodName]
           ,[SchoolId])
     VALUES
           (@BellScheduleName
           ,@ClassPeriodName4
           ,@SchoolId)

	INSERT INTO [edfi].[BellScheduleClassPeriod]
           ([BellScheduleName]
           ,[ClassPeriodName]
           ,[SchoolId])
     VALUES
           (@BellScheduleName
           ,@ClassPeriodName5
           ,@SchoolId)

	INSERT INTO [edfi].[BellScheduleClassPeriod]
           ([BellScheduleName]
           ,[ClassPeriodName]
           ,[SchoolId])
     VALUES
           (@BellScheduleName
           ,@ClassPeriodName6
           ,@SchoolId)

	INSERT INTO [edfi].[BellScheduleClassPeriod]
           ([BellScheduleName]
           ,[ClassPeriodName]
           ,[SchoolId])
     VALUES
           (@BellScheduleName
           ,@ClassPeriodName7
           ,@SchoolId)

	INSERT INTO [edfi].[BellScheduleDate]
           ([BellScheduleName]
           ,[Date]
           ,[SchoolId])
     VALUES
           (@BellScheduleName
           ,CONCAT(@@CurrentSchoolYear,'-05','-02')
           ,@SchoolId)

	INSERT INTO [edfi].[BellScheduleDate]
           ([BellScheduleName]
           ,[Date]
           ,[SchoolId])
     VALUES
           (@BellScheduleName
           ,CONCAT(@@CurrentSchoolYear,'-05','-03')
           ,@SchoolId)

	INSERT INTO [edfi].[BellScheduleDate]
           ([BellScheduleName]
           ,[Date]
           ,[SchoolId])
     VALUES
           (@BellScheduleName
           ,CONCAT(@@CurrentSchoolYear,'-05','-04')
           ,@SchoolId)
	
	INSERT INTO [edfi].[BellScheduleDate]
           ([BellScheduleName]
           ,[Date]
           ,[SchoolId])
     VALUES
           (@BellScheduleName
           ,CONCAT(@@CurrentSchoolYear,'-05','-05')
           ,@SchoolId)

	INSERT INTO [edfi].[BellScheduleDate]
           ([BellScheduleName]
           ,[Date]
           ,[SchoolId])
     VALUES
           (@BellScheduleName
           ,CONCAT(@@CurrentSchoolYear,'-05','-06')
           ,@SchoolId)

	INSERT INTO [edfi].[SectionClassPeriod]
           ([ClassPeriodName]
           ,[LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName])
     VALUES
           (@ClassPeriodName1 
           ,@LocalCourseCode1
           ,@SchoolId
           ,@@CurrentSchoolYear
           ,@SectionIdentifier1
           ,@SessionNameSpring)

	INSERT INTO [edfi].[SectionClassPeriod]
           ([ClassPeriodName]
           ,[LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName])
     VALUES
           (@ClassPeriodName2
           ,@LocalCourseCode2
           ,@SchoolId
           ,@@CurrentSchoolYear
           ,@SectionIdentifier2
           ,@SessionNameSpring)

	INSERT INTO [edfi].[SectionClassPeriod]
           ([ClassPeriodName]
           ,[LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName])
     VALUES
           (@ClassPeriodName3 
           ,@LocalCourseCode3
           ,@SchoolId
           ,@@CurrentSchoolYear
           ,@SectionIdentifier3
           ,@SessionNameSpring)

	INSERT INTO [edfi].[SectionClassPeriod]
           ([ClassPeriodName]
           ,[LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName])
     VALUES
           (@ClassPeriodName4
           ,@LocalCourseCode4
           ,@SchoolId
           ,@@CurrentSchoolYear
           ,@SectionIdentifier4
           ,@SessionNameSpring)

	INSERT INTO [edfi].[SectionClassPeriod]
           ([ClassPeriodName]
           ,[LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName])
     VALUES
           (@ClassPeriodName5 
           ,@LocalCourseCode5
           ,@SchoolId
           ,@@CurrentSchoolYear
           ,@SectionIdentifier5
           ,@SessionNameSpring)

	INSERT INTO [edfi].[SectionClassPeriod]
           ([ClassPeriodName]
           ,[LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName])
     VALUES
           (@ClassPeriodName6
           ,@LocalCourseCode6
           ,@SchoolId
           ,@@CurrentSchoolYear
           ,@SectionIdentifier6
           ,@SessionNameSpring)

	INSERT INTO [edfi].[SectionClassPeriod]
           ([ClassPeriodName]
           ,[LocalCourseCode]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SectionIdentifier]
           ,[SessionName])
     VALUES
           (@ClassPeriodName7
           ,@LocalCourseCode7
           ,@SchoolId
           ,@@CurrentSchoolYear
           ,@SectionIdentifier7
           ,@SessionNameSpring)

	INSERT INTO [edfi].[ClassPeriodMeetingTime]
           ([ClassPeriodName]
           ,[EndTime]
           ,[SchoolId]
           ,[StartTime])
     VALUES
           (@ClassPeriodName1
           ,'09:05:00.0000000'
           ,@SchoolId
           ,'08:15:00.0000000')

	INSERT INTO [edfi].[ClassPeriodMeetingTime]
           ([ClassPeriodName]
           ,[EndTime]
           ,[SchoolId]
           ,[StartTime])
     VALUES
           (@ClassPeriodName2
           ,'10:00:00.0000000'
           ,@SchoolId
           ,'09:10:00.0000000')

	INSERT INTO [edfi].[ClassPeriodMeetingTime]
           ([ClassPeriodName]
           ,[EndTime]
           ,[SchoolId]
           ,[StartTime])
     VALUES
           (@ClassPeriodName3
           ,'11:15:00.0000000'
           ,@SchoolId
           ,'10:25:00.0000000')

	INSERT INTO [edfi].[ClassPeriodMeetingTime]
           ([ClassPeriodName]
           ,[EndTime]
           ,[SchoolId]
           ,[StartTime])
     VALUES
           (@ClassPeriodName4
           ,'11:45:00.0000000'
           ,@SchoolId
           ,'11:20:00.0000000')

	INSERT INTO [edfi].[ClassPeriodMeetingTime]
           ([ClassPeriodName]
           ,[EndTime]
           ,[SchoolId]
           ,[StartTime])
     VALUES
           (@ClassPeriodName5
           ,'13:35:00.0000000'
           ,@SchoolId
           ,'12:45:00.0000000')

	INSERT INTO [edfi].[ClassPeriodMeetingTime]
           ([ClassPeriodName]
           ,[EndTime]
           ,[SchoolId]
           ,[StartTime])
     VALUES
           (@ClassPeriodName6
           ,'14:30:00.0000000'
           ,@SchoolId
           ,'13:40:00.0000000')

	INSERT INTO [edfi].[ClassPeriodMeetingTime]
           ([ClassPeriodName]
           ,[EndTime]
           ,[SchoolId]
           ,[StartTime])
     VALUES
           (@ClassPeriodName7
           ,'15:45:00.0000000'
           ,@SchoolId
           ,'14:55:00.0000000')

	-- GPA

	--Student 1
	INSERT INTO [edfi].[StudentAcademicRecord]
           ([EducationOrganizationId]
           ,[SchoolYear]
           ,[StudentUSI]
           ,[TermDescriptorId]
           ,[CumulativeEarnedCredits]
		   ,[CumulativeGradePointAverage])
     VALUES
           (@SchoolId
           ,@@CurrentSchoolYear
           ,@StudentUSI1
           ,@TermDescriptorIdSpring
           ,7.000
		   ,3.5000)

	INSERT INTO [edfi].[StudentAcademicRecord]
           ([EducationOrganizationId]
           ,[SchoolYear]
           ,[StudentUSI]
           ,[TermDescriptorId]
           ,[CumulativeEarnedCredits]
		   ,[CumulativeGradePointAverage])
     VALUES
           (@SchoolId
           ,@@CurrentSchoolYear
           ,@StudentUSI1
           ,@TermDescriptorIdFall
           ,11.500
		   ,3.5000)

	INSERT INTO [edfi].[StudentSchoolAttendanceEvent]
           ([AttendanceEventCategoryDescriptorId]
           ,[EventDate]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SessionName]
           ,[StudentUSI]
		   ,[AttendanceEventReason])
     VALUES
           (@AttendanceEventCategoryDescriptorId
           ,CONCAT(@@CurrentSchoolYear,'-05','-05')
           ,@SchoolId
           ,@@CurrentSchoolYear
           ,@SessionNameSpring
           ,@StudentUSI1
		   ,'Stundet left the school')

	INSERT INTO [edfi].[StudentSchoolAttendanceEvent]
           ([AttendanceEventCategoryDescriptorId]
           ,[EventDate]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SessionName]
           ,[StudentUSI]
		   ,[AttendanceEventReason])
     VALUES
           (@AttendanceEventCategoryDescriptorId
           ,CONCAT(@@CurrentSchoolYear,'-02','-05')
           ,@SchoolId
           ,@@CurrentSchoolYear
           ,@SessionNameSpring
           ,@StudentUSI1
		   ,'Student sick')

	INSERT INTO [edfi].[StudentSchoolAttendanceEvent]
           ([AttendanceEventCategoryDescriptorId]
           ,[EventDate]
           ,[SchoolId]
           ,[SchoolYear]
           ,[SessionName]
           ,[StudentUSI]
		   ,[AttendanceEventReason])
     VALUES
           (@AttendanceEventCategoryDescriptorId
           ,CONCAT(@@CurrentSchoolYear,'-08','-05')
           ,@SchoolId
           ,@@CurrentSchoolYear
           ,@SessionNameSpring
           ,@StudentUSI1
		   ,'The student was out of the city.')


	COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

		DECLARE @Message nvarchar(2048) = ERROR_MESSAGE();
        DECLARE @Severity integer = ERROR_SEVERITY();
        DECLARE @State integer = ERROR_STATE();
		SELECT ERROR_LINE() AS ErrorLine;  
        RAISERROR(@Message, @Severity, @State);
	END CATCH;
END;

