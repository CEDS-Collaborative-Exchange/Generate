CREATE PROCEDURE [RDS].[Migrate_DimPsInstitutionStatuses]
	@studentDates AS RDS.PsStudentDateTableType READONLY,
	@studentOrganizations AS RDS.PsStudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL
AS
BEGIN
	
	SELECT
		s.DimPsStudentId
		, org.DimPsInstitutionId
		, s.DimCountDateId
		, ISNULL(dps.DimPsInstitutionStatusId, -1) AS DimPsInstitutionStatusId	
		, org.DimAcademicTermDesignatorId
		, dps.MostPrevalentLevelOfInstitutionCode
	FROM @studentDates s
	JOIN @studentOrganizations org 
		ON s.DimPsStudentId = org.DimPsStudentId
		AND s.PersonId = org.PersonId
	JOIN dbo.PsInstitution psi
		ON psi.OrganizationId = org.PsInstitutionOrganizationId
		AND s.RecordStartDatetime BETWEEN psi.RecordStartDateTime AND psi.RecordEndDateTime
	LEFT JOIN dbo.RefMostPrevalentLevelOfInstitution refmploi
		ON psi.RefMostPrevalentLevelOfInstitutionId = refmploi.RefMostPrevalentLevelOfInstitutionId
	LEFT JOIN (Select DimPsInstitutionStatusId,MostPrevalentLevelOfInstitutionCode From rds.DimPsInstitutionStatuses dps
					Where dps.MostPrevalentLevelOfInstitutionCode <> 'MISSING'
					AND dps.LevelOfInstitututionCode = 'MISSING'
					AND dps.ControlOfInstitutionCode = 'MISSING'
					AND dps.CarnegieBasicClassificationCode = 'MISSING'
					AND  dps.PerdominentCalendarSystemCode = 'MISSING') dps
	ON  refmploi.Code = dps.MostPrevalentLevelOfInstitutionCode


	--SELECT DISTINCT
	--	s.DimPsStudentId
	--	, org.DimPsInstitutionId
	--	, s.DimCountDateId
	--	, atd.DimAcademicTermDesignatorId
	--	, ISNULL(dps.DimPsInstitutionStatusId, -1) AS DimPsInstitutionStatusId	
	--	, dps.CarnegieBasicClassificationCode
	--	, dps.LevelOfInstitututionCode
	--	, dps.ControlOfInstitutionCode
	--	, dps.PerdominentCalendarSystemCode
	--	, dps.TenureSystem
	--	, dps.MostPrevalentLevelOfInstitutionCode
	--FROM @studentDates s
	--JOIN @studentOrganizations org 
	--	ON s.DimPsStudentId = org.DimPsStudentId
	--	AND s.PersonId = org.PersonId
	--JOIN dbo.PsInstitution psi
	--	ON psi.OrganizationId = org.PsInstitutionOrganizationId
	--		AND s.RecordStartDatetime BETWEEN psi.RecordStartDateTime AND psi.RecordEndDateTime
	--JOIN rds.DimAcademicTermDesignators atd
	--	ON atd.AcademicTermDesignatorCode = org.AcademicTermDesignatorCode
	--LEFT JOIN dbo.RefCarnegieBasicClassification refCarnegie
	--	ON psi.RefCarnegieBasicClassificationId = refCarnegie.Code
	--LEFT JOIN dbo.RefLevelOfInstitution reflvl 
	--	ON psi.RefLevelOfInstitutionId = reflvl.Code
	--LEFT JOIN dbo.RefControlOfInstitution refctrl
	--	ON psi.RefControlOfInstitutionId = refctrl.Code
	--LEFT JOIN dbo.RefPredominantCalendarSystem refPred
	--	ON psi.RefPredominantCalendarSystemId = refPred.Code
	--LEFT JOIN dbo.RefTenureSystem refTs
	--	ON psi.REfTenureSystemId = refTs.Code
	--LEFT JOIN dbo.RefMostPrevalentLevelOfInstitution refmploi
	--	ON psi.RefMostPrevalentLevelOfInstitutionId = refmploi.Code
	--JOIN rds.DimPsInstitutionStatuses dps
	--	ON ISNULL(refCarnegie.Code, 'MISSING') = dps.CarnegieBasicClassificationCode
	--	AND ISNULL(reflvl.Code, 'MISSING') = dps.LevelOfInstitututionCode
	--	AND ISNULL(refctrl.Code, 'MISSING') = dps.ControlOfInstitutionCode
	--	AND ISNULL(refPred.Code, 'MISSING') = dps.PerdominentCalendarSystemCode
	--	AND ISNULL(refTs.Code, 'MISSING') = dps.TenureSystem
	--	AND ISNULL(refmploi.Code, 'MISSING') = dps.MostPrevalentLevelOfInstitutionCode
END
