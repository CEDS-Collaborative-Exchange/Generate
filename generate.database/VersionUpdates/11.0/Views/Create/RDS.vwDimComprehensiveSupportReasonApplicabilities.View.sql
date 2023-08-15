CREATE VIEW RDS.vwDimComprehensiveSupportReasonApplicabilities
AS
	SELECT csr.DimComprehensiveSupportReasonApplicabilityId
		,rsy.SchoolYear
		,csr.ComprehensiveSupportReasonApplicabilityCode
		,[ComprehensiveSupportReasonApplicabilityMap] = ISNULL(ssrd.InputCode,'MISSING')
	FROM RDS.DimComprehensiveSupportReasonApplicabilities csr
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData ssrd
		ON csr.ComprehensiveSupportReasonApplicabilityCode = ssrd.OutputCode
		AND ssrd.TableName = 'RefComprehensiveSupportReasonApplicability'
		AND rsy.SchoolYear = ssrd.SchoolYear
