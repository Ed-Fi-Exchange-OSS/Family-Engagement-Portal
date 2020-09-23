-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.


IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'extension')
BEGIN
    EXEC('CREATE SCHEMA [extension] AUTHORIZATION dbo')
END
GO
   
IF EXISTS (SELECT 1 FROM sys.tables WHERE SCHEMA_NAME(schema_id) = 'extension' AND OBJECT_NAME(object_id) = 'StaffBiography')
    DROP TABLE extension.StaffBiography;
   
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE SCHEMA_NAME(schema_id) = 'extension' AND OBJECT_NAME(object_id) = 'StaffBiography')
BEGIN
    CREATE TABLE extension.StaffBiography (
        StaffUniqueId NVARCHAR(32) NOT NULL
        ,ShortBiography NVARCHAR(1000) NULL
        ,Biography NVARCHAR(2000) NULL
        ,FunFact NVARCHAR(500) NULL
        ,CreateDate datetime NOT NULL CONSTRAINT StaffBiography_DF_CreateDate DEFAULT getdate()
        ,LastModifiedDate datetime NOT NULL CONSTRAINT StaffBiography_DF_LastModifiedDate DEFAULT getdate()
		,Id uniqueidentifier NOT NULL CONSTRAINT StaffBiography_DF_Id DEFAULT newid()
        ,CONSTRAINT StaffBiography_PK PRIMARY KEY CLUSTERED (StaffUniqueId ASC)
    )        
END
GO
  
EXEC sys.sp_addextendedproperty 'MS_Description', 'Biography related to the Staff.', 'schema', 'extension', 'table', 'StaffBiography'
GO

/* Parent Biography */
   
IF EXISTS (SELECT 1 FROM sys.tables WHERE SCHEMA_NAME(schema_id) = 'extension' AND OBJECT_NAME(object_id) = 'ParentBiography')
    DROP TABLE extension.ParentBiography;
   
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE SCHEMA_NAME(schema_id) = 'extension' AND OBJECT_NAME(object_id) = 'ParentBiography')
BEGIN
    CREATE TABLE extension.ParentBiography (
        ParentUniqueId NVARCHAR(32) NOT NULL
        ,ShortBiography NVARCHAR(1000) NULL
        ,Biography NVARCHAR(2000) NULL
		,FunFact NVARCHAR(500) NULL
        ,CreateDate datetime NOT NULL CONSTRAINT ParentBiography_DF_CreateDate DEFAULT getdate()
        ,LastModifiedDate datetime NOT NULL CONSTRAINT ParentBiography_DF_LastModifiedDate DEFAULT getdate()
		,Id uniqueidentifier NOT NULL CONSTRAINT ParentBiography_DF_Id DEFAULT newid()
        ,CONSTRAINT ParentBiography_PK PRIMARY KEY CLUSTERED (ParentUniqueId ASC)
    )        
END
GO
  
EXEC sys.sp_addextendedproperty 'MS_Description', 'Biography related to the Parent.', 'schema', 'extension', 'table', 'ParentBiography'
GO

/* On Track to Graduate - Student Academic Record Extension */

IF EXISTS (SELECT 1 FROM sys.tables WHERE SCHEMA_NAME(schema_id) = 'extension' AND OBJECT_NAME(object_id) = 'StudentGraduationReadiness')
    DROP TABLE extension.StudentGraduationReadiness;
   
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE SCHEMA_NAME(schema_id) = 'extension' AND OBJECT_NAME(object_id) = 'StudentGraduationReadiness')
BEGIN
	CREATE TABLE [extension].[StudentGraduationReadiness](
		[StudentUniqueId] [nvarchar](32) NOT NULL
		,[OnTrackToGraduate] [bit] NULL
		,[CreateDate] [datetime] NOT NULL DEFAULT getdate()
		,[LastModifiedDate] [datetime] NOT NULL DEFAULT getdate()
		,[Id] [uniqueidentifier] NOT NULL DEFAULT newid()
	    ,CONSTRAINT [StudentGraduationReadiness_PK] PRIMARY KEY CLUSTERED ([StudentUniqueId] ASC)
	)
END
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A unique alphanumeric code assigned to a student.' , @level0type=N'SCHEMA',@level0name=N'extension', @level1type=N'TABLE',@level1name=N'StudentGraduationReadiness', @level2type=N'COLUMN',@level2name=N'StudentUniqueId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The boolean value indicating if the student is on track to graduate or not.' , @level0type=N'SCHEMA',@level0name=N'extension', @level1type=N'TABLE',@level1name=N'StudentGraduationReadiness', @level2type=N'COLUMN',@level2name=N'OnTrackToGraduate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This educational entity represents the students status regarding graduation.' , @level0type=N'SCHEMA',@level0name=N'extension', @level1type=N'TABLE',@level1name=N'StudentGraduationReadiness'
GO
