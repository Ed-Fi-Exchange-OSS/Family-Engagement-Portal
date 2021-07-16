BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
		declare @@StudentUsi int = 13727; --Student Usi
		declare @@ParentUsi int = null;
		
		delete edfi.[Grade] where StudentUSI = @@StudentUsi;
		delete edfi.[StudentGradebookEntry] where StudentUsi = @@StudentUsi;
		delete edfi.[StudentSectionAssociation] where StudentUSI = @@StudentUsi;
		delete edfi.[StudentSchoolAttendanceEvent] where StudentUsi = @@StudentUsi;
		delete edfi.[StudentEducationOrganizationAssociationRace] where StudentUsi = @@StudentUsi;
		delete edfi.[StudentEducationOrganizationAssociationTelephone] where StudentUsi = @@StudentUsi;
		delete edfi.[StudentEducationOrganizationAssociationElectronicMail] where StudentUsi = @@StudentUsi;
		delete edfi.[StudentEducationOrganizationAssociation] where StudentUsi = @@StudentUsi;
		delete edfi.[StudentDisciplineIncidentAssociation] where StudentUsi = @@StudentUsi;
		
		select @@ParentUsi = ParentUsi from edfi.StudentParentAssociation where StudentUSi = @@StudentUsi;
		
		delete edfi.[ParentElectronicMail] where ParentUsi = @@ParentUsi;
		delete edfi.[ParentAddress] where ParentUsi = @@ParentUsi;
		delete edfi.[StudentParentAssociation] where StudentUsi = @@StudentUsi;
		delete edfi.[Parent] where ParentUsi = @@ParentUsi;
		
		delete edfi.[StudentSchoolAssociation] where StudentUsi = @@StudentUsi;
		
		delete edfi.[Student] where StudentUsi = @@StudentUsi;
	COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

		DECLARE @Message nvarchar(2048) = ERROR_MESSAGE();
        DECLARE @Severity integer = ERROR_SEVERITY();
        DECLARE @State integer = ERROR_STATE();

        RAISERROR(@Message, @Severity, @State);
	END CATCH;
END;


