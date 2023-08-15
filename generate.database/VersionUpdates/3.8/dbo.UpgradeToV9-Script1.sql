/*    

	Copyright 2021 Common Education Data Standards
	
	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at
	
	    http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language verning permissions and
	limitations under the License.

	
	Common Education Data Standards (CEDS)
    Version 9
    Integration Data Schema (IDS)
    
	Model database update script
	
    This script updates a IDS version 8 model database to version 9.  
    

    WARNING!!!!
    This script is intended for use on a model database and should not 
    be used on a database that contains data.
    
    This script contains potentially breaking changes.  Queries are included to preserve data.  
	However, programming logic should be adjusted were necessary for these changes.

    Search for "WARNING!!!!" through this update script to see said changes and make necessary adjustments before executing.


    The script was generated from a model database 
    hosted on a Microsoft SQL Server 2012 platform.  
    
    Questions on this script can be sent to ceds@ed.v
    
	More information on the data model is available at the CEDS website,  
	http://ceds.ed.v, and the CEDS Open Source Community (OSC) site, 
	https://github.com/CEDStandards/CEDS-IDS.  
      	  
*/ 

DECLARE @sql nvarchar(max)

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'CompetencySet_Rubric' )
BEGIN

PRINT N'V8-to-V8_1 upgrade'

/*

    WARNING!!!!
    V8_1 update fixes the following bugs found in the V8 upgrade and ddl scripts

	- DECIMAL AND NUMERIC precision and scale missing during DROP and CREATE for columns in the following tables.  
		As a result, these columns defaulted to (18,0), effectively removing any decimals in data stored in them
			AeStaff
			ApipInteraction
			BuildingSpaceUtilization
			CompetencyDefAssociation
			CompetencyDefinition
			Course
			CourseSection
			CredentialDefinition
			CteCourse
			CteStudentAcademicRecord
			ELClassSection
			ELEnrollment
			ELOrganizationAvailability
			ELStaffEducation
			ELStaffEmployment
			FacilityUtilization
			K12Course
			K12LeaFederalFunds
			K12LeaFederalReporting
			K12SeaFederalFunds
			K12StaffEmployment
			K12StudentAcademicRecord
			K12StudentActivity
			K12StudentCourseSection
			K12StudentGraduationPlan
			Program
			PsPriceOfAttendance
			PsStaffEmployment
			PsStudentApplication
			PsStudentFinancialAid
			PsStudentSection
			StaffExperience
			WorkforceEmploymentQuarterlyData
			RefCompetencyDefAssociationType
			RefCompetencyDefNodeAccessibilityProfile
			RefCompetencyDefTestabilityType
			RefCredentialDefAssessMethodType
			RefCredentialDefIntendedPurposeType
			RefCredentialDefStatusType
			RefCredentialDefVerificationType
	
	NOTE: Non-breaking changes for the following bugs found in the V8 upgrade and ddl scripts upgrade.
	- Restoring UPDATE and DELETE CASCADE to FKs missing after DROP and CREATE in V8
	- Recreating INDEX missing after DROP and CREATE in V8
	- Adding FK to Organization table missing from new Ref tables in V8

*/

PRINT N'--Drop FK and Unique statements'

PRINT N'Dropping [dbo].[FK_CourseSection_Organization]...';



ALTER TABLE [dbo].[CourseSection] DROP CONSTRAINT [FK_CourseSection_Organization];




PRINT N'Dropping [dbo].[FK_EcProgramEnrollment_OrganizationPerson]...';



ALTER TABLE [dbo].[ELEnrollment] DROP CONSTRAINT [FK_EcProgramEnrollment_OrganizationPerson];




PRINT N'Dropping [dbo].[FK_K12Lea_Organization]...';



ALTER TABLE [dbo].[K12Lea] DROP CONSTRAINT [FK_K12Lea_Organization];




PRINT N'Dropping [dbo].[FK_K12Sea_Organization]...';



ALTER TABLE [dbo].[K12Sea] DROP CONSTRAINT [FK_K12Sea_Organization];




PRINT N'Dropping [dbo].[FK_K12StudentAcademicRecord_OrganizationPerson]...';



ALTER TABLE [dbo].[K12StudentAcademicRecord] DROP CONSTRAINT [FK_K12StudentAcademicRecord_OrganizationPerson];




PRINT N'Dropping [dbo].[FK_K12StudentCourseSection_OrganizationPerson]...';



ALTER TABLE [dbo].[K12StudentCourseSection] DROP CONSTRAINT [FK_K12StudentCourseSection_OrganizationPerson];




PRINT N'Dropping [dbo].[FK_LocationAddress_Location]...';



ALTER TABLE [dbo].[LocationAddress] DROP CONSTRAINT [FK_LocationAddress_Location];




PRINT N'Dropping [dbo].[FK_PsInstitution_Organization]...';



ALTER TABLE [dbo].[PsInstitution] DROP CONSTRAINT [FK_PsInstitution_Organization];

--ALTER TABLE [dbo].[RefCharterSchoolAuthorizerType] DROP CONSTRAINT [FK_RefCharterSchoolAuthorizerType_Organization]

ALTER TABLE [dbo].[K12CharterSchoolAuthorizer] DROP CONSTRAINT [FK_K12CharterSchoolAuthorizer_Organization]





PRINT N'--Drop and Create or Alter existing table statements'

PRINT N'Altering [dbo].[PsStaffEmployment]...';



ALTER TABLE [dbo].[PsStaffEmployment]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for AnnualBaseContractualSalary, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[AnnualBaseContractualSalary]                       DECIMAL(9, 2)             NULL;




PRINT N'Altering [dbo].[AeStaff]...';



ALTER TABLE [dbo].[AeStaff]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for YearsOfPriorAeTeachingExperience, data type has changed from DECIMAL(18, 0) to DECIMAL(4, 2)
	[YearsOfPriorAeTeachingExperience]                       DECIMAL(4, 2)             NULL;




PRINT N'Altering [dbo].[ApipInteraction]...';



ALTER TABLE [dbo].[ApipInteraction]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for APIPInteractionSequenceNumber, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[APIPInteractionSequenceNumber]                       DECIMAL(9, 2)             NULL;




PRINT N'Altering [dbo].[BuildingSpaceUtilization]...';



ALTER TABLE [dbo].[BuildingSpaceUtilization]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for BuildingSpaceUtilizationArea, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[BuildingSpaceUtilizationArea]                       DECIMAL(9, 2)             NULL;




PRINT N'Altering [dbo].[CompetencyDefAssociation]...';



ALTER TABLE [dbo].[CompetencyDefAssociation]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for Weight, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 3)
	[Weight]                       DECIMAL(9, 3)             NULL;




PRINT N'Altering [dbo].[CompetencyDefinition]...';



ALTER TABLE [dbo].[CompetencyDefinition]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for TextComplexityMinimumValue, data type has changed from DECIMAL(18, 0) to DECIMAL(18, 4)
	[TextComplexityMinimumValue]                       DECIMAL(18, 4)             NULL;



ALTER TABLE [dbo].[CompetencyDefinition]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for TextComplexityMaximumValue, data type has changed from DECIMAL(18, 0) to DECIMAL(18, 4)
	[TextComplexityMaximumValue]                       DECIMAL(18, 4)             NULL;




PRINT N'Altering [dbo].[Course]...';



ALTER TABLE [dbo].[Course]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for CreditValue, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[CreditValue]                       DECIMAL(9, 2)             NULL;




PRINT N'Altering [dbo].[CourseSection]...';



ALTER TABLE [dbo].[CourseSection]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for AvailableCarnegieUnitCredit, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[AvailableCarnegieUnitCredit]                       DECIMAL(9, 2)             NULL;



ALTER TABLE [dbo].[CourseSection]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for TimeRequiredForCompletion, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 0)
	[TimeRequiredForCompletion]                       DECIMAL(9, 0)             NULL;




PRINT N'Altering [dbo].[CredentialDefinition]...';



ALTER TABLE [dbo].[CredentialDefinition]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for Version, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[Version]                       DECIMAL(9, 2)             NULL;




PRINT N'Altering [dbo].[CteCourse]...';



ALTER TABLE [dbo].[CteCourse]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for AvailableCarnegieUnitCredit, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[AvailableCarnegieUnitCredit]                       DECIMAL(9, 2)             NULL;




PRINT N'Altering [dbo].[CteStudentAcademicRecord]...';



ALTER TABLE [dbo].[CteStudentAcademicRecord]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for CreditsAttemptedCumulative, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[CreditsAttemptedCumulative]                       DECIMAL(9, 2)             NULL;



ALTER TABLE [dbo].[CteStudentAcademicRecord]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for CreditsEarnedCumulative, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[CreditsEarnedCumulative]                       DECIMAL(9, 2)             NULL;




PRINT N'Altering [dbo].[ELClassSection]...';



ALTER TABLE [dbo].[ELClassSection]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for HoursAvailablePerDay, data type has changed from DECIMAL(18, 0) to DECIMAL(4, 2)
	[HoursAvailablePerDay]                       DECIMAL(4, 2)             NULL;




PRINT N'Altering [dbo].[ELEnrollment]...';



ALTER TABLE [dbo].[ELEnrollment]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for NumberOfDaysInAttendance, data type has changed from DECIMAL(18, 0) to DECIMAL(8, 2)
	[NumberOfDaysInAttendance]                       DECIMAL(8, 2)             NULL;




PRINT N'Altering [dbo].[ELOrganizationAvailability]...';



ALTER TABLE [dbo].[ELOrganizationAvailability]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for HoursAvailablePerDay, data type has changed from DECIMAL(18, 0) to DECIMAL(5, 2)
	[HoursAvailablePerDay]                       DECIMAL(5, 2)             NULL;




PRINT N'Altering [dbo].[ELStaffEducation]...';



ALTER TABLE [dbo].[ELStaffEducation]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for TotalCollegeCreditsEarned, data type has changed from DECIMAL(18, 0) to DECIMAL(10, 2)
	[TotalCollegeCreditsEarned]                       DECIMAL(10, 2)             NULL;



ALTER TABLE [dbo].[ELStaffEducation]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for TotalApprovedECCreditsEarned, data type has changed from DECIMAL(18, 0) to DECIMAL(10, 2)
	[TotalApprovedECCreditsEarned]                       DECIMAL(10, 2)             NULL;



ALTER TABLE [dbo].[ELStaffEducation]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for SchoolAgeEducationPSCredits, data type has changed from DECIMAL(18, 0) to DECIMAL(10, 2)
	[SchoolAgeEducationPSCredits]                       DECIMAL(10, 2)             NULL;




PRINT N'Altering [dbo].[ELStaffEmployment]...';



ALTER TABLE [dbo].[ELStaffEmployment]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for HoursWorkedPerWeek, data type has changed from DECIMAL(18, 0) to DECIMAL(5, 2)
	[HoursWorkedPerWeek]                       DECIMAL(5, 2)             NULL;



ALTER TABLE [dbo].[ELStaffEmployment]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for HourlyWage, data type has changed from DECIMAL(18, 0) to DECIMAL(5, 2)
	[HourlyWage]                       DECIMAL(5, 2)             NULL;




PRINT N'Altering [dbo].[FacilityUtilization]...';



ALTER TABLE [dbo].[FacilityUtilization]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for BuildingNetAreaOfInstructionalSpace, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[BuildingNetAreaOfInstructionalSpace]                       DECIMAL(9, 2)             NULL;




PRINT N'Altering [dbo].[K12Course]...';



ALTER TABLE [dbo].[K12Course]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for AvailableCarnegieUnitCredit, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[AvailableCarnegieUnitCredit]                       DECIMAL(9, 2)             NULL;




PRINT N'Altering [dbo].[K12LeaFederalFunds]...';



ALTER TABLE [dbo].[K12LeaFederalFunds]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for InnovativeProgramsFundsReceived, data type has changed from NUMERIC(18, 0) to NUMERIC(12, 2)
	[InnovativeProgramsFundsReceived]                       NUMERIC(12, 2)             NULL;



ALTER TABLE [dbo].[K12LeaFederalFunds]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for InnovativeDollarsSpent, data type has changed from NUMERIC(18, 0) to NUMERIC(12, 2)
	[InnovativeDollarsSpent]                       NUMERIC(12, 2)             NULL;



ALTER TABLE [dbo].[K12LeaFederalFunds]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for InnovativeDollarsSpentOnStrategicPriorities, data type has changed from NUMERIC(18, 0) to NUMERIC(12, 2)
	[InnovativeDollarsSpentOnStrategicPriorities]                       NUMERIC(12, 2)             NULL;



ALTER TABLE [dbo].[K12LeaFederalFunds]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for PublicSchoolChoiceFundsSpent, data type has changed from NUMERIC(18, 0) to NUMERIC(12, 2)
	[PublicSchoolChoiceFundsSpent]                       NUMERIC(12, 2)             NULL;



ALTER TABLE [dbo].[K12LeaFederalFunds]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for SesFundsSpent, data type has changed from NUMERIC(18, 0) to NUMERIC(12, 2)
	[SesFundsSpent]                       NUMERIC(12, 2)             NULL;



ALTER TABLE [dbo].[K12LeaFederalFunds]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for SesSchoolChoice20PercentObligation, data type has changed from NUMERIC(18, 0) to NUMERIC(12, 2)
	[SesSchoolChoice20PercentObligation]                       NUMERIC(12, 2)             NULL;



