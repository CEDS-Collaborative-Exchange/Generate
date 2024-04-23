CREATE VIEW [debug].[vwTitleIIIELSY_StagingTables] 
AS
	SELECT	DISTINCT 
		enrollment.StudentIdentifierState
		, enrollment.LEAIdentifierSeaAccountability
		, enrollment.SchoolIdentifierSea
		, enrollment.FirstName
		, enrollment.LastOrSurname
		, enrollment.MiddleName

	FROM Staging.K12Enrollment								enrollment		

	WHERE 1 = 1
