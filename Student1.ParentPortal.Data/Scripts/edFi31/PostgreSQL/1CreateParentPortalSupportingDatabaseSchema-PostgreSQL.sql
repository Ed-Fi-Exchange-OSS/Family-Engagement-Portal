DO $$
BEGIN

	/* working */

    CREATE SCHEMA IF NOT EXISTS ParentPortal;
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp"; -- load module

    -- GO

    CREATE TABLE ParentPortal.AlertLog(
        AlertlogId INT GENERATED ALWAYS AS IDENTITY,
        SchoolYear smallint NOT NULL,
        AlertTypeId int NOT NULL,
        ParentUniqueId Varchar(32) NOT NULL,
        StudentUniqueId Varchar(32) NOT NULL,
        Value Varchar(200) NOT NULL,
        Read Boolean NOT NULL,
        UTCSentDate Timestamp(3) NOT NULL,
        UTCCreateDate Timestamp(3) NOT NULL,
        UTCLastModifiedDate Timestamp(3) NOT NULL,
        Id uuid NOT NULL,
        PRIMARY KEY(AlertlogId)
    );

    CREATE TABLE ParentPortal.MethodOfContactType(
        MethodOfContactTypeId int GENERATED ALWAYS AS IDENTITY,
        Description Varchar(1024) NOT NULL,
        ShortDescription Varchar(450) NOT NULL,
        CreateDate Timestamp(3) NOT NULL,
        LastModifiedDate Timestamp(3) NOT NULL,
        Id uuid NOT NULL,
        PRIMARY KEY(MethodOfContactTypeId)
    );

    CREATE TABLE ParentPortal.AlertType(
        AlertTypeId int GENERATED ALWAYS AS IDENTITY,
        Description Varchar(1024) NOT NULL,
        ShortDescription Varchar(450) NOT NULL,
        CreateDate Timestamp(3) NOT NULL,
        LastModifiedDate Timestamp(3) NOT NULL,
        Id uuid NOT NULL,
        PRIMARY KEY(AlertTypeId)
    );

    CREATE TABLE ParentPortal.ParentAlert(
        ParentUniqueId Varchar(32) PRIMARY KEY,
        AlertsEnabled Boolean NOT NULL,
        CreateDate Timestamp(3) NOT NULL
    );

    CREATE TABLE ParentPortal.ParentAlertAssociation(
        ParentUniqueId Varchar(32) PRIMARY KEY,
        AlertTypeId int NOT NULL
    );

    CREATE TABLE ParentPortal.TextMessageCarrierType(
        TextMessageCarrierTypeId int GENERATED ALWAYS AS IDENTITY,
        Description Varchar(1024) NOT NULL,
        ShortDescription Varchar(450) NOT NULL,
        SmsSuffixDomain Varchar(50) NOT NULL,
        MmsSuffixDomain Varchar(50) NOT NULL,
        CreateDate Timestamp(3) NOT NULL,
        LastModifiedDate Timestamp(3) NOT NULL,
        Id uuid NOT NULL,
        PRIMARY KEY(TextMessageCarrierTypeId)
    );

    -- GO
    
    ALTER TABLE ONLY ParentPortal.AlertLog ALTER COLUMN UTCSentDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.AlertLog ALTER COLUMN UTCCreateDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.AlertLog ALTER COLUMN UTCLastModifiedDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.AlertLog ALTER COLUMN Id SET DEFAULT (uuid_generate_v4()); /* check */
    ALTER TABLE ONLY ParentPortal.AlertLog ALTER COLUMN Read SET DEFAULT (FALSE);

    ALTER TABLE ONLY ParentPortal.MethodOfContactType ALTER COLUMN CreateDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.MethodOfContactType ALTER COLUMN LastModifiedDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.MethodOfContactType ALTER COLUMN Id SET DEFAULT (uuid_generate_v4()); /* check */

    ALTER TABLE ONLY ParentPortal.AlertType ALTER COLUMN CreateDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.AlertType ALTER COLUMN LastModifiedDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.AlertType ALTER COLUMN Id SET DEFAULT (uuid_generate_v4());
    ALTER TABLE ONLY ParentPortal.ParentAlert ALTER COLUMN AlertsEnabled SET DEFAULT (FALSE);
    ALTER TABLE ONLY ParentPortal.ParentAlert ALTER COLUMN CreateDate SET DEFAULT (now() AT time zone 'utc');

    ALTER TABLE ONLY ParentPortal.TextMessageCarrierType ALTER COLUMN CreateDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.TextMessageCarrierType ALTER COLUMN LastModifiedDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.TextMessageCarrierType ALTER COLUMN Id SET DEFAULT (uuid_generate_v4());

    ALTER TABLE ONLY ParentPortal.AlertLog ADD CONSTRAINT FK_AlertLog_AlertType FOREIGN KEY (AlertTypeId) 
    REFERENCES ParentPortal.AlertType (AlertTypeId);

    ALTER TABLE ONLY ParentPortal.ParentAlertAssociation ADD CONSTRAINT FK_ParentAlertAssociation_AlertType FOREIGN KEY (AlertTypeId) 
    REFERENCES ParentPortal.AlertType (AlertTypeId);

    ALTER TABLE ONLY ParentPortal.ParentAlertAssociation ADD CONSTRAINT FK_ParentAlertAssociation_ParentAlert FOREIGN KEY (ParentUniqueId) 
    REFERENCES ParentPortal.ParentAlert (ParentUniqueId) ON UPDATE CASCADE ON DELETE CASCADE;
    
    /* 
        This seems to be the GUI designer things, not needed in pgsql 
        see https://stackoverflow.com/questions/3856077/can-you-explain-the-use-of-sys-sp-addextendedproperty-in-the-following-code#3856166 for more

    
    EXECUTE sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Key for School Year' , @level0type=N'SCHEMA',@level0name=N'ParentPortal', @level1type=N'TABLE',@level1name=N'AlertLog', @level2type=N'COLUMN',@level2name=N'SchoolYear';
    */

    --GO 

    /*Parent Profile*/

    CREATE TABLE ParentPortal.ParentProfile(
        ParentUniqueId Varchar(32) PRIMARY KEY,
        FirstName Varchar(75) NOT NULL,
        MiddleName Varchar(75) NULL,
        LastSurname Varchar(75) NOT NULL,
        NickName Varchar(75) NULL,
        CreateDate Timestamp(3) NOT NULL,
        LastModifiedDate Timestamp(3) NOT NULL,
        PreferredMethodOfContactTypeId int NOT NULL,
        ReplyExpectations Varchar(255) NULL,
        LanguageCode Varchar(10) NULL
    );

    CREATE TABLE ParentPortal.ParentProfileAddress(
        ParentUniqueId Varchar(32) PRIMARY KEY,
        AddressTypeDescriptorId int NOT NULL,
        StreetNumberName Varchar(150) NOT NULL,
        ApartmentRoomSuiteNumber Varchar(50) NULL,
        City Varchar(30) NOT NULL,
        StateAbbreviationDescriptorId int NOT NULL,
        PostalCode Varchar(17) NOT NULL,
        NameOfCounty Varchar(30) NULL,
        CreateDate Timestamp(3) NOT NULL,
        LastModifiedDate Timestamp(3) NOT NULL
    );

    CREATE TABLE ParentPortal.ParentProfileElectronicMail(
        ParentUniqueId Varchar(32) PRIMARY KEY,
        ElectronicMailTypeDescriptorId int NOT NULL,
        ElectronicMailAddress Varchar(128) NOT NULL,
        PrimaryEmailAddressIndicator Boolean NULL,
        CreateDate Timestamp(3) NOT NULL,
        LastModifiedDate Timestamp(3) NOT NULL
    );

    CREATE TABLE ParentPortal.ParentProfileTelephone(
        ParentUniqueId Varchar(32) PRIMARY KEY,
        TelephoneNumberTypeDescriptorId int NOT NULL,
        TelephoneNumber Varchar(24) NOT NULL,
        TextMessageCapabilityIndicator Boolean NULL,
        CreateDate Timestamp(3) NOT NULL,
        LastModifiedDate Timestamp(3) NOT NULL,
        TelephoneCarrierTypeId int NULL,
        PrimaryMethodOfContact Boolean NULL
    );

    --GO

    ALTER TABLE ONLY ParentPortal.ParentProfile ALTER COLUMN CreateDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.ParentProfileAddress ALTER COLUMN CreateDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.ParentProfileElectronicMail ALTER COLUMN CreateDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.ParentProfileTelephone ALTER COLUMN CreateDate SET DEFAULT (now() AT time zone 'utc');

    ALTER TABLE ONLY ParentPortal.ParentProfile ALTER COLUMN LastModifiedDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.ParentProfileAddress ALTER COLUMN LastModifiedDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.ParentProfileElectronicMail ALTER COLUMN LastModifiedDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.ParentProfileTelephone ALTER COLUMN LastModifiedDate SET DEFAULT(now() AT time zone 'utc');

    ALTER TABLE ONLY ParentPortal.ParentProfile ADD CONSTRAINT FK_ParentProfile_MethodOfContactType FOREIGN KEY (PreferredMethodOfContactTypeId) 
    REFERENCES ParentPortal.MethodOfContactType (MethodOfContactTypeId);
    
    ALTER TABLE ONLY ParentPortal.ParentProfileAddress ADD CONSTRAINT FK_ParentProfileAddresss_AddressTypeDescriptor FOREIGN KEY(AddressTypeDescriptorId)
    REFERENCES edfi.AddressTypeDescriptor (AddressTypeDescriptorId);
    
    --GO

    ALTER TABLE ONLY ParentPortal.ParentProfileAddress ADD CONSTRAINT FK_ParentProfileAddress_ParentProfile FOREIGN KEY (ParentUniqueId) 
    REFERENCES ParentPortal.ParentProfile (ParentUniqueId) ON UPDATE CASCADE ON DELETE CASCADE;
    
    ALTER TABLE ONLY ParentPortal.ParentProfileAddress ADD CONSTRAINT FK_ParentProfileAddress_StateAbbreviationDescriptor FOREIGN KEY(StateAbbreviationDescriptorId)
    REFERENCES edfi.StateAbbreviationDescriptor (StateAbbreviationDescriptorId);

    ALTER TABLE ParentPortal.ParentProfileElectronicMail ADD CONSTRAINT FK_ParentProfileElectronicMail_ElectronicMailTypeDescriptor FOREIGN KEY(ElectronicMailTypeDescriptorId)
    REFERENCES edfi.ElectronicMailTypeDescriptor (ElectronicMailTypeDescriptorId);

    ALTER TABLE ONLY ParentPortal.ParentProfileElectronicMail ADD CONSTRAINT FK_ParentProfileElectronicMail_ParentProfile FOREIGN KEY (ParentUniqueId) 
    REFERENCES ParentPortal.ParentProfile (ParentUniqueId) ON UPDATE CASCADE ON DELETE CASCADE;

    ALTER TABLE ONLY ParentPortal.ParentProfileTelephone ADD CONSTRAINT FK_ParentProfileTelephone_ParentProfile FOREIGN KEY (ParentUniqueId) 
    REFERENCES ParentPortal.ParentProfile (ParentUniqueId) ON UPDATE CASCADE ON DELETE CASCADE;

    ALTER TABLE ParentPortal.ParentProfileTelephone ADD CONSTRAINT FK_ParentProfileTelephone_TelephoneNumberTypeDescriptor FOREIGN KEY(TelephoneNumberTypeDescriptorId)
    REFERENCES edfi.TelephoneNumberTypeDescriptor (TelephoneNumberTypeDescriptorId);

    ALTER TABLE ONLY ParentPortal.ParentProfileTelephone ADD CONSTRAINT FK_ParentProfileTelephone_CarrierType FOREIGN KEY (TelephoneCarrierTypeId) 
    REFERENCES ParentPortal.TextMessageCarrierType (TextMessageCarrierTypeId);

    --GO

    CREATE TABLE ParentPortal.StaffProfile(
        StaffUniqueId Varchar(32) PRIMARY KEY, 
        FirstName Varchar(75) NOT NULL,
        MiddleName Varchar(75) NULL,
        LastSurname Varchar(75) NOT NULL,
        NickName Varchar(75) NULL,
        CreateDate Timestamp(3) NOT NULL,
        LastModifiedDate Timestamp(3) NOT NULL,
        PreferredMethodOfContactTypeId int NOT NULL,
        ReplyExpectations Varchar(255) null,
        LanguageCode Varchar(10) null
    );

    CREATE TABLE ParentPortal.StaffProfileAddress(
        StaffUniqueId Varchar(32) PRIMARY KEY,
        AddressTypeDescriptorId int NOT NULL,
        StreetNumberName Varchar(150) NOT NULL,
        ApartmentRoomSuiteNumber Varchar(50) NULL,
        City Varchar(30) NOT NULL,
        StateAbbreviationDescriptorId int NOT NULL,
        PostalCode Varchar(17) NOT NULL,
        NameOfCounty Varchar(30) NULL,
        CreateDate Timestamp(3) NOT NULL,
        LastModifiedDate Timestamp(3) NOT NULL
    );

    CREATE TABLE ParentPortal.StaffProfileElectronicMail(
        StaffUniqueId Varchar(32) PRIMARY KEY,
        ElectronicMailTypeDescriptorId int NOT NULL,
        ElectronicMailAddress Varchar(128) NOT NULL,
        PrimaryEmailAddressIndicator Boolean NULL,
        CreateDate Timestamp(3) NOT NULL,
        LastModifiedDate Timestamp(3) NOT NULL
    );

    CREATE TABLE ParentPortal.StaffProfileTelephone(
        StaffUniqueId Varchar(32) PRIMARY KEY,
        TelephoneNumberTypeDescriptorId int NOT NULL,
        TelephoneNumber Varchar(24) NOT NULL,
        TextMessageCapabilityIndicator Boolean NULL,
        CreateDate Timestamp(3) NOT NULL,
        LastModifiedDate Timestamp(3) NOT NULL,
        TelephoneCarrierTypeId int NULL,
        PrimaryMethodOfContact Boolean NULL
    );

    --GO

    ALTER TABLE ONLY ParentPortal.StaffProfile ALTER COLUMN CreateDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.StaffProfileAddress ALTER COLUMN CreateDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.StaffProfileElectronicMail ALTER COLUMN CreateDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.StaffProfileTelephone ALTER COLUMN CreateDate SET DEFAULT (now() AT time zone 'utc');

    ALTER TABLE ONLY ParentPortal.StaffProfile ALTER COLUMN LastModifiedDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.StaffProfileAddress ALTER COLUMN LastModifiedDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.StaffProfileElectronicMail ALTER COLUMN LastModifiedDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.StaffProfileTelephone ALTER COLUMN LastModifiedDate SET DEFAULT (now() AT time zone 'utc');

    --GO

    ALTER TABLE ONLY ParentPortal.StaffProfile ADD CONSTRAINT FK_StaffProfile_MethodOfContactType FOREIGN KEY (PreferredMethodOfContactTypeId) 
    REFERENCES ParentPortal.MethodOfContactType (MethodOfContactTypeId);
    
    ALTER TABLE ONLY ParentPortal.StaffProfileAddress ADD CONSTRAINT FK_StaffProfileAddress_AddressTypeDescriptor FOREIGN KEY(AddressTypeDescriptorId)
    REFERENCES edfi.AddressTypeDescriptor (AddressTypeDescriptorId);

    ALTER TABLE ONLY ParentPortal.StaffProfileAddress ADD CONSTRAINT FK_StaffProfileAddress_StaffProfile FOREIGN KEY (StaffUniqueId) 
    REFERENCES ParentPortal.StaffProfile (StaffUniqueId) ON UPDATE CASCADE ON DELETE CASCADE;
    
    ALTER TABLE ONLY ParentPortal.StaffProfileAddress ADD CONSTRAINT FK_StaffProfileAddress_StateAbbreviationDescriptor FOREIGN KEY(StateAbbreviationDescriptorId)
    REFERENCES edfi.StateAbbreviationDescriptor (StateAbbreviationDescriptorId);
    
    ALTER TABLE ONLY ParentPortal.StaffProfileElectronicMail  ADD CONSTRAINT FK_StaffProfileElectronicMail_ElectronicMailTypeDescriptor FOREIGN KEY(ElectronicMailTypeDescriptorId)
    REFERENCES edfi.ElectronicMailTypeDescriptor (ElectronicMailTypeDescriptorId);
    
    --ALTER TABLE ParentPortal.StaffProfileElectronicMail CHECK CONSTRAINT [FK_StaffProfileElectronicMail_ElectronicMailTypeDescriptor];

    ALTER TABLE ONLY ParentPortal.StaffProfileElectronicMail ADD CONSTRAINT FK_StaffProfileElectronicMail_StaffProfile FOREIGN KEY (StaffUniqueId) 
    REFERENCES ParentPortal.StaffProfile (StaffUniqueId) ON UPDATE CASCADE ON DELETE CASCADE;

    --ALTER TABLE ParentPortal.StaffProfileElectronicMail CHECK CONSTRAINT [FK_StaffProfileElectronicMail_StaffProfile];

    ALTER TABLE ONLY ParentPortal.StaffProfileTelephone ADD CONSTRAINT FK_StaffProfileTelephone_StaffProfile FOREIGN KEY (StaffUniqueId) 
    REFERENCES ParentPortal.StaffProfile (StaffUniqueId) ON UPDATE CASCADE ON DELETE CASCADE;

    --ALTER TABLE ParentPortal.StaffProfileTelephone CHECK CONSTRAINT [FK_StaffProfileTelephone_StaffProfile];
    
    ALTER TABLE ONLY ParentPortal.StaffProfileTelephone ADD CONSTRAINT FK_StaffProfileTelephone_TelephoneNumberTypeDescriptor FOREIGN KEY(TelephoneNumberTypeDescriptorId)
    REFERENCES edfi.TelephoneNumberTypeDescriptor (TelephoneNumberTypeDescriptorId);

    --ALTER TABLE ParentPortal.StaffProfileTelephone CHECK CONSTRAINT [FK_StaffProfileTelephone_TelephoneNumberTypeDescriptor];

    ALTER TABLE ONLY ParentPortal.StaffProfileTelephone ADD CONSTRAINT FK_StaffProfileTelephone_CarrierType FOREIGN KEY (TelephoneCarrierTypeId) 
    REFERENCES ParentPortal.TextMessageCarrierType (TextMessageCarrierTypeId);
    
    --ALTER TABLE ParentPortal.StaffProfileTelephone CHECK CONSTRAINT [FK_StaffProfileTelephone_CarrierType];

    --GO
    
    /*DATA*/

    -- working
    INSERT INTO ParentPortal.MethodOfContactType (Description, ShortDescription, CreateDate, LastModifiedDate) VALUES ('Email', N'Email', CAST('2018-11-23T17:16:51.620' AS TIMESTAMP(3)), CAST('2018-11-23T17:16:51.620' AS TIMESTAMP(3)));
    
    --GO
    
    INSERT INTO ParentPortal.AlertType (Description, ShortDescription) VALUES ('Missing Assignment Alert', 'Assignment');
    INSERT INTO ParentPortal.AlertType (Description, ShortDescription) VALUES ('Course Grade Alert', 'Course Grade');
    INSERT INTO ParentPortal.AlertType (Description, ShortDescription) VALUES ('Unread Message Alert', 'Unread Message');

    --GO
    INSERT INTO ParentPortal.ParentAlert (ParentUniqueId, AlertsEnabled, CreateDate) VALUES ('778657', TRUE, CAST(N'2018-11-23T17:23:13.997' AS TIMESTAMP(3)));
    -- INSERT INTO ParentPortal.ParentAlertAssociation (ParentUniqueId, AlertTypeId) VALUES ('778657', 1);
    
    INSERT INTO ParentPortal.TextMessageCarrierType (Description, ShortDescription, SmsSuffixDomain, MmsSuffixDomain, CreateDate, LastModifiedDate) VALUES (N'AT&T', N'AT&T', N'@txt.att.net', N'@mms.att.net', CAST(N'2018-11-27T10:40:34.423' AS TIMESTAMP(3)), CAST(N'2018-11-27T10:40:34.423' AS TIMESTAMP(3)));
    INSERT INTO ParentPortal.TextMessageCarrierType (Description, ShortDescription, SmsSuffixDomain, MmsSuffixDomain, CreateDate, LastModifiedDate) VALUES (N'Boost Mobile', N'Boost Mobile', N'@smsmyboostmobile.com', N'@myboostmobile.com', CAST(N'2018-11-27T10:40:34.423' AS TIMESTAMP(3)), CAST(N'2018-11-27T10:40:34.423' AS TIMESTAMP(3)));
    INSERT INTO ParentPortal.TextMessageCarrierType (Description, ShortDescription, SmsSuffixDomain, MmsSuffixDomain, CreateDate, LastModifiedDate) VALUES (N'Cricket', N'Cricket', N'@sms.cricketwireless.net', N'@mms.cricketwireless.net', CAST(N'2018-11-27T10:40:34.423' AS TIMESTAMP(3)), CAST(N'2018-11-27T10:40:34.423' AS TIMESTAMP(3)));
    INSERT INTO ParentPortal.TextMessageCarrierType (Description, ShortDescription, SmsSuffixDomain, MmsSuffixDomain, CreateDate, LastModifiedDate) VALUES (N'Sprint', N'Sprint', N'@messaging.sprintpcs.com', N'@pm.sprint.com', CAST(N'2018-11-27T10:40:34.423' AS TIMESTAMP(3)), CAST(N'2018-11-27T10:40:34.423' AS TIMESTAMP(3)));
    INSERT INTO ParentPortal.TextMessageCarrierType (Description, ShortDescription, SmsSuffixDomain, MmsSuffixDomain, CreateDate, LastModifiedDate) VALUES (N'T-Mobile', N'T-Mobile', N'@tmomail.net', N'@tmomail.net', CAST(N'2018-11-27T10:40:34.423' AS TIMESTAMP(3)), CAST(N'2018-11-27T10:40:34.423' AS TIMESTAMP(3)));
    INSERT INTO ParentPortal.TextMessageCarrierType (Description, ShortDescription, SmsSuffixDomain, MmsSuffixDomain, CreateDate, LastModifiedDate) VALUES (N'U.S. Cellular', N'U.S. Cellular', N'@email.uscc.net', N'@mms.uscc.net', CAST(N'2018-11-27T10:40:34.427' AS TIMESTAMP(3)), CAST(N'2018-11-27T10:40:34.427' AS TIMESTAMP(3)));
    INSERT INTO ParentPortal.TextMessageCarrierType (Description, ShortDescription, SmsSuffixDomain, MmsSuffixDomain, CreateDate, LastModifiedDate) VALUES (N'Verizon', N'Verizon', N'@vtext.com', N'@vzwpix.com', CAST(N'2018-11-27T10:40:34.427' AS TIMESTAMP(3)), CAST(N'2018-11-27T10:40:34.427' AS TIMESTAMP(3)));
    INSERT INTO ParentPortal.TextMessageCarrierType (Description, ShortDescription, SmsSuffixDomain, MmsSuffixDomain, CreateDate, LastModifiedDate) VALUES (N'Virgin Mobile', N'Virgin Mobile', N'@vmobl.com', N'@vmpix.com', CAST(N'2018-11-27T10:40:34.427' AS TIMESTAMP(3)), CAST(N'2018-11-27T10:40:34.427' AS TIMESTAMP(3)));
    
    ---GO

    CREATE TABLE ParentPortal.AlertTypeThresholdAssociation(
        AlertTypeId int GENERATED ALWAYS AS IDENTITY,
        ThresholdTypeId int NOT NULL,
        PRIMARY KEY(AlertTypeId)
    );

    CREATE TABLE ParentPortal.ThresholdType(
        ThresholdTypeId int GENERATED ALWAYS AS IDENTITY,
        Description Varchar(1024) NOT NULL,
        ShortDescription Varchar(450) NOT NULL,
        ThresholdValue decimal(6,2) NOT NULL,
        WhatCanParentDo Text NOT NULL,
        CreateDate Timestamp(3) NOT NULL,
        LastModifiedDate Timestamp(3) NOT NULL,
        Id uuid NOT NULL,
        PRIMARY KEY(ThresholdTypeId)
    );

    ---GO

    ALTER TABLE ONLY ParentPortal.AlertTypeThresholdAssociation ADD CONSTRAINT FK_StaffProfileTelephone_CarrierType FOREIGN KEY (ThresholdTypeId) 
    REFERENCES ParentPortal.ThresholdType (ThresholdTypeId);
    
    -- ALTER TABLE ParentPortal.AlertTypeThresholdAssociation CHECK CONSTRAINT [FK_AlertTypeThresholdAssociation_Threshold];

    ALTER TABLE ONLY ParentPortal.AlertTypeThresholdAssociation ADD CONSTRAINT FK_AlertTypeThresholdAssociation_AlertType FOREIGN KEY (AlertTypeId) 
    REFERENCES ParentPortal.AlertType (AlertTypeId) ON UPDATE CASCADE ON DELETE CASCADE;

    -- ALTER TABLE ParentPortal.AlertTypeThresholdAssociation CHECK CONSTRAINT [FK_AlertTypeThresholdAssociation_AlertType];

    --GO
    ALTER TABLE ONLY ParentPortal.AlertLog ALTER COLUMN UTCSentDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.ThresholdType ALTER COLUMN CreateDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.ThresholdType ALTER COLUMN LastModifiedDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.ThresholdType ALTER COLUMN Id SET DEFAULT (uuid_generate_v4());
    
    --GO

    INSERT INTO ParentPortal.ThresholdType(Description, ShortDescription, ThresholdValue, WhatCanParentDo) VALUES('Unexcused Absence Threshold', 'Unexcused Absence', 5, 'At YES Prep, your child’s education is our #1 priority.   In order to achieve our goals as educators, we need students in school, on time, every day.  If a student has three or more unexcused absences for three or more days or parts of days, we want to connect with you as the parent or guardian to identify what barriers prevent your child from attending school regularly.  You can connect with your child’s Student Support Counselor to discuss the current number of absences, rectify any errors (excused absences), and possibly develop an attendance plan that outlines how the campus and family can work in partnership support your child’s regular participation in school.  Please note that according to Texas Education Agency (Section 25.093), it is an offense for a parent to contribute to nonattendance and YES Prep is required to notify the Courts of truancy if there a lack of compliance after notice of excessive absences.');
    INSERT INTO ParentPortal.ThresholdType(Description, ShortDescription, ThresholdValue, WhatCanParentDo) VALUES('Excused Absence Threshold', 'Excused Absence', 3, 'At YES Prep, your child’s education is our #1 priority.   In order to achieve our goals as educators, we need students in school, on time, every day.  If a student has three or more unexcused absences for three or more days or parts of days, we want to connect with you as the parent or guardian to identify what barriers prevent your child from attending school regularly.  You can connect with your child’s Student Support Counselor to discuss the current number of absences, rectify any errors (excused absences), and possibly develop an attendance plan that outlines how the campus and family can work in partnership support your child’s regular participation in school.  Please note that according to Texas Education Agency (Section 25.093), it is an offense for a parent to contribute to nonattendance and YES Prep is required to notify the Courts of truancy if there a lack of compliance after notice of excessive absences.');
    INSERT INTO ParentPortal.ThresholdType(Description, ShortDescription, ThresholdValue, WhatCanParentDo) VALUES('Tardy Threshold', 'Tardy', 10, 'At YES Prep, your child’s education is our #1 priority.   In order to achieve our goals as educators, we need students in school, on time, every day.  If a student has three or more unexcused absences for three or more days or parts of days, we want to connect with you as the parent or guardian to identify what barriers prevent your child from attending school regularly.  You can connect with your child’s Student Support Counselor to discuss the current number of absences, rectify any errors (excused absences), and possibly develop an attendance plan that outlines how the campus and family can work in partnership support your child’s regular participation in school.  Please note that according to Texas Education Agency (Section 25.093), it is an offense for a parent to contribute to nonattendance and YES Prep is required to notify the Courts of truancy if there a lack of compliance after notice of excessive absences.');
    INSERT INTO ParentPortal.ThresholdType(Description, ShortDescription, ThresholdValue, WhatCanParentDo) VALUES('Discipline Incidents Threshold', 'Discipline', 1, 'YES Prep students are expected to behave in a manner that promotes respect for all individuals, contributes to a safe environment for students, and provides an educational environment free of disruption. <br><br> Collaborating with our parents around student behavior is an important part of the YES Prep community.  We hope to meet with you to discuss your student’s behavior further to ensure we are all working towards providing your student with the supports necessary to be successful behaviorally and academically.  If you have not scheduled a meeting with your students Dean of Students, please reach out to the front office.');
    INSERT INTO ParentPortal.ThresholdType(Description, ShortDescription, ThresholdValue, WhatCanParentDo) VALUES('Missing Assignment Threshold', 'Assignment', 3,'In order to progress towards promotion, graduation, and college readiness, students should be succeeding in their coursework.  Based on the number of missing assignments, the following actions are recommended. <ul><li> Review your child''s agenda nightly.</li><li>Provide your child with a designated time and space to study and do homework.</li><li>Ensure you have an active account in Home Access Center and check students’ progress regularly.</li><li>Refer to the teacher’s makeup policy to determine if there are any assignments that can be made up.</li></ul> Ensure your student is present at school on time, every day so that they are not missing instruction and important assignments.');
    INSERT INTO ParentPortal.ThresholdType(Description, ShortDescription, ThresholdValue, WhatCanParentDo) VALUES('Course Average Threshold', 'Course', 70, 'In order to progress towards promotion, graduation, and college readiness, students should be succeeding in their coursework.  Based on your child''s current grades, the following actions are recommended. <ul><li>Your child should attend tutorials when available.</li><li>Refer to the teacher’s reassessment policy to determine if there are any reassessment opportunities.</li><li>Ensure you have an active account in Home Access Center and check students’ progress regularly.</li><li>Provide your child with a designated time and space to study and do homework.</li><li>Set a goal with your child and monitor progress toward that goal.</li></ul>');
    
    --GO 

    /*
        ERROR:  cannot insert into column alerttypeid
        DETAIL:  Column alerttypeid is an identity column defined as GENERATED ALWAYS.
        HINT:  Use OVERRIDING SYSTEM VALUE to override.
        
        INSERT INTO ParentPortal.AlertTypeThresholdAssociation VALUES (1,1),(1,2),(1,3),(2,4),(3,5),(4,6);
    */

    CREATE TABLE ParentPortal.ChatLog (
        StudentUniqueId        VARCHAR(32) PRIMARY KEY,
        SenderTypeId           INT NOT NULL,
        SenderUniqueId         VARCHAR(32) NOT NULL,
        RecipientTypeId        INT NOT NULL,
        RecipientUniqueId      VARCHAR(32) NOT NULL,
        EnglishMessage         TEXT NOT NULL,
        TranslatedMessage      TEXT NULL,
        DateSent               TIMESTAMP(3) CONSTRAINT DF_ChatLog_CreateDate DEFAULT (now() AT time zone 'utc') NOT NULL,
        RecipientHasRead       BOOLEAN CONSTRAINT DF_ChatLog_RecipientHasRead DEFAULT (FALSE) NOT NULL,
        Id                     uuid CONSTRAINT ChatLog_DF_Id DEFAULT (uuid_generate_v4()) NOT NULL,
        TranslatedLanguageCode VARCHAR (5) NULL
    );

    --GO

    /*
        PostgreSQL doesn't have the concept of clustered indexes at all. Instead, all tables are heap tables and all indexes are non-clustered indexes.
        https://stackoverflow.com/questions/27978157/cluster-and-non-cluster-index-in-postgresql#27979121

    CREATE NONCLUSTERED INDEX ChatLog_RecipientUniqueId
        ON ParentPortal.ChatLog(RecipientUniqueId ASC);
    
    CREATE NONCLUSTERED INDEX ChatLog_SenderUniqueId
        ON ParentPortal.ChatLog(SenderUniqueId ASC);
    */

    CREATE TABLE ParentPortal.ChatLogPersonType(
        ChatLogPersonTypeId int GENERATED ALWAYS AS IDENTITY,
        Description Varchar(1024) NOT NULL,
        ShortDescription Varchar(450) NOT NULL,
        CreateDate Timestamp(3) NOT NULL,
        LastModifiedDate Timestamp(3) NOT NULL,
        Id uuid NOT NULL,
        PRIMARY KEY(ChatLogPersonTypeId)
    );

    ALTER TABLE ONLY ParentPortal.ChatLogPersonType ALTER COLUMN CreateDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.ChatLogPersonType ALTER COLUMN LastModifiedDate SET DEFAULT (now() AT time zone 'utc');    
    ALTER TABLE ONLY ParentPortal.ChatLogPersonType ALTER COLUMN Id SET DEFAULT (uuid_generate_v4());

    ALTER TABLE ONLY ParentPortal.ChatLog ADD CONSTRAINT FK_ChatLog_RecipientType FOREIGN KEY (RecipientTypeId) 
    REFERENCES ParentPortal.ChatLogPersonType (ChatLogPersonTypeId);
    
    -- ALTER TABLE ParentPortal.ChatLog CHECK CONSTRAINT [FK_ChatLog_RecipientType];

    ALTER TABLE ONLY ParentPortal.ChatLog ADD CONSTRAINT FK_ChatLog_SenderType FOREIGN KEY (SenderTypeId) 
    REFERENCES ParentPortal.ChatLogPersonType (ChatLogPersonTypeId);
    
    -- ALTER TABLE ParentPortal.ChatLog CHECK CONSTRAINT [FK_ChatLog_SenderType];

    --GO

    INSERT INTO ParentPortal.ChatLogPersonType(Description, ShortDescription) VALUES ('Parent', 'Parent');
    INSERT INTO ParentPortal.ChatLogPersonType(Description, ShortDescription) VALUES ('Staff', 'Staff');

    --GO 

    CREATE TABLE ParentPortal.AppOffline(
        IsAppOffline Boolean NOT NULL
    );

    INSERT INTO ParentPortal.AppOffline(IsAppOffline) VALUES (FALSE);

    CREATE TABLE ParentPortal.FeedbackLog (
        FeedbackLogId int GENERATED ALWAYS AS IDENTITY,
        PersonUniqueId Varchar(32) NOT NULL,
        PersonTypeId int NOT NULL,
        Name Varchar(128) NOT NULL,
        Email Varchar(128) NOT NULL,
        Subject Varchar(128) NOT NULL,
        Issue Varchar(128) NOT NULL,
        CurrentUrl Varchar(128) NOT NULL,
        Description Text NOT NULL,
        CreateDate Timestamp(3) NOT NULL,
        LastModifiedDate Timestamp(3) NOT NULL,
        Id uuid NOT NULL,
        PRIMARY KEY(FeedbackLogId)
    );

    --GO

    ALTER TABLE ONLY ParentPortal.FeedbackLog ALTER COLUMN CreateDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.FeedbackLog ALTER COLUMN LastModifiedDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.FeedbackLog ALTER COLUMN Id SET DEFAULT (uuid_generate_v4());
    
    ALTER TABLE ONLY ParentPortal.FeedbackLog ADD CONSTRAINT FK_FeedbackLog_PersonType FOREIGN KEY (PersonTypeId) 
    REFERENCES ParentPortal.ChatLogPersonType (ChatLogPersonTypeId);

    -- ALTER TABLE ParentPortal.FeedbackLog CHECK CONSTRAINT [FK_FeedbackLog_PersonType];

    --GO

    CREATE TABLE ParentPortal.SpotlightIntegration(
        StudentUniqueId Varchar(32) PRIMARY KEY,
        Url Text NOT NULL,
        UrlTypeId int NOT NULL
    );

    CREATE TABLE ParentPortal.UrlType(
        UrlTypeId int GENERATED ALWAYS AS IDENTITY,
        Description Varchar(1024) NOT NULL,
        ShortDescription Varchar(450) NOT NULL,
        CreateDate Timestamp(3) NOT NULL,
        LastModifiedDate Timestamp(3) NOT NULL,
        Id uuid NOT NULL,
        PRIMARY KEY(UrlTypeId) 
    );

    --GO

    ALTER TABLE ONLY ParentPortal.UrlType ALTER COLUMN CreateDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.UrlType ALTER COLUMN LastModifiedDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.UrlType ALTER COLUMN Id SET DEFAULT (uuid_generate_v4());

    ALTER TABLE ONLY ParentPortal.SpotlightIntegration ADD CONSTRAINT FK_SpotlightIntegration_UrlType FOREIGN KEY (UrlTypeId) 
    REFERENCES ParentPortal.UrlType (UrlTypeId);

    --ALTER TABLE ParentPortal.SpotlightIntegration CHECK CONSTRAINT [FK_SpotlightIntegration_UrlType];

    --GO 

    INSERT INTO ParentPortal.UrlType(Description, ShortDescription) VALUES ('Video Url', 'Video');
    INSERT INTO ParentPortal.UrlType(Description, ShortDescription) VALUES ('PDF Url', 'PDF');

    --GO
    CREATE VIEW ParentPortal.StudentABCSummary AS
    SELECT s.StudentUsi, s.StudentUniqueId, s.FirstName, s.MiddleName, s.LastSurname,
    -- Sex Type --
        (SELECT ShortDescription FROM edfi.Descriptor
                WHERE DescriptorId = s.BirthSexDescriptorId LIMIT 1) as  SexType,
    -- GPA --
        (SELECT sar.CumulativeGradePointAverage FROM edfi.StudentAcademicRecord as sar
                WHERE StudentUSI = s.StudentUSI
                ORDER BY sar.SchoolYear desc, sar.TermDescriptorId desc LIMIT 1) as Gpa,
    -- Grade Level --
        (SELECT d.ShortDescription
                FROM edfi.Descriptor AS d 
                INNER JOIN edfi.StudentSchoolAssociation AS ssa ON ssa.StudentUSI = 730 
                    AND d.DescriptorId = ssa.EntryGradeLevelDescriptorId
                INNER JOIN edfi.Session AS sess ON ssa.EntryDate >= sess.BeginDate
                    AND ssa.EntryDate <= sess.EndDate
                    AND ssa.ExitWithdrawDate IS NULL 
                    AND NOW() >= sess.BeginDate
                    AND NOW() <= sess.EndDate
                INNER JOIN edfi.SchoolYearType AS sy ON sy.SchoolYear = sess.SchoolYear
                WHERE sy.CurrentSchoolYear = TRUE
                ORDER BY ssa.EntryDate DESC LIMIT 1) as GradeLevel,
    -- Absences Count --
    (SELECT COUNT(*) AS Expr1 
        FROM edfi.StudentSchoolAttendanceEvent AS ssae 
            INNER JOIN edfi.SchoolYearType AS sy ON ssae.SchoolYear = sy.SchoolYear
            INNER JOIN edfi.Descriptor as aecd on ssae.AttendanceEventCategoryDescriptorId = aecd.DescriptorId
            WHERE (sy.CurrentSchoolYear = TRUE) 
                AND (ssae.StudentUSI = s.StudentUSI)
                AND (aecd.CodeValue IN ('Excused Absence', 'Unexcused Absence'))) as Absences,
    (SELECT Count(*) 
        FROM edfi.GradebookEntry as gbe
            INNER JOIN edfi.Descriptor as getd
                on gbe.GradebookEntryTypeDescriptorId = getd.DescriptorId
            INNER JOIN edfi.StudentSectionAssociation as ssa
                on ssa.SchoolId = gbe.SchoolId
                AND ssa.SchoolYear = gbe.SchoolYear
                AND ssa.SectionIdentifier = gbe.SectionIdentifier
                AND ssa.LocalCourseCode = gbe.LocalCourseCode
                AND ssa.SessionName = gbe.SessionName
            LEFT JOIN edfi.StudentGradebookEntry as sgbe
                on sgbe.DateAssigned = gbe.DateAssigned
                AND sgbe.StudentUSI = ssa.StudentUSI
                AND sgbe.GradebookEntryTitle = gbe.GradebookEntryTitle
                AND sgbe.LocalCourseCode = gbe.LocalCourseCode
                AND sgbe.SchoolId = gbe.SchoolId
                AND sgbe.SchoolYear = gbe.SchoolYear
                AND sgbe.SectionIdentifier = gbe.SectionIdentifier
                AND sgbe.SessionName = gbe.SessionName
            WHERE  sgbe.DateFulfilled IS NULL 
                AND ssa.StudentUSI = s.StudentUSI
                AND sgbe.LetterGradeEarned = 'M'
                AND gbe.GradebookEntryTypeDescriptorId IS NOT NULL
                AND getd.CodeValue = 'HMWK'
                AND gbe.SchoolYear = (SELECT SchoolYear FROM edfi.SchoolYearType WHERE( CurrentSchoolYear = TRUE)))
                as MissingAssignments,
    (SELECT Count(*) 
        FROM edfi.StudentDisciplineIncidentAssociation as sdia
            inner join edfi.DisciplineIncident as di
                on sdia.IncidentIdentifier = di.IncidentIdentifier
                AND sdia.SchoolId = di.SchoolId
            inner join edfi.Descriptor as d
                on sdia.StudentParticipationCodeDescriptorId = d.DescriptorId
            WHERE d.CodeValue = 'Perpetrator'
                AND sdia.StudentUSI = s.StudentUSI) 
                as DisciplineIncidents,
    (SELECT AVG(g.NumericGradeEarned) from edfi.Grade as g
            inner join edfi.Descriptor as gtd
                on g.GradeTypeDescriptorId = gtd.DescriptorId
            inner join edfi.Descriptor as gpd
                on g.GradingPeriodDescriptorId = gpd.DescriptorId
            inner join edfi.SchoolYearType as sy
                on g.SchoolYear = sy.SchoolYear
            WHERE g.StudentUSI = s.StudentUSI
                AND sy.CurrentSchoolYear = TRUE
                AND  gtd.CodeValue = 'Grading Period'
                AND g.NumericGradeEarned IS NOT NULL)
                as GradingPeriodAvg,
    -- Exam Average --
    (SELECT AVG(g.NumericGradeEarned) from edfi.Grade as g
            inner join edfi.Descriptor as gtd
                on g.GradeTypeDescriptorId = gtd.DescriptorId
            inner join edfi.Descriptor as gpd
                on g.GradingPeriodDescriptorId = gpd.DescriptorId
            inner join edfi.SchoolYearType as sy
                on g.SchoolYear = sy.SchoolYear
            WHERE g.StudentUSI = s.StudentUSI
                AND sy.CurrentSchoolYear = TRUE
                AND  gtd.CodeValue = 'Exam'
                AND g.NumericGradeEarned IS NOT NULL)
                as ExamAvg,
    -- Semester Average --
    (SELECT AVG(g.NumericGradeEarned) from edfi.Grade as g
            inner join edfi.Descriptor as gtd
                on g.GradeTypeDescriptorId = gtd.DescriptorId
            inner join edfi.Descriptor as gpd
                on g.GradingPeriodDescriptorId = gpd.DescriptorId
            inner join edfi.SchoolYearType as sy
                on g.SchoolYear = sy.SchoolYear
            WHERE g.StudentUSI = s.StudentUSI
                AND sy.CurrentSchoolYear = TRUE
                AND  gtd.CodeValue = 'Semester'
                AND g.NumericGradeEarned IS NOT NULL)
                as SemesterAvg,
    -- Final Average --
    (SELECT AVG(g.NumericGradeEarned) FROM edfi.Grade as g
            inner join edfi.Descriptor as gtd
                on g.GradeTypeDescriptorId = gtd.DescriptorId
            inner join edfi.Descriptor as gpd
                on g.GradingPeriodDescriptorId = gpd.DescriptorId
            inner join edfi.SchoolYearType as sy
                on g.SchoolYear = sy.SchoolYear
            WHERE g.StudentUSI = s.StudentUSI
                AND sy.CurrentSchoolYear = TRUE
                AND  gtd.CodeValue = 'Final'
                AND g.NumericGradeEarned IS NOT NULL)
                as FinalAvg
    FROM edfi.Student as s;
    -- GO 

    CREATE TABLE ParentPortal.Logs(
        LogId int GENERATED ALWAYS AS IDENTITY,
        LogMessage Text NOT NULL,
        LogType Varchar(450) NOT NULL,
        DateTimeOfEvent Timestamp(3) NOT NULL,
        LastModifiedDate Timestamp(3) NOT NULL,
        Id uuid NOT NULL,
        PRIMARY KEY(LogId)
    );
    
    ALTER TABLE ONLY ParentPortal.Logs ALTER COLUMN DateTimeOfEvent SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.Logs ALTER COLUMN LastModifiedDate SET DEFAULT (now() AT time zone 'utc');
    ALTER TABLE ONLY ParentPortal.Logs ALTER COLUMN Id SET DEFAULT (uuid_generate_v4());

    -- GO 

    CREATE TABLE ParentPortal.NotificationsToken(
        NotificationTokenUSI int GENERATED ALWAYS AS IDENTITY,
        PersonUniqueId Varchar(32) NOT NULL,
        PersonType Varchar(8) NOT NULL,
        DeviceUUID Varchar(100) NOT NULL,
        Token Varchar(500) NOT NULL,
        CreateDate Timestamp(6) NOT NULL,
        LastModifiedDate Timestamp(6) NOT NULL,
        Id uuid NOT NULL,
        PRIMARY KEY(NotificationTokenUSI)
    );

    INSERT INTO ParentPortal.MethodOfContactType
            (Description
            ,ShortDescription
            )
        VALUES
            ('App Notifications'
            ,'Notifications');

    CREATE TABLE ParentPortal.Admin(
        AdminUSI int GENERATED ALWAYS AS IDENTITY,
        ElectronicMailAddress Varchar(50) NOT NULL,
        CreateDate Timestamp(6) NOT NULL,
        LastModifiedDate Timestamp(6) NOT NULL,
        Id uuid NOT NULL,
        PRIMARY KEY(AdminUSI)
    );

    CREATE TABLE ParentPortal.GroupMessagesQueueLog(
        Id uuid NOT NULL,
        Type Varchar(20) NOT NULL,
        QueuedDateTime Timestamp(3) NOT NULL,
        StaffUniqueIdSent Varchar(50) NOT NULL,
        SchoolId int NOT NULL,
        Audience Varchar(1000) NULL,
        FilterParams Text NULL,
        Subject Varchar(250) NOT NULL,
        Body Text NOT NULL,
        SentStatus int NOT NULL,
        RetryCount int NOT NULL,
        Data Text NOT NULL,
        DateSent Timestamp(3) NULL,
        PRIMARY KEY(Id)
    );

    -- GO

    ALTER TABLE ONLY ParentPortal.GroupMessagesQueueLog ALTER COLUMN Id SET DEFAULT (uuid_generate_v4());
    
    CREATE TABLE ParentPortal.GroupMessagesLogChatLog(
        GroupMessagesLogId uuid PRIMARY KEY,
        ChatLogId Char(36) NOT NULL,
        Status int NOT NULL,
        ErrorMessage Varchar(500) NULL
    );

    -- GO

    ALTER TABLE ONLY ParentPortal.GroupMessagesLogChatLog ADD CONSTRAINT FK_GroupMessagesLogChatLog_GroupMessagesQueueLog FOREIGN KEY (GroupMessagesLogId) 
    REFERENCES ParentPortal.GroupMessagesQueueLog (Id);

    -- ALTER TABLE ParentPortal.GroupMessagesLogChatLog CHECK CONSTRAINT [FK_GroupMessagesLogChatLog_GroupMessagesQueueLog];

    --GO
    CREATE VIEW ParentPortal.ParentChatRecipients
    AS
    SELECT        stu.StudentUSI, stu.StudentUniqueId, stu.FirstName AS StudentFirstName, stu.MiddleName AS StudentMiddleName, stu.LastSurname AS StudentLastSurname, co.LocalCourseTitle AS RelationsToStudent, sta.StaffUSI, 
                            sta.StaffUniqueId, sta.FirstName, sta.LastSurname, pro.ReplyExpectations, MAX(cl.DateSent) AS MostRecentMessageDate, SUM(CASE WHEN cl.RecipientHasRead = TRUE THEN 1 ELSE 0 END) AS UnreadMessageCount, 
                            sess.BeginDate, sess.EndDate
    FROM            edfi.Student AS stu INNER JOIN
                            edfi.StudentSectionAssociation AS stusa ON stu.StudentUSI = stusa.StudentUSI INNER JOIN
                            edfi.SchoolYearType AS sy ON stusa.SchoolYear = sy.SchoolYear INNER JOIN
                            edfi.StaffSectionAssociation AS stasa ON stusa.SectionIdentifier = stasa.SectionIdentifier AND stusa.LocalCourseCode = stasa.LocalCourseCode AND stusa.SchoolId = stasa.SchoolId AND 
                            stusa.SchoolYear = stasa.SchoolYear AND stusa.SessionName = stasa.SessionName INNER JOIN
                            edfi.CourseOffering AS co ON co.LocalCourseCode = stasa.LocalCourseCode AND co.SchoolId = stasa.SchoolId AND co.SchoolYear = stasa.SchoolYear AND co.SessionName = stasa.SessionName INNER JOIN
                            edfi.Session AS sess ON stusa.SchoolId = sess.SchoolId AND stusa.SchoolYear = sess.SchoolYear AND stusa.SessionName = sess.SessionName INNER JOIN
                            edfi.Staff AS sta ON stasa.StaffUSI = sta.StaffUSI LEFT OUTER JOIN
                            ParentPortal.StaffProfile AS pro ON sta.StaffUniqueId = pro.StaffUniqueId LEFT OUTER JOIN
                            ParentPortal.ChatLog AS cl ON stu.StudentUniqueId = cl.StudentUniqueId AND sta.StaffUniqueId = cl.SenderUniqueId AND cl.SenderTypeId = 2
    WHERE        (sy.CurrentSchoolYear = TRUE)
    GROUP BY stu.StudentUSI, stu.StudentUniqueId, stu.FirstName, stu.LastSurname, stu.MiddleName, co.LocalCourseTitle, sta.StaffUSI, sta.StaffUniqueId, sta.FirstName, sta.LastSurname, pro.ReplyExpectations, sess.BeginDate, 
                            sess.EndDate;
    

    --GO
    CREATE VIEW ParentPortal.ParentPrincipalsChatRecipients
    AS
    SELECT        s.StudentUSI, s.StudentUniqueId, s.FirstName AS StudentFirstName, s.MiddleName AS StudentMiddleName, s.LastSurname AS StudentLastSurname, staff.StaffUSI, staff.StaffUniqueId, staff.FirstName AS StaffFirstName, 
                            staff.LastSurname AS StaffLastSurname, seoaa.PositionTitle AS RelationsToStudent, MAX(cl.DateSent) AS MostRecentMessageDate, SUM(CASE WHEN cl.RecipientHasRead = TRUE THEN 1 ELSE 0 END) 
                            AS UnreadMessageCount
    FROM            edfi.StaffEducationOrganizationAssignmentAssociation AS seoaa INNER JOIN
                            edfi.StudentEducationOrganizationAssociation AS seoa ON seoaa.EducationOrganizationId = seoa.EducationOrganizationId INNER JOIN
                            edfi.Student AS s ON seoa.StudentUSI = s.StudentUSI INNER JOIN
                            edfi.Staff AS staff ON seoaa.StaffUSI = staff.StaffUSI LEFT OUTER JOIN
                            ParentPortal.ChatLog AS cl ON s.StudentUniqueId = cl.StudentUniqueId AND staff.StaffUniqueId = cl.SenderUniqueId AND cl.SenderTypeId = 2
    GROUP BY s.StudentUSI, s.StudentUniqueId, s.FirstName, s.MiddleName, s.LastSurname, staff.StaffUSI, staff.StaffUniqueId, staff.FirstName, staff.LastSurname, seoaa.PositionTitle;

    CREATE VIEW ParentPortal.StaffChatRecipients
    AS
    SELECT        s.StudentUSI, s.StudentUniqueId, s.FirstName AS StudentFirstName, s.MiddleName AS StudentMiddleName, s.LastSurname AS StudentLastSurname, p.ParentUSI, p.ParentUniqueId, p.FirstName AS ParentFirstName, 
                            p.LastSurname AS ParentLastSurname, co.LocalCourseTitle, MAX(cl.DateSent) AS MostRecentMessageDate, SUM(CASE WHEN cl.RecipientHasRead = TRUE THEN 1 ELSE 0 END) AS UnreadMessageCount, staff.StaffUniqueId, 
                            sess.BeginDate, sess.EndDate, pro.ReplyExpectations, pro.LanguageCode
    FROM            edfi.Student AS s INNER JOIN
                            edfi.StudentSectionAssociation AS ssa ON s.StudentUSI = ssa.StudentUSI INNER JOIN
                            edfi.SchoolYearType AS sy ON ssa.SchoolYear = sy.SchoolYear INNER JOIN
                            edfi.StaffSectionAssociation AS staffsa ON staffsa.SchoolId = ssa.SchoolId AND staffsa.SchoolYear = ssa.SchoolYear AND staffsa.LocalCourseCode = ssa.LocalCourseCode AND staffsa.SessionName = ssa.SessionName AND 
                            staffsa.SectionIdentifier = ssa.SectionIdentifier INNER JOIN
                            edfi.CourseOffering AS co ON staffsa.SchoolId = co.SchoolId AND staffsa.SchoolYear = co.SchoolYear AND staffsa.LocalCourseCode = co.LocalCourseCode AND staffsa.SessionName = co.SessionName INNER JOIN
                            edfi.Session AS sess ON ssa.SchoolId = sess.SchoolId AND ssa.SchoolYear = sess.SchoolYear AND ssa.SessionName = sess.SessionName INNER JOIN
                            edfi.Staff AS staff ON staffsa.StaffUSI = staff.StaffUSI LEFT OUTER JOIN
                            edfi.StudentParentAssociation AS spa ON s.StudentUSI = spa.StudentUSI LEFT OUTER JOIN
                            edfi.Parent AS p ON spa.ParentUSI = p.ParentUSI LEFT OUTER JOIN
                            ParentPortal.ParentProfile AS pro ON p.ParentUniqueId = pro.ParentUniqueId LEFT OUTER JOIN
                            ParentPortal.ChatLog AS cl ON cl.StudentUniqueId = s.StudentUniqueId AND p.ParentUniqueId = cl.SenderUniqueId AND cl.SenderTypeId = 1
    WHERE        (sy.CurrentSchoolYear = TRUE)
    GROUP BY s.StudentUSI, s.StudentUniqueId, s.FirstName, s.MiddleName, s.LastSurname, co.LocalCourseTitle, pro.ReplyExpectations, p.ParentUSI, p.ParentUniqueId, p.FirstName, p.LastSurname, staff.StaffUniqueId, sess.BeginDate, 
                            sess.EndDate, pro.LanguageCode;
end $$   