ALTER TABLE [dbo].[K12LeaFederalFunds]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for ParentalInvolvementReservationFunds, data type has changed from NUMERIC(18, 0) to NUMERIC(12, 2)
	[ParentalInvolvementReservationFunds]                       NUMERIC(12, 2)             NULL;




PRINT N'Altering [dbo].[K12LeaFederalReporting]...';



ALTER TABLE [dbo].[K12LeaFederalReporting]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for StateAssessmentAdminFunding, data type has changed from NUMERIC(18, 0) to NUMERIC(5, 2)
	[StateAssessmentAdminFunding]                       NUMERIC(5, 2)             NULL;



ALTER TABLE [dbo].[K12LeaFederalReporting]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for StateAssessStandardsFunding, data type has changed from NUMERIC(18, 0) to NUMERIC(5, 2)
	[StateAssessStandardsFunding]                       NUMERIC(5, 2)             NULL;




PRINT N'Altering [dbo].[K12SeaFederalFunds]...';



ALTER TABLE [dbo].[K12SeaFederalFunds]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for NumberOfDaysForTitleIIISubgrants, data type has changed from NUMERIC(18, 0) to NUMERIC(6, 2)
	[NumberOfDaysForTitleIIISubgrants]                       NUMERIC(6, 2)             NULL;




PRINT N'Altering [dbo].[K12StaffEmployment]...';



ALTER TABLE [dbo].[K12StaffEmployment]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for ContractDaysOfServicePerYear, data type has changed from DECIMAL(18, 0) to DECIMAL(5, 2)
	[ContractDaysOfServicePerYear]                       DECIMAL(5, 2)             NULL;



ALTER TABLE [dbo].[K12StaffEmployment]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for StaffCompensationBaseSalary, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[StaffCompensationBaseSalary]                       DECIMAL(9, 2)             NULL;



ALTER TABLE [dbo].[K12StaffEmployment]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for StaffCompensationRetirementBenefits, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[StaffCompensationRetirementBenefits]                       DECIMAL(9, 2)             NULL;



ALTER TABLE [dbo].[K12StaffEmployment]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for StaffCompensationHealthBenefits, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[StaffCompensationHealthBenefits]                       DECIMAL(9, 2)             NULL;



ALTER TABLE [dbo].[K12StaffEmployment]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for StaffCompensationOtherBenefits, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[StaffCompensationOtherBenefits]                       DECIMAL(9, 2)             NULL;



ALTER TABLE [dbo].[K12StaffEmployment]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for StaffCompensationTotalBenefits, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[StaffCompensationTotalBenefits]                       DECIMAL(9, 2)             NULL;



ALTER TABLE [dbo].[K12StaffEmployment]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for StaffCompensationTotalSalary, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[StaffCompensationTotalSalary]                       DECIMAL(9, 2)             NULL;




PRINT N'Altering [dbo].[K12StudentAcademicRecord]...';



ALTER TABLE [dbo].[K12StudentAcademicRecord]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for CreditsAttemptedCumulative, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[CreditsAttemptedCumulative]                       DECIMAL(9, 2)             NULL;



ALTER TABLE [dbo].[K12StudentAcademicRecord]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for CreditsEarnedCumulative, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[CreditsEarnedCumulative]                       DECIMAL(9, 2)             NULL;



ALTER TABLE [dbo].[K12StudentAcademicRecord]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for GradePointsEarnedCumulative, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[GradePointsEarnedCumulative]                       DECIMAL(9, 2)             NULL;



ALTER TABLE [dbo].[K12StudentAcademicRecord]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for GradePointAverageCumulative, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 4)
	[GradePointAverageCumulative]                       DECIMAL(9, 4)             NULL;




PRINT N'Altering [dbo].[K12StudentActivity]...';



ALTER TABLE [dbo].[K12StudentActivity]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for ActivityTimeInvolved, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[ActivityTimeInvolved]                       DECIMAL(9, 2)             NULL;




PRINT N'Altering [dbo].[K12StudentCourseSection]...';



ALTER TABLE [dbo].[K12StudentCourseSection]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for NumberOfCreditsAttempted, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[NumberOfCreditsAttempted]                       DECIMAL(9, 2)             NULL;



ALTER TABLE [dbo].[K12StudentCourseSection]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for NumberOfCreditsEarned, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[NumberOfCreditsEarned]                       DECIMAL(9, 2)             NULL;




PRINT N'Altering [dbo].[K12StudentGraduationPlan]...';



ALTER TABLE [dbo].[K12StudentGraduationPlan]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for CreditsRequired, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[CreditsRequired]                       DECIMAL(9, 2)             NULL;




PRINT N'Altering [dbo].[Program]...';



ALTER TABLE [dbo].[Program]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for CreditsRequired, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[CreditsRequired]                       DECIMAL(9, 2)             NULL;




PRINT N'Altering [dbo].[PsPriceOfAttendance]...';



ALTER TABLE [dbo].[PsPriceOfAttendance]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for TuitionPublished, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[TuitionPublished]                       DECIMAL(9, 2)             NULL;



ALTER TABLE [dbo].[PsPriceOfAttendance]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for BoardCharges, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[BoardCharges]                       DECIMAL(9, 2)             NULL;



ALTER TABLE [dbo].[PsPriceOfAttendance]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for RoomCharges, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[RoomCharges]                       DECIMAL(9, 2)             NULL;



ALTER TABLE [dbo].[PsPriceOfAttendance]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for BooksAndSuppliesCosts, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[BooksAndSuppliesCosts]                       DECIMAL(9, 2)             NULL;



ALTER TABLE [dbo].[PsPriceOfAttendance]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for RequiredStudentFees, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[RequiredStudentFees]                       DECIMAL(9, 2)             NULL;



ALTER TABLE [dbo].[PsPriceOfAttendance]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for ComprehensiveFee, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[ComprehensiveFee]                       DECIMAL(9, 2)             NULL;



ALTER TABLE [dbo].[PsPriceOfAttendance]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for OtherStudentExpenses, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[OtherStudentExpenses]                       DECIMAL(9, 2)             NULL;



ALTER TABLE [dbo].[PsPriceOfAttendance]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for PriceOfAttendance, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[PriceOfAttendance]                       DECIMAL(9, 2)             NULL;




PRINT N'Altering [dbo].[PsStudentApplication]...';



ALTER TABLE [dbo].[PsStudentApplication]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for GradePointAverageCumulative, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 4)
	[GradePointAverageCumulative]                       DECIMAL(9, 4)             NULL;



ALTER TABLE [dbo].[PsStudentApplication]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for HighSchoolPercentile, data type has changed from DECIMAL(18, 0) to DECIMAL(5, 4)
	[HighSchoolPercentile]                       DECIMAL(5, 4)             NULL;




PRINT N'Altering [dbo].[PsStudentFinancialAid]...';



ALTER TABLE [dbo].[PsStudentFinancialAid]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for FinancialNeed, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[FinancialNeed]                       DECIMAL(9, 2)             NULL;



ALTER TABLE [dbo].[PsStudentFinancialAid]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for FinancialAidIncomeLevel, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[FinancialAidIncomeLevel]                       DECIMAL(9, 2)             NULL;




PRINT N'Altering [dbo].[PsStudentSection]...';



ALTER TABLE [dbo].[PsStudentSection]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for NumberOfCreditsEarned, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[NumberOfCreditsEarned]                       DECIMAL(9, 2)             NULL;



ALTER TABLE [dbo].[PsStudentSection]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for QualityPointsEarned, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[QualityPointsEarned]                       DECIMAL(9, 2)             NULL;




PRINT N'Altering [dbo].[RefCompetencyDefAssociationType]...';



ALTER TABLE [dbo].[RefCompetencyDefAssociationType]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for SortOrder, data type has changed from DECIMAL(18, 0) to DECIMAL(6, 2)
	[SortOrder]                       DECIMAL(6, 2)             NULL;




PRINT N'Altering [dbo].[RefCompetencyDefNodeAccessibilityProfile]...';



ALTER TABLE [dbo].[RefCompetencyDefNodeAccessibilityProfile]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for SortOrder, data type has changed from DECIMAL(18, 0) to DECIMAL(6, 2)
	[SortOrder]                       DECIMAL(6, 2)             NULL;




PRINT N'Altering [dbo].[RefCompetencyDefTestabilityType]...';



ALTER TABLE [dbo].[RefCompetencyDefTestabilityType]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for SortOrder, data type has changed from DECIMAL(18, 0) to DECIMAL(6, 2)
	[SortOrder]                       DECIMAL(6, 2)             NULL;




PRINT N'Altering [dbo].[RefCredentialDefAssessMethodType]...';



ALTER TABLE [dbo].[RefCredentialDefAssessMethodType]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for SortOrder, data type has changed from DECIMAL(18, 0) to DECIMAL(6, 2)
	[SortOrder]                       DECIMAL(6, 2)             NULL;




PRINT N'Altering [dbo].[RefCredentialDefIntendedPurposeType]...';



ALTER TABLE [dbo].[RefCredentialDefIntendedPurposeType]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for SortOrder, data type has changed from DECIMAL(18, 0) to DECIMAL(6, 2)
	[SortOrder]                       DECIMAL(6, 2)             NULL;




PRINT N'Altering [dbo].[RefCredentialDefStatusType]...';



ALTER TABLE [dbo].[RefCredentialDefStatusType]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for SortOrder, data type has changed from DECIMAL(18, 0) to DECIMAL(6, 2)
	[SortOrder]                       DECIMAL(6, 2)             NULL;




PRINT N'Altering [dbo].[RefCredentialDefVerificationType]...';



ALTER TABLE [dbo].[RefCredentialDefVerificationType]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for SortOrder, data type has changed from DECIMAL(18, 0) to DECIMAL(6, 2)
	[SortOrder]                       DECIMAL(6, 2)             NULL;




PRINT N'Altering [dbo].[StaffExperience]...';



ALTER TABLE [dbo].[StaffExperience]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for YearsOfPriorTeachingExperience, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[YearsOfPriorTeachingExperience]                       DECIMAL(9, 2)             NULL;



ALTER TABLE [dbo].[StaffExperience]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for YearsOfPriorAETeachingExperience, data type has changed from DECIMAL(18, 0) to DECIMAL(9, 2)
	[YearsOfPriorAETeachingExperience]                       DECIMAL(9, 2)             NULL;




PRINT N'Altering [dbo].[WorkforceEmploymentQuarterlyData]...';



ALTER TABLE [dbo].[WorkforceEmploymentQuarterlyData]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for EmployedInMultipleJobsCount, data type has changed from DECIMAL(18, 0) to DECIMAL(2, 0)
	[EmployedInMultipleJobsCount]                       DECIMAL(2, 0)             NULL;




PRINT N'Creating [dbo].[AssessmentRegistration].[IX_AssReg_PersonId]...';



IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AssessmentRegistration]') AND name = N'IX_AssReg_PersonId')
DROP INDEX [IX_AssReg_PersonId] ON [dbo].[AssessmentRegistration]


CREATE  NONCLUSTERED INDEX [IX_AssReg_PersonId]
	ON [dbo].[AssessmentRegistration]([PersonId] ASC)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];





PRINT N'Creating [dbo].[FK_CourseSection_Organization]...';



ALTER TABLE [dbo].[CourseSection] WITH NOCHECK
	ADD CONSTRAINT [FK_CourseSection_Organization] FOREIGN KEY ([OrganizationId]) REFERENCES [dbo].[Organization] ([OrganizationId]) 
	ON UPDATE CASCADE
	ON DELETE CASCADE;




PRINT N'Creating [dbo].[FK_EcProgramEnrollment_OrganizationPerson]...';



ALTER TABLE [dbo].[ELEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_EcProgramEnrollment_OrganizationPerson] FOREIGN KEY ([OrganizationPersonRoleId]) REFERENCES [dbo].[OrganizationPersonRole] ([OrganizationPersonRoleId]) 
	ON UPDATE CASCADE
	ON DELETE CASCADE;




PRINT N'Creating [dbo].[FK_K12Lea_Organization]...';



ALTER TABLE [dbo].[K12Lea] WITH NOCHECK
	ADD CONSTRAINT [FK_K12Lea_Organization] FOREIGN KEY ([OrganizationId]) REFERENCES [dbo].[Organization] ([OrganizationId]) 
	ON UPDATE CASCADE
	ON DELETE CASCADE;




PRINT N'Creating [dbo].[FK_K12LeaFederalFunds_OrganizationCalendarSession]...';



IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_K12LEAFederalFunds_OrganizationCalendarSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[K12LeaFederalFunds]'))
ALTER TABLE [dbo].[K12LeaFederalFunds] DROP CONSTRAINT [FK_K12LEAFederalFunds_OrganizationCalendarSession]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_K12LeaFederalFunds_OrganizationCalendarSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[K12LeaFederalFunds]'))
ALTER TABLE [dbo].[K12LeaFederalFunds] DROP CONSTRAINT [FK_K12LeaFederalFunds_OrganizationCalendarSession]


ALTER TABLE [dbo].[K12LeaFederalFunds] WITH NOCHECK
	ADD CONSTRAINT [FK_K12LeaFederalFunds_OrganizationCalendarSession] FOREIGN KEY ([OrganizationCalendarSessionId]) REFERENCES [dbo].[OrganizationCalendarSession] ([OrganizationCalendarSessionId]) ;




PRINT N'Creating [dbo].[FK_K12LeaFederalFunds_RefRlisProgramUse]...';



IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_K12LEAFederalFunds_RefRLISProgramUse]') AND parent_object_id = OBJECT_ID(N'[dbo].[K12LeaFederalFunds]'))
ALTER TABLE [dbo].[K12LeaFederalFunds] DROP CONSTRAINT [FK_K12LEAFederalFunds_RefRLISProgramUse]


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_K12LeaFederalFunds_RefRlisProgramUse]') AND parent_object_id = OBJECT_ID(N'[dbo].[K12LeaFederalFunds]'))
ALTER TABLE [dbo].[K12LeaFederalFunds] DROP CONSTRAINT [FK_K12LeaFederalFunds_RefRlisProgramUse]


ALTER TABLE [dbo].[K12LeaFederalFunds] WITH NOCHECK
	ADD CONSTRAINT [FK_K12LeaFederalFunds_RefRlisProgramUse] FOREIGN KEY ([RefRlisProgramUseId]) REFERENCES [dbo].[RefRlisProgramUse] ([RefRlisProgramUseId]) ;




PRINT N'Creating [dbo].[FK_K12Sea_Organization]...';



ALTER TABLE [dbo].[K12Sea] WITH NOCHECK
	ADD CONSTRAINT [FK_K12Sea_Organization] FOREIGN KEY ([OrganizationId]) REFERENCES [dbo].[Organization] ([OrganizationId]) 
	ON UPDATE CASCADE
	ON DELETE CASCADE;




PRINT N'Creating [dbo].[FK_K12StudentAcademicRecord_OrganizationPerson]...';



ALTER TABLE [dbo].[K12StudentAcademicRecord] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StudentAcademicRecord_OrganizationPerson] FOREIGN KEY ([OrganizationPersonRoleId]) REFERENCES [dbo].[OrganizationPersonRole] ([OrganizationPersonRoleId]) 
	ON UPDATE CASCADE
	ON DELETE CASCADE;




PRINT N'Creating [dbo].[FK_K12StudentCourseSection_OrganizationPerson]...';



ALTER TABLE [dbo].[K12StudentCourseSection] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StudentCourseSection_OrganizationPerson] FOREIGN KEY ([OrganizationPersonRoleId]) REFERENCES [dbo].[OrganizationPersonRole] ([OrganizationPersonRoleId]) 
	ON UPDATE CASCADE
	ON DELETE CASCADE;




PRINT N'Creating [dbo].[FK_LocationAddress_Location]...';



ALTER TABLE [dbo].[LocationAddress] WITH NOCHECK
	ADD CONSTRAINT [FK_LocationAddress_Location] FOREIGN KEY ([LocationId]) REFERENCES [dbo].[Location] ([LocationId]) 
	ON UPDATE CASCADE
	ON DELETE CASCADE;




PRINT N'Creating [dbo].[FK_PsInstitution_Organization]...';



ALTER TABLE [dbo].[PsInstitution] WITH NOCHECK
	ADD CONSTRAINT [FK_PsInstitution_Organization] FOREIGN KEY ([OrganizationId]) REFERENCES [dbo].[Organization] ([OrganizationId]) 
	ON UPDATE CASCADE
	ON DELETE CASCADE;




PRINT N'Creating [dbo].[FK_RefCredentialDefAgentRoleType_Organization]...';



IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RefCredentialDefAgentRoleType_Organization]') AND parent_object_id = OBJECT_ID(N'[dbo].[RefCredentialDefAgentRoleType]'))
ALTER TABLE [dbo].[RefCredentialDefAgentRoleType] DROP CONSTRAINT [FK_RefCredentialDefAgentRoleType_Organization]


ALTER TABLE [dbo].[RefCredentialDefAgentRoleType] WITH NOCHECK
	ADD CONSTRAINT [FK_RefCredentialDefAgentRoleType_Organization] FOREIGN KEY ([RefJurisdictionId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Creating [dbo].[FK_RefCTDLAudienceLevelType_Organization]...';



IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RefCTDLAudienceLevelType_Organization]') AND parent_object_id = OBJECT_ID(N'[dbo].[RefCTDLAudienceLevelType]'))
ALTER TABLE [dbo].[RefCTDLAudienceLevelType] DROP CONSTRAINT [FK_RefCTDLAudienceLevelType_Organization]


ALTER TABLE [dbo].[RefCTDLAudienceLevelType] WITH NOCHECK
	ADD CONSTRAINT [FK_RefCTDLAudienceLevelType_Organization] FOREIGN KEY ([RefJurisdictionId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Check existing data against newly created constraints';


ALTER TABLE [dbo].[CourseSection] WITH CHECK CHECK CONSTRAINT [FK_CourseSection_Organization];


ALTER TABLE [dbo].[ELEnrollment] WITH CHECK CHECK CONSTRAINT [FK_EcProgramEnrollment_OrganizationPerson];


ALTER TABLE [dbo].[K12Lea] WITH CHECK CHECK CONSTRAINT [FK_K12Lea_Organization];


ALTER TABLE [dbo].[K12LeaFederalFunds] WITH CHECK CHECK CONSTRAINT [FK_K12LeaFederalFunds_OrganizationCalendarSession];


ALTER TABLE [dbo].[K12LeaFederalFunds] WITH CHECK CHECK CONSTRAINT [FK_K12LeaFederalFunds_RefRlisProgramUse];


ALTER TABLE [dbo].[K12Sea] WITH CHECK CHECK CONSTRAINT [FK_K12Sea_Organization];


ALTER TABLE [dbo].[K12StudentAcademicRecord] WITH CHECK CHECK CONSTRAINT [FK_K12StudentAcademicRecord_OrganizationPerson];


ALTER TABLE [dbo].[K12StudentCourseSection] WITH CHECK CHECK CONSTRAINT [FK_K12StudentCourseSection_OrganizationPerson];


ALTER TABLE [dbo].[LocationAddress] WITH CHECK CHECK CONSTRAINT [FK_LocationAddress_Location];


ALTER TABLE [dbo].[PsInstitution] WITH CHECK CHECK CONSTRAINT [FK_PsInstitution_Organization];


ALTER TABLE [dbo].[RefCredentialDefAgentRoleType] WITH CHECK CHECK CONSTRAINT [FK_RefCredentialDefAgentRoleType_Organization];


ALTER TABLE [dbo].[RefCTDLAudienceLevelType] WITH CHECK CHECK CONSTRAINT [FK_RefCTDLAudienceLevelType_Organization];




PRINT N'V8-to-V9 update complete.';




PRINT N'V8_1-to-V9 upgrade'

PRINT N'--Drop FK and Unique statements'

PRINT N'Dropping [dbo].[FK_AssessmentSubtest_CompetencyDefinition_CompetencyDefinition]...';


IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_AssessmentSubtest_CompetencyDefinition_CompetencyDefinition' 
	    AND OBJECT_NAME(id) = 'AssessmentSubtest_CompetencyDefinition' )
ALTER TABLE [dbo].[AssessmentSubtest_CompetencyDefinition] DROP CONSTRAINT [FK_AssessmentSubtest_CompetencyDefinition_CompetencyDefinition];




PRINT N'Dropping [dbo].[FK_CompetencyDefAssociation_CompetencyDefinition]...';


IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_CompetencyDefAssociation_CompetencyDefinition' 
	    AND OBJECT_NAME(id) = 'CompetencyDefAssociation' )
ALTER TABLE [dbo].[CompetencyDefAssociation] DROP CONSTRAINT [FK_CompetencyDefAssociation_CompetencyDefinition];




PRINT N'Dropping [dbo].[FK_CompetencyDefEducationLevel_CompetencyDefinition]...';



ALTER TABLE [dbo].[CompetencyDefEducationLevel] DROP CONSTRAINT [FK_CompetencyDefEducationLevel_CompetencyDefinition];




PRINT N'Dropping [dbo].[FK_CompetencyDefinition_CompetencyDefinition]...';



ALTER TABLE [dbo].[CompetencyDefinition] DROP CONSTRAINT [FK_CompetencyDefinition_CompetencyDefinition];




PRINT N'Dropping [dbo].[FK_CompetencyDefinition_CompetencyFramework]...';



ALTER TABLE [dbo].[CompetencyDefinition] DROP CONSTRAINT [FK_CompetencyDefinition_CompetencyFramework];




PRINT N'Dropping [dbo].[FK_CompetencyDefinition_RefBloomsTaxonomyDomain]...';



ALTER TABLE [dbo].[CompetencyDefinition] DROP CONSTRAINT [FK_CompetencyDefinition_RefBloomsTaxonomyDomain];




PRINT N'Dropping [dbo].[FK_CompetencyDefinition_RefCompetencyDefinitionNodeAccessibilityProfile]...';



ALTER TABLE [dbo].[CompetencyDefinition] DROP CONSTRAINT [FK_CompetencyDefinition_RefCompetencyDefinitionNodeAccessibilityProfile];




PRINT N'Dropping [dbo].[FK_CompetencyDefinition_RefCompetencyDefinitionTestabilityType]...';



ALTER TABLE [dbo].[CompetencyDefinition] DROP CONSTRAINT [FK_CompetencyDefinition_RefCompetencyDefinitionTestabilityType];




PRINT N'Dropping [dbo].[FK_CompetencyDefinition_RefLanguage]...';



ALTER TABLE [dbo].[CompetencyDefinition] DROP CONSTRAINT [FK_CompetencyDefinition_RefLanguage];




PRINT N'Dropping [dbo].[FK_CompetencyDefinition_RefMultipleIntelligenceType]...';



ALTER TABLE [dbo].[CompetencyDefinition] DROP CONSTRAINT [FK_CompetencyDefinition_RefMultipleIntelligenceType];




PRINT N'Dropping [dbo].[FK_CompetencyDefinition_CompetencySet_CompetencyDefinition]...';



ALTER TABLE [dbo].[CompetencyDefinition_CompetencySet] DROP CONSTRAINT [FK_CompetencyDefinition_CompetencySet_CompetencyDefinition];




PRINT N'Dropping [dbo].[FK_Course_Organization]...';



ALTER TABLE [dbo].[Course] DROP CONSTRAINT [FK_Course_Organization];




PRINT N'Dropping [dbo].[FK_Course_RefCourseApplicableEducationLevel]...';



ALTER TABLE [dbo].[Course] DROP CONSTRAINT [FK_Course_RefCourseApplicableEducationLevel];




PRINT N'Dropping [dbo].[FK_Course_RefCourseCreditUnit]...';



ALTER TABLE [dbo].[Course] DROP CONSTRAINT [FK_Course_RefCourseCreditUnit];




PRINT N'Dropping [dbo].[FK_Course_RefCourseLevelCharacteristic]...';



ALTER TABLE [dbo].[Course] DROP CONSTRAINT [FK_Course_RefCourseLevelCharacteristic];




PRINT N'Dropping [dbo].[FK_Course_RefLanguage]...';



ALTER TABLE [dbo].[Course] DROP CONSTRAINT [FK_Course_RefLanguage];




PRINT N'Dropping [dbo].[FK_CourseSection_Course]...';



ALTER TABLE [dbo].[CourseSection] DROP CONSTRAINT [FK_CourseSection_Course];




PRINT N'Dropping [dbo].[FK_CredentialCriteriaCourse_Course]...';



ALTER TABLE [dbo].[CredentialCriteriaCourse] DROP CONSTRAINT [FK_CredentialCriteriaCourse_Course];




PRINT N'Dropping [dbo].[FK_CteCourse_Course]...';



ALTER TABLE [dbo].[CteCourse] DROP CONSTRAINT [FK_CteCourse_Course];




PRINT N'Dropping [dbo].[FK_ELStaffEmployment_StaffEmployment]...';



ALTER TABLE [dbo].[ELStaffEmployment] DROP CONSTRAINT [FK_ELStaffEmployment_StaffEmployment];




PRINT N'Dropping [dbo].[FK_K12CharterSchoolApprovalAgency_Organization]...';



ALTER TABLE [dbo].[K12CharterSchoolApprovalAgency] DROP CONSTRAINT [FK_K12CharterSchoolApprovalAgency_Organization];




PRINT N'Dropping [dbo].[FK_Organization_K12CharterSchoolApprovalAgency]...';



ALTER TABLE [dbo].[K12CharterSchoolApprovalAgency] DROP CONSTRAINT [FK_Organization_K12CharterSchoolApprovalAgency];




PRINT N'Dropping [dbo].[FK_K12Course_Course]...';



ALTER TABLE [dbo].[K12Course] DROP CONSTRAINT [FK_K12Course_Course];




PRINT N'Dropping [dbo].[FK_K12Course_RefAdditionalCreditType]...';



ALTER TABLE [dbo].[K12Course] DROP CONSTRAINT [FK_K12Course_RefAdditionalCreditType];




PRINT N'Dropping [dbo].[FK_K12Course_RefBlendedLearningModel]...';



ALTER TABLE [dbo].[K12Course] DROP CONSTRAINT [FK_K12Course_RefBlendedLearningModel];




PRINT N'Dropping [dbo].[FK_K12Course_RefCareerCluster]...';



ALTER TABLE [dbo].[K12Course] DROP CONSTRAINT [FK_K12Course_RefCareerCluster];




PRINT N'Dropping [dbo].[FK_K12Course_RefCourseGpaApplicability]...';



ALTER TABLE [dbo].[K12Course] DROP CONSTRAINT [FK_K12Course_RefCourseGpaApplicability];




PRINT N'Dropping [dbo].[FK_K12Course_RefCourseInteractionMode]...';



ALTER TABLE [dbo].[K12Course] DROP CONSTRAINT [FK_K12Course_RefCourseInteractionMode];




PRINT N'Dropping [dbo].[FK_K12Course_RefCreditTypeEarned]...';



ALTER TABLE [dbo].[K12Course] DROP CONSTRAINT [FK_K12Course_RefCreditTypeEarned];




PRINT N'Dropping [dbo].[FK_K12Course_RefCurriculumFrameworkType]...';



ALTER TABLE [dbo].[K12Course] DROP CONSTRAINT [FK_K12Course_RefCurriculumFrameworkType];




PRINT N'Dropping [dbo].[FK_K12Course_RefK12EndOfCourseRequirement]...';



ALTER TABLE [dbo].[K12Course] DROP CONSTRAINT [FK_K12Course_RefK12EndOfCourseRequirement];




PRINT N'Dropping [dbo].[FK_K12Course_RefSCEDCourseLevel]...';



ALTER TABLE [dbo].[K12Course] DROP CONSTRAINT [FK_K12Course_RefSCEDCourseLevel];




PRINT N'Dropping [dbo].[FK_K12Course_RefSCEDCourseSubjectArea]...';



ALTER TABLE [dbo].[K12Course] DROP CONSTRAINT [FK_K12Course_RefSCEDCourseSubjectArea];




PRINT N'Dropping [dbo].[FK_K12Course_RefWorkbasedLearninpportunityType]...';



ALTER TABLE [dbo].[K12Course] DROP CONSTRAINT [FK_K12Course_RefWorkbasedLearningopportunityType];




PRINT N'Dropping [dbo].[FK_K12School_K12CharterSchoolApprovalAgency]...';



ALTER TABLE [dbo].[K12School] DROP CONSTRAINT [FK_K12School_K12CharterSchoolApprovalAgency];




PRINT N'Dropping [dbo].[FK_K12School_K12CharterSchoolManagementOrganization]...';



ALTER TABLE [dbo].[K12School] DROP CONSTRAINT [FK_K12School_K12CharterSchoolManagementOrganization];




PRINT N'Dropping [dbo].[FK_K12School_Organization]...';



ALTER TABLE [dbo].[K12School] DROP CONSTRAINT [FK_K12School_Organization];




PRINT N'Dropping [dbo].[FK_K12School_RefAdminFundingControl]...';



ALTER TABLE [dbo].[K12School] DROP CONSTRAINT [FK_K12School_RefAdminFundingControl];




PRINT N'Dropping [dbo].[FK_K12School_RefCharterSchoolType]...';



ALTER TABLE [dbo].[K12School] DROP CONSTRAINT [FK_K12School_RefCharterSchoolType];




PRINT N'Dropping [dbo].[FK_K12School_RefIncreasedLearningTimeType]...';



ALTER TABLE [dbo].[K12School] DROP CONSTRAINT [FK_K12School_RefIncreasedLearningTimeType];




PRINT N'Dropping [dbo].[FK_K12School_RefSchoolLevel]...';



ALTER TABLE [dbo].[K12School] DROP CONSTRAINT [FK_K12School_RefSchoolLevel];




PRINT N'Dropping [dbo].[FK_K12School_RefSchoolType]...';



ALTER TABLE [dbo].[K12School] DROP CONSTRAINT [FK_K12School_RefSchoolType];




PRINT N'Dropping [dbo].[FK_K12School_RefStatePovertyDesignation]...';

ALTER TABLE [dbo].[K12School] DROP CONSTRAINT [FK_K12School_RefStatePovertyDesignation];


PRINT N'Dropping [dbo].[FK_K12School_RefStateAppropriationMethod]...';

ALTER TABLE [dbo].[K12School] DROP CONSTRAINT [FK_K12School_RefStateAppropriationMethod]

PRINT N'Dropping [dbo].[FK_K12SchoolComprehensiveSupportIdentificationType_K12School]...';

ALTER TABLE [dbo].[K12SchoolComprehensiveSupportIdentificationType] DROP CONSTRAINT [FK_K12SchoolComprehensiveSupportIdentificationType_K12School]


PRINT N'Dropping [dbo].[FK_K12SchoolTargetedSupportIdentificationType_K12School]...';

ALTER TABLE [dbo].[K12SchoolTargetedSupportIdentificationType] DROP CONSTRAINT [FK_K12SchoolTargetedSupportIdentificationType_K12School]


PRINT N'Dropping [dbo].[FK_K12SchoolCorrectiveAction_K12School]...';



ALTER TABLE [dbo].[K12SchoolCorrectiveAction] DROP CONSTRAINT [FK_K12SchoolCorrectiveAction_K12School];




PRINT N'Dropping [dbo].[FK_K12SchoolGradeOffered_K12School]...';



ALTER TABLE [dbo].[K12SchoolGradeOffered] DROP CONSTRAINT [FK_K12SchoolGradeOffered_K12School];




PRINT N'Dropping [dbo].[FK_K12SchoolImprovement_K12School]...';



ALTER TABLE [dbo].[K12SchoolImprovement] DROP CONSTRAINT [FK_K12SchoolImprovement_K12School];




PRINT N'Dropping [dbo].[FK_K12SchoolIndicatorStatus_K12School]...';



ALTER TABLE [dbo].[K12SchoolIndicatorStatus] DROP CONSTRAINT [FK_K12SchoolIndicatorStatus_K12School];




PRINT N'Dropping [dbo].[FK_K12SchoolStatus_K12School]...';



ALTER TABLE [dbo].[K12SchoolStatus] DROP CONSTRAINT [FK_K12SchoolStatus_K12School];




PRINT N'Dropping [dbo].[FK_K12SchoolStatus_RefAlternativeSchoolFocus]...';



ALTER TABLE [dbo].[K12SchoolStatus] DROP CONSTRAINT [FK_K12SchoolStatus_RefAlternativeSchoolFocus];




PRINT N'Dropping [dbo].[FK_K12SchoolStatus_RefBlendedLearningModelType]...';



ALTER TABLE [dbo].[K12SchoolStatus] DROP CONSTRAINT [FK_K12SchoolStatus_RefBlendedLearningModelType];




PRINT N'Dropping [dbo].[FK_K12SchoolStatus_RefComprehensiveAndTargetedSupport]...';



ALTER TABLE [dbo].[K12SchoolStatus] DROP CONSTRAINT [FK_K12SchoolStatus_RefComprehensiveAndTargetedSupport];




PRINT N'Dropping [dbo].[FK_K12SchoolStatus_RefComprehensiveSupport]...';



ALTER TABLE [dbo].[K12SchoolStatus] DROP CONSTRAINT [FK_K12SchoolStatus_RefComprehensiveSupport];




PRINT N'Dropping [dbo].[FK_K12SchoolStatus_RefInternetAccess]...';



ALTER TABLE [dbo].[K12SchoolStatus] DROP CONSTRAINT [FK_K12SchoolStatus_RefInternetAccess];




PRINT N'Dropping [dbo].[FK_K12SchoolStatus_RefMagnetSpecialProgram]...';



ALTER TABLE [dbo].[K12SchoolStatus] DROP CONSTRAINT [FK_K12SchoolStatus_RefMagnetSpecialProgram];




PRINT N'Dropping [dbo].[FK_K12SchoolStatus_RefNationalSchoolLunchProgramStatus]...';



ALTER TABLE [dbo].[K12SchoolStatus] DROP CONSTRAINT [FK_K12SchoolStatus_RefNationalSchoolLunchProgramStatus];




PRINT N'Dropping [dbo].[FK_K12SchoolStatus_RefNSLPStatus]...';



ALTER TABLE [dbo].[K12SchoolStatus] DROP CONSTRAINT [FK_K12SchoolStatus_RefNSLPStatus];




PRINT N'Dropping [dbo].[FK_K12SchoolStatus_RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus]...';



ALTER TABLE [dbo].[K12SchoolStatus] DROP CONSTRAINT [FK_K12SchoolStatus_RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus];




PRINT N'Dropping [dbo].[FK_K12SchoolStatus_RefRestructuringAction]...';



ALTER TABLE [dbo].[K12SchoolStatus] DROP CONSTRAINT [FK_K12SchoolStatus_RefRestructuringAction];




PRINT N'Dropping [dbo].[FK_K12SchoolStatus_RefSchoolDangerousStatus]...';



ALTER TABLE [dbo].[K12SchoolStatus] DROP CONSTRAINT [FK_K12SchoolStatus_RefSchoolDangerousStatus];




PRINT N'Dropping [dbo].[FK_K12SchoolStatus_RefSchoolImprovementStatus]...';



ALTER TABLE [dbo].[K12SchoolStatus] DROP CONSTRAINT [FK_K12SchoolStatus_RefSchoolImprovementStatus];




PRINT N'Dropping [dbo].[FK_K12SchoolStatus_RefTargetedSupport]...';



ALTER TABLE [dbo].[K12SchoolStatus] DROP CONSTRAINT [FK_K12SchoolStatus_RefTargetedSupport];




PRINT N'Dropping [dbo].[FK_K12SchoolStatus_RefTitle1SchoolStatus]...';



ALTER TABLE [dbo].[K12SchoolStatus] DROP CONSTRAINT [FK_K12SchoolStatus_RefTitle1SchoolStatus];




PRINT N'Dropping [dbo].[FK_K12SchoolStatus_RefVirtualSchoolStatus]...';



ALTER TABLE [dbo].[K12SchoolStatus] DROP CONSTRAINT [FK_K12SchoolStatus_RefVirtualSchoolStatus];




PRINT N'Dropping [dbo].[FK_K12Sea_Organization]...';



ALTER TABLE [dbo].[K12Sea] DROP CONSTRAINT [FK_K12Sea_Organization];



PRINT N'Dropping [dbo].[FK_K12SeaFederalFunds_K12Sea]...';



ALTER TABLE [dbo].[K12SeaFederalFunds] DROP CONSTRAINT [FK_K12SeaFederalFunds_K12Sea];




PRINT N'Dropping [dbo].[FK_K12StaffAssignment_OrganizationPerson]...';



ALTER TABLE [dbo].[K12StaffAssignment] DROP CONSTRAINT [FK_K12StaffAssignment_OrganizationPerson];




PRINT N'Dropping [dbo].[FK_K12StaffAssignment_OrganizationPersonRole]...';



ALTER TABLE [dbo].[K12StaffAssignment] DROP CONSTRAINT [FK_K12StaffAssignment_OrganizationPersonRole];




PRINT N'Dropping [dbo].[FK_K12StaffAssignment_RefClassroomPositionType]...';



ALTER TABLE [dbo].[K12StaffAssignment] DROP CONSTRAINT [FK_K12StaffAssignment_RefClassroomPositionType];




PRINT N'Dropping [dbo].[FK_K12StaffAssignment_RefEducationStaffClassification]...';



ALTER TABLE [dbo].[K12StaffAssignment] DROP CONSTRAINT [FK_K12StaffAssignment_RefEducationStaffClassification];




PRINT N'Dropping [dbo].[FK_K12StaffAssignment_RefEmergencyOrProvisionalCredentialStatus]...';



ALTER TABLE [dbo].[K12StaffAssignment] DROP CONSTRAINT [FK_K12StaffAssignment_RefEmergencyOrProvisionalCredentialStatus];




PRINT N'Dropping [dbo].[FK_K12StaffAssignment_RefMepStaffCatery]...';



ALTER TABLE [dbo].[K12StaffAssignment] DROP CONSTRAINT [FK_K12StaffAssignment_RefMepStaffCategory];




PRINT N'Dropping [dbo].[FK_K12StaffAssignment_RefOutOfFieldStatus]...';



ALTER TABLE [dbo].[K12StaffAssignment] DROP CONSTRAINT [FK_K12StaffAssignment_RefOutOfFieldStatus];




PRINT N'Dropping [dbo].[FK_K12StaffAssignment_RefProfessionalEducationJobClassification]...';



ALTER TABLE [dbo].[K12StaffAssignment] DROP CONSTRAINT [FK_K12StaffAssignment_RefProfessionalEducationJobClassification];




PRINT N'Dropping [dbo].[FK_K12StaffAssignment_RefSpecialEducationAgeGroupTaught]...';



ALTER TABLE [dbo].[K12StaffAssignment] DROP CONSTRAINT [FK_K12StaffAssignment_RefSpecialEducationAgeGroupTaught];




PRINT N'Dropping [dbo].[FK_K12StaffAssignment_RefSpecialEducationStaffCatery]...';



ALTER TABLE [dbo].[K12StaffAssignment] DROP CONSTRAINT [FK_K12StaffAssignment_RefSpecialEducationStaffCategory];




PRINT N'Dropping [dbo].[FK_K12StaffAssignment_RefTeachingAssignmentRole]...';



ALTER TABLE [dbo].[K12StaffAssignment] DROP CONSTRAINT [FK_K12StaffAssignment_RefTeachingAssignmentRole];




PRINT N'Dropping [dbo].[FK_K12StaffAssignment_RefTitleIProgramStaffCategory]...';



ALTER TABLE [dbo].[K12StaffAssignment] DROP CONSTRAINT [FK_K12StaffAssignment_RefTitleIProgramStaffCategory];




PRINT N'Dropping [dbo].[FK_K12StaffAssignment_RefUnexperiencedStatus]...';



ALTER TABLE [dbo].[K12StaffAssignment] DROP CONSTRAINT [FK_K12StaffAssignment_RefUnexperiencedStatus];




PRINT N'Dropping [dbo].[FK_K12StaffEmployment_RefEduStaffClassification]...';



ALTER TABLE [dbo].[K12StaffEmployment] DROP CONSTRAINT [FK_K12StaffEmployment_RefEduStaffClassification];




PRINT N'Dropping [dbo].[FK_K12StaffEmployment_RefEmploymentStatus]...';



ALTER TABLE [dbo].[K12StaffEmployment] DROP CONSTRAINT [FK_K12StaffEmployment_RefEmploymentStatus];




PRINT N'Dropping [dbo].[FK_K12StaffEmployment_StaffEmployment]...';



ALTER TABLE [dbo].[K12StaffEmployment] DROP CONSTRAINT [FK_K12StaffEmployment_StaffEmployment];




PRINT N'Dropping [dbo].[FK_K12EnrollmentMember_OrganizationPerson]...';



ALTER TABLE [dbo].[K12StudentEnrollment] DROP CONSTRAINT [FK_K12EnrollmentMember_OrganizationPerson];




PRINT N'Dropping [dbo].[FK_K12EnrollmentMember_RefGrade]...';



ALTER TABLE [dbo].[K12StudentEnrollment] DROP CONSTRAINT [FK_K12EnrollmentMember_RefGrade];




PRINT N'Dropping [dbo].[FK_K12StudentEnrollment_OrganizationPersonRole]...';



ALTER TABLE [dbo].[K12StudentEnrollment] DROP CONSTRAINT [FK_K12StudentEnrollment_OrganizationPersonRole];




PRINT N'Dropping [dbo].[FK_K12StudentEnrollment_RefDirectoryInformationBlockStatus]...';



ALTER TABLE [dbo].[K12StudentEnrollment] DROP CONSTRAINT [FK_K12StudentEnrollment_RefDirectoryInformationBlockStatus];




PRINT N'Dropping [dbo].[FK_K12StudentEnrollment_RefEndOfTermStatus]...';



ALTER TABLE [dbo].[K12StudentEnrollment] DROP CONSTRAINT [FK_K12StudentEnrollment_RefEndOfTermStatus];




PRINT N'Dropping [dbo].[FK_K12StudentEnrollment_RefEnrollmentStatus]...';



ALTER TABLE [dbo].[K12StudentEnrollment] DROP CONSTRAINT [FK_K12StudentEnrollment_RefEnrollmentStatus];




PRINT N'Dropping [dbo].[FK_K12StudentEnrollment_RefEntryType]...';



ALTER TABLE [dbo].[K12StudentEnrollment] DROP CONSTRAINT [FK_K12StudentEnrollment_RefEntryType];




PRINT N'Dropping [dbo].[FK_K12StudentEnrollment_RefExitOrWithdrawalStatus]...';



ALTER TABLE [dbo].[K12StudentEnrollment] DROP CONSTRAINT [FK_K12StudentEnrollment_RefExitOrWithdrawalStatus];




PRINT N'Dropping [dbo].[FK_K12StudentEnrollment_RefExitOrWithdrawalType]...';



ALTER TABLE [dbo].[K12StudentEnrollment] DROP CONSTRAINT [FK_K12StudentEnrollment_RefExitOrWithdrawalType];




PRINT N'Dropping [dbo].[FK_K12StudentEnrollment_RefFoodServiceEligibility]...';



ALTER TABLE [dbo].[K12StudentEnrollment] DROP CONSTRAINT [FK_K12StudentEnrollment_RefFoodServiceEligibility];




PRINT N'Dropping [dbo].[FK_K12StudentEnrollment_RefGradeLevel]...';



ALTER TABLE [dbo].[K12StudentEnrollment] DROP CONSTRAINT [FK_K12StudentEnrollment_RefGradeLevel];




PRINT N'Dropping [dbo].[FK_K12StudentEnrollment_RefNonPromotionReason]...';



ALTER TABLE [dbo].[K12StudentEnrollment] DROP CONSTRAINT [FK_K12StudentEnrollment_RefNonPromotionReason];




PRINT N'Dropping [dbo].[FK_K12StudentEnrollment_RefPromotionReason]...';



ALTER TABLE [dbo].[K12StudentEnrollment] DROP CONSTRAINT [FK_K12StudentEnrollment_RefPromotionReason];




PRINT N'Dropping [dbo].[FK_K12StudentEnrollment_RefPublicSchoolResidence]...';



ALTER TABLE [dbo].[K12StudentEnrollment] DROP CONSTRAINT [FK_K12StudentEnrollment_RefPublicSchoolResidence];




PRINT N'Dropping [dbo].[FK_K12StudentEnrollment_RefStudentEnrollmentAccessType]...';



ALTER TABLE [dbo].[K12StudentEnrollment] DROP CONSTRAINT [FK_K12StudentEnrollment_RefStudentEnrollmentAccessType];




PRINT N'Dropping [dbo].[FK_K12StudentGraduationPlan_K12Course]...';



ALTER TABLE [dbo].[K12StudentGraduationPlan] DROP CONSTRAINT [FK_K12StudentGraduationPlan_K12Course];




PRINT N'Dropping [dbo].[FK_OrganizationDetail_Organization]...';



ALTER TABLE [dbo].[OrganizationDetail] DROP CONSTRAINT [FK_OrganizationDetail_Organization];




PRINT N'Dropping [dbo].[FK_OrganizationDetail_RefOrganizationType]...';



ALTER TABLE [dbo].[OrganizationDetail] DROP CONSTRAINT [FK_OrganizationDetail_RefOrganizationType];




PRINT N'Dropping [dbo].[FK_OrganizationFedAccountability_RefAMAOAttainmentLEPStudents]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] DROP CONSTRAINT [FK_OrganizationFedAccountability_RefAMAOAttainmentLEPStudents];




PRINT N'Dropping [dbo].[FK_OrganizationFedAccountability_RefAMAOAttainmentLEPStudents1]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] DROP CONSTRAINT [FK_OrganizationFedAccountability_RefAMAOAttainmentLEPStudents1];




PRINT N'Dropping [dbo].[FK_OrganizationFedAccountability_RefAMAOAttainmentLEPStudents2]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] DROP CONSTRAINT [FK_OrganizationFedAccountability_RefAMAOAttainmentLEPStudents2];




PRINT N'Dropping [dbo].[FK_OrganizationFedAccountability_RefCTEGraduationRateInclusion]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] DROP CONSTRAINT [FK_OrganizationFedAccountability_RefCTEGraduationRateInclusion];




PRINT N'Dropping [dbo].[FK_OrganizationFedAccountability_RefElementaryMiddleAdditional]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] DROP CONSTRAINT [FK_OrganizationFedAccountability_RefElementaryMiddleAdditional];




PRINT N'Dropping [dbo].[FK_OrganizationFedAccountability_RefHSGraduationRateIndicator]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] DROP CONSTRAINT [FK_OrganizationFedAccountability_RefHSGraduationRateIndicator];




PRINT N'Dropping [dbo].[FK_OrganizationFederaAccountability_RefAypStatus]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] DROP CONSTRAINT [FK_OrganizationFederaAccountability_RefAypStatus];




PRINT N'Dropping [dbo].[FK_OrganizationFederalAccountability_Organization]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] DROP CONSTRAINT [FK_OrganizationFederalAccountability_Organization];




PRINT N'Dropping [dbo].[FK_OrganizationFederalAccountability_RefGunFreeSchoolsActStatus]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] DROP CONSTRAINT [FK_OrganizationFederalAccountability_RefGunFreeSchoolsActStatus];




PRINT N'Dropping [dbo].[FK_OrganizationFederalAccountability_RefParticipationStatusAyp2]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] DROP CONSTRAINT [FK_OrganizationFederalAccountability_RefParticipationStatusAyp2];




PRINT N'Dropping [dbo].[FK_OrganizationFederalAccountability_RefParticipationStatusAyp3]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] DROP CONSTRAINT [FK_OrganizationFederalAccountability_RefParticipationStatusAyp3];




PRINT N'Dropping [dbo].[FK_OrganizationFederalAccountability_RefProficiencyTargetAYP]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] DROP CONSTRAINT [FK_OrganizationFederalAccountability_RefProficiencyTargetAYP];




PRINT N'Dropping [dbo].[FK_OrganizationFederalAccountability_RefProficiencyTargetAYP1]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] DROP CONSTRAINT [FK_OrganizationFederalAccountability_RefProficiencyTargetAYP1];




PRINT N'Dropping [dbo].[FK_OrganizationFederalAccountability_RefReconstitutedStatus]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] DROP CONSTRAINT [FK_OrganizationFederalAccountability_RefReconstitutedStatus];




PRINT N'Dropping [dbo].[FK_PDActivityEducationLevel_PDActivity]...';



ALTER TABLE [dbo].[PDActivityEducationLevel] DROP CONSTRAINT [FK_PDActivityEducationLevel_PDActivity];




PRINT N'Dropping [dbo].[FK_PersonRelationship_Person_Primary]...';



ALTER TABLE [dbo].[PersonRelationship] DROP CONSTRAINT [FK_PersonRelationship_Person_Primary];




PRINT N'Dropping [dbo].[FK_PersonRelationship_Person_Secondary]...';



ALTER TABLE [dbo].[PersonRelationship] DROP CONSTRAINT [FK_PersonRelationship_Person_Secondary];




PRINT N'Dropping [dbo].[FK_PersonRelationship_RefRelationship]...';



ALTER TABLE [dbo].[PersonRelationship] DROP CONSTRAINT [FK_PersonRelationship_RefRelationship];




PRINT N'Dropping [dbo].[FK_PDSession_Course]...';



ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] DROP CONSTRAINT [FK_PDSession_Course];




