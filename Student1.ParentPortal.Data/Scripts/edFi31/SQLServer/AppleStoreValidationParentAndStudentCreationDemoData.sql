BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
		declare @@SchoolId int = 56 --Hoffman; 
		-- ** Student Identification, Names and Demographics ** --
		declare @@StudentUniqueId nvarchar(50) = '989898';
		declare @@StudentFirstName nvarchar(10) = 'Maria';
		declare @@StudentMiddleName nvarchar(10) = 'Fernanda';
		declare @@StudentLastSurname nvarchar(10) = 'Perez';
		declare @BirthSexDescriptorId int = 1453;                  -- Female
		declare @SexDescriptorId int = 1453;                       -- Female
		declare @TelephoneNumberTypeDescriptorId int = 769;        -- Home
		declare @RaceDescriptorId int = 1479;                      -- American Indian or Alaskan Native
		
		-- ** Parent Name and Demographics ** --
		declare @@ParentUniqueId nvarchar(50) = '979797';
		declare @@ParentFirstName nvarchar(10) = 'April';
		declare @@ParentLastSurname nvarchar(10) = 'Perez';
		declare @@EmailLogin nvarchar(50) = 'aprilperez910101@gmail.com';
		declare @ElectronicMailTypeDescriptorId int = 774;         -- Home/Personal
		declare @RelationDescriptorId int = 1504;                  -- mother
		declare @AddressTypeDescriptorId int = 82;                 -- contact
		declare @StateAbbreviationDescriptorId int = 73;           -- Texas
		
		-- ** Student Enrollment Courses **--
		declare @SessionName nvarchar(20) = 'Spring Semester';     -- Session Name (Fall Semester, Spring Semester, Year round)
		declare @@LocalCourseCode1 nvarchar(50) = 'E1010-3';	   -- Local Course Name
		declare @@LocalCourseCode2 nvarchar(50) = 'A3020-1';	   -- Local Course Name
		declare @@LocalCourseCode3 nvarchar(50) = 'A3030-1';       -- Local Course Name
		declare @@LocalCourseCode4 nvarchar(50) = 'H3010-1';       -- Local Course Name
		declare @@LocalCourseCode5 nvarchar(50) = 'A3010-1';       -- Local Course Name
		declare @@GradeLevelDescriptorId int = 1392;               -- 8th Grade
		declare @@EntryTypeDescriptorId int = 1403                 -- Promoted to Next Grade
		declare @@GraduationPlanTypeDescriptorId int = 1378        -- Graduation Plan (YES Foundation HS Prog w/Endorsements)
		declare @@CalendarCode nvarchar(5) = 'R'                   -- Calendar Code
		declare @@StudentParticipationCodeDescriptorId int = 3922; -- Perpetrator
		declare @AttendanceEventCategoryDescriptorId int = 1158    -- Absent
		declare @@GradeTypeDescriptorId int = 3599;                 -- Semester
		declare @GradingPeriodDescriptorId int = 1356              -- A1
		
		declare @@StudentUSI int = null;
		declare @@ParentUSI int = null;
		declare @@CurrentSchoolYear int = null;

		INSERT INTO [edfi].[Student]
		           ([PersonalTitlePrefix]
		           ,[FirstName]
		           ,[MiddleName]
		           ,[LastSurname]
		           ,[BirthDate]
		           ,[BirthSexDescriptorId]
		           ,[StudentUniqueId])
		     VALUES
		           ('Mrs'
		           ,@@StudentFirstName
		           ,@@StudentMiddleName
		           ,@@StudentLastSurname
		           ,'2014-07-29'
		           ,@BirthSexDescriptorId
		           ,@@StudentUniqueId)
		set @@StudentUSI = SCOPE_IDENTITY();
		
		select @@CurrentSchoolYear = CAST(SchoolYear AS int) from edfi.SchoolYearType where CurrentSchoolYear = 1
		
		declare @RegisterStudentInSchool nvarchar(10) = null;
		select @RegisterStudentInSchool = format(getDate(), 'yyyy-MM-dd');
		
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
		           ,@@SchoolId
		           ,@@StudentUSI
		           ,@@GradeLevelDescriptorId -- Grade Level
		           ,@@EntryTypeDescriptorId -- Promoted to Next Grade
		           ,@@GraduationPlanTypeDescriptorId -- Graduation Plan
		           ,@@SchoolId
			       ,@@CalendarCode -- Calendar Code
		           ,@@CurrentSchoolYear)
		
		INSERT INTO [edfi].[Parent]
		           ([PersonalTitlePrefix]
		           ,[FirstName]
		           ,[LastSurname]
		           ,[SexDescriptorId]
		           ,[ParentUniqueId])
		     VALUES
		          ('Ms'
		           ,@@ParentFirstName
		           ,@@ParentLastSurname
		           ,@SexDescriptorId
		           ,@@ParentUniqueId)
		
		set @@ParentUSI = SCOPE_IDENTITY();
				   
		INSERT INTO [edfi].[StudentParentAssociation] 
					([ParentUSI]
					,[StudentUSI]
					,[RelationDescriptorId]
					,[PrimaryContactStatus]
					,[LivesWith]
					,[EmergencyContactStatus]) 
			VALUES 
					(@@ParentUSI 
					,@@StudentUSI 
					,@RelationDescriptorId 
					,1
		            ,1
		            ,1)
		
		INSERT INTO [edfi].[ParentAddress]
		           ([AddressTypeDescriptorId]
		           ,[ParentUSI]
		           ,[StreetNumberName]
		           ,[City]
		           ,[StateAbbreviationDescriptorId]
		           ,[PostalCode]
		           ,[NameOfCounty])
		     VALUES
		           (@AddressTypeDescriptorId
		           ,@@ParentUSI
		           ,'123 Red Jay St'
		           ,'Houston'
		           ,@StateAbbreviationDescriptorId
		           ,12123
		           ,'United States')
		
		INSERT INTO [edfi].[ParentElectronicMail]
		           ([ElectronicMailTypeDescriptorId]
		           ,[ParentUSI]
		           ,[ElectronicMailAddress]
		           ,[PrimaryEmailAddressIndicator])
		     VALUES
		           (@ElectronicMailTypeDescriptorId
		           ,@@ParentUSI
		           ,@@EmailLogin
		           ,1)
		
		--course 1
		declare @SectionIdentifier1 nvarchar(50) = null;
		declare @BeginDate1 nvarchar(50) = null;
		declare @LocalCourseCode1 nvarchar(50) = null;
		declare @EndDate1 nvarchar(50) = null;
		declare @GradebookEntryTitle1 nvarchar(50) = null;
		
		--course 2
		declare @SectionIdentifier2 nvarchar(50) = null;
		declare @BeginDate2 nvarchar(50) = null;
		declare @LocalCourseCode2 nvarchar(50) = null;
		declare @EndDate2 nvarchar(50) = null;
		declare @GradebookEntryTitle2 nvarchar(50) = null;
		
		--course 3
		declare @SectionIdentifier3 nvarchar(50) = null;
		declare @BeginDate3 nvarchar(50) = null;
		declare @LocalCourseCode3 nvarchar(50) = null;
		declare @EndDate3 nvarchar(50) = null;
		declare @GradebookEntryTitle3 nvarchar(50) = null;
		
		--course 4
		declare @SectionIdentifier4 nvarchar(50) = null;
		declare @BeginDate4 nvarchar(50) = null;
		declare @LocalCourseCode4 nvarchar(50) = null;
		declare @EndDate4 nvarchar(50) = null;
		declare @GradebookEntryTitle4 nvarchar(50) = null;
		
		--course 5
		declare @SectionIdentifier5 nvarchar(50) = null;
		declare @BeginDate5 nvarchar(50) = null;
		declare @LocalCourseCode5 nvarchar(50) = null;
		declare @EndDate5 nvarchar(50) = null;
		declare @GradebookEntryTitle5 nvarchar(50) = null;
		
		select top(1) @SectionIdentifier1 = SectionIdentifier, @BeginDate1 = DateAssigned, @GradebookEntryTitle1 = GradebookEntryTitle, @LocalCourseCode1 = LocalCourseCode from edfi.GradebookEntry where LocalCourseCode = @@LocalCourseCode1 and SchoolId = @@SchoolId and SessionName = @SessionName and SchoolYear = @@CurrentSchoolYear
		select top(1) @SectionIdentifier2 = SectionIdentifier, @BeginDate2 = DateAssigned, @GradebookEntryTitle2 = GradebookEntryTitle, @LocalCourseCode2 = LocalCourseCode from edfi.GradebookEntry where LocalCourseCode = @@LocalCourseCode2 and SchoolId = @@SchoolId and SessionName = @SessionName and SchoolYear = @@CurrentSchoolYear
		select top(1) @SectionIdentifier3 = SectionIdentifier, @BeginDate3 = DateAssigned, @GradebookEntryTitle3 = GradebookEntryTitle, @LocalCourseCode3 = LocalCourseCode from edfi.GradebookEntry where LocalCourseCode = @@LocalCourseCode3 and SchoolId = @@SchoolId and SessionName = @SessionName and SchoolYear = @@CurrentSchoolYear
		select top(1) @SectionIdentifier4 = SectionIdentifier, @BeginDate4 = DateAssigned, @GradebookEntryTitle4 = GradebookEntryTitle, @LocalCourseCode4 = LocalCourseCode from edfi.GradebookEntry where LocalCourseCode = @@LocalCourseCode4 and SchoolId = @@SchoolId and SessionName = @SessionName and SchoolYear = @@CurrentSchoolYear
		select top(1) @SectionIdentifier5 = SectionIdentifier, @BeginDate5 = DateAssigned, @GradebookEntryTitle5 = GradebookEntryTitle, @LocalCourseCode5 = LocalCourseCode from edfi.GradebookEntry where LocalCourseCode = @@LocalCourseCode5 and SchoolId = @@SchoolId and SessionName = @SessionName and SchoolYear = @@CurrentSchoolYear
		
		select @EndDate1 = EndDate from edfi.StudentSectionAssociation where BeginDate = @BeginDate1
		select @EndDate2 = EndDate from edfi.StudentSectionAssociation where BeginDate = @BeginDate2 
		select @EndDate3 = EndDate from edfi.StudentSectionAssociation where BeginDate = @BeginDate3 
		select @EndDate4 = EndDate from edfi.StudentSectionAssociation where BeginDate = @BeginDate4 
		select @EndDate5 = EndDate from edfi.StudentSectionAssociation where BeginDate = @BeginDate5 
		
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
		           (@BeginDate1
		           ,@@LocalCourseCode1
		           ,@@SchoolId
		           ,@@CurrentSchoolYear
		           ,@SectionIdentifier1
		           ,@SessionName
		           ,@@StudentUSI
		           ,@EndDate1
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
		           (@BeginDate2
		           ,@@LocalCourseCode2
		           ,@@SchoolId
		           ,@@CurrentSchoolYear
		           ,@SectionIdentifier2
		           ,@SessionName
		           ,@@StudentUSI
		           ,@EndDate2
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
		           (@BeginDate3
		           ,@@LocalCourseCode3
		           ,@@SchoolId
		           ,@@CurrentSchoolYear
		           ,@SectionIdentifier3
		           ,@SessionName
		           ,@@StudentUSI
		           ,@EndDate3
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
		           (@BeginDate4
		           ,@@LocalCourseCode4
		           ,@@SchoolId
		           ,@@CurrentSchoolYear
		           ,@SectionIdentifier4
		           ,@SessionName
		           ,@@StudentUSI
		           ,@EndDate4
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
		           (@BeginDate5
		           ,@@LocalCourseCode5
		           ,@@SchoolId
		           ,@@CurrentSchoolYear
		           ,@SectionIdentifier5
		           ,@SessionName
		           ,@@StudentUSI
		           ,@EndDate5
		           ,0)
		
		INSERT INTO [edfi].[StudentGradebookEntry]
		           ([BeginDate]
		           ,[DateAssigned]
		           ,[GradebookEntryTitle]
		           ,[LocalCourseCode]
		           ,[SchoolId]
		           ,[SchoolYear]
		           ,[SectionIdentifier]
		           ,[SessionName]
		           ,[StudentUSI]
		           ,[LetterGradeEarned])
		     VALUES
		           (@BeginDate1
		           ,@BeginDate1
		           ,@GradebookEntryTitle1
		           ,@LocalCourseCode1
		           ,@@SchoolId
		           ,@@CurrentSchoolYear
		           ,@SectionIdentifier1
		           ,@SessionName
		           ,@@StudentUSI
		           ,'M')

		INSERT INTO [edfi].[StudentDisciplineIncidentAssociation]
		           ([IncidentIdentifier]
		           ,[SchoolId]
		           ,[StudentUSI]
		           ,[StudentParticipationCodeDescriptorId])
		     VALUES
		           ('24688'
		           ,@@SchoolId
		           ,@@StudentUSI
		           ,@@StudentParticipationCodeDescriptorId)
		
			INSERT INTO [edfi].[StudentEducationOrganizationAssociation]
		           ([EducationOrganizationId]
		           ,[StudentUSI]
		           ,[SexDescriptorId]
		           ,[HispanicLatinoEthnicity])
		     VALUES
		           (@@SchoolId
		           ,@@StudentUSI
		           ,@SexDescriptorId
		           ,1)
		
		INSERT INTO [edfi].[StudentEducationOrganizationAssociationElectronicMail]
		           ([EducationOrganizationId]
		           ,[ElectronicMailTypeDescriptorId]
		           ,[StudentUSI]
		           ,[ElectronicMailAddress])
		     VALUES
		           (@@SchoolId
		           ,@ElectronicMailTypeDescriptorId
		           ,@@StudentUSI
		           ,@@StudentFirstName + @@StudentLastSurname+ '@yesprep.com')
		
		INSERT INTO [edfi].[StudentEducationOrganizationAssociationTelephone]
		           ([EducationOrganizationId]
		           ,[StudentUSI]
		           ,[TelephoneNumberTypeDescriptorId]
		           ,[TelephoneNumber])
		     VALUES
		           (@@SchoolId
		           ,@@StudentUSI
		           ,@TelephoneNumberTypeDescriptorId
		           ,'(123) 456 7890')
		
		INSERT INTO [edfi].[StudentEducationOrganizationAssociationRace]
		           ([EducationOrganizationId]
				   ,[RaceDescriptorId]
				   ,[StudentUSI])
		    VALUES (@@SchoolId
					,@RaceDescriptorId
					,@@StudentUSI)
		
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
		           ,'2020-03-24' 
		           ,@@SchoolId
		           ,@@CurrentSchoolYear
		           ,@SessionName
		           ,@@StudentUSI
		           ,'The student left the school.')
		
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
		           (@BeginDate1
		           ,@@GradeTypeDescriptorId -- Semester
		           ,1356 -- A1
		           ,@@CurrentSchoolYear-- year of period
		           ,1
		           ,@LocalCourseCode1
		           ,@@SchoolId
		           ,@@CurrentSchoolYear
		           ,@SectionIdentifier1
		           ,@SessionName
		           ,@@StudentUSI
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
		           (@BeginDate2
		           ,@@GradeTypeDescriptorId  -- Semester
		           ,1357 --A2
		           ,@@CurrentSchoolYear
		           ,2
		           ,@LocalCourseCode2
		           ,@@SchoolId
		           ,@@CurrentSchoolYear
		           ,@SectionIdentifier2
		           ,@SessionName
		           ,@@StudentUSI
		           ,63.00)
				   
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
		           (@BeginDate3
		           ,@@GradeTypeDescriptorId
		           ,1359 --A4
		           ,@@CurrentSchoolYear -- year of period
		           ,4
		           ,@LocalCourseCode3
		           ,@@SchoolId
		           ,@@CurrentSchoolYear
		           ,@SectionIdentifier3
		           ,@SessionName
		           ,@@StudentUSI
		           ,72.00)
				   
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
		           (@BeginDate4
		           ,@@GradeTypeDescriptorId
		           ,1360 --A5
		           ,@@CurrentSchoolYear -- year of period
		           ,5
		           ,@LocalCourseCode4
		           ,@@SchoolId
		           ,@@CurrentSchoolYear
		           ,@SectionIdentifier4
		           ,@SessionName
		           ,@@StudentUSI
		           ,82.00)
				   
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
		           (@BeginDate5
		           ,@@GradeTypeDescriptorId
		           ,1361 --A6
		           ,@@CurrentSchoolYear -- year of period
		           ,6
		           ,@LocalCourseCode5
		           ,@@SchoolId
		           ,@@CurrentSchoolYear
		           ,@SectionIdentifier5
		           ,@SessionName
		           ,@@StudentUSI
		           ,75.00);

	COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

		DECLARE @Message nvarchar(2048) = ERROR_MESSAGE() + '/Line:' + ERROR_LINE();
        DECLARE @Severity integer = ERROR_SEVERITY();
        DECLARE @State integer = ERROR_STATE();

        RAISERROR(@Message, @Severity, @State);
	END CATCH;
END;
