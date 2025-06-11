CREATE PROCEDURE [RDS].[Migrate_DimComprehensiveSupportIdentificationType_School]
	@orgDates as SchoolDateTableType READONLY
AS
BEGIN
	-- School Identifer
	DECLARE @schoolIdentifierTypeId AS INT

	SELECT @schoolIdentifierTypeId = RefOrganizationIdentifierTypeId
	FROM  ods.RefOrganizationIdentifierType
	WHERE [Code] = '001073'
	
	--School State Identifer
	DECLARE @schoolSEAIdentificationSystemId AS INT

	SELECT	@schoolSEAIdentificationSystemId = RefOrganizationIdentificationSystemId
	FROM	ods.RefOrganizationIdentificationSystem
	WHERE	[Code] = 'SEA'
	AND		RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId

	SELECT 
		org.DimCountDateId, 
		s.DimSchoolId,
		ISNULL(cs.Code, 'MISSING')	AS ComprehensiveSupportCode,
		ISNULL(csra.Code, 'MISSING')	AS ComprehensiveSupportReasonApplicabilityCode		
	FROM @orgDates org
	INNER JOIN RDS.DimSchools s ON org.DimSchoolId = s.DimSchoolId
	INNER JOIN ODS.OrganizationIdentifier oi ON s.SchoolStateIdentifier = oi.Identifier 
				AND oi.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
				AND oi.RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId
	INNER JOIN ODS.K12School sch ON  sch.OrganizationId = oi.OrganizationId
	INNER JOIN [dbo].[K12SchoolComprehensiveSupportIdentificationType] k12 ON sch.K12SchoolId = k12.K12SchoolId
				AND org.SubmissionYearStartDate <= ISNULL(k12.RecordEndDateTime, GETDATE())
				AND k12.RecordStartDateTime <= org.SubmissionYearEndDate
	LEFT JOIN ODS.RefComprehensiveSupport cs on k12.RefComprehensiveSupportId = cs.RefComprehensiveSupportId
	LEFT JOIN dbo.RefComprehensiveSupportReasonApplicability csra on k12.RefComprehensiveSupportReasonApplicabilityId = csra.RefComprehensiveSupportReasonApplicabilityId
	GROUP BY s.DimSchoolId, org.DimCountDateId, k12.RecordStartDateTime, cs.Code, csra.Code
	HAVING (k12.RecordStartDateTime = MAX(k12.RecordStartDateTime))
END


