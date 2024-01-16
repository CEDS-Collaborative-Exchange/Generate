/************************************************************************
July 24, 2023

This view returns detailed demographic information for all students in
Staging.K12Enrollment, including data from SSRD, EdFacts values, etc.

This view can be used when creating end-to-end tests to easily
gather the necessary data for comparison.
*************************************************************************/

CREATE VIEW debug.vwStudentDetails
AS

select 
distinct
	sk12e.schoolyear, 
	sk12e.StudentIdentifierState, sk12e.Birthdate, 
	rds.Get_Age(sk12e.Birthdate, ChildCount.ChildCountDate) 'Age_ChildCount',
	rds.Get_Age(sk12e.Birthdate, Membership.MembershipDate) 'Age_Membership',
	sk12e.EnrollmentEntryDate, sk12e.EnrollmentExitDate, 
-- Grade
	'[GRADE]' '[GRADE]',
	sk12e.GradeLevel 'GradeLevel_STG', ssrdGRADE.GradeLevelCode 'Grade_SSRDOut', rgl.GradeLevelEdFactsCode, rgl.DimGradeLevelId,
--Sex
	'[SEX]' '[SEX]', 
	sk12e.sex 'Sex_STG', ssrdSEX.SexCode 'Sex_SSRDOut', rk12dem.SexEdFactsCode, rk12dem.DimK12DemographicId,
--Race
	'[RACE]' '[RACE]', 
	sk12e.HispanicLatinoEthnicity 'Hisp_STG', 
	case
		when sk12e.HispanicLatinoEthnicity = 1 then 'Yes'
		when sk12e.HispanicLatinoEthnicity = 0 then 'No'
		else 'MISSING'
	end 'Hisp_EdFacts',

	spr.RaceType 'Race_STG', ssrdRace.RaceCode 'Race_SSRDOut', rdr.RaceEdFactsCode, rdr.DimRaceId,
-- EL
	'[EL]' '[EL]', 
	sps.EnglishLearnerStatus 'ELStatus_STG', 
	case
		when sps.EnglishLearnerStatus = 1 then 'LEP'
		when sps.EnglishLearnerStatus = 0 then 'NLEP'
		else 'MISSING'
	end 'EnglishLearnerStatusEdFactsCode',
	sps.EnglishLearner_StatusStartDate, sps.EnglishLearner_StatusEndDate, 
	sps.ISO_639_2_NativeLanguage 'Lang_STG', ssrdLANG.Iso6392LanguageCodeCode 'Lang_SSRDOut', rlang.Iso6392LanguageCodeEdFactsCode, rlang.DimLanguageId,
-- IDEA
	'[IDEA]' '[IDEA]',
	sppse.IDEAIndicator 'IDEAIndicator_STG',
	case
		when sppse.IDEAIndicator = 1 then 'Yes'
		when sppse.IDEAIndicator = 0 then 'No'
		else 'MISSING'
	end 'IDEAIndicatorEdFactsCode',

	sppse.IDEAEducationalEnvironmentForSchoolAge 'EdEnvSA_STG', ssrdIDEA.IdeaEducationalEnvironmentForSchoolAgeCode 'EdEnvSA_SSRDOut', rIdeaStatus.IdeaEducationalEnvironmentForSchoolAgeEdFactsCode,
	sppse.IDEAEducationalEnvironmentForEarlyChildhood 'EdEnvEC_STG', ssrdIDEA.IdeaEducationalEnvironmentForEarlyChildhoodCode 'EdEnvEC_SSRDOut', rIdeaStatus.IdeaEducationalEnvironmentForEarlyChildhoodEdFactsCode, 
	sppse.SpecialEducationExitReason 'IDEAExitReason_STG', ssrdIDEA.SpecialEducationExitReasonCode 'IDEAExitReason_SSRDOut', rIdeaStatus.SpecialEducationExitReasonEdFactsCode, 
	
	rIdeaStatus.DimIdeaStatusId,

	sdt.IdeaDisabilityTypeCode,sdt.IsPrimaryDisability,
	sppse.ProgramParticipationBeginDate, sppse.ProgramParticipationEndDate,
