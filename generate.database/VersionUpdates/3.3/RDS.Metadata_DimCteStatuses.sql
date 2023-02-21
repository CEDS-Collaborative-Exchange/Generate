if not exists(select 1 from rds.DimCteStatuses)
BEGIN

	set identity_insert rds.DimCteStatuses on

	insert into rds.DimCteStatuses(DimCteStatusId, CteProgramCode,CteProgramDescription,CteProgramEdFactsCode,CteProgramId,
	CteAeDisplacedHomemakerIndicatorCode, CteAeDisplacedHomemakerIndicatorDescription, CteAeDisplacedHomemakerIndicatorEdFactsCode,	CteAeDisplacedHomemakerIndicatorId,
	CteNontraditionalGenderStatusCode,	CteNontraditionalGenderStatusDescription, CteNontraditionalGenderStatusEdFactsCode,	CteNontraditionalGenderStatusId,
	RepresentationStatusCode, RepresentationStatusDescription, RepresentationStatusEdFactsCode,	RepresentationStatusId,
	SingleParentOrSinglePregnantWomanCode,	SingleParentOrSinglePregnantWomanDescription, SingleParentOrSinglePregnantWomanEdFactsCode,	SingleParentOrSinglePregnantWomanId,
	CteGraduationRateInclusionCode,	CteGraduationRateInclusionDescription,	CteGraduationRateInclusionEdFactsCode, CteGraduationRateInclusionId,
	LepPerkinsStatusCode,LepPerkinsStatusDescription,LepPerkinsStatusEdFactsCode,LepPerkinsStatusId)
	values(-1, 'MISSING','Missing','MISSING',-1, 'MISSING', 'Missing', 'MISSING', -1, 'MISSING',	'Missing', 'MISSING',	-1,
	'MISSING', 'Missing', 'MISSING',-1,	'MISSING',	'Missing', 'MISSING',	-1,	'MISSING',	'Missing',	'MISSING', -1, 'MISSING','Missing','MISSING',-1)

	set identity_insert rds.DimCteStatuses off


	declare @CteProgramId as int
	declare @CteProgramCode as varchar(50)
	declare @CteProgramDescription as varchar(200)
	declare @CteProgramEdFactsCode as varchar(50)

	declare @CteProgramTable table(
			CteProgramId int,
			CteProgramCode varchar(50),
			CteProgramDescription varchar(200),
			CteProgramEdFactsCode varchar(50)
	); 

	insert into @CteProgramTable(CteProgramId, CteProgramCode,	CteProgramDescription,	CteProgramEdFactsCode) 		
	values (-1, 'MISSING', 'Missing', 'MISSING')

	insert into @CteProgramTable(CteProgramId, CteProgramCode,	CteProgramDescription,	CteProgramEdFactsCode)
	values (1, 'CTEPART', 'CTE Participation', 'CTEPART')

	insert into @CteProgramTable(CteProgramId, CteProgramCode,	CteProgramDescription,	CteProgramEdFactsCode)
	values (2, 'NONCTEPART', 'Not participating in CTE', 'NONCTEPART')

	insert into @CteProgramTable(CteProgramId, CteProgramCode,	CteProgramDescription,	CteProgramEdFactsCode)
	values (3, 'CTECONC', 'CTE Concentrator', 'CTECONC')

	declare @CteAeDisplacedHomemaker table(
			CteAeDisplacedHomemakerId int,
			CteAeDisplacedHomemakerCode varchar(50),
			CteAeDisplacedHomemakerDescription varchar(200),
			CteAeDisplacedHomemakerEdFactsCode varchar(50)
	); 

	insert into @CteAeDisplacedHomemaker(CteAeDisplacedHomemakerId,	CteAeDisplacedHomemakerCode, CteAeDisplacedHomemakerDescription,CteAeDisplacedHomemakerEdFactsCode) 			values (-1, 'MISSING', 'Missing', 'MISSING')

	insert into @CteAeDisplacedHomemaker(CteAeDisplacedHomemakerId,	CteAeDisplacedHomemakerCode, CteAeDisplacedHomemakerDescription,CteAeDisplacedHomemakerEdFactsCode)
	values (1, 'DH', 'Displaced homemaker', 'DH')

	declare @CteNontraditionalGenderStatus table(
			CteNontraditionalGenderStatusId int,
			CteNontraditionalGenderStatusCode varchar(50),
			CteNontraditionalGenderStatusDescription varchar(200),
			CteNontraditionalGenderStatusEdFactsCode varchar(50)
	); 

	insert into @CteNontraditionalGenderStatus(CteNontraditionalGenderStatusId,	CteNontraditionalGenderStatusCode, CteNontraditionalGenderStatusDescription,
												CteNontraditionalGenderStatusEdFactsCode)
	values (-1, 'MISSING', 'Missing', 'MISSING')

	insert into @CteNontraditionalGenderStatus(CteNontraditionalGenderStatusId,	CteNontraditionalGenderStatusCode, CteNontraditionalGenderStatusDescription,
												CteNontraditionalGenderStatusEdFactsCode)
	values (1, 'NTE', 'Non-Traditional Enrollee', 'NTE')

	declare @RepresentationStatus table(
			RepresentationStatusId int,
			RepresentationStatusCode varchar(50),
			RepresentationStatusDescription varchar(200),
			RepresentationStatusEdFactsCode varchar(50)
	); 

	insert into @RepresentationStatus(RepresentationStatusId, RepresentationStatusCode,	RepresentationStatusDescription, RepresentationStatusEdFactsCode)
	values (-1, 'MISSING', 'Missing', 'MISSING')

	insert into @RepresentationStatus(RepresentationStatusId, RepresentationStatusCode,	RepresentationStatusDescription, RepresentationStatusEdFactsCode)
	values (1, 'MEM', 'Member of an Underrepresented Gender Group', 'MEM')

	insert into @RepresentationStatus(RepresentationStatusId, RepresentationStatusCode,	RepresentationStatusDescription, RepresentationStatusEdFactsCode)
	values (1, 'NM', 'Not a Member of an Underrepresented Gender Group', 'NM')

	declare @SingleParentOrSinglePregnantWoman table(
			SingleParentOrSinglePregnantWomanId int,
			SingleParentOrSinglePregnantWomanCode varchar(50),
			SingleParentOrSinglePregnantWomanDescription varchar(200),
			SingleParentOrSinglePregnantWomanEdFactsCode varchar(50)
	); 

	insert into @SingleParentOrSinglePregnantWoman(SingleParentOrSinglePregnantWomanId, SingleParentOrSinglePregnantWomanCode,	SingleParentOrSinglePregnantWomanDescription,													   SingleParentOrSinglePregnantWomanEdFactsCode)
	values (-1, 'MISSING', 'Missing', 'MISSING')

	insert into @SingleParentOrSinglePregnantWoman(SingleParentOrSinglePregnantWomanId, SingleParentOrSinglePregnantWomanCode,	SingleParentOrSinglePregnantWomanDescription,													   SingleParentOrSinglePregnantWomanEdFactsCode)
	values (1, 'SPPT', 'Single Parents Status', 'SPPT')

	declare @CteGraduationRateInclusion table(
			CteGraduationRateInclusionId int,
			CteGraduationRateInclusionCode varchar(50),
			CteGraduationRateInclusionDescription varchar(200),
			CteGraduationRateInclusionEdFactsCode varchar(50)
	); 

	insert into @CteGraduationRateInclusion(CteGraduationRateInclusionId, CteGraduationRateInclusionCode, CteGraduationRateInclusionDescription,													   CteGraduationRateInclusionEdFactsCode)
	values (-1, 'MISSING', 'Missing', 'MISSING')

	insert into @CteGraduationRateInclusion(CteGraduationRateInclusionId, CteGraduationRateInclusionCode, CteGraduationRateInclusionDescription,													   CteGraduationRateInclusionEdFactsCode)
	values (1, 'GRAD', 'Graduated', 'GRAD')

	insert into @CteGraduationRateInclusion(CteGraduationRateInclusionId, CteGraduationRateInclusionCode, CteGraduationRateInclusionDescription,													   CteGraduationRateInclusionEdFactsCode)
	values (1, 'NOTG', 'Not Graduated', 'NOTG')

	declare @LepPerkinsStatus table(
			LepPerkinsStatusId int,
			LepPerkinsStatusCode varchar(50),
			LepPerkinsStatusDescription varchar(200),
			LepPerkinsStatusEdFactsCode varchar(50)
	); 

	insert into @LepPerkinsStatus(LepPerkinsStatusId,LepPerkinsStatusCode,LepPerkinsStatusDescription,LepPerkinsStatusEdFactsCode)
	values (-1, 'MISSING', 'Missing', 'MISSING')

	insert into @LepPerkinsStatus(LepPerkinsStatusId,LepPerkinsStatusCode,LepPerkinsStatusDescription,LepPerkinsStatusEdFactsCode)
	values (1, 'LEPP', 'Lep Status Perkins', 'LEPP')



	insert into rds.DimCteStatuses(CteProgramCode,CteProgramDescription,CteProgramEdFactsCode,CteProgramId,
	CteAeDisplacedHomemakerIndicatorCode, CteAeDisplacedHomemakerIndicatorDescription, CteAeDisplacedHomemakerIndicatorEdFactsCode,	CteAeDisplacedHomemakerIndicatorId,
	CteNontraditionalGenderStatusCode,	CteNontraditionalGenderStatusDescription, CteNontraditionalGenderStatusEdFactsCode,	CteNontraditionalGenderStatusId,
	RepresentationStatusCode, RepresentationStatusDescription, RepresentationStatusEdFactsCode,	RepresentationStatusId,
	SingleParentOrSinglePregnantWomanCode,	SingleParentOrSinglePregnantWomanDescription, SingleParentOrSinglePregnantWomanEdFactsCode,	SingleParentOrSinglePregnantWomanId,
	CteGraduationRateInclusionCode,	CteGraduationRateInclusionDescription,	CteGraduationRateInclusionEdFactsCode, CteGraduationRateInclusionId,
	LepPerkinsStatusCode,LepPerkinsStatusDescription,LepPerkinsStatusEdFactsCode,LepPerkinsStatusId)
	select CteProgramCode,CteProgramDescription,CteProgramEdFactsCode,CteProgramId,
	CteAeDisplacedHomemakerCode, CteAeDisplacedHomemakerDescription, CteAeDisplacedHomemakerEdFactsCode, CteAeDisplacedHomemakerId,
	CteNontraditionalGenderStatusCode,	CteNontraditionalGenderStatusDescription, CteNontraditionalGenderStatusEdFactsCode,	CteNontraditionalGenderStatusId,
	RepresentationStatusCode, RepresentationStatusDescription, RepresentationStatusEdFactsCode,	RepresentationStatusId,
	SingleParentOrSinglePregnantWomanCode,	SingleParentOrSinglePregnantWomanDescription, SingleParentOrSinglePregnantWomanEdFactsCode,	SingleParentOrSinglePregnantWomanId,
	CteGraduationRateInclusionCode,	CteGraduationRateInclusionDescription,	CteGraduationRateInclusionEdFactsCode, CteGraduationRateInclusionId,
	LepPerkinsStatusCode,LepPerkinsStatusDescription,LepPerkinsStatusEdFactsCode,LepPerkinsStatusId
	from
	@CteProgramTable 
	cross join @CteAeDisplacedHomemaker
	cross join @CteNontraditionalGenderStatus
	cross join @RepresentationStatus
	cross join @SingleParentOrSinglePregnantWoman
	cross join @CteGraduationRateInclusion
	cross join @LepPerkinsStatus
	except
	select CteProgramCode,CteProgramDescription,CteProgramEdFactsCode,CteProgramId,
	CteAeDisplacedHomemakerCode, CteAeDisplacedHomemakerDescription, CteAeDisplacedHomemakerEdFactsCode, CteAeDisplacedHomemakerId,
	CteNontraditionalGenderStatusCode,	CteNontraditionalGenderStatusDescription, CteNontraditionalGenderStatusEdFactsCode,	CteNontraditionalGenderStatusId,
	RepresentationStatusCode, RepresentationStatusDescription, RepresentationStatusEdFactsCode,	RepresentationStatusId,
	SingleParentOrSinglePregnantWomanCode,	SingleParentOrSinglePregnantWomanDescription, SingleParentOrSinglePregnantWomanEdFactsCode,	SingleParentOrSinglePregnantWomanId,
	CteGraduationRateInclusionCode,	CteGraduationRateInclusionDescription,	CteGraduationRateInclusionEdFactsCode, CteGraduationRateInclusionId,
	LepPerkinsStatusCode,LepPerkinsStatusDescription,LepPerkinsStatusEdFactsCode,LepPerkinsStatusId
	from
	@CteProgramTable 
	cross join @CteAeDisplacedHomemaker
	cross join @CteNontraditionalGenderStatus
	cross join @RepresentationStatus
	cross join @SingleParentOrSinglePregnantWoman
	cross join @CteGraduationRateInclusion
	cross join @LepPerkinsStatus
	where CteProgramCode = 'MISSING' AND CteAeDisplacedHomemakerCode = 'MISSING' AND CteNontraditionalGenderStatusCode = 'MISSING' 
	AND RepresentationStatusCode = 'MISSING' AND SingleParentOrSinglePregnantWomanCode = 'MISSING' AND CteGraduationRateInclusionCode = 'MISSING'
	AND LepPerkinsStatusCode = 'MISSING'
END