PRINT N'Dropping [dbo].[FK_PDSession_PDRequirement]...';



ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] DROP CONSTRAINT [FK_PDSession_PDRequirement];




PRINT N'Dropping [dbo].[FK_PDSession_RefCourseCreditUnit]...';



ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] DROP CONSTRAINT [FK_PDSession_RefCourseCreditUnit];




PRINT N'Dropping [dbo].[FK_PDSession_RefProfDevFinancialSupport]...';



ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] DROP CONSTRAINT [FK_PDSession_RefProfDevFinancialSupport];




PRINT N'Dropping [dbo].[FK_ProfessionalDevelopmentActivity_RefPDActivityApprovedFor]...';



ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] DROP CONSTRAINT [FK_ProfessionalDevelopmentActivity_RefPDActivityApprovedFor];




PRINT N'Dropping [dbo].[FK_ProfessionalDevelopmentActivity_RefPDActivityCreditType]...';



ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] DROP CONSTRAINT [FK_ProfessionalDevelopmentActivity_RefPDActivityCreditType];




PRINT N'Dropping [dbo].[FK_ProfessionalDevelopmentActivity_RefPDActivityLevel]...';



ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] DROP CONSTRAINT [FK_ProfessionalDevelopmentActivity_RefPDActivityLevel];




PRINT N'Dropping [dbo].[FK_ProfessionalDevelopmentActivity_RefPDActivityType]...';



ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] DROP CONSTRAINT [FK_ProfessionalDevelopmentActivity_RefPDActivityType];




PRINT N'Dropping [dbo].[FK_ProfessionalDevelopmentActivity_RefPDAudienceType]...';



ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] DROP CONSTRAINT [FK_ProfessionalDevelopmentActivity_RefPDAudienceType];




PRINT N'Dropping [dbo].[FK_PDSession_PDActivity]...';



ALTER TABLE [dbo].[ProfessionalDevelopmentSession] DROP CONSTRAINT [FK_PDSession_PDActivity];




PRINT N'Dropping [dbo].[FK_ProgramParticipationSpecialEd_RefIDEAEdEnvironmentForEC]...';



ALTER TABLE [dbo].[ProgramParticipationSpecialEducation] DROP CONSTRAINT [FK_ProgramParticipationSpecialEd_RefIDEAEdEnvironmentForEC];




PRINT N'Dropping [dbo].[FK_ProgramParticipationSpecialEd_RefIDEAEdEnvironmentSchoolAge]...';



ALTER TABLE [dbo].[ProgramParticipationSpecialEducation] DROP CONSTRAINT [FK_ProgramParticipationSpecialEd_RefIDEAEdEnvironmentSchoolAge];




PRINT N'Dropping [dbo].[FK_ProgramParticipationSpecialEd_RefSpecialEducationExitReason]...';



ALTER TABLE [dbo].[ProgramParticipationSpecialEducation] DROP CONSTRAINT [FK_ProgramParticipationSpecialEd_RefSpecialEducationExitReason];




PRINT N'Dropping [dbo].[FK_ProgramParticipationSpecialEducation_PersonProgramParticipat]...';



ALTER TABLE [dbo].[ProgramParticipationSpecialEducation] DROP CONSTRAINT [FK_ProgramParticipationSpecialEducation_PersonProgramParticipat];




PRINT N'Dropping [dbo].[FK_PsCourse_Course]...';



ALTER TABLE [dbo].[PsCourse] DROP CONSTRAINT [FK_PsCourse_Course];




PRINT N'Dropping [dbo].[FK_PSProgram_RefPSExitOrWithdrawalType]...';


IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_PSProgram_RefPSExitOrWithdrawalType' 
	    AND OBJECT_NAME(id) = 'PsProgram' )
ALTER TABLE [dbo].[PsProgram] DROP CONSTRAINT [FK_PSProgram_RefPSExitOrWithdrawalType];




PRINT N'Dropping [dbo].[FK_PsStaffEmployment_StaffEmployment]...';



ALTER TABLE [dbo].[PsStaffEmployment] DROP CONSTRAINT [FK_PsStaffEmployment_StaffEmployment];




PRINT N'Dropping [dbo].[FK_PsStudentEnrollment_OrganizationPersonRole]...';



