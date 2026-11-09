CREATE VIEW [RDS].[vwSignificantDisproportionality_Membership] AS
  

--================================================================================================
-- Membership
--================================================================================================
WITH
MembershipData 
AS
	(
		SELECT		Fact.FactK12StudentCountId
					,Fact.K12StudentId
					,Fact.SchoolYearId
					,Fact.LeaId
					,LEAs.LeaIdentifierSea
					,LEAs.LeaIdentifierNces
					,Fact.RaceId
					,Fact.IdeaStatusId			
					,Fact.GradeLevelId
					,Fact.AgeId
					,1 AS MembershipStudentCount

 		FROM		RDS.FactK12StudentCounts			Fact
		JOIN		RDS.DimSchoolYears					SchoolYears			ON Fact.SchoolYearId			= SchoolYears.DimSchoolYearId	
		LEFT JOIN	RDS.DimAges							Ages				ON Fact.AgeId					= Ages.DimAgeId      
		LEFT JOIN	RDS.DimGradeLevels					Grades				ON Fact.GradeLevelId			= Grades.DimGradeLevelId
		LEFT JOIN	RDS.DimLeas							LEAs				ON Fact.LeaId					= LEAs.DimLeaId

		WHERE 1 = 1
		AND Fact.FactTypeId = 6
		
		AND Ages.AgeValue >= 3 and Ages.AgeValue <= 21
		AND Grades.GradeLevelEdFactsCode in ('UG', 'AE','PK','KG','01','02','03','04','05','06','07','08','09','10','11','12', '13')  
		--and SchoolYear = 2023

	
	)

	SELECT	*
			
	FROM	MembershipData			AS membership