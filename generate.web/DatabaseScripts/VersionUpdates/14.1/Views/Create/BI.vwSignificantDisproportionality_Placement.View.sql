CREATE VIEW [BI].[vwSignificantDisproportionality_Placement] AS

--================================================================================================
-- Placement Child Count
--================================================================================================

SELECT 
	fsc.SchoolYearId, 
	dl.LeaIdentifierSea, 
	fsc.RaceId,
	fsc.GradeLevelId,
	fsc.PrimaryDisabilityTypeID,
	fsc.K12StudentId,
	dis.IdeaEducationalEnvironmentForSchoolAgeCode, 
	dis.IdeaEducationalEnvironmentForSchoolAgeDescription 
FROM 		RDS.FactK12StudentCounts 		fsc
INNER JOIN 	RDS.DimIdeaStatuses				dis					ON fsc.IdeaStatusId = dis.DimIdeaStatusId
INNER JOIN	RDS.DimIdeaDisabilityTypes		IDEAType			ON fsc.PrimaryDisabilityTypeId = IDEAType.DimIdeaDisabilityTypeId
LEFT JOIN	RDS.DimAges						Ages				ON fsc.AgeId					= Ages.DimAgeId      
LEFT JOIN 	RDS.DimLeas						dl					ON fsc.LeaId = dl.DimLeaId
WHERE 1 = 1
AND IDEAType.IdeaDisabilityTypeCode <> 'MISSING'
AND Ages.AgeValue >= 3 
AND Ages.AgeValue <= 21