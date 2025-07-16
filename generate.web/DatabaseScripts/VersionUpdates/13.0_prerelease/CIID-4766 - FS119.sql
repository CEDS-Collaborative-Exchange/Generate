
	IF COL_LENGTH('Staging.ProgramParticipationTitleIII', 'EnglishLearnersExitedStatus') IS NULL
	BEGIN
		ALTER TABLE Staging.ProgramParticipationTitleIII ADD EnglishLearnersExitedStatus bit;
	END

	IF COL_LENGTH('RDS.DimTitleIIIStatuses', 'EnglishLearnersExitedStatus') IS NULL
	BEGIN
		ALTER TABLE RDS.DimTitleIIIStatuses ADD EnglishLearnersExitedStatus bit;
	END

