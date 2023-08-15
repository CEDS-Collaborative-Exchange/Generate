CREATE PROCEDURE [App].[Migrate_Data_ETL_PRELIMINARY_STEP01_CompletelyClearDataFromODS]
	@SchoolYear SMALLINT = NULL
AS
BEGIN

	BEGIN TRY
	
		set nocount on;

    /*************************************************************************************************************
    Created by:    Duane Brown | duane.brown@aemcorp.com | CIID (https://ciidta.grads360.org/#program)
    Date Created:  12/19/2017

    Purpose:
        The purpose of this ETL is to clean the Generate ODS data store in preparation for
        a new run of the ETL process to populate the Generate ODS. After removing records,
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
      EXEC App.[Migrate_Data_ETL_PRELIMINARY_STEP01_CompletelyClearDataFromODS] 2018;
    
    Modification Log:
      #	  Date		    Developer	  Issue#	 Description
      --  ----------  ----------  -------  --------------------------------------------------------------------
      01		  	 
    *************************************************************************************************************/

	IF @SchoolYear IS NULL BEGIN
		SELECT @SchoolYear = d.Year
		FROM rds.DimDateDataMigrationTypes dd 
		JOIN rds.DimDates d 
			ON dd.DimDateId = d.DimDateId 
		JOIN rds.DimDataMigrationTypes b 
			ON b.DimDataMigrationTypeId = dd.DataMigrationTypeId 
		WHERE dd.IsSelected = 1 
			AND DataMigrationTypeCode = 'ODS'
	END 


        /* REMOVE ALL DATA FROM THE ODS */
          -----------------------------
		ALTER TABLE ODS.Organization NOCHECK CONSTRAINT all


		TRUNCATE TABLE ODS.K12StudentDiscipline
		TRUNCATE TABLE ODS.ProgramParticipationSpecialEducation
		TRUNCATE TABLE ODS.ProgramParticipationTitleIIILEp
		TRUNCATE TABLE ODS.ProgramParticipationMigrant
		TRUNCATE TABLE ODS.ProgramParticipationCte
		TRUNCATE TABLE ODS.ProgramParticipationTitleI
		TRUNCATE TABLE ODS.ProgramParticipationNeglected
		TRUNCATE TABLE ODS.PersonLanguage
		TRUNCATE TABLE ODS.PersonStatus
		TRUNCATE TABLE ODS.PersonIdentifier
		TRUNCATE TABLE ODS.PersonDisability
		TRUNCATE TABLE ODS.PersonDemographicRace
		TRUNCATE TABLE ODS.PersonMilitary
		TRUNCATE TABLE ODS.OrganizationPersonRoleRelationship
		TRUNCATE TABLE ODS.OrganizationRelationship
		TRUNCATE TABLE ODS.OrganizationProgramType
		TRUNCATE TABLE ODS.PersonDetail
		TRUNCATE TABLE ODS.StaffCredential
		TRUNCATE TABLE ODS.K12StudentEnrollment
		TRUNCATE TABLE ODS.AssessmentResult_PerformanceLevel
		TRUNCATE TABLE ODS.AssessmentAdministration_Organization
		TRUNCATE TABLE ODS.K12LeaTitleISupportService
		TRUNCATE TABLE ODS.K12OrganizationStudentResponsibility
		TRUNCATE TABLE ODS.K12StudentCohort
		TRUNCATE TABLE ODS.AeStaff
		TRUNCATE TABLE ODS.PersonEmailAddress
		TRUNCATE TABLE ODS.PersonTelephone
		TRUNCATE TABLE ODS.LocationAddress
		TRUNCATE TABLE ODS.OrganizationLocation
		TRUNCATE TABLE ODS.OrganizationTelephone
		TRUNCATE TABLE ODS.OrganizationWebsite
		TRUNCATE TABLE ODS.OrganizationIndicator
		TRUNCATE TABLE ODS.OrganizationOperationalStatus
		TRUNCATE TABLE ODS.K12ProgramOrService
		TRUNCATE TABLE ODS.K12SchoolStatus
		TRUNCATE TABLE ODS.K12SchoolGradeOffered
		TRUNCATE TABLE ODS.K12SchoolIndicatorStatus
		TRUNCATE TABLE ODS.K12SchoolImprovement
		TRUNCATE TABLE ODS.K12StudentAcademicRecord
		TRUNCATE TABLE ODS.WorkforceProgramParticipation
		TRUNCATE TABLE ODS.ProgramParticipationNeglected
		TRUNCATE TABLE ODS.OrganizationFederalAccountability
		TRUNCATE TABLE ODS.K12LEAFederalFunds
		TRUNCATE TABLE ODS.K12FederalFundAllocation
		TRUNCATE TABLE ODS.K12SchoolImprovement
		TRUNCATE TABLE ODS.WorkforceProgramParticipation
		TRUNCATE TABLE ODS.WorkforceEmploymentQuarterlyData
		TRUNCATE TABLE ODS.K12TitleIIILanguageInstruction
		TRUNCATE TABLE ODS.PersonHomelessness
		TRUNCATE TABLE ODS.OrganizationFinancial
		TRUNCATE TABLE ODS.RoleAttendance
		TRUNCATE TABLE ODS.OrganizationFinancial
		TRUNCATE TABLE ODS.CteStudentAcademicRecord
		TRUNCATE TABLE ODS.PsStudentEnrollment
		TRUNCATE TABLE ODS.OrganizationIdentifier


		DELETE FROM ODS.K12Sea
		DELETE FROM ODS.OrganizationDetail WHERE OrganizationId <> 0 
		DBCC CHECKIDENT('ODS.OrganizationDetail', RESEED, 1);
		DELETE FROM ODS.OrganizationCalendarSession --Cannot truncate as it is referenced by foreign key constraint
		DBCC CHECKIDENT('ODS.OrganizationCalendarSession', RESEED, 1);
		DELETE FROM ODS.OrganizationCalendar --Cannot truncate as it is referenced by foreign key constraint
		DBCC CHECKIDENT('ODS.OrganizationCalendar', RESEED, 1);
		DELETE FROM ODS.K12Lea --Cannot truncate as it is referenced by foreign key constraint
		DELETE FROM ODS.K12School --Cannot truncate as it is referenced by foreign key constraint
		DBCC CHECKIDENT('ODS.K12School', RESEED, 1);
		DELETE FROM ODS.K12CharterSchoolAuthorizer
		DBCC CHECKIDENT('ODS.K12CharterSchoolAuthorizer', RESEED, 1);
		DELETE FROM ODS.K12CharterSchoolManagementOrganization
		DBCC CHECKIDENT('ODS.K12CharterSchoolManagementOrganization', RESEED, 1);
		DELETE FROM ODS.Incident --Cannot truncate as it is referenced by foreign key constraint
		DBCC CHECKIDENT('ODS.Incident', RESEED, 1);
		DELETE FROM ODS.StaffEmployment --Cannot truncate as it is referenced by foreign key constraint
		DBCC CHECKIDENT('ODS.StaffEmployment', RESEED, 1);
		DELETE FROM ODS.ProgramParticipationNeglectedProgressLevel --Cannot truncate as it is referenced by foreign key constraint
		DBCC CHECKIDENT('ODS.ProgramParticipationNeglectedProgressLevel', RESEED, 1);
		DELETE FROM ODS.PersonProgramParticipation --Cannot truncate as it is referenced by foreign key constraint
		DBCC CHECKIDENT('ODS.PersonProgramParticipation', RESEED, 1);
		DELETE FROM ODS.AssessmentResult
		DBCC CHECKIDENT('ODS.AssessmentResult', RESEED, 1);
		DELETE FROM ODS.AssessmentPerformanceLevel
		DBCC CHECKIDENT('ODS.AssessmentPerformanceLevel', RESEED, 1);
		DELETE FROM ODS.AssessmentRegistration
		DBCC CHECKIDENT('ODS.AssessmentRegistration', RESEED, 1);
		DELETE FROM ODS.AssessmentAdministration
		DBCC CHECKIDENT('ODS.AssessmentAdministration', RESEED, 1);
		DELETE FROM ODS.AssessmentSubtest
		DBCC CHECKIDENT('ODS.AssessmentSubtest', RESEED, 1);
		DELETE FROM ODS.AssessmentForm
		DBCC CHECKIDENT('ODS.AssessmentForm', RESEED, 1);
		DELETE FROM ODS.Assessment
		DBCC CHECKIDENT('ODS.Assessment', RESEED, 1);
		DELETE FROM  ODS.OrganizationPersonRole --Cannot truncate as it is referenced by foreign key constraint
		DBCC CHECKIDENT('ODS.OrganizationPersonRole', RESEED, 1);
		DELETE FROM  ODS.K12StaffAssignment --Cannot truncate as it is referenced by foreign key constraint
		DBCC CHECKIDENT('ODS.K12StaffAssignment', RESEED, 1);
		DELETE FROM  ODS.PersonCredential --Cannot truncate as it is referenced by foreign key constraint
		DBCC CHECKIDENT('ODS.PersonCredential', RESEED, 1);
		DELETE FROM ODS.Person --Cannot truncate as it is referenced by foreign key constraint
		DBCC CHECKIDENT('ODS.Person', RESEED, 1);
		DELETE FROM ODS.[Course] --Cannot trucnate and add record back int because it is referenced by a foreign Key constraint.
		DELETE FROM ODS.Organization WHERE OrganizationId NOT IN (0, 1) --Cannot trucnate and add record back int because it is referenced by a foreign Key constraint.
		DBCC CHECKIDENT('ODS.Organization', RESEED, 1);
		DELETE FROM ODS.[Location] --Cannot trucnate and add record back int because it is referenced by a foreign Key constraint.
		DBCC CHECKIDENT('ODS.Location', RESEED, 1);
		DELETE FROM ODS.[OrganizationCalendarSession] --Cannot trucnate and add record back int because it is referenced by a foreign Key constraint.
		DBCC CHECKIDENT('ODS.OrganizationCalendarSession', RESEED, 1);
		DELETE FROM ODS.[FinancialAccount] --Cannot trucnate and add record back int because it is referenced by a foreign Key constraint.
		DBCC CHECKIDENT('ODS.FinancialAccount', RESEED, 1);
		DELETE FROM ODS.[OrganizationCalendar] --Cannot trucnate and add record back int because it is referenced by a foreign Key constraint.
		DBCC CHECKIDENT('ODS.OrganizationCalendar', RESEED, 1);

		ALTER TABLE ODS.Organization WITH CHECK CHECK CONSTRAINT all


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



