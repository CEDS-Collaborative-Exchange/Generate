CREATE VIEW RDS.vwDimComprehensiveSupportReasonApplicabilities
AS
	SELECT csr.DimComprehensiveSupportReasonApplicabilityId
		, rsy.SchoolYear
		, csr.ComprehensiveSupportReasonApplicabilityCode
		, ssrd.InputCode AS [ComprehensiveSupportReasonApplicabilityMap]
	FROM RDS.DimComprehensiveSupportReasonApplicabilities csr
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData ssrd
		ON csr.ComprehensiveSupportReasonApplicabilityCode = ssrd.OutputCode
		AND ssrd.TableName = 'RefComprehensiveSupportReasonApplicability'
		AND rsy.SchoolYear = ssrd.SchoolYear
