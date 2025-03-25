CREATE VIEW Staging.vwChildCount_StagingTables_C089
AS
	WITH excludedLeas AS (
		SELECT DISTINCT LEAIdentifierSea
		FROM Staging.K12Organization
		WHERE LEA_IsReportedFederally = 0
			OR LEA_OperationalStatus in ('Closed', 'FutureAgency', 'Inactive', 'MISSING', 'Closed_1', 'FutureAgency_1', 'Inactive_1')
	)
	--Get the data needed for the tests
	SELECT  
		StudentIdentifierState,
		LeaIdentifierSeaAccountability,
		IDEAEducationalEnvironmentForEarlyChildhood,
		CalculatedAge AS Age,
		GradeLevel,
		SchoolYear,
		CASE IdeaDisabilityTypeCode
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
			WHEN 'Autism_1' THEN 'AUT'
			WHEN 'Deafblindness_1' THEN 'DB'
			WHEN 'Deafness_1' THEN 'DB'
			WHEN 'Developmentaldelay_1' THEN 'DD'
			WHEN 'Emotionaldisturbance_1' THEN 'EMN'
			WHEN 'Hearingimpairment_1' THEN 'HI'
			WHEN 'Intellectualdisability_1' THEN 'ID'
			WHEN 'Multipledisabilities_1' THEN 'MD'
			WHEN 'Orthopedicimpairment_1' THEN 'OI'
			WHEN 'Otherhealthimpairment_1' THEN 'OHI'
			WHEN 'Specificlearningdisability_1' THEN 'SLD'
			WHEN 'Speechlanguageimpairment_1' THEN 'SLI'
			WHEN 'Traumaticbraininjury_1' THEN 'TBI'
			WHEN 'Visualimpairment_1' THEN 'VI'
			ELSE IdeaDisabilityTypeCode
		END AS IdeaDisabilityType,
		CASE 	
			WHEN MAX(CAST(HispanicLatinoEthnicity AS INT)) = 1 THEN 'HI7' 
			WHEN COUNT(RaceType) > 1 THEN 'MU7'
			WHEN MAX(RaceType) = 'AmericanIndianorAlaskaNative' THEN 'AM7'
			WHEN MAX(RaceType) = 'Asian' THEN 'AS7'
			WHEN MAX(RaceType) = 'BlackorAfricanAmerican' THEN 'BL7'
			WHEN MAX(RaceType) = 'NativeHawaiianorOtherPacificIslander' THEN 'PI7'
			WHEN MAX(RaceType) = 'White' THEN 'WH7'
			WHEN MAX(RaceType) = 'TwoorMoreRaces' THEN 'MU7'
			WHEN MAX(RaceType) = 'AmericanIndianorAlaskaNative_1' THEN 'AM7'
			WHEN MAX(RaceType) = 'Asian_1' THEN 'AS7'
			WHEN MAX(RaceType) = 'BlackorAfricanAmerican_1' THEN 'BL7'
			WHEN MAX(RaceType) = 'NativeHawaiianorOtherPacificIslander_1' THEN 'PI7'
			WHEN MAX(RaceType) = 'White_1' THEN 'WH7'
			WHEN MAX(RaceType) = 'TwoorMoreRaces_1' THEN 'MU7'
		END AS Race,
		CASE Sex
				WHEN 'Male' THEN 'M'
				WHEN 'Female' THEN 'F'
				WHEN 'Male_1' THEN 'M'
				WHEN 'Female_1' THEN 'F'
				ELSE 'MISSING'
		END AS Sex,
		CASE 
			WHEN EnglishLearnerStatus = 1 THEN 'LEP'
			ELSE 'NLEP'
		END AS EnglishLearnerStatus
FROM [Debug].[vwChildCount_StagingTables] vw
LEFT JOIN excludedLeas el
	ON vw.LEAIdentifierSeaAccountability = el.LeaIdentifierSea
LEFT JOIN excludeDD dd
	ON vw.K12StudentId = dd.K12StudentId
WHERE el.LeaIdentifierSea IS NULL
AND IDEAIndicator = 1
AND (CalculatedAge BETWEEN 3 and 4
	OR (CalculatedAge = 5
		AND GradeLevel IS NULL 
		AND GradeLevel IN ('PK', 'PK_1')))
GROUP BY
		StudentIdentifierState
	, LeaIdentifierSeaAccountability
	, vw.SchoolIdentifierSea
	, SchoolYear
	, Sex
	, CalculatedAge
	, IdeaDisabilityTypeCode
	, CalculatedAge
	, IDEAEducationalEnvironmentForEarlyChildhood
	, GradeLevel
	, EnglishLearnerStatus