ALTER TABLE [dbo].[PsStudentEnrollment] DROP CONSTRAINT [FK_PsStudentEnrollment_OrganizationPersonRole];




PRINT N'Dropping [dbo].[FK_PsStudentEnrollment_RefDevelopmentalEducationReferralStatus]...';



ALTER TABLE [dbo].[PsStudentEnrollment] DROP CONSTRAINT [FK_PsStudentEnrollment_RefDevelopmentalEducationReferralStatus];




PRINT N'Dropping [dbo].[FK_PsStudentEnrollment_RefDevelopmentalEducationType]...';



ALTER TABLE [dbo].[PsStudentEnrollment] DROP CONSTRAINT [FK_PsStudentEnrollment_RefDevelopmentalEducationType];




PRINT N'Dropping [dbo].[FK_PsStudentEnrollment_RefDistanceEducationCourseEnr]...';



ALTER TABLE [dbo].[PsStudentEnrollment] DROP CONSTRAINT [FK_PsStudentEnrollment_RefDistanceEducationCourseEnr];




PRINT N'Dropping [dbo].[FK_PsStudentEnrollment_RefDoctoralExamsRequiredCode]...';



ALTER TABLE [dbo].[PsStudentEnrollment] DROP CONSTRAINT [FK_PsStudentEnrollment_RefDoctoralExamsRequiredCode];




PRINT N'Dropping [dbo].[FK_PsStudentEnrollment_RefGraduateOrDoctoralExamResultsStatus]...';



ALTER TABLE [dbo].[PsStudentEnrollment] DROP CONSTRAINT [FK_PsStudentEnrollment_RefGraduateOrDoctoralExamResultsStatus];




PRINT N'Dropping [dbo].[FK_PsStudentEnrollment_RefInstructionalActivityHours]...';



ALTER TABLE [dbo].[PsStudentEnrollment] DROP CONSTRAINT [FK_PsStudentEnrollment_RefInstructionalActivityHours];




PRINT N'Dropping [dbo].[FK_PsStudentEnrollment_RefPsEnrollmentAwardType]...';



ALTER TABLE [dbo].[PsStudentEnrollment] DROP CONSTRAINT [FK_PsStudentEnrollment_RefPsEnrollmentAwardType];




PRINT N'Dropping [dbo].[FK_PsStudentEnrollment_RefPsEnrollmentStatus]...';



ALTER TABLE [dbo].[PsStudentEnrollment] DROP CONSTRAINT [FK_PsStudentEnrollment_RefPsEnrollmentStatus];




PRINT N'Dropping [dbo].[FK_PsStudentEnrollment_RefPsEnrollmentType]...';



ALTER TABLE [dbo].[PsStudentEnrollment] DROP CONSTRAINT [FK_PsStudentEnrollment_RefPsEnrollmentType];




PRINT N'Dropping [dbo].[FK_PsStudentEnrollment_RefPsStudentLevel]...';



ALTER TABLE [dbo].[PsStudentEnrollment] DROP CONSTRAINT [FK_PsStudentEnrollment_RefPsStudentLevel];




PRINT N'Dropping [dbo].[FK_PsStudentEnrollment_RefTransferReady]...';



ALTER TABLE [dbo].[PsStudentEnrollment] DROP CONSTRAINT [FK_PsStudentEnrollment_RefTransferReady];




PRINT N'Dropping [dbo].[FK_RefCharterSchoolApprovalAgencyType_Organization]...';



ALTER TABLE [dbo].[RefCharterSchoolApprovalAgencyType] DROP CONSTRAINT [FK_RefCharterSchoolApprovalAgencyType_Organization];




PRINT N'Dropping [dbo].[FK_RefGunFreeSchoolsActStatus_Organization1]...';



ALTER TABLE [dbo].[RefGunFreeSchoolsActReportingStatus] DROP CONSTRAINT [FK_RefGunFreeSchoolsActStatus_Organization1];




PRINT N'Dropping [dbo].[FK_RefHSGraduationRateIndicator_Organization]...';



ALTER TABLE [dbo].[RefHighSchoolGraduationRateIndicator] DROP CONSTRAINT [FK_RefHSGraduationRateIndicator_Organization];




PRINT N'Dropping [dbo].[FK_RefIdeaEdEnvironmentSchoolAge_Organization]...';



ALTER TABLE [dbo].[RefIDEAEducationalEnvironmentSchoolAge] DROP CONSTRAINT [FK_RefIdeaEdEnvironmentSchoolAge_Organization];




PRINT N'Dropping [dbo].[FK_RefEducationStaffClassification_Organization]...';



ALTER TABLE [dbo].[RefK12StaffClassification] DROP CONSTRAINT [FK_RefEducationStaffClassification_Organization];




PRINT N'Dropping [dbo].[FK_RefPDActivityApprovedFor_Organization]...';



ALTER TABLE [dbo].[RefPDActivityApprovedPurpose] DROP CONSTRAINT [FK_RefPDActivityApprovedFor_Organization];




PRINT N'Dropping [dbo].[FK_RefRelationship_Organization]...';



ALTER TABLE [dbo].[RefPersonRelationship] DROP CONSTRAINT [FK_RefRelationship_Organization];




PRINT N'Dropping [dbo].[FK_RefTitle1SchoolStatus_Organization]...';



ALTER TABLE [dbo].[RefTitleISchoolStatus] DROP CONSTRAINT [FK_RefTitle1SchoolStatus_Organization];




PRINT N'Dropping [dbo].[FK_StaffEmployment_OrganizationPersonRole]...';



ALTER TABLE [dbo].[StaffEmployment] DROP CONSTRAINT [FK_StaffEmployment_OrganizationPersonRole];




PRINT N'Dropping [dbo].[FK_StaffEmployment_RefEmploymentSeparationReason]...';



ALTER TABLE [dbo].[StaffEmployment] DROP CONSTRAINT [FK_StaffEmployment_RefEmploymentSeparationReason];




PRINT N'Dropping [dbo].[FK_StaffEmployment_RefEmploymentSeparationType]...';



ALTER TABLE [dbo].[StaffEmployment] DROP CONSTRAINT [FK_StaffEmployment_RefEmploymentSeparationType];




PRINT N'Dropping [dbo].[FK_StaffPDActivity_PDActivity]...';



ALTER TABLE [dbo].[StaffProfessionalDevelopmentActivity] DROP CONSTRAINT [FK_StaffPDActivity_PDActivity];





PRINT N'--Create new table statements'

PRINT N'Creating [dbo].[CompetencySet_Rubric]...';



