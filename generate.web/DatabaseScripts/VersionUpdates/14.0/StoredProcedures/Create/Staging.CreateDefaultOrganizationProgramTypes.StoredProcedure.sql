CREATE PROCEDURE [Staging].[CreateDefaultOrganizationProgramTypes]
AS
BEGIN

	CREATE TABLE #programs (
		ProgramType VARCHAR(10),
		OrganizationName VARCHAR(1000)
		)

	INSERT INTO #programs VALUES ('04888', NULL)
	INSERT INTO #programs VALUES ('04906', NULL)
	INSERT INTO #programs VALUES ('77000', NULL)
	INSERT INTO #programs VALUES ('76000', NULL)
	INSERT INTO #programs VALUES ('04967', NULL)
	INSERT INTO #programs VALUES ('04957', NULL)
	INSERT INTO #programs VALUES ('75000', NULL)
	INSERT INTO #programs VALUES ('75001', 'Title I Program')
	INSERT INTO #programs VALUES ('09999', 'Neglected or Delinquent Program')

	TRUNCATE TABLE Staging.OrganizationProgramType

	DECLARE @LeaOrgType VARCHAR(20), @SchoolOrgType VARCHAR(20)

	SELECT @LeaOrgType = InputCode
	FROM Staging.SourceSystemReferenceData
	WHERE TableName = 'RefOrganizationType'
		AND TableFilter = '001156'
		AND OutputCode = 'LEA'

	SELECT @SchoolOrgType = InputCode
	FROM Staging.SourceSystemReferenceData
	WHERE TableName = 'RefOrganizationType'
		AND TableFilter = '001156'
		AND OutputCode = 'K12School'

	INSERT INTO Staging.OrganizationProgramType
	(
		  OrganizationIdentifier
		, OrganizationType
		, OrganizationName
		, ProgramType
		, RecordStartDateTime
		, RecordEndDateTime
		, SchoolYear
	)
	SELECT DISTINCT
		  so.LEA_Identifier_State
		, @LeaOrgType
		, p.OrganizationName
		, p.ProgramType
		, so.LEA_RecordStartDateTime
		, so.LEA_RecordEndDateTime
		, so.SchoolYear
	FROM Staging.K12Organization so
	CROSS JOIN #programs p


	INSERT INTO Staging.OrganizationProgramType
	(
		  OrganizationIdentifier
		, OrganizationType
		, OrganizationName
		, ProgramType
		, RecordStartDateTime
		, RecordEndDateTime
		, SchoolYear
	)
	SELECT DISTINCT
		  so.School_Identifier_State
		, @SchoolOrgType
		, p.OrganizationName
		, p.ProgramType
		, so.School_RecordStartDateTime
		, so.School_RecordEndDateTime
		, so.SchoolYear
	FROM Staging.K12Organization so
	CROSS JOIN #programs p


	DROP TABLE #programs
END