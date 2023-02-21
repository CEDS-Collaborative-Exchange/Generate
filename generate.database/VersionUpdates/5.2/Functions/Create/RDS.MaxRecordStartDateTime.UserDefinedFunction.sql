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
	-- Add the column definitions for the TABLE variable h ere

		OrganizationIdentifierState varchar(10),	
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
					SELECT max(RecordStartDateTime) as maxDate, LeaIdentifierState 
					FROM RDS.DimLeas 
					WHERE RecordStartDateTime between @StartDate and @EndDate
					GROUP BY LeaIdentifierState
			)
			-- Fill the table variable with the rows for your result set
				-- Get the Max record for this school year
				INSERT INTO @MaxRecordStartDateTime				
				SELECT d.LeaIdentifierState, d.OperationalStatusEffectiveDate,d.LeaTypeDescription, d.LeaOperationalStatusEdFactsCode, d.ReconstitutedStatus, d.CharterLeaStatus, d.RecordStartDateTime, d.RecordEndDateTime
				FROM RDS.DimLeas d
				LEFT JOIN MaxDateCTE dl on (d.LeaIdentifierState = dl.LeaIdentifierState AND d.RecordStartDateTime = dl.maxDate )
				WHERE RecordStartDateTime between @StartDate and @EndDate and dl.maxDate is not null
		END
	if @OrganizationType = 'K12School'
		BEGIN
			;WITH MaxDateCTE AS (
					-- Get the Max record for this school year
					SELECT max(RecordStartDateTime) as maxDate, SchoolIdentifierState 
					FROM rds.DimK12Schools schDir 
					WHERE RecordStartDateTime between @StartDate and @EndDate
					GROUP BY SchoolIdentifierState
			)
			-- Fill the table variable with the rows for your result set
				-- Get the Max record for this school year
				INSERT INTO @MaxRecordStartDateTime				
				SELECT d.SchoolIdentifierState, d.SchoolOperationalStatusEffectiveDate, d.SchoolTypeDescription, d.SchoolTypeEdFactsCode, d.ReconstitutedStatus, d.CharterSchoolStatus, d.RecordStartDateTime, d.RecordEndDateTime
				FROM RDS.DimK12Schools d
				LEFT JOIN MaxDateCTE dl on (d.SchoolIdentifierState = dl.SchoolIdentifierState AND d.RecordStartDateTime = dl.maxDate )
				WHERE RecordStartDateTime between @StartDate and @EndDate and dl.maxDate is not null
		END

		if @OrganizationType = 'Charter'
		BEGIN
			;WITH MaxDateCTE AS (
					-- Get the Max record for this school year
					SELECT max(RecordStartDateTime) as maxDate, StateIdentifier 
					FROM rds.DimCharterSchoolManagementOrganizations dcsaa
					WHERE RecordStartDateTime between @StartDate and @EndDate
					GROUP BY StateIdentifier
			)
			-- Fill the table variable with the rows for your result set
				-- Get the Max record for this school year
				INSERT INTO @MaxRecordStartDateTime				
				SELECT d.StateIdentifier, NULL, d.CharterSchoolManagementOrganizationTypeDescription, NULL, NULL, NULL, d.RecordStartDateTime, d.RecordEndDateTime
				FROM rds.DimCharterSchoolManagementOrganizations d
				LEFT JOIN MaxDateCTE dl on (d.StateIdentifier = dl.StateIdentifier AND d.RecordStartDateTime = dl.maxDate )
				WHERE RecordStartDateTime between @StartDate and @EndDate and dl.maxDate is not null
		END

	
	RETURN 
END