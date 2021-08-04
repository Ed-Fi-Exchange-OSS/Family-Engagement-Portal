DO $$
BEGIN

    /* working without alters o drops */

    CREATE SCHEMA IF NOT EXISTS Extension;
    
    ALTER TABLE Extension.StaffBiography ALTER COLUMN FK_StaffBiography_StaffUniqueId DROP NOT NULL;
    
    -- IF EXISTS (SELECT 1 FROM sys.tables WHERE SCHEMA_NAME(schema_id) = 'extension' AND OBJECT_NAME(object_id) = 'StaffBiography')
    --    DROP TABLE extension.StaffBiography;
    
    DROP TABLE IF EXISTS Extension.StaffBiography; -- throws issue

    CREATE TABLE IF NOT EXISTS Extension.StaffBiography(
        StaffUniqueId VARCHAR(32) PRIMARY KEY,
        ShortBiography VARCHAR(1000) NULL,
        Biography VARCHAR(2000) NULL,
        FunFact VARCHAR(500) NULL,
        CreateDate timestamp NOT NULL CONSTRAINT StaffBiography_DF_CreateDate DEFAULT (now() AT time zone 'utc'),
        LastModifiedDate timestamp NOT NULL CONSTRAINT StaffBiography_DF_LastModifiedDate DEFAULT (now() AT time zone 'utc'),
        Id uuid NOT NULL,
        CONSTRAINT FK_StaffBiography_StaffUniqueId FOREIGN KEY (StaffUniqueId) REFERENCES edfi.Staff (StaffUniqueId)
    );

    ALTER TABLE Extension.ParentBiography ALTER COLUMN FK_ParentBiography_ParentUniqueId DROP NOT NULL;

    CREATE TABLE IF NOT EXISTS Extension.ParentBiography(
        ParentUniqueId VARCHAR(32) PRIMARY KEY,
        ShortBiography VARCHAR(1000) NOT NULL,
        Biography VARCHAR(2000) NULL,
        FunFact VARCHAR(500) NULL,
        CreateDate timestamp NOT NULL CONSTRAINT ParentBiography_DF_CreateDate DEFAULT (now() AT time zone 'utc'),
        LastModifiedDate timestamp NOT NULL CONSTRAINT ParentBiography_DF_LastModifiedDate DEFAULT (now() AT time zone 'utc'),
        Id uuid NOT NULL CONSTRAINT ParentBiography_DF_Id DEFAULT uuid_generate_v4(),
        CONSTRAINT FK_ParentBiography_ParentUniqueId FOREIGN KEY (ParentUniqueId) REFERENCES edfi.Parent (ParentUniqueId)
    );

    ALTER TABLE IF EXISTS Extension.StudentGraduationReadiness ALTER COLUMN FK_StudentGraduationReadiness_StudentAcademicRecord DROP NOT NULL; -- throws issue

    ALTER TABLE IF EXISTS Extension.StudentGraduationReadiness ALTER COLUMN FK_StudentGraduationReadiness_Student DROP NOT NULL; -- throws issue

    DROP TABLE IF EXISTS Extension.StudentGraduationReadiness;

    CREATE TABLE IF NOT EXISTS Extension.StudentGraduationReadiness(
        StudentUniqueId VARCHAR(32) PRIMARY KEY,
        OnTrackToGraduate boolean NULL,
        CreateDate timestamp NOT NULL DEFAULT (now() AT time zone 'utc'),
        LastModifiedDate timestamp NOT NULL DEFAULT (now() AT time zone 'utc'),
        Id uuid NOT NULL DEFAULT uuid_generate_v4(),
        CONSTRAINT FK_StudentGraduationReadiness_Student FOREIGN KEY (StudentUniqueId) REFERENCES edfi.Student(StudentUniqueId) ON DELETE CASCADE
    );
END $$