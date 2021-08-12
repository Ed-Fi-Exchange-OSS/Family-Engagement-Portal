DO $$
BEGIN

    /* working without alters o drops */

    CREATE SCHEMA IF NOT EXISTS Extension;

    ALTER TABLE IF EXISTS Extension.StaffBiography DROP CONSTRAINT IF EXISTS FK_StaffBiography_StaffUniqueId;

    DROP TABLE IF EXISTS Extension.StaffBiography;

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

    ALTER TABLE IF EXISTS Extension.ParentBiography DROP CONSTRAINT IF EXISTS FK_ParentBiography_ParentUniqueId;

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

    ALTER TABLE IF EXISTS Extension.StudentGraduationReadiness DROP CONSTRAINT IF EXISTS FK_StudentGraduationReadiness_StudentAcademicRecord;

    ALTER TABLE IF EXISTS Extension.StudentGraduationReadiness DROP CONSTRAINT IF EXISTS FK_StudentGraduationReadiness_Student;

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