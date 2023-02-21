CREATE PROCEDURE [Staging].[Migrate_StagingToIDS_CompletelyClearDataFromODS]
	@SchoolYear SMALLINT = NULL
AS
BEGIN

	BEGIN TRY
	
		set nocount on;

    /*************************************************************************************************************
    Created by:    Duane Brown | duane.brown@aemcorp.com | CIID (https://ciidta.grads360.org/#program)
    Date Created:  12/19/2017

    Purpose:
        The purpose of this ETL is to clean the Generate IDS data store in preparation for
        a new run of the ETL process to populate the Generate IDS. After removing records,
        all tables will be reseeded.

    Assumptions:
        None

    Account executed under: LOGIN

    Approximate run time:  ~ 45 seconds

    Data Sources:  N/A

    Data Targets:  Generate Database: Generate

    Return Values:
    	 0	= Success
       All Errors are Thrown via Try/Catch Block	
  
    Example Usage: 
      EXEC Staging.[Migrate_StagingToIDS_CompletelyClearDataFromODS] 2018;
    
    Modification Log:
      #	  Date		    Developer	  Issue#	 Description
      --  ----------  ----------  -------  --------------------------------------------------------------------
      01		  	 
    *************************************************************************************************************/

	IF @SchoolYear IS NULL BEGIN
		SELECT @SchoolYear = d.SchoolYear
			FROM rds.DimSchoolYearDataMigrationTypes dd 
			JOIN rds.DimSchoolYears d 
				ON dd.DimSchoolYearId = d.DimSchoolYearId 
			JOIN rds.DimDataMigrationTypes b 
				ON b.DimDataMigrationTypeId = dd.DataMigrationTypeId 
			WHERE dd.IsSelected = 1 
				AND DataMigrationTypeCode = 'ODS'
	END 


        /* REMOVE ALL DATA FROM THE ODS */
          -----------------------------
		ALTER TABLE dbo.Organization NOCHECK CONSTRAINT all
		ALTER TABLE dbo.OrganizationPersonRole NOCHECK CONSTRAINT all

		
		TRUNCATE TABLE dbo.K12StudentDiscipline
		TRUNCATE TABLE dbo.ProgramParticipationSpecialEducation
		TRUNCATE TABLE dbo.ProgramParticipationTitleIIILEp
		TRUNCATE TABLE dbo.ProgramParticipationMigrant
		TRUNCATE TABLE dbo.ProgramParticipationCte
		TRUNCATE TABLE dbo.ProgramParticipationTitleI
		TRUNCATE TABLE dbo.ProgramParticipationNeglected
		TRUNCATE TABLE dbo.PersonLanguage
		TRUNCATE TABLE dbo.PersonStatus
		TRUNCATE TABLE dbo.PersonIdentifier
		TRUNCATE TABLE dbo.PersonDisability
		TRUNCATE TABLE dbo.PersonDemographicRace
		TRUNCATE TABLE dbo.PersonMilitary
		TRUNCATE TABLE dbo.OrganizationPersonRoleRelationship
		TRUNCATE TABLE dbo.OrganizationRelationship
		TRUNCATE TABLE dbo.OrganizationProgramType
		TRUNCATE TABLE dbo.PersonDetail
		TRUNCATE TABLE dbo.StaffCredential
		TRUNCATE TABLE dbo.K12StudentEnrollment
		TRUNCATE TABLE dbo.AssessmentResult_PerformanceLevel
		TRUNCATE TABLE dbo.AssessmentAdministration_Organization
		TRUNCATE TABLE dbo.K12LeaTitleISupportService
		TRUNCATE TABLE dbo.K12OrganizationStudentResponsibility
		TRUNCATE TABLE dbo.K12StudentCohort
		TRUNCATE TABLE dbo.AeStaff
		TRUNCATE TABLE dbo.PersonEmailAddress
		TRUNCATE TABLE dbo.PersonTelephone
		TRUNCATE TABLE dbo.LocationAddress
		TRUNCATE TABLE dbo.OrganizationLocation
		TRUNCATE TABLE dbo.OrganizationTelephone
		TRUNCATE TABLE dbo.OrganizationWebsite
		TRUNCATE TABLE dbo.OrganizationIndicator
		TRUNCATE TABLE dbo.OrganizationOperationalStatus
		TRUNCATE TABLE dbo.K12ProgramOrService
		TRUNCATE TABLE dbo.K12SchoolStatus
		TRUNCATE TABLE dbo.K12SchoolGradeOffered
		TRUNCATE TABLE dbo.K12SchoolIndicatorStatus
		TRUNCATE TABLE dbo.K12SchoolImprovement
		TRUNCATE TABLE dbo.K12StudentAcademicRecord
		TRUNCATE TABLE dbo.WorkforceProgramParticipation
		TRUNCATE TABLE dbo.ProgramParticipationNeglected
		TRUNCATE TABLE dbo.OrganizationFederalAccountability
		TRUNCATE TABLE dbo.K12LEAFederalFunds
		TRUNCATE TABLE dbo.K12FederalFundAllocation
		TRUNCATE TABLE dbo.K12SchoolImprovement
		TRUNCATE TABLE dbo.WorkforceProgramParticipation
		TRUNCATE TABLE dbo.WorkforceEmploymentQuarterlyData
		TRUNCATE TABLE dbo.K12TitleIIILanguageInstruction
		TRUNCATE TABLE dbo.PersonHomelessness
		TRUNCATE TABLE dbo.RoleAttendance
		TRUNCATE TABLE dbo.CteStudentAcademicRecord
		TRUNCATE TABLE dbo.PsStudentEnrollment
		TRUNCATE TABLE dbo.OrganizationIdentifier


		DELETE FROM dbo.K12Sea
		DELETE FROM dbo.OrganizationDetail WHERE OrganizationId <> 0 
		DBCC CHECKIDENT('dbo.OrganizationDetail', RESEED, 1);
		DELETE FROM dbo.OrganizationCalendarSession --Cannot truncate as it is referenced by foreign key constraint
		DBCC CHECKIDENT('dbo.OrganizationCalendarSession', RESEED, 1);
		DELETE FROM dbo.OrganizationCalendar --Cannot truncate as it is referenced by foreign key constraint
		DBCC CHECKIDENT('dbo.OrganizationCalendar', RESEED, 1);
		DELETE FROM dbo.K12Lea --Cannot truncate as it is referenced by foreign key constraint
		DELETE FROM dbo.K12School --Cannot truncate as it is referenced by foreign key constraint
		DBCC CHECKIDENT('dbo.K12School', RESEED, 1);
		DELETE FROM dbo.K12CharterSchoolAuthorizer
		DBCC CHECKIDENT('dbo.K12CharterSchoolAuthorizer', RESEED, 1);
		DELETE FROM dbo.K12CharterSchoolManagementOrganization
		DBCC CHECKIDENT('dbo.K12CharterSchoolManagementOrganization', RESEED, 1);
		DELETE FROM dbo.Incident --Cannot truncate as it is referenced by foreign key constraint
		DBCC CHECKIDENT('dbo.Incident', RESEED, 1);
		DELETE FROM dbo.StaffEmployment --Cannot truncate as it is referenced by foreign key constraint
		DBCC CHECKIDENT('dbo.StaffEmployment', RESEED, 1);
		DELETE FROM dbo.ProgramParticipationNeglectedProgressLevel --Cannot truncate as it is referenced by foreign key constraint
		DBCC CHECKIDENT('dbo.ProgramParticipationNeglectedProgressLevel', RESEED, 1);
		DELETE FROM dbo.PersonProgramParticipation --Cannot truncate as it is referenced by foreign key constraint
		DBCC CHECKIDENT('dbo.PersonProgramParticipation', RESEED, 1);
		DELETE FROM dbo.AssessmentResult
		DBCC CHECKIDENT('dbo.AssessmentResult', RESEED, 1);
		DELETE FROM dbo.AssessmentPerformanceLevel
		DBCC CHECKIDENT('dbo.AssessmentPerformanceLevel', RESEED, 1);
		DELETE FROM dbo.AssessmentRegistration
		DBCC CHECKIDENT('dbo.AssessmentRegistration', RESEED, 1);
		DELETE FROM dbo.AssessmentAdministration
		DBCC CHECKIDENT('dbo.AssessmentAdministration', RESEED, 1);
		DELETE FROM dbo.AssessmentSubtest
		DBCC CHECKIDENT('dbo.AssessmentSubtest', RESEED, 1);
		DELETE FROM dbo.AssessmentForm
		DBCC CHECKIDENT('dbo.AssessmentForm', RESEED, 1);
		DELETE FROM dbo.Assessment
		DBCC CHECKIDENT('dbo.Assessment', RESEED, 1);
		DELETE FROM  dbo.K12StaffAssignment --Cannot truncate as it is referenced by foreign key constraint
		DBCC CHECKIDENT('dbo.K12StaffAssignment', RESEED, 1);
		DELETE FROM dbo.K12StudentCohort
		DBCC CHECKIDENT('dbo.K12StudentCohort', RESEED, 1);
		DELETE FROM  dbo.PersonCredential --Cannot truncate as it is referenced by foreign key constraint
		DBCC CHECKIDENT('dbo.PersonCredential', RESEED, 1);
		DELETE FROM dbo.[Course] --Cannot trucnate and add record back int because it is referenced by a foreign Key constraint.
		DBCC CHECKIDENT('dbo.Course', RESEED, 1);
		DELETE FROM dbo.[Location] --Cannot trucnate and add record back int because it is referenced by a foreign Key constraint.
		DBCC CHECKIDENT('dbo.Location', RESEED, 1);
		DELETE FROM dbo.[OrganizationCalendarSession] --Cannot trucnate and add record back int because it is referenced by a foreign Key constraint.
		DBCC CHECKIDENT('dbo.OrganizationCalendarSession', RESEED, 1);
		DELETE FROM dbo.[FinancialAccount] --Cannot trucnate and add record back int because it is referenced by a foreign Key constraint.
		DBCC CHECKIDENT('dbo.FinancialAccount', RESEED, 1);
		DELETE FROM dbo.[OrganizationCalendar] --Cannot trucnate and add record back int because it is referenced by a foreign Key constraint.
		DBCC CHECKIDENT('dbo.OrganizationCalendar', RESEED, 1);
		DELETE FROM  dbo.OrganizationPersonRoleRelationship 
		DBCC CHECKIDENT('dbo.OrganizationPersonRoleRelationship', RESEED, 1);
		DELETE FROM dbo.K12Course
		DBCC CHECKIDENT('dbo.K12Course', RESEED, 1);
		--DELETE FROM dbo.MiPsStudentAcademicRecord
		--DBCC CHECKIDENT('dbo.MiPsStudentAcademicRecord', RESEED, 1);
		DELETE FROM dbo.PsStudentAcademicRecord
		DBCC CHECKIDENT('dbo.PsStudentAcademicRecord', RESEED, 1);
		DELETE FROM dbo.PsInstitution
		DBCC CHECKIDENT('dbo.PsInstitution', RESEED, 1);
		DELETE FROM  dbo.OrganizationFinancial 
		DBCC CHECKIDENT('dbo.OrganizationFinancial', RESEED, 1);

		DECLARE @Deleted_Rows INT;
		SET @Deleted_Rows = 1;
		ALTER TABLE dbo.OrganizationPersonRole NOCHECK CONSTRAINT all
		WHILE (@Deleted_Rows > 0)
		BEGIN
		   BEGIN TRANSACTION
			-- Delete some small number of rows at a time
			DELETE TOP (10000000)  dbo.OrganizationPersonRole 
			SET @Deleted_Rows = @@ROWCOUNT;
		   COMMIT TRANSACTION
		   CHECKPOINT -- for simple recovery model
		END
		DBCC CHECKIDENT('dbo.OrganizationPersonRole', RESEED, 1);

		DELETE FROM dbo.Person --Cannot truncate AS it IS referenced by foreign key constraint
		DBCC CHECKIDENT('dbo.Person', RESEED, 1);
		DELETE FROM dbo.Organization WHERE OrganizationId NOT IN (0, 1) --Cannot trucnate AND add record back INT because it IS referenced by a foreign Key constraint.
		DBCC CHECKIDENT('dbo.Organization', RESEED, 1);

		ALTER TABLE dbo.OrganizationPersonRole WITH CHECK CHECK CONSTRAINT all
		ALTER TABLE dbo.Organization WITH CHECK CHECK CONSTRAINT all


		RETURN 0;

		set nocount off;


	END TRY
	BEGIN CATCH

		declare @msg as nvarchar(max)
		set @msg = ERROR_MESSAGE()

		declare @sev as int
		set @sev = ERROR_SEVERITY()

		RAISERROR(@msg, @sev, 1)

	END CATCH; 

END
