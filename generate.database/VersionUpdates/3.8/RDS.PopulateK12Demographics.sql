-- Release-Specific metadata for the RDS schema
-- e.g. dimension seed data
----------------------------------

set nocount on
begin try
 
	begin transaction

	-------- Insert new records in the added dimensions ---------------------------------------------------------

	CREATE TABLE #MilitaryConnectedStudentIndicator (MilitaryConnectedStudentIndicatorCode VARCHAR(50), MilitaryConnectedStudentIndicatorDescription VARCHAR(200), MilitaryConnectedStudentIndicatorEdFactsCode VARCHAR(50))

	INSERT INTO #MilitaryConnectedStudentIndicator VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #MilitaryConnectedStudentIndicator 
	SELECT 
		  Code
		, Description
		, CASE Code
			WHEN 'ActiveDuty' THEN 'MILCNCTD'
			WHEN 'NationalGuardOrReserve' THEN 'MILCNCTD'
			ELSE 'Missing'
		  END
	FROM dbo.RefMilitaryConnectedStudentIndicator

	CREATE TABLE #HomelessPrimaryNighttimeResidence (HomelessPrimaryNighttimeResidenceCode VARCHAR(50), HomelessPrimaryNighttimeResidenceDescription VARCHAR(200), HomelessPrimaryNighttimeResidenceEdFactsCode VARCHAR(50))

	INSERT INTO #HomelessPrimaryNighttimeResidence VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #HomelessPrimaryNighttimeResidence 
	SELECT 
		  Code
		, Description
		, CASE Code
			WHEN 'Shelters' THEN 'STH'
			WHEN 'DoubledUp' THEN 'D'
			WHEN 'Unsheltered' THEN 'U'
			WHEN 'HotelMotel' THEN 'HM'
		  END
	FROM dbo.RefHomelessNighttimeResidence


	INSERT INTO RDS.DimK12Demographics
		(
			  EconomicDisadvantageStatusCode
			, EconomicDisadvantageStatusDescription
			, EconomicDisadvantageStatusEdFactsCode
			, HomelessnessStatusCode
			, HomelessnessStatusDescription
			, HomelessnessStatusEdFactsCode
			, EnglishLearnerStatusCode
			, EnglishLearnerStatusDescription
			, EnglishLearnerStatusEdFactsCode
			, MigrantStatusCode
			, MigrantStatusDescription
			, MigrantStatusEdFactsCode
			, MilitaryConnectedStudentIndicatorCode
			, MilitaryConnectedStudentIndicatorDescription
			, MilitaryConnectedStudentIndicatorEdFactsCode
			, HomelessPrimaryNighttimeResidenceCode
			, HomelessPrimaryNighttimeResidenceDescription
			, HomelessPrimaryNighttimeResidenceEdFactsCode
			, HomelessUnaccompaniedYouthStatusCode
			, HomelessUnaccompaniedYouthStatusDescription
			, HomelessUnaccompaniedYouthStatusEdFactsCode
		)
	SELECT DISTINCT
		  EcoDis.Code
		, EcoDis.Description
		, EcoDis.EdFactsCode
		, Homeless.Code
		, Homeless.Description
		, Homeless.EdFactsCode
		, EL.Code
		, EL.Description
		, EL.EdFactsCode
		, Migrant.Code
		, Migrant.Description
		, Migrant.EdFactsCode
		, military.MilitaryConnectedStudentIndicatorCode
		, military.MilitaryConnectedStudentIndicatorDescription
		, military.MilitaryConnectedStudentIndicatorEdFactsCode
		, homelessres.HomelessPrimaryNighttimeResidenceCode
		, homelessres.HomelessPrimaryNighttimeResidenceDescription
		, homelessres.HomelessPrimaryNighttimeResidenceEdFactsCode
		, UnaccYouth.Code
		, UnaccYouth.Description
		, UnaccYouth.EdFactsCode
	FROM (VALUES('Yes', 'Economically Disadvantaged', 'ECODIS'),('No', 'Not Economoically Disadvantaged', 'MISSING'),('MISSING', 'MISSING', 'MISSING')) EcoDis(Code, Description, EdFactsCode)
	CROSS JOIN (VALUES('Yes', 'Homeless enrolled', 'HOMELSENRL'),('No', 'Not Homeless enrolled', 'MISSING'),('MISSING', 'MISSING', 'MISSING')) Homeless(Code, Description, EdFactsCode)
	CROSS JOIN (VALUES('LEP', 'Limited English proficient (LEP) Student', 'LEP'),('NLEP', 'Non-limited English proficient (non-LEP) Student', 'NLEP'),('LEPP', 'Perkins LEP Student', 'LEPP'),('MISSING', 'MISSING', 'MISSING')) EL(Code, Description, EdFactsCode)
	CROSS JOIN (VALUES('Yes', 'Migrant students', 'MS'),('No', 'Not a Migrant students', 'MISSING'),('MISSING', 'MISSING', 'MISSING')) Migrant(Code, Description, EdFactsCode)
	CROSS JOIN (VALUES('Yes', 'Unaccompanied Youth', 'UY'),('No', 'Not Unaccompanied Youth', 'MISSING'),('MISSING', 'MISSING', 'MISSING')) UnaccYouth(Code, Description, EdFactsCode)
	CROSS JOIN #MilitaryConnectedStudentIndicator military
	CROSS JOIN #HomelessPrimaryNighttimeResidence homelessres
	LEFT JOIN RDS.DimK12Demographics kd
		ON kd.EconomicDisadvantageStatusCode = EcoDis.Code
		AND kd.HomelessnessStatusCode = Homeless.Code
		AND kd.EnglishLearnerStatusCode = EL.Code
		AND kd.MigrantStatusCode = Migrant.Code
		AND kd.MilitaryConnectedStudentIndicatorCode = military.MilitaryConnectedStudentIndicatorCode
		AND kd.HomelessPrimaryNighttimeResidenceCode = homelessres.HomelessPrimaryNighttimeResidenceCode
		AND kd.HomelessUnaccompaniedYouthStatusCode = UnaccYouth.Code
	WHERE kd.DimK12DemographicId IS NULL


  IF EXISTS(Select 1 from RDS.DimK12Demographics where EconomicDisadvantageStatusCode = 'MISSING' and HomelessnessStatusCode = 'MISSING'
  AND EnglishLearnerStatusCode = 'MISSING' AND MigrantStatusCode = 'MISSING' AND MilitaryConnectedStudentIndicatorCode = 'MISSING'
  AND HomelessPrimaryNighttimeResidenceCode = 'MISSING' and HomelessUnaccompaniedYouthStatusCode = 'MISSING')
  BEGIN
	  delete from RDS.DimK12Demographics where EconomicDisadvantageStatusCode = 'MISSING' and HomelessnessStatusCode = 'MISSING'
	  AND EnglishLearnerStatusCode = 'MISSING' AND MigrantStatusCode = 'MISSING' AND MilitaryConnectedStudentIndicatorCode = 'MISSING'
	  AND HomelessPrimaryNighttimeResidenceCode = 'MISSING' and HomelessUnaccompaniedYouthStatusCode = 'MISSING'
  END

  IF NOT EXISTS(Select 1 from RDS.DimK12Demographics where EconomicDisadvantageStatusCode = 'MISSING' and HomelessnessStatusCode = 'MISSING'
  AND EnglishLearnerStatusCode = 'MISSING' AND MigrantStatusCode = 'MISSING' AND MilitaryConnectedStudentIndicatorCode = 'MISSING'
  AND HomelessPrimaryNighttimeResidenceCode = 'MISSING' and HomelessUnaccompaniedYouthStatusCode = 'MISSING')
  BEGIN

  SET IDENTITY_INSERT RDS.DimK12Demographics ON
  
  INSERT INTO RDS.DimK12Demographics
		(		
			  DimK12DemographicId
			, EconomicDisadvantageStatusCode
			, EconomicDisadvantageStatusDescription
			, EconomicDisadvantageStatusEdFactsCode
			, HomelessnessStatusCode
			, HomelessnessStatusDescription
			, HomelessnessStatusEdFactsCode
			, EnglishLearnerStatusCode
			, EnglishLearnerStatusDescription
			, EnglishLearnerStatusEdFactsCode
			, MigrantStatusCode
			, MigrantStatusDescription
			, MigrantStatusEdFactsCode
			, MilitaryConnectedStudentIndicatorCode
			, MilitaryConnectedStudentIndicatorDescription
			, MilitaryConnectedStudentIndicatorEdFactsCode
			, HomelessPrimaryNighttimeResidenceCode
			, HomelessPrimaryNighttimeResidenceDescription
			, HomelessPrimaryNighttimeResidenceEdFactsCode
			, HomelessUnaccompaniedYouthStatusCode
			, HomelessUnaccompaniedYouthStatusDescription
			, HomelessUnaccompaniedYouthStatusEdFactsCode
		)
	VALUES(-1, 'MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING',
			'MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING')

	SET IDENTITY_INSERT RDS.DimK12Demographics OFF

	END

	DROP TABLE #MilitaryConnectedStudentIndicator
	DROP TABLE #HomelessPrimaryNighttimeResidence

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
