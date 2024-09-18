CREATE PROCEDURE [RDS].[Migrate_DimComprehensiveAndTargetedSupport_School]
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
		--ISNULL(cts.Code,'MISSING')	AS ComprehensiveAndTargetedSupportCode,
		ISNULL(csi.Code,'MISSING')	AS ComprehensiveSupportImprovementCode,
		ISNULL(tsi.Code,'MISSING')	AS TargetedSupportImprovementCode,
		ISNULL(cs.Code, 'MISSING')	AS ComprehensiveSupportCode,
		ISNULL(ts.Code, 'MISSING')	AS TargetedSupportCode,
		ISNULL(ats.Code, 'MISSING')	AS AdditionalTargetedSupportCode		
	FROM @orgDates org
	INNER JOIN rds.DimSchools s ON org.DimSchoolId = s.DimSchoolId 
	INNER JOIN ods.OrganizationIdentifier oi ON s.SchoolStateIdentifier = oi.Identifier 
				AND oi.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
				AND oi.RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId
	INNER JOIN ods.K12School sch ON  sch.OrganizationId = oi.OrganizationId
	INNER JOIN ods.K12SchoolStatus k12status ON k12status.K12SchoolId = sch.K12SchoolId
				AND	org.SubmissionYearStartDate <= ISNULL(k12status.RecordEndDateTime, GETDATE())
				AND k12status.RecordStartDateTime <= org.SubmissionYearEndDate
	--LEFT JOIN ods.RefComprehensiveAndTargetedSupport cts ON cts.RefComprehensiveAndTargetedSupportId=k12status.RefComprehensiveAndTargetedSupportId
	LEFT JOIN ods.RefComprehensiveSupportImprovement csi ON csi.RefComprehensiveSupportImprovementId=k12status.RefComprehensiveSupportImprovementId
	LEFT JOIN ods.RefTargetedSupportImprovement tsi ON tsi.RefTargetedSupportImprovementId=k12status.RefTargetedSupportImprovementId
	LEFT JOIN ods.RefComprehensiveSupport cs ON cs.RefComprehensiveSupportId=k12status.RefComprehensiveSupportId
	LEFT JOIN ods.RefTargetedSupport ts ON ts.RefTargetedSupportId=k12status.RefTargetedSupportId
	LEFT JOIN ods.RefAdditionalTargetedSupport ats ON ats.RefAdditionalTargetedSupportId=k12status.RefAdditionalTargetedSupportId
	GROUP BY s.DimSchoolId,  org.DimCountDateId, k12status.RecordStartDateTime, csi.Code, cs.Code, ts.Code,tsi.Code,ats.Code
	HAVING (k12status.RecordStartDateTime = MAX(k12status.RecordStartDateTime))
END