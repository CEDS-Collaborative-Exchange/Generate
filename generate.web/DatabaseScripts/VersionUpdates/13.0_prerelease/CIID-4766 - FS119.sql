
ALTER TABLE [generate].[Staging].[ProgramParticipationTitleIII] ADD EnglishLearnersExitedStatus bit;
ALTER TABLE [generate].[RDS].[DimTitleIIIStatuses] ADD EnglishLearnersExitedStatus bit;

--UPDATE [generate].[Staging].[ProgramParticipationTitleIII] SET EnglishLearnersExitedStatus = 1;
--UPDATE [generate].[RDS].[DimTitleIIIStatuses] SET EnglishLearnersExitedStatus = 1;