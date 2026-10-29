--Copy the fact table data from the upgrade tables back into the main RDS fact tables
--FactK12StudentCounts
update f
set TitleIIIStatusId = t.TitleIIIStatusId
from upgrade.FactK12StudentCounts_14_1 b
	inner join rds.DimTitleIIIStatuses t
		on b.ProgramParticipationTitleIIILiepCode = t.ProgramParticipationTitleIIILiepCode
		and b.TitleIIIImmigrantParticipationStatusCode = t.TitleIIIImmigrantParticipationStatusCode
		and b.ProficiencyStatusCode = t.ProficiencyStatusCode
		and b.TitleIIIAccountabilityProgressStatusCode = t.TitleIIIAccountabilityProgressStatusCode
		and b.TitleIIILanguageInstructionProgramTypeCode = t.TitleIIILanguageInstructionProgramTypeCode
		and b.EnglishLearnerExitedStatusCode = t.EnglishLearnerExitedStatusCode
		and t.TitleIIIEnglishLearnerParticipationStatusCode = 'MISSING'
	inner join rds.FactK12StudentCounts f
		on f.FactK12StudentCountId = b.FactK12StudentCountId

--FactK12StudentDisciplines
update f
set TitleIIIStatusId = t.TitleIIIStatusId
from upgrade.FactK12StudentDisciplines_14_1 b
	inner join rds.DimTitleIIIStatuses t
		on b.ProgramParticipationTitleIIILiepCode = t.ProgramParticipationTitleIIILiepCode
		and b.TitleIIIImmigrantParticipationStatusCode = t.TitleIIIImmigrantParticipationStatusCode
		and b.ProficiencyStatusCode = t.ProficiencyStatusCode
		and b.TitleIIIAccountabilityProgressStatusCode = t.TitleIIIAccountabilityProgressStatusCode
		and b.TitleIIILanguageInstructionProgramTypeCode = t.TitleIIILanguageInstructionProgramTypeCode
		and b.EnglishLearnerExitedStatusCode = t.EnglishLearnerExitedStatusCode
		and t.TitleIIIEnglishLearnerParticipationStatusCode = 'MISSING'
	inner join rds.FactK12StudentDisciplines f
		on f.FactK12StudentDisciplineId = b.FactK12StudentDisciplineId

--FactK12StudentAssessments
update f
set TitleIIIStatusId = t.TitleIIIStatusId
from upgrade.FactK12StudentAssessments_14_1 b
	inner join rds.DimTitleIIIStatuses t
		on b.ProgramParticipationTitleIIILiepCode = t.ProgramParticipationTitleIIILiepCode
		and b.TitleIIIImmigrantParticipationStatusCode = t.TitleIIIImmigrantParticipationStatusCode
		and b.ProficiencyStatusCode = t.ProficiencyStatusCode
		and b.TitleIIIAccountabilityProgressStatusCode = t.TitleIIIAccountabilityProgressStatusCode
		and b.TitleIIILanguageInstructionProgramTypeCode = t.TitleIIILanguageInstructionProgramTypeCode
		and b.EnglishLearnerExitedStatusCode = t.EnglishLearnerExitedStatusCode
		and t.TitleIIIEnglishLearnerParticipationStatusCode = 'MISSING'
	inner join rds.FactK12StudentAssessments f
		on f.FactK12StudentAssessmentId = b.FactK12StudentAssessmentId