-- LEA
	'[LEA]' '[LEA]',
	sk12e.LeaIdentifierSeaAccountability, LEA.LEA_OperationalStatus, LEA.LEA_OperationalStatusEffectiveDate, LEA.LEA_IsReportedFederally,
-- School
	'[SCHOOL]' '[SCHOOL]',
	sk12e.SchoolIdentifierSea, sko.School_OperationalStatus, sko.School_OperationalStatusEffectiveDate, sko.School_IsReportedFederally

from staging.K12Enrollment sk12e
	INNER JOIN (
		SELECT max(Schoolyear) AS SchoolYear, 
		CAST(CAST(max(dm.Schoolyear) - 1 AS CHAR(4)) + '-' + CAST(MONTH(tr.ResponseValue) AS VARCHAR(2)) + '-' + CAST(DAY(tr.ResponseValue) AS VARCHAR(2)) AS DATE) AS ChildCountDate
		FROM App.ToggleQuestions tq
		JOIN App.ToggleResponses tr
			ON tq.ToggleQuestionId = tr.ToggleQuestionId
		CROSS JOIN staging.StateDetail dm
		WHERE tq.EmapsQuestionAbbrv = 'CHDCTDTE'
		GROUP BY tr.ResponseValue
	) ChildCount on ChildCount.SchoolYear = sk12e.SchoolYear

	INNER JOIN (
		SELECT max(Schoolyear) AS SchoolYear, 
		CAST(CAST(max(dm.Schoolyear) - 1 AS CHAR(4)) + '-' + CAST(MONTH(tr.ResponseValue) AS VARCHAR(2)) + '-' + CAST(DAY(tr.ResponseValue) AS VARCHAR(2)) AS DATE) AS MembershipDate
		FROM App.ToggleQuestions tq
		JOIN App.ToggleResponses tr
			ON tq.ToggleQuestionId = tr.ToggleQuestionId
		CROSS JOIN staging.StateDetail dm
		WHERE tq.EmapsQuestionAbbrv = 'MEMBERDTE'
		GROUP BY tr.ResponseValue
	) Membership on Membership.SchoolYear = sk12e.SchoolYear


inner join staging.K12Organization LEA
	on isnull(LEA.LeaIdentifierSea,'') = isnull(sk12e.LeaIdentifierSeaAccountability ,'')

left join staging.K12Organization sko
	on (isnull(sko.LeaIdentifierSea,'') = isnull(sk12e.LeaIdentifierSeaAccountability ,'')
		and isnull(sko.SchoolIdentifierSea,'') = isnull(sk12e.SchoolIdentifierSea, ''))

left join staging.ProgramParticipationSpecialEducation sppse
	on sk12e.StudentIdentifierState = sppse.StudentIdentifierState
		and isnull(sk12e.LeaIdentifierSeaAccountability,'') = isnull(sppse.LeaIdentifierSeaAccountability,'')
		and isnull(sppse.SchoolIdentifierSea,'') = isnull(sk12e.SchoolIdentifierSea, '')
left join staging.personstatus sps
	on sps.StudentIdentifierState = sk12e.StudentIdentifierState
		and isnull(sps.LeaIdentifierSeaAccountability,'') = isnull(sk12e.LeaIdentifierSeaAccountability,'')
		and isnull(sps.SchoolIdentifierSea,'') = isnull(sk12e.SchoolIdentifierSea, '')
left join staging.K12PersonRace spr
	on spr.StudentIdentifierState = sk12e.StudentIdentifierState
		and isnull(sk12e.LeaIdentifierSeaAccountability,'') = isnull(spr.LeaIdentifierSeaAccountability,'') 
		and isnull(sk12e.SchoolIdentifierSea,'') = isnull(spr.SchoolIdentifierSea,'')
