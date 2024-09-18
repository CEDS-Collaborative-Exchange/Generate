-- Metadata changes for the RDS schema
----------------------------------
set nocount on
begin try
	begin transaction	
		
		Update f set K12DemographicId = DimK12DemographicId
		from rds.FactK12StudentCounts f
		inner join 
			(select k12demographics.DimK12DemographicId, v8Facts.DimDemographicId as v8DemographicId 
			from rds.DimK12Demographics k12demographics
			inner join
			(SELECT distinct 
				CASE WHEN EcoDisStatusCode = 'EconomicDisadvantage' THEN 'Yes' ELSE EcoDisStatusCode END as EcoDisStatusCode, 
				CASE WHEN HomelessStatusCode = 'Homeless' THEN 'Yes' ELSE HomelessStatusCode END as HomelessStatusCode, 
				LepStatusCode, 
				CASE WHEN MigrantStatusCode = 'Migrant' THEN 'Yes' ELSE MigrantStatusCode END as MigrantStatusCode, 
				MilitaryConnectedStatusCode, 
				HomelessNighttimeResidenceCode,
				HomelessUnaccompaniedYouthStatusCode, 
				v8Demographics.DimDemographicId
			FROM rds.FactK12StudentCounts f
			inner join cedsv8.DimDemographics v8Demographics on f.K12DemographicId = v8Demographics.DimDemographicId) v8Facts 
		on k12demographics.EconomicDisadvantageStatusCode = v8Facts.EcoDisStatusCode
		AND k12demographics.HomelessnessStatusCode = v8Facts.HomelessStatusCode
		AND k12demographics.EnglishLearnerStatusEdFactsCode = v8Facts.LepStatusCode
		AND k12demographics.MigrantStatusCode = v8Facts.MigrantStatusCode
		AND k12demographics.MilitaryConnectedStudentIndicatorEdFactsCode = v8Facts.MilitaryConnectedStatusCode
		AND k12demographics.HomelessPrimaryNighttimeResidenceEdFactsCode = v8Facts.HomelessNighttimeResidenceCode
		AND k12demographics.HomelessUnaccompaniedYouthStatusEdFactsCode = v8Facts.HomelessUnaccompaniedYouthStatusCode) facts
		on f.K12DemographicId = facts.v8DemographicId


		Update f set K12DemographicId = DimK12DemographicId
		from rds.FactK12StudentAssessments f
		inner join 
			(select k12demographics.DimK12DemographicId, v8Facts.DimDemographicId as v8DemographicId 
			from rds.DimK12Demographics k12demographics
			inner join
			(SELECT distinct 
				CASE WHEN EcoDisStatusCode = 'EconomicDisadvantage' THEN 'Yes' ELSE EcoDisStatusCode END as EcoDisStatusCode, 
				CASE WHEN HomelessStatusCode = 'Homeless' THEN 'Yes' ELSE HomelessStatusCode END as HomelessStatusCode, 
				LepStatusCode, 
				CASE WHEN MigrantStatusCode = 'Migrant' THEN 'Yes' ELSE MigrantStatusCode END as MigrantStatusCode, 
				MilitaryConnectedStatusCode, 
				HomelessNighttimeResidenceCode,
				HomelessUnaccompaniedYouthStatusCode, 
				v8Demographics.DimDemographicId
			FROM rds.FactK12StudentAssessments f
			inner join cedsv8.DimDemographics v8Demographics on f.K12DemographicId = v8Demographics.DimDemographicId) v8Facts 
		on k12demographics.EconomicDisadvantageStatusCode = v8Facts.EcoDisStatusCode
		AND k12demographics.HomelessnessStatusCode = v8Facts.HomelessStatusCode
		AND k12demographics.EnglishLearnerStatusEdFactsCode = v8Facts.LepStatusCode
		AND k12demographics.MigrantStatusCode = v8Facts.MigrantStatusCode
		AND k12demographics.MilitaryConnectedStudentIndicatorEdFactsCode = v8Facts.MilitaryConnectedStatusCode
		AND k12demographics.HomelessPrimaryNighttimeResidenceEdFactsCode = v8Facts.HomelessNighttimeResidenceCode
		AND k12demographics.HomelessUnaccompaniedYouthStatusEdFactsCode = v8Facts.HomelessUnaccompaniedYouthStatusCode) facts
		on f.K12DemographicId = facts.v8DemographicId

		Update f set K12DemographicId = DimK12DemographicId
		from rds.FactK12StudentAttendance f
		inner join 
			(select k12demographics.DimK12DemographicId, v8Facts.DimDemographicId as v8DemographicId 
			from rds.DimK12Demographics k12demographics
			inner join
			(SELECT distinct 
				CASE WHEN EcoDisStatusCode = 'EconomicDisadvantage' THEN 'Yes' ELSE EcoDisStatusCode END as EcoDisStatusCode, 
				CASE WHEN HomelessStatusCode = 'Homeless' THEN 'Yes' ELSE HomelessStatusCode END as HomelessStatusCode, 
				LepStatusCode, 
				CASE WHEN MigrantStatusCode = 'Migrant' THEN 'Yes' ELSE MigrantStatusCode END as MigrantStatusCode, 
				MilitaryConnectedStatusCode, 
				HomelessNighttimeResidenceCode,
				HomelessUnaccompaniedYouthStatusCode, 
				v8Demographics.DimDemographicId
			FROM rds.FactK12StudentAttendance f
			inner join cedsv8.DimDemographics v8Demographics on f.K12DemographicId = v8Demographics.DimDemographicId) v8Facts 
		on k12demographics.EconomicDisadvantageStatusCode = v8Facts.EcoDisStatusCode
		AND k12demographics.HomelessnessStatusCode = v8Facts.HomelessStatusCode
		AND k12demographics.EnglishLearnerStatusEdFactsCode = v8Facts.LepStatusCode
		AND k12demographics.MigrantStatusCode = v8Facts.MigrantStatusCode
		AND k12demographics.MilitaryConnectedStudentIndicatorEdFactsCode = v8Facts.MilitaryConnectedStatusCode
		AND k12demographics.HomelessPrimaryNighttimeResidenceEdFactsCode = v8Facts.HomelessNighttimeResidenceCode
		AND k12demographics.HomelessUnaccompaniedYouthStatusEdFactsCode = v8Facts.HomelessUnaccompaniedYouthStatusCode) facts
		on f.K12DemographicId = facts.v8DemographicId

		Update f set K12DemographicId = DimK12DemographicId
		from rds.FactK12StudentDisciplines f
		inner join 
			(select k12demographics.DimK12DemographicId, v8Facts.DimDemographicId as v8DemographicId 
			from rds.DimK12Demographics k12demographics
			inner join
			(SELECT distinct 
				CASE WHEN EcoDisStatusCode = 'EconomicDisadvantage' THEN 'Yes' ELSE EcoDisStatusCode END as EcoDisStatusCode, 
				CASE WHEN HomelessStatusCode = 'Homeless' THEN 'Yes' ELSE HomelessStatusCode END as HomelessStatusCode, 
				LepStatusCode, 
				CASE WHEN MigrantStatusCode = 'Migrant' THEN 'Yes' ELSE MigrantStatusCode END as MigrantStatusCode, 
				MilitaryConnectedStatusCode, 
				HomelessNighttimeResidenceCode,
				HomelessUnaccompaniedYouthStatusCode, 
				v8Demographics.DimDemographicId
			FROM rds.FactK12StudentDisciplines f
			inner join cedsv8.DimDemographics v8Demographics on f.K12DemographicId = v8Demographics.DimDemographicId) v8Facts 
		on k12demographics.EconomicDisadvantageStatusCode = v8Facts.EcoDisStatusCode
		AND k12demographics.HomelessnessStatusCode = v8Facts.HomelessStatusCode
		AND k12demographics.EnglishLearnerStatusEdFactsCode = v8Facts.LepStatusCode
		AND k12demographics.MigrantStatusCode = v8Facts.MigrantStatusCode
		AND k12demographics.MilitaryConnectedStudentIndicatorEdFactsCode = v8Facts.MilitaryConnectedStatusCode
		AND k12demographics.HomelessPrimaryNighttimeResidenceEdFactsCode = v8Facts.HomelessNighttimeResidenceCode
		AND k12demographics.HomelessUnaccompaniedYouthStatusEdFactsCode = v8Facts.HomelessUnaccompaniedYouthStatusCode) facts
		on f.K12DemographicId = facts.v8DemographicId

		Update f set NOrDProgramStatusId = DimNorDProgramStatusId
		from rds.FactK12StudentCounts f
		inner join 
			(select dimNOrD.DimNorDProgramStatusId, v8Facts.DimNorDProgramStatusId as v8NorDProgramStatusId
			from rds.DimNOrDProgramStatuses dimNOrD
			inner join
			(SELECT distinct  LongTermStatusCode, NeglectedProgramTypeCode, v8NOrD.DimNorDProgramStatusId
			FROM rds.FactK12StudentCounts f
			inner join cedsv8.DimNorDProgramStatuses v8NOrD on f.NOrDProgramStatusId = v8NOrD.DimNorDProgramStatusId) v8Facts 
		on dimNOrD.LongTermStatusCode = v8Facts.LongTermStatusCode
		AND dimNOrD.NeglectedOrDelinquentProgramTypeCode = v8Facts.NeglectedProgramTypeCode
		) facts
		on f.NOrDProgramStatusId = facts.v8NorDProgramStatusId

		Update f set NOrDProgramStatusId = DimNorDProgramStatusId
		from rds.FactK12StudentAssessments f
		inner join 
			(select dimNOrD.DimNorDProgramStatusId, v8Facts.DimNorDProgramStatusId as v8NorDProgramStatusId
			from rds.DimNOrDProgramStatuses dimNOrD
			inner join
			(SELECT distinct  LongTermStatusCode, NeglectedProgramTypeCode, v8NOrD.DimNorDProgramStatusId
			FROM rds.FactK12StudentAssessments f
			inner join cedsv8.DimNorDProgramStatuses v8NOrD on f.NOrDProgramStatusId = v8NOrD.DimNorDProgramStatusId) v8Facts 
		on dimNOrD.LongTermStatusCode = v8Facts.LongTermStatusCode
		AND dimNOrD.NeglectedOrDelinquentProgramTypeCode = v8Facts.NeglectedProgramTypeCode
		) facts
		on f.NOrDProgramStatusId = facts.v8NorDProgramStatusId

		IF NOT EXISTS (SELECT 1 FROM RDS.DimFactTypes WHERE FactTypeCode = 'CompSupport')
		BEGIN
			INSERT INTO RDS.DimFactTypes VALUES ('compsupport','Comprehensive Support Identification Type')
		END


	commit transaction
end try
 
begin catch
	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end
	declare @msg as nvarchar(max)
	set @msg = ERROR_MESSAGE()
	declare @sev as int
	set @sev = ERROR_SEVERITY()
	RAISERROR(@msg, @sev, 1)
end catch
 
set nocount off