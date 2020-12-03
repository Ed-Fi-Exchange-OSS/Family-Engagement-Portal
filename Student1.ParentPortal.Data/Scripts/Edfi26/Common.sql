/****** Script for Joining All People on the Ed-Fi ODS  ******/
-- =============================================
-- Author: Douglas Loyo
-- Create date:  November 8, 2019
-- Description: This view joins Staff, Student and Parent into one resultset so that we can have a unified person object.
-- ODS Version: v3.x
-- =============================================
IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'common')) 
BEGIN
    EXEC ('CREATE SCHEMA [common] AUTHORIZATION [dbo]')
END

DROP VIEW IF EXISTS common.People;
GO

CREATE VIEW common.People AS
(SELECT s.StaffUSI USI, StaffUniqueId UniqueId, FirstName, LastSurname, ElectronicMailAddress, 'Staff' PersonType, PositionTitle
FROM edfi.Staff s
INNER JOIN edfi.StaffElectronicMail se on s.StaffUSI = se.StaffUSI
INNER JOIN edfi.StaffEducationOrganizationAssignmentAssociation seoaa on s.StaffUSI = seoaa.StaffUSI)
UNION
(SELECT p.ParentUSI USI, ParentUniqueId UniqueId, FirstName, LastSurname, ElectronicMailAddress, 'Parent' PersonType, rt.CodeValue PositionTitle
FROM edfi.Parent p
inner join edfi.ParentElectronicMail pe on p.ParentUSI = pe.ParentUSI
inner join edfi.StudentParentAssociation spa on p.ParentUSI = spa.ParentUSI
inner join edfi.RelationType rt on spa.RelationTypeId = rt.RelationTypeId)
UNION 
(SELECT s.StudentUSI USI, StudentUniqueId UniqueId, FirstName, LastSurname, ElectronicMailAddress, 'Student' PersonType, 'Student' PositionTitle
FROM edfi.Student s
INNER JOIN edfi.StudentElectronicMail se on s.StudentUSI = se.StudentUSI)