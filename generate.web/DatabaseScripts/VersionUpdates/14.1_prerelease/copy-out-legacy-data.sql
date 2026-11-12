IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'Upgrade')
    EXEC(N'CREATE SCHEMA Upgrade');

IF EXISTS (select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA = 'Upgrade' AND TABLE_NAME = 'FactK12StudentCounts_v14_1') 
BEGIN
	DROP TABLE Upgrade.FactK12StudentCounts_v14_1
END

IF EXISTS (select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA = 'Upgrade' AND TABLE_NAME = 'FactK12StudentDisciplines_v14_1') 
BEGIN
	DROP TABLE Upgrade.FactK12StudentDisciplines_v14_1
END

IF EXISTS (select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA = 'Upgrade' AND TABLE_NAME = 'FactK12StudentAssessments_v14_1') 
BEGIN
	DROP TABLE Upgrade.FactK12StudentAssessments_v14_1
END

--FactK12StudentCounts
CREATE TABLE Upgrade.FactK12StudentCounts_v14_1 (
	FactK12StudentCountId INT
	, TitleIIIStatusId INT
	, ProgramParticipationTitleIIILiepCode NVARCHAR(50)
	, TitleIIIImmigrantParticipationStatusCode NVARCHAR(50)
	, ProficiencyStatusCode NVARCHAR(50)
	, TitleIIIAccountabilityProgressStatusCode NVARCHAR(50)
	, TitleIIILanguageInstructionProgramTypeCode NVARCHAR(50)
	, EnglishLearnerExitedStatusCode NVARCHAR(50)
)

INSERT INTO Upgrade.FactK12StudentCounts_v14_1
SELECT 
	FactK12StudentCountId 											
	, TitleIIIStatusId
--DimTitleIIIStatuses with v14.0 column names
	, rdtiiis.ProgramParticipationTitleIIILiepCode
	, rdtiiis.TitleIIIImmigrantParticipationStatusCode
	, rdtiiis.ProficiencyStatusCode
	, rdtiiis.TitleIIIAccountabilityProgressStatusCode
	, rdtiiis.TitleIIILanguageInstructionProgramTypeCode
	, rdtiiis.EnglishLearnerExitedStatusCode
FROM RDS.FactK12StudentCounts f
LEFT JOIN RDS.DimTitleIIIStatuses rdtiiis 
	ON f.TitleIIIStatusId = rdtiiis.DimTitleIIIStatusId

--FactK12StudentDisciplines
CREATE TABLE Upgrade.FactK12StudentDisciplines_v14_1 (
	FactK12StudentDisciplineId INT
	, TitleIIIStatusId INT
	, ProgramParticipationTitleIIILiepCode NVARCHAR(50)
	, TitleIIIImmigrantParticipationStatusCode NVARCHAR(50)
	, ProficiencyStatusCode NVARCHAR(50)
	, TitleIIIAccountabilityProgressStatusCode NVARCHAR(50)
	, TitleIIILanguageInstructionProgramTypeCode NVARCHAR(50)
	, EnglishLearnerExitedStatusCode NVARCHAR(50)
)

INSERT INTO Upgrade.FactK12StudentDisciplines_v14_1
SELECT 
	FactK12StudentDisciplineId 											
	, TitleIIIStatusId
--DimTitleIIIStatuses with v14.0 column names
	, rdtiiis.ProgramParticipationTitleIIILiepCode
	, rdtiiis.TitleIIIImmigrantParticipationStatusCode
	, rdtiiis.ProficiencyStatusCode
	, rdtiiis.TitleIIIAccountabilityProgressStatusCode
	, rdtiiis.TitleIIILanguageInstructionProgramTypeCode
	, rdtiiis.EnglishLearnerExitedStatusCode
FROM RDS.FactK12StudentDisciplines f
LEFT JOIN RDS.DimTitleIIIStatuses rdtiiis 
	ON f.TitleIIIStatusId = rdtiiis.DimTitleIIIStatusId

--FactK12StudentAssessments
CREATE TABLE Upgrade.FactK12StudentAssessments_v14_1 (
	FactK12StudentAssessmentId INT
	, TitleIIIStatusId INT
	, ProgramParticipationTitleIIILiepCode NVARCHAR(50)
	, TitleIIIImmigrantParticipationStatusCode NVARCHAR(50)
	, ProficiencyStatusCode NVARCHAR(50)
	, TitleIIIAccountabilityProgressStatusCode NVARCHAR(50)
	, TitleIIILanguageInstructionProgramTypeCode NVARCHAR(50)
	, EnglishLearnerExitedStatusCode NVARCHAR(50)
)

INSERT INTO Upgrade.FactK12StudentAssessments_v14_1
SELECT 
	FactK12StudentAssessmentId 											
	, TitleIIIStatusId
--DimTitleIIIStatuses with v14.0 column names
	, rdtiiis.ProgramParticipationTitleIIILiepCode
	, rdtiiis.TitleIIIImmigrantParticipationStatusCode
	, rdtiiis.ProficiencyStatusCode
	, rdtiiis.TitleIIIAccountabilityProgressStatusCode
	, rdtiiis.TitleIIILanguageInstructionProgramTypeCode
	, rdtiiis.EnglishLearnerExitedStatusCode
FROM RDS.FactK12StudentAssessments f
LEFT JOIN RDS.DimTitleIIIStatuses rdtiiis 
	ON f.TitleIIIStatusId = rdtiiis.DimTitleIIIStatusId

