-----------------------------------------------
--Title III changes	
-----------------------------------------------

	--Add Title III English Learner Participation Status
    IF COL_LENGTH('RDS.DimTitleIIIStatuses', 'TitleIIIEnglishLearnerParticipationStatusCode') IS NULL
    BEGIN
        ALTER TABLE RDS.DimTitleIIIStatuses ADD TitleIIIEnglishLearnerParticipationStatusCode VARCHAR(50) NULL;
    END
	
    IF COL_LENGTH('RDS.DimTitleIIIStatuses', 'TitleIIIEnglishLearnerParticipationStatusDescription') IS NULL
    BEGIN
        ALTER TABLE RDS.DimTitleIIIStatuses ADD TitleIIIEnglishLearnerParticipationStatusDescription VARCHAR(200) NULL;
    END

    IF COL_LENGTH('RDS.DimTitleIIIStatuses', 'TitleIIIEnglishLearnerParticipationStatusEdFactsCode') IS NULL
    BEGIN
        ALTER TABLE RDS.DimTitleIIIStatuses ADD TitleIIIEnglishLearnerParticipationStatusEdFactsCode VARCHAR(50) NULL;
    END


