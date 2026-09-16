CREATE FUNCTION [RDS].[MaxRecordStartDateTime]
(
	-- Add the parameters for the function here
		@SchoolYear SMALLINT,
		@OrganizationType varchar(10),
		@StartDate DATE,
		@EndDate DATE
)
RETURNS 
@MaxRecordStartDateTime TABLE 
(
	-- Add the column definitions for the TABLE variable here
		OrganizationIdentifierState varchar(100),	
		OrganizationOperationalStatusEffectiveDate datetime2(7),
		OrganizationTypeDescription nvarchar(100),
        OrganizationTypeEdFactsCode nvarchar(50),
        ReconstitutedStatus varchar(50),
		CharterStatus varchar(50),
		RecordStartDateTime datetime2(7),
		RecordEndDateTime datetime2(7)
)
AS

BEGIN
	
	if @OrganizationType = 'LEA'
		BEGIN
			;WITH MaxDateCTE AS (
					-- Get the Max record for this school year
					SELECT max(RecordStartDateTime) as maxDate, LeaIdentifierSea 
					FROM RDS.DimLeas 
					WHERE RecordStartDateTime between @StartDate and @EndDate
					GROUP BY LeaIdentifierSea
			)
			-- Fill the table variable with the rows for your result set
				-- Get the Max record for this school year
				INSERT INTO @MaxRecordStartDateTime				
				SELECT d.LeaIdentifierSea
					, d.OperationalStatusEffectiveDate
					, d.LeaTypeDescription
					, d.LeaTypeEdFactsCode
					, d.ReconstitutedStatus
					, d.CharterLeaStatus
					, d.RecordStartDateTime
					, d.RecordEndDateTime
				FROM RDS.DimLeas d
				LEFT JOIN MaxDateCTE dl 
					ON (d.LeaIdentifierSea = dl.LeaIdentifierSea 
					AND d.RecordStartDateTime = dl.maxDate )
				WHERE RecordStartDateTime between @StartDate and @EndDate 
				AND dl.maxDate is not null
		END
	if @OrganizationType = 'K12School'
		BEGIN
			;WITH MaxDateCTE AS (
					-- Get the Max record for this school year
					SELECT max(RecordStartDateTime) as maxDate, SchoolIdentifierSea 
					FROM rds.DimK12Schools schDir 
					WHERE RecordStartDateTime between @StartDate and @EndDate
					GROUP BY SchoolIdentifierSea
			)
			-- Fill the table variable with the rows for your result set
				-- Get the Max record for this school year
				INSERT INTO @MaxRecordStartDateTime				
				SELECT d.SchoolIdentifierSea
					, d.SchoolOperationalStatusEffectiveDate
					, d.SchoolTypeDescription
					, d.SchoolTypeEdFactsCode
					, d.ReconstitutedStatus
					, d.CharterSchoolStatus
					, d.RecordStartDateTime
					, d.RecordEndDateTime
				FROM RDS.DimK12Schools d
				LEFT JOIN MaxDateCTE dl 
					ON (d.SchoolIdentifierSea = dl.SchoolIdentifierSea 
					AND d.RecordStartDateTime = dl.maxDate )
				WHERE RecordStartDateTime between @StartDate and @EndDate 
				AND dl.maxDate is not null
		END

		if @OrganizationType = 'Charter'
		BEGIN
			;WITH MaxDateCTE AS (
					-- Get the Max record for this school year
					SELECT max(RecordStartDateTime) as maxDate, CharterSchoolManagementOrganizationOrganizationIdentifierSea
					FROM rds.DimCharterSchoolManagementOrganizations dcsaa
					WHERE RecordStartDateTime between @StartDate and @EndDate
					GROUP BY CharterSchoolManagementOrganizationOrganizationIdentifierSea
			)
			-- Fill the table variable with the rows for your result set
				-- Get the Max record for this school year
				INSERT INTO @MaxRecordStartDateTime				
				SELECT d.CharterSchoolManagementOrganizationOrganizationIdentifierSea
					, NULL
					, d.CharterSchoolManagementOrganizationTypeDescription
					, NULL
					, NULL
					, NULL
					, d.RecordStartDateTime
					, d.RecordEndDateTime
				FROM rds.DimCharterSchoolManagementOrganizations d
				LEFT JOIN MaxDateCTE dl 
					ON (d.CharterSchoolManagementOrganizationOrganizationIdentifierSea = dl.CharterSchoolManagementOrganizationOrganizationIdentifierSea 
					AND d.RecordStartDateTime = dl.maxDate )
				WHERE RecordStartDateTime between @StartDate and @EndDate 
				AND dl.maxDate is not null
		END

	RETURN 

END