left join staging.IdeaDisabilityType sdt
	on sdt.StudentIdentifierState = sk12e.StudentIdentifierState
		and isnull(sk12e.LeaIdentifierSeaAccountability,'') = isnull(sdt.LeaIdentifierSeaAccountability,'') 
		and isnull(sk12e.SchoolIdentifierSea,'') = isnull(sdt.SchoolIdentifierSea,'')
		and sdt.SchoolYear = sk12e.SchoolYear

left join RDS.vwDimK12Demographics ssrdSEX
	on ssrdSex.SchoolYear = sk12e.SchoolYear
	and ssrdSex.SexMap = sk12e.Sex
left join RDS.DimK12Demographics rk12dem
	on rk12dem.SexCode = ssrdSEX.SexCode

left join RDS.vwUnduplicatedRaceMap vUndupRace
	on sk12e.StudentIdentifierState = vUndupRace.StudentIdentifierState
		and isnull(sk12e.LeaIdentifierSeaAccountability,'') = isnull(vUndupRace.LeaIdentifierSeaAccountability,'')
		and isnull(vUndupRace.SchoolIdentifierSea,'') = isnull(sk12e.SchoolIdentifierSea, '')
		and vUndupRace.SchoolYear = sk12e.SchoolYear

left join RDS.vwDimRaces ssrdRACE
	on ssrdRACE.SchoolYear = sk12e.SchoolYear
	and ssrdRACE.RaceMap = vUndupRace.RaceMap -- spr.RaceType
left join RDS.DimRaces rdr
	on rdr.RaceCode = 
		case 
			when sk12e.HispanicLatinoEthnicity = 1 then 'HispanicorLatinoEthnicity'
			else ssrdRace.RaceCode
		end

left join RDS.vwDimGradeLevels ssrdGRADE
	on ssrdGRADE.SchoolYear = sk12e.SchoolYear
	and ssrdGRADE.GradeLevelMap = sk12e.GradeLevel
left join RDS.DimGradeLevels rgl
	on rgl.GradeLevelCode = ssrdGRADE.GradeLevelCode

left join RDS.vwDimIdeaStatuses ssrdIDEA
	on ssrdIDEA.SchoolYear = sk12e.SchoolYear
	and ssrdIDEA.SpecialEducationExitReasonMap = isnull(sppse.SpecialEducationExitReason,'MISSING')
	and ssrdIDEA.IdeaEducationalEnvironmentForEarlyChildhoodMap = isnull(sppse.IdeaEducationalEnvironmentForEarlyChildhood,'MISSING')
	and ssrdIDEA.IdeaEducationalEnvironmentForSchoolAgeMap = isnull(sppse.IdeaEducationalEnvironmentForSchoolAge,'MISSING')
	and ssrdIDEA.IdeaIndicatorCode =
		case 
			when sppse.IDEAIndicator = 1 then 'Yes'
			when sppse.IDEAIndicator = 0 then 'No'
			else 'MISSING'
		end
left join RDS.DimIdeaStatuses rIdeaStatus
	on rIdeaStatus.SpecialEducationExitReasonCode = ssrdIDEA.SpecialEducationExitReasonCode
	and rIdeaStatus.IdeaEducationalEnvironmentForEarlyChildhoodCode = ssrdIDEA.IdeaEducationalEnvironmentForEarlyChildhoodCode
	and rIdeaStatus.IdeaEducationalEnvironmentForSchoolAgeCode = ssrdIDEA.IdeaEducationalEnvironmentForSchoolAgeCode
	and rIdeaStatus.IdeaIndicatorCode = ssrdIDEA.IdeaIndicatorCode
	
left join 
	(select min(dimLanguageId) 'LanguageId', SchoolYear, Iso6392LanguageCodeCode, Iso6392LanguageMap 
	from rds.vwdimlanguages 
	group by SchoolYear, Iso6392LanguageCodeCode, Iso6392LanguageMap) ssrdLANG
	on ssrdLANG.SchoolYear = sk12e.SchoolYear
	and ssrdLANG.Iso6392LanguageMap = sps.ISO_639_2_NativeLanguage
left join RDS.DimLanguages rLang
	on rlang.DimLanguageId = ssrdLANG.LanguageId
