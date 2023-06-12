CREATE VIEW rds.vwDimIdeaDisabilityTypes 
AS
	SELECT
		DimIdeaDisabilityTypeId
		, rsy.SchoolYear
		, rdidt.IdeaDisabilityTypeCode
		, CASE rdidt.IdeaDisabilityTypeCode 
			WHEN 'Autism' THEN 'AUT'
			WHEN 'Deafblindness' THEN 'DB'
			WHEN 'Deafness' THEN 'DB'
			WHEN 'Developmentaldelay' THEN 'DD'
			WHEN 'Emotionaldisturbance' THEN 'EMN'
			WHEN 'Hearingimpairment' THEN 'HI'
			WHEN 'Intellectualdisability' THEN 'ID'
			WHEN 'Multipledisabilities' THEN 'MD'
			WHEN 'Orthopedicimpairment' THEN 'OI'
			WHEN 'Otherhealthimpairment' THEN 'OHI'
			WHEN 'Specificlearningdisability' THEN 'SLD'
			WHEN 'Speechlanguageimpairment' THEN 'SLI'
			WHEN 'Traumaticbraininjury' THEN 'TBI'
			WHEN 'Visualimpairment' THEN 'VI'
			ELSE 'MISSING'
		  END AS IdeaDisabilityTypeMap
--		sssrd.InputCode AS IdeaDisabilityTypeMap
	FROM rds.DimIdeaDisabilityTypes rdidt
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
/* we can add this back in when we have the IDEA Disability Type vs Primary Disability Type decided */
	-- LEFT JOIN staging.SourceSystemReferenceData sssrd
	-- 	ON rdidt.IdeaDisabilityTypeCode = sssrd.OutputCode
	-- 	AND sssrd.TableName = 'RefIDEADisabilityType'
	-- 	AND rsy.SchoolYear = sssrd.SchoolYear