CREATE TABLE [dbo].[CompetencySet_Rubric] (
	[CompetencySet_RubricId]                       INT            IDENTITY (1,1) NOT NULL,
	[CompetencySetId]                       INT             NOT NULL,
	[RubricId]                       INT             NOT NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [PK_CompetencySet_Rubric] PRIMARY KEY CLUSTERED ([CompetencySet_RubricId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);




PRINT N'Creating [dbo].[CompetencySet_RubricCriterion]...';



CREATE TABLE [dbo].[CompetencySet_RubricCriterion] (
	[CompetencySet_RubricCriterionId]                       INT            IDENTITY (1,1) NOT NULL,
	[CompetencySetId]                       INT             NOT NULL,
	[RubricCriterionId]                       INT             NOT NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [PK_CompetencySet_RubricCriterion] PRIMARY KEY CLUSTERED ([CompetencySet_RubricCriterionId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);




PRINT N'Creating [dbo].[K12LeaGradeLevelsApproved]...';



CREATE TABLE [dbo].[K12LeaGradeLevelsApproved] (
	[K12LeaGradeLevelsApprovedId]                       INT            IDENTITY (1,1) NOT NULL,
	[K12LeaId]                       INT             NOT NULL,
	[RefGradeLevelId]                       INT             NOT NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [PK_K12LeaGradeLevelsApproved] PRIMARY KEY CLUSTERED ([K12LeaGradeLevelsApprovedId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);




PRINT N'Creating [dbo].[K12LeaGradeOffered]...';



CREATE TABLE [dbo].[K12LeaGradeOffered] (
	[K12LeaGradeOfferedId]                       INT            IDENTITY (1,1) NOT NULL,
	[K12LeaId]                       INT             NOT NULL,
	[RefGradeLevelId]                       INT             NOT NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [PK_K12LeaGradeOffered] PRIMARY KEY CLUSTERED ([K12LeaGradeOfferedId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);




PRINT N'Creating [dbo].[K12SchoolGradeLevelsApproved]...';



CREATE TABLE [dbo].[K12SchoolGradeLevelsApproved] (
	[K12SchoolGradeLevelsApprovedId]                       INT            IDENTITY (1,1) NOT NULL,
	[K12SchoolId]                       INT             NOT NULL,
	[RefGradeLevelId]                       INT             NOT NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [PK_K12SchoolGradeLevelsApproved] PRIMARY KEY CLUSTERED ([K12SchoolGradeLevelsApprovedId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);




PRINT N'Creating [dbo].[OrganizationPersonRoleFTE]...';



CREATE TABLE [dbo].[OrganizationPersonRoleFTE] (
	[OrganizationPersonRoleFTEId]                       INT            IDENTITY (1,1) NOT NULL,
	[OrganizationPersonRoleId]                       INT             NOT NULL,
	[FullTimeEquivalency]                       DECIMAL(3,2)             NOT NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [PK_OrganizationPersonRoleFTE] PRIMARY KEY CLUSTERED ([OrganizationPersonRoleFTEId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);




PRINT N'Creating [dbo].[RefAdditionalTargetedSupportAndImprovementStatus]...';



CREATE TABLE [dbo].[RefAdditionalTargetedSupportAndImprovementStatus] (
	[RefAdditionalTargetedSupportAndImprovementStatusId]                       INT            IDENTITY (1,1) NOT NULL,
	[Description]                       NVARCHAR(150)             NOT NULL,
	[Code]                       NVARCHAR(50)             NULL,
	[Definition]                       NVARCHAR (4000)             NULL,
	[RefJurisdictionId]                       INT             NULL,
	[SortOrder]                       DECIMAL(6,2)             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [PK_RefAdditionalTargetedSupportAndImprovementStatus] PRIMARY KEY CLUSTERED ([RefAdditionalTargetedSupportAndImprovementStatusId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);




PRINT N'Creating [dbo].[RefComprehensiveSupportAndImprovementStatus]...';



CREATE TABLE [dbo].[RefComprehensiveSupportAndImprovementStatus] (
	[RefComprehensiveSupportAndImprovementStatusId]                       INT            IDENTITY (1,1) NOT NULL,
	[Description]                       NVARCHAR(150)             NOT NULL,
	[Code]                       NVARCHAR(50)             NULL,
	[Definition]                       NVARCHAR (4000)             NULL,
	[RefJurisdictionId]                       INT             NULL,
	[SortOrder]                       DECIMAL(6,2)             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [PK_RefComprehensiveSupportAndImprovementStatus] PRIMARY KEY CLUSTERED ([RefComprehensiveSupportAndImprovementStatusId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);




PRINT N'Creating [dbo].[RefGradeLevelsApproved]...';



CREATE TABLE [dbo].[RefGradeLevelsApproved] (
	[RefGradeLevelsApprovedId]                       INT            IDENTITY (1,1) NOT NULL,
	[Description]                       NVARCHAR(150)             NOT NULL,
	[Code]                       NVARCHAR(50)             NULL,
	[Definition]                       NVARCHAR (4000)             NULL,
	[RefJurisdictionId]                       INT             NULL,
	[SortOrder]                       DECIMAL(6,2)             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [PK_RefGradeLevelsApproved] PRIMARY KEY CLUSTERED ([RefGradeLevelsApprovedId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);




PRINT N'Creating [dbo].[RefProgramEntryReason]...';



CREATE TABLE [dbo].[RefProgramEntryReason] (
	[RefProgramEntryReasonId]                       INT            IDENTITY (1,1) NOT NULL,
	[Description]                       NVARCHAR(150)             NOT NULL,
	[Code]                       NVARCHAR(50)             NULL,
	[Definition]                       NVARCHAR (4000)             NULL,
	[RefJurisdictionId]                       INT             NULL,
	[SortOrder]                       DECIMAL(6,2)             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [PK_RefProgramEntryReason] PRIMARY KEY CLUSTERED ([RefProgramEntryReasonId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);




PRINT N'Creating [dbo].[RefTargetedSupportAndImprovementStatus]...';



CREATE TABLE [dbo].[RefTargetedSupportAndImprovementStatus] (
	[RefTargetedSupportAndImprovementStatusId]                       INT            IDENTITY (1,1) NOT NULL,
	[Description]                       NVARCHAR(150)             NOT NULL,
	[Code]                       NVARCHAR(50)             NULL,
	[Definition]                       NVARCHAR (4000)             NULL,
	[RefJurisdictionId]                       INT             NULL,
	[SortOrder]                       DECIMAL(6,2)             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [PK_RefTargetedSupportAndImprovementStatus] PRIMARY KEY CLUSTERED ([RefTargetedSupportAndImprovementStatusId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);




PRINT N'Creating [dbo].[RefTelephoneNumberListedStatus]...';



CREATE TABLE [dbo].[RefTelephoneNumberListedStatus] (
	[RefTelephoneNumberListedStatusId]                       INT            IDENTITY (1,1) NOT NULL,
	[Description]                       NVARCHAR(150)             NOT NULL,
	[Code]                       NVARCHAR(50)             NULL,
	[Definition]                       NVARCHAR (4000)             NULL,
	[RefJurisdictionId]                       INT             NULL,
	[SortOrder]                       DECIMAL(6,2)             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [PK_RefTelephoneNumberListedStatus] PRIMARY KEY CLUSTERED ([RefTelephoneNumberListedStatusId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);




PRINT N'--Drop and Create or Alter existing table statements'

PRINT N'Starting rebuilding table [dbo].[RefStateANSICode]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_RefStateANSICode] (
	[RefStateANSICodeId]                       INT            IDENTITY (1,1) NOT NULL,
	[Code]                       NVARCHAR(50)             NOT NULL,
	[Description]                       NVARCHAR(150)             NOT NULL,
	[Definition]                       NVARCHAR (4000)             NULL,
	[RefJurisdictionId]                       INT             NULL,
	[SortOrder]                       DECIMAL(6,2)             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_PK_RefStateANSICode1] PRIMARY KEY CLUSTERED ([RefStateANSICodeId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[RefStateANSICode])
	BEGIN

		SET @sql = 'INSERT INTO [dbo].[tmp_ms_xx_RefStateANSICode] ([Code], [Description])'

		IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'RefStateANSICode' AND COLUMN_NAME = 'StateName')
		BEGIN
			
			SET @sql = @sql + 'SELECT   
					 [Code],
					 [StateName]
			FROM     [dbo].[RefStateANSICode]
			ORDER BY [Code] ASC;'

		END
		ELSE
		BEGIN

			SET @sql = @sql + 'SELECT   
					 [Code],
					 [Description]
			FROM     [dbo].[RefStateANSICode]
			ORDER BY [Code] ASC;'

		END

		

		EXEC sp_executesql @sql
		
		
	END

	SET @sql = ''

DROP TABLE [dbo].[RefStateANSICode];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_RefStateANSICode]', N'RefStateANSICode';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_RefStateANSICode1]', N'PK_RefStateANSICode', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Starting rebuilding table [dbo].[CompetencyDefinition]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_CompetencyDefinition] (
	[CompetencyDefinitionId]                       INT            IDENTITY (1, 1) NOT NULL,
	[CompetencyFrameworkId]                       INT             NOT NULL,
	[Identifier]                       NVARCHAR (40)             NULL,
	[Code]                       NVARCHAR (30)             NULL,
	[URL]                       NVARCHAR (512)             NULL,
	[Type]                       NVARCHAR (60)             NULL,
	[Statement]                       NVARCHAR (MAX)             NULL,
	[Version]                       NVARCHAR (MAX)             NULL,
	[TypicalAgeRange]                       NVARCHAR (20)             NULL,
	[TextComplexitySystem]                       NVARCHAR (30)             NULL,
	[TextComplexityMinimumValue]                       DECIMAL(18, 4)             NULL,
	[TextComplexityMaximumValue]                       DECIMAL(18, 4)             NULL,
	[ConceptTerm]                       NVARCHAR (30)             NULL,
	[ConceptKeyword]                       NVARCHAR (300)             NULL,
	[License]                       NVARCHAR (300)             NULL,
	[Notes]                       NVARCHAR (MAX)             NULL,
	[CompetencyDefParentId]                       NVARCHAR (40)             NULL,
	[CompetencyDefParentCode]                       NVARCHAR (30)             NULL,
	[CompetencyDefParentUrl]                       NVARCHAR (512)             NULL,
	[ChildOf_CompetencyDefinitionId]                       INT             NULL,
	[CurrentVersionIndicator]                       BIT             NULL,
	[PreviousVersionIdentifier]                       NVARCHAR (40)             NULL,
	[ValidStartDate]                       DATE             NULL,
	[ValidEndDate]                       DATE             NULL,
	[ShortName]                       NVARCHAR (30)             NULL,
	[CompetencyDefSequence]                       NVARCHAR (60)             NULL,
	[TypeURL]                       NVARCHAR (512)             NULL,
	[TypicalAgeRangeMaximum]                       INT             NULL,
	[TypicalAgeRangeMinimum]                       INT             NULL,
	[RefLanguageId]                       INT             NULL,
	[RefBloomsTaxonomyDomainId]                       INT             NULL,
	[RefMultipleIntelligenceTypeId]                       INT             NULL,
	[RefCompetencyDefNodeAccessibilityProfileId]                       INT             NULL,
	[RefCompetencyDefTestabilityTypeId]                       INT             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_XPKCompetencyDefinition1] PRIMARY KEY CLUSTERED ([CompetencyDefinitionId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[CompetencyDefinition])
	BEGIN

		SET @sql = 'SET IDENTITY_INSERT [dbo].[tmp_ms_xx_CompetencyDefinition] ON;
					'

		SET @sql = @sql + 'INSERT INTO [dbo].[tmp_ms_xx_CompetencyDefinition] ([CompetencyDefinitionId], [CompetencyFrameworkId], [Identifier], [Code], [URL], [Type], [Statement], [Version], [TypicalAgeRange], [TextComplexitySystem], [TextComplexityMinimumValue], [TextComplexityMaximumValue], [ConceptTerm], [ConceptKeyword], [License], [Notes], [CompetencyDefParentId], [CompetencyDefParentCode], [CompetencyDefParentUrl], [ChildOf_CompetencyDefinitionId], [CurrentVersionIndicator], [PreviousVersionIdentifier], [ValidStartDate], [ValidEndDate], [ShortName], [CompetencyDefSequence], [TypeURL], [TypicalAgeRangeMaximum], [TypicalAgeRangeMinimum], [RefLanguageId], [RefBloomsTaxonomyDomainId], [RefMultipleIntelligenceTypeId], [RefCompetencyDefNodeAccessibilityProfileId], [RefCompetencyDefTestabilityTypeId], [RecordStartDateTime], [RecordEndDateTime])
					'

		IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'CompetencyDefinition' AND COLUMN_NAME = 'NodeName')
		BEGIN
			
			SET @sql = @sql + 'SELECT   
				 [CompetencyDefinitionId],
				 [CompetencyFrameworkId],
				 [Identifier],
				 [Code],
				 [URL],
				 [Type],
				 [Statement],
				 [Version],
				 [TypicalAgeRange],
				 [TextComplexitySystem],
				 [TextComplexityMinimumValue],
				 [TextComplexityMaximumValue],
				 [ConceptTerm],
				 [ConceptKeyword],
				 [License],
				 [Notes],
				 [CompetencyDefParentId],
				 [CompetencyDefParentCode],
				 [CompetencyDefParentUrl],
				 [ChildOf_CompetencyDefinitionId],
				 [CurrentVersionIndicator],
				 [PreviousVersionIdentifier],
				 [ValidStartDate],
				 [ValidEndDate],
				 [NodeName],
				 [CompetencyDefSequence],
				 [TypeURL],
				 [TypicalAgeRangeMaximum],
				 [TypicalAgeRangeMinimum],
				 [RefLanguageId],
				 [RefBloomsTaxonomyDomainId],
				 [RefMultipleIntelligenceTypeId],
				 [RefCompetencyDefNodeAccessibilityProfileId],
				 [RefCompetencyDefTestabilityTypeId],
				 [RecordStartDateTime],
				 [RecordEndDateTime]
		FROM     [dbo].[CompetencyDefinition]
		ORDER BY [CompetencyDefinitionId] ASC;
		'

		END
		ELSE
		BEGIN

			SET @sql = @sql + 'SELECT   
				 [CompetencyDefinitionId],
				 [CompetencyFrameworkId],
				 [Identifier],
				 [Code],
				 [URL],
				 [Type],
				 [Statement],
				 [Version],
				 [TypicalAgeRange],
				 [TextComplexitySystem],
				 [TextComplexityMinimumValue],
				 [TextComplexityMaximumValue],
				 [ConceptTerm],
				 [ConceptKeyword],
				 [License],
				 [Notes],
				 [CompetencyDefParentId],
				 [CompetencyDefParentCode],
				 [CompetencyDefParentUrl],
				 [ChildOf_CompetencyDefinitionId],
				 [CurrentVersionIndicator],
				 [PreviousVersionIdentifier],
				 [ValidStartDate],
				 [ValidEndDate],
				 [ShortName],
				 [CompetencyDefSequence],
				 [TypeURL],
				 [TypicalAgeRangeMaximum],
				 [TypicalAgeRangeMinimum],
				 [RefLanguageId],
				 [RefBloomsTaxonomyDomainId],
				 [RefMultipleIntelligenceTypeId],
				 [RefCompetencyDefNodeAccessibilityProfileId],
				 [RefCompetencyDefTestabilityTypeId],
				 [RecordStartDateTime],
				 [RecordEndDateTime]
		FROM     [dbo].[CompetencyDefinition]
		ORDER BY [CompetencyDefinitionId] ASC;
		'

		END

		SET @sql = @sql + 'SET IDENTITY_INSERT [dbo].[tmp_ms_xx_CompetencyDefinition] OFF;
							' 
		EXEC sp_executesql @sql


	END

DROP TABLE [dbo].[CompetencyDefinition];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_CompetencyDefinition]', N'CompetencyDefinition';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_XPKCompetencyDefinition1]', N'XPKCompetencyDefinition', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Starting rebuilding table [dbo].[Course]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Course] (
	[CourseId]                       INT            IDENTITY (1, 1) NOT NULL,
	[OrganizationId]                       INT             NOT NULL,
	[Description]                       NVARCHAR (60)             NULL,
	[SubjectAbbreviation]                       NVARCHAR (50)             NULL,
	[SCEDSequenceOfCourse]                       NVARCHAR (50)             NULL,
	[InstructionalMinutes]                       INT             NULL,
	[CreditValue]                       DECIMAL(9, 2)             NULL,
	[CertificationDescription]                       NVARCHAR (300)             NULL,
	[RepeatabilityMaximumNumber]                       INT             NULL,
	[RefCourseLevelCharacteristicsId]                       INT             NULL,
	[RefCourseCreditUnitId]                       INT             NULL,
	[RefInstructionLanguageId]                       INT             NULL,
	[RefCourseApplicableEducationLevelId]                       INT             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_PK_Course1] PRIMARY KEY CLUSTERED ([CourseId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[Course])
	BEGIN

		SET @sql = 'SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Course] ON;
					'

		SET @sql = @sql + 'INSERT INTO [dbo].[tmp_ms_xx_Course] ([CourseId], [OrganizationId], [Description], [SubjectAbbreviation], [SCEDSequenceOfCourse], [InstructionalMinutes], [CreditValue], [CertificationDescription], [RepeatabilityMaximumNumber], [RefCourseLevelCharacteristicsId], [RefCourseCreditUnitId], [RefInstructionLanguageId], [RefCourseApplicableEducationLevelId], [RecordStartDateTime], [RecordEndDateTime])
							'

		
		IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Course' AND COLUMN_NAME = 'RefInstructionLanguage')
		BEGIN
			
			SET @sql = @sql + 'SELECT   
				 [CourseId],
				 [OrganizationId],
				 [Description],
				 [SubjectAbbreviation],
				 [SCEDSequenceOfCourse],
				 [InstructionalMinutes],
				 [CreditValue],
				 [CertificationDescription],
				 [RepeatabilityMaximumNumber],
				 [RefCourseLevelCharacteristicsId],
				 [RefCourseCreditUnitId],
				 [RefInstructionLanguage],
				 [RefCourseApplicableEducationLevelId],
				 [RecordStartDateTime],
				 [RecordEndDateTime]
		FROM     [dbo].[Course]
		ORDER BY [CourseId] ASC;
		'

		END
		ELSE
		BEGIN

			SET @sql = @sql + 'SELECT   
				 [CourseId],
				 [OrganizationId],
				 [Description],
				 [SubjectAbbreviation],
				 [SCEDSequenceOfCourse],
				 [InstructionalMinutes],
				 [CreditValue],
				 [CertificationDescription],
				 [RepeatabilityMaximumNumber],
				 [RefCourseLevelCharacteristicsId],
				 [RefCourseCreditUnitId],
				 [RefInstructionLanguageId],
				 [RefCourseApplicableEducationLevelId],
				 [RecordStartDateTime],
				 [RecordEndDateTime]
		FROM     [dbo].[Course]
		ORDER BY [CourseId] ASC;
		'

		END

		SET @sql = @sql + 'SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Course] OFF;
							' 
		EXEC sp_executesql @sql
		
		
	END

DROP TABLE [dbo].[Course];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Course]', N'Course';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_Course1]', N'PK_Course', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Altering [dbo].[Facility]...';



ALTER TABLE [dbo].[Facility]
    ALTER COLUMN 
	[BuildingSiteNumber]                       NVARCHAR(60)             NULL;



ALTER TABLE [dbo].[Facility]
    ALTER COLUMN 
		--WARNING!!!! - check data compatibility for FacilityAcquisitionDate, data type has changed from NVARCHAR (100) to DATE
	[FacilityAcquisitionDate]                       DATE             NULL;




PRINT N'Starting rebuilding table [dbo].[K12CharterSchoolAuthorizerAgency]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_K12CharterSchoolAuthorizerAgency] (
	[K12CharterSchoolAuthorizerAgencyId]                       INT            IDENTITY (1, 1) NOT NULL,
	[OrganizationId]                       INT             NULL,
	[RefCharterSchoolAuthorizerTypeId]                       INT             NOT NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_PK__K12CharterSchoolAuthorizerAgency1] PRIMARY KEY CLUSTERED ([K12CharterSchoolAuthorizerAgencyId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[K12CharterSchoolApprovalAgency])
	BEGIN
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_K12CharterSchoolAuthorizerAgency] ON;
		INSERT INTO [dbo].[tmp_ms_xx_K12CharterSchoolAuthorizerAgency] ([K12CharterSchoolAuthorizerAgencyId], [OrganizationId], [RefCharterSchoolAuthorizerTypeId], [RecordStartDateTime], [RecordEndDateTime])
		SELECT   
				 [K12CharterSchoolApprovalAgencyId],
				 [OrganizationId],
				 [RefCharterSchoolApprovalAgencyTypeId],
				 [RecordStartDateTime],
				 [RecordEndDateTime]
		FROM     [dbo].[K12CharterSchoolApprovalAgency]
		ORDER BY [K12CharterSchoolApprovalAgencyId] ASC;
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_K12CharterSchoolAuthorizerAgency] OFF;
	END

DROP TABLE [dbo].[K12CharterSchoolApprovalAgency];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_K12CharterSchoolAuthorizerAgency]', N'K12CharterSchoolAuthorizerAgency';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK__K12CharterSchoolAuthorizerAgency1]', N'PK__K12CharterSchoolAuthorizerAgency', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Starting rebuilding table [dbo].[K12Course]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_K12Course] (
	[K12CourseId]                       INT            IDENTITY (1, 1) NOT NULL,
	[CourseId]                       INT             NOT NULL,
	[HighSchoolCourseRequirement]                       BIT             NULL,
	[AvailableCarnegieUnitCredit]                       DECIMAL(9, 2)             NULL,
	[CoreAcademicCourse]                       BIT             NULL,
	[CourseAlignedWithStandards]                       BIT             NULL,
	[FundingProgram]                       NVARCHAR (30)             NULL,
	[FamilyConsumerSciencesCourseInd]                       BIT             NULL,
	[SCEDCourseCode]                       NCHAR (5)             NULL,
	[SCEDGradeSpan]                       NCHAR (4)             NULL,
	[CourseDepartmentName]                       NVARCHAR (60)             NULL,
	[RefCreditTypeEarnedId]                       INT             NULL,
	[RefAdditionalCreditTypeId]                       INT             NULL,
	[RefCourseGPAApplicabilityId]                       INT             NULL,
	[RefCurriculumFrameworkTypeId]                       INT             NULL,
	[RefSCEDCourseLevelId]                       INT             NULL,
	[RefSCEDCourseSubjectAreaId]                       INT             NULL,
	[RefCareerClusterId]                       INT             NULL,
	[RefBlendedLearningModelTypeId]                       INT             NULL,
	[RefCourseInteractionModeId]                       INT             NULL,
	[RefK12EndOfCourseRequirementId]                       INT             NULL,
	[RefWorkbasedLearningopportunityTypeId]                       INT             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_PK_K12Course1] PRIMARY KEY CLUSTERED ([K12CourseId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[K12Course])
	BEGIN
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_K12Course] ON;
		INSERT INTO [dbo].[tmp_ms_xx_K12Course] ([K12CourseId], [CourseId], [HighSchoolCourseRequirement], [AvailableCarnegieUnitCredit], [CoreAcademicCourse], [CourseAlignedWithStandards], [FundingProgram], [FamilyConsumerSciencesCourseInd], [SCEDCourseCode], [SCEDGradeSpan], [CourseDepartmentName], [RefCreditTypeEarnedId], [RefAdditionalCreditTypeId], [RefCourseGPAApplicabilityId], [RefCurriculumFrameworkTypeId], [RefSCEDCourseLevelId], [RefSCEDCourseSubjectAreaId], [RefCareerClusterId], [RefBlendedLearningModelTypeId], [RefCourseInteractionModeId], [RefK12EndOfCourseRequirementId], [RefWorkbasedLearningopportunityTypeId], [RecordStartDateTime], [RecordEndDateTime])
		SELECT   
				 [K12CourseId],
				 [CourseId],
				 [HighSchoolCourseRequirement],
				 [AvailableCarnegieUnitCredit],
				 [CoreAcademicCourse],
				 [CourseAlignedWithStandards],
				 [FundingProgram],
				 [FamilyConsumerSciencesCourseInd],
				 [SCEDCourseCode],
				 [SCEDGradeSpan],
				 [CourseDepartmentName],
				 [RefCreditTypeEarnedId],
				 [RefAdditionalCreditTypeId],
				 [RefCourseGPAApplicabilityId],
				 [RefCurriculumFrameworkTypeId],
				 [RefSCEDCourseLevelId],
				 [RefSCEDCourseSubjectAreaId],
				 [RefCareerClusterId],
				 [RefBlendedLearningModelTypeId],
				 [RefCourseInteractionModeId],
				 [RefK12EndOfCourseRequirementId],
				 [RefWorkbasedLearningopportunityTypeId],
				 [RecordStartDateTime],
				 [RecordEndDateTime]
		FROM     [dbo].[K12Course]
		ORDER BY [K12CourseId] ASC;
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_K12Course] OFF;
	END

DROP TABLE [dbo].[K12Course];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_K12Course]', N'K12Course';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_K12Course1]', N'PK_K12Course', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Starting rebuilding table [dbo].[K12School]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_K12School] (
	[K12SchoolId]                       INT            IDENTITY (1, 1) NOT NULL,
	[OrganizationId]                       INT             NOT NULL,
	[CharterSchoolIndicator]                       BIT             NULL,
	[CharterSchoolApprovalYear]                       NVARCHAR (9)             NULL,
	[AccreditationAgencyName]                       NVARCHAR (300)             NULL,
	[CharterSchoolOpenEnrollmentIndicator]                       BIT             NULL,
	[CharterSchoolContractApprovalDate]                       DATE             NULL,
	[CharterSchoolContractIdNumber]                       NVARCHAR (30)             NULL,
	[CharterSchoolContractRenewalDate]                       DATE             NULL,
	[K12CharterSchoolManagementOrganizationId]                       INT             NULL,
	[K12CharterSchoolAuthorizerAgencyId]                       INT             NULL,
	[RefSchoolTypeId]                       INT             NULL,
	[RefSchoolLevelId]                       INT             NULL,
	[RefAdministrativeFundingControlId]                       INT             NULL,
	[RefCharterSchoolTypeId]                       INT             NULL,
	[RefIncreasedLearningTimeTypeId]                       INT             NULL,
	[RefStatePovertyDesignationId]                       INT             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_PK_K12School1] PRIMARY KEY NONCLUSTERED ([K12SchoolId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[K12School])
	BEGIN


		SET @sql = 'SET IDENTITY_INSERT [dbo].[tmp_ms_xx_K12School] ON;
					'

		SET @sql = @sql + 'INSERT INTO [dbo].[tmp_ms_xx_K12School] ([K12SchoolId], [OrganizationId], [CharterSchoolIndicator], [CharterSchoolApprovalYear], [AccreditationAgencyName], [CharterSchoolOpenEnrollmentIndicator], [CharterSchoolContractApprovalDate], [CharterSchoolContractIdNumber], [CharterSchoolContractRenewalDate], [K12CharterSchoolManagementOrganizationId], [K12CharterSchoolAuthorizerAgencyId], [RefSchoolTypeId], [RefSchoolLevelId], [RefAdministrativeFundingControlId], [RefCharterSchoolTypeId], [RefIncreasedLearningTimeTypeId], [RefStatePovertyDesignationId], [RecordStartDateTime], [RecordEndDateTime])
							'

		
		IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'K12School' AND COLUMN_NAME = 'K12CharterSchoolApprovalAgencyId')
		BEGIN
			
			SET @sql = @sql + 'SELECT   
				 [K12SchoolId],
				 [OrganizationId],
				 [CharterSchoolIndicator],
				 [CharterSchoolApprovalYear],
				 [AccreditationAgencyName],
				 [CharterSchoolOpenEnrollmentIndicator],
				 [CharterSchoolContractApprovalDate],
				 [CharterSchoolContractIdNumber],
				 [CharterSchoolContractRenewalDate],
				 [K12CharterSchoolManagementOrganizationId],
				 [K12CharterSchoolApprovalAgencyId],
				 [RefSchoolTypeId],
				 [RefSchoolLevelId],
				 [RefAdministrativeFundingControlId],
				 [RefCharterSchoolTypeId],
				 [RefIncreasedLearningTimeTypeId],
				 [RefStatePovertyDesignationId],
				 [RecordStartDateTime],
				 [RecordEndDateTime]
		FROM     [dbo].[K12School]
		ORDER BY [K12SchoolId] ASC;
		'
		END
		ELSE
		BEGIN

			SET @sql = @sql + 'SELECT   
				 [K12SchoolId],
				 [OrganizationId],
				 [CharterSchoolIndicator],
				 [CharterSchoolApprovalYear],
				 [AccreditationAgencyName],
				 [CharterSchoolOpenEnrollmentIndicator],
				 [CharterSchoolContractApprovalDate],
				 [CharterSchoolContractIdNumber],
				 [CharterSchoolContractRenewalDate],
				 [K12CharterSchoolManagementOrganizationId],
				 [K12CharterSchoolAuthorizerAgencyId],
				 [RefSchoolTypeId],
				 [RefSchoolLevelId],
				 [RefAdministrativeFundingControlId],
				 [RefCharterSchoolTypeId],
				 [RefIncreasedLearningTimeTypeId],
				 [RefStatePovertyDesignationId],
				 [RecordStartDateTime],
				 [RecordEndDateTime]
		FROM     [dbo].[K12School]
		ORDER BY [K12SchoolId] ASC;
		'

		END

		SET @sql = @sql + '	SET IDENTITY_INSERT [dbo].[tmp_ms_xx_K12School] OFF;
							' 
		EXEC sp_executesql @sql

				
	END

DROP TABLE [dbo].[K12School];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_K12School]', N'K12School';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_K12School1]', N'PK_K12School', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Starting rebuilding table [dbo].[K12SchoolStatus]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_K12SchoolStatus] (
	[K12SchoolStatusId]                       INT            IDENTITY (1, 1) NOT NULL,
	[K12SchoolId]                       INT             NOT NULL,
	[ConsolidatedMepFundsStatus]                       BIT             NULL,
	[ProgressAcheivingEnglishLearnerProficiencyStateDefinedStatus]                       NVARCHAR (50)             NULL,
	[RefMagnetSpecialProgramId]                       INT             NULL,
	[RefAlternativeSchoolFocusId]                       INT             NULL,
	[RefInternetAccessId]                       INT             NULL,
	[RefRestructuringActionId]                       INT             NULL,
	[RefTitleISchoolStatusId]                       INT             NULL,
	[RefNSLPStatusId]                       INT             NULL,
	[RefSchoolDangerousStatusId]                       INT             NULL,
	[RefSchoolImprovementStatusId]                       INT             NULL,
	[RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId]                       INT             NULL,
	[RefComprehensiveAndTargetedSupportId]                       INT             NULL,
	[RefComprehensiveSupportId]                       INT             NULL,
	[RefTargetedSupportId]                       INT             NULL,
	[RefNationalSchoolLunchProgramStatusId]                       INT             NULL,
	[RefVirtualSchoolStatusId]                       INT             NULL,
	[RefBlendedLearningModelTypeId]                       INT             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_PK_K12SchoolStatus1] PRIMARY KEY CLUSTERED ([K12SchoolStatusId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[K12SchoolStatus])
	BEGIN
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_K12SchoolStatus] ON;
		INSERT INTO [dbo].[tmp_ms_xx_K12SchoolStatus] ([K12SchoolStatusId], [K12SchoolId], [ConsolidatedMepFundsStatus], [ProgressAcheivingEnglishLearnerProficiencyStateDefinedStatus], [RefMagnetSpecialProgramId], [RefAlternativeSchoolFocusId], [RefInternetAccessId], [RefRestructuringActionId], [RefTitleISchoolStatusId], [RefNSLPStatusId], [RefSchoolDangerousStatusId], [RefSchoolImprovementStatusId], [RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId], [RefComprehensiveAndTargetedSupportId], [RefComprehensiveSupportId], [RefTargetedSupportId], [RefNationalSchoolLunchProgramStatusId], [RefVirtualSchoolStatusId], [RefBlendedLearningModelTypeId], [RecordStartDateTime], [RecordEndDateTime])
		SELECT   
				 [K12SchoolStatusId],
				 [K12SchoolId],
				 [ConsolidatedMepFundsStatus],
				 [ProgressAcheivingEnglishLearnerProficiencyStateDefinedStatus],
				 [RefMagnetSpecialProgramId],
				 [RefAlternativeSchoolFocusId],
				 [RefInternetAccessId],
				 [RefRestructuringActionId],
				 [RefTitleISchoolStatusId],
				 [RefNSLPStatusId],
				 [RefSchoolDangerousStatusId],
				 [RefSchoolImprovementStatusId],
				 [RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId],
				 [RefComprehensiveAndTargetedSupportId],
				 [RefComprehensiveSupportId],
				 [RefTargetedSupportId],
				 [RefNationalSchoolLunchProgramStatusId],
				 [RefVirtualSchoolStatusId],
				 [RefBlendedLearningModelTypeId],
				 [RecordStartDateTime],
				 [RecordEndDateTime]
		FROM     [dbo].[K12SchoolStatus]
		ORDER BY [K12SchoolStatusId] ASC;
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_K12SchoolStatus] OFF;
	END

DROP TABLE [dbo].[K12SchoolStatus];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_K12SchoolStatus]', N'K12SchoolStatus';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_K12SchoolStatus1]', N'PK_K12SchoolStatus', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


END