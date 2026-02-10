-----------------------------------------------
--School Performance Indicators changes	
-----------------------------------------------

    --Update the column name in ReportEDFactsSchoolPerformanceIndicators

   	IF COL_LENGTH('RDS.ReportEDFactsSchoolPerformanceIndicators', 'ECODISSTATUS') IS NOT NULL
	BEGIN
		exec sp_rename 'RDS.ReportEDFactsSchoolPerformanceIndicators.ECODISSTATUS', 'ECONOMICDISADVANTAGESTATUS', 'COLUMN';
	END

-----------------------------------------------
--File 160 changes	
-----------------------------------------------

	--Add Postsecondary Enrollment Action to the dimension table
    IF COL_LENGTH('RDS.DimPsEnrollmentStatuses', 'PostSecondaryEnrollmentActionCode') IS NULL
    BEGIN
        ALTER TABLE RDS.DimPsEnrollmentStatuses ADD PostSecondaryEnrollmentActionCode VARCHAR(50) NULL;
    END
	
    IF COL_LENGTH('RDS.DimPsEnrollmentStatuses', 'PostSecondaryEnrollmentActionDescription') IS NULL
    BEGIN
        ALTER TABLE RDS.DimPsEnrollmentStatuses ADD PostSecondaryEnrollmentActionDescription VARCHAR(200) NULL;
    END

    IF COL_LENGTH('RDS.DimPsEnrollmentStatuses', 'PostSecondaryEnrollmentActionEdFactsCode') IS NULL
    BEGIN
        ALTER TABLE RDS.DimPsEnrollmentStatuses ADD PostSecondaryEnrollmentActionEdFactsCode VARCHAR(50) NULL;
    END

	--Add PSEnrollmentStatus to the Fact table
    IF COL_LENGTH('RDS.FactK12StudentCounts', 'PsEnrollmentStatusId') IS NULL
    BEGIN
        ALTER TABLE RDS.FactK12StudentCounts ADD PsEnrollmentStatusId BIGINT NULL;
    END
       
	IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys fk
    JOIN sys.tables t ON fk.parent_object_id = t.object_id
    WHERE t.name = 'FactK12StudentCounts'
      AND fk.name = 'FK_FactK12StudentCounts_PSEnrollmentStatusId'
	)
	BEGIN
		ALTER TABLE RDS.FactK12StudentCounts
		ADD CONSTRAINT FK_FactK12StudentCounts_PSEnrollmentStatusId
		FOREIGN KEY (PSEnrollmentStatusId)
		REFERENCES RDS.DimPsEnrollmentStatuses(DimPSEnrollmentStatusId);
	END

    IF COL_LENGTH('RDS.FactK12StudentCounts', 'PsEnrollmentStatusId') IS NOT NULL
    BEGIN
    	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [DF_FactK12StudentCounts_PsEnrollmentStatusId] DEFAULT ((-1)) FOR [PsEnrollmentStatusId];
    END
-----------------------------------------------
--CIID-8170 
-----------------------------------------------

    --Remove the constraint on TitleIStatusId in FactOrganizationCounts
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_TitleIStatusId]

    --Rename the column TitleIStatusId to OrganizationTitleIStatusId
   	IF COL_LENGTH('RDS.FactOrganizationCounts', 'TitleIStatusId') IS NOT NULL
	BEGIN
		exec sp_rename 'RDS.FactOrganizationCounts.TitleIStatusId', 'OrganizationTitleIStatusId', 'COLUMN';
	END

    --Add the default constraint back on the renamed column
    ALTER TABLE [RDS].[FactOrganizationCounts] ADD  CONSTRAINT [DF_FactOrganizationCounts_OrganizationTitleIStatusId]  DEFAULT ((-1)) FOR [OrganizationTitleIStatusId]

    --Add the new column to FactOrganizationCounts
    IF COL_LENGTH('RDS.FactOrganizationCounts', 'HomelessChildrenandYouthReservation') IS NULL
    BEGIN
        ALTER TABLE RDS.FactOrganizationCounts ADD HomelessChildrenandYouthReservation INT NULL;
    END

    --Add the default constraint back on the renamed column
    ALTER TABLE [RDS].[FactOrganizationCounts] ADD  CONSTRAINT [DF_FactOrganizationCounts_HomelessChildrenandYouthReservation]  DEFAULT ((0)) FOR [HomelessChildrenandYouthReservation]

    --Add the new column to ReportEdFactsOrganizationCounts
    IF COL_LENGTH('RDS.ReportEdFactsOrganizationCounts', 'HomelessChildrenandYouthReservation') IS NULL
    BEGIN
        ALTER TABLE RDS.ReportEdFactsOrganizationCounts ADD HomelessChildrenandYouthReservation INT NULL;
    END

-----------------------------------------------
--File 138 changes	
-----------------------------------------------
	--Add AssessmentStatus to the Fact table
    IF COL_LENGTH('RDS.FactK12StudentAssessments', 'AssessmentStatusId') IS NULL
    BEGIN
        ALTER TABLE RDS.FactK12StudentAssessments ADD AssessmentStatusId INT NULL;
    END

	IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys fk
    JOIN sys.tables t ON fk.parent_object_id = t.object_id
    WHERE t.name = 'FactK12StudentAssessments'
      AND fk.name = 'FK_FactK12StudentAssessments_AssessmentStatusId'
	)
	BEGIN
		ALTER TABLE RDS.FactK12StudentAssessments
		ADD CONSTRAINT FK_FactK12StudentAssessments_AssessmentStatusId
		FOREIGN KEY (AssessmentStatusId)
		REFERENCES RDS.DimAssessmentStatuses(DimAssessmentStatusId);
	END

-----------------------------------------------
--File 067 changes	
-----------------------------------------------

    IF COL_LENGTH('RDS.DimK12StaffCategories', 'TitleIIILanguageInstructionIndicatorCode') IS NULL
    BEGIN
        ALTER TABLE RDS.DimK12StaffCategories ADD TitleIIILanguageInstructionIndicatorCode VARCHAR(50) NULL;
    END
	
    IF COL_LENGTH('RDS.DimK12StaffCategories', 'TitleIIILanguageInstructionIndicatorDescription') IS NULL
    BEGIN
        ALTER TABLE RDS.DimK12StaffCategories ADD TitleIIILanguageInstructionIndicatorDescription VARCHAR(200) NULL;
    END

-----------------------------------------------
--File 203 changes	
-----------------------------------------------

    --IF COL_LENGTH('RDS.DimK12StaffStatuses', 'TeachingCredentialTypeCode') IS NULL
    --BEGIN
    --    ALTER TABLE RDS.DimK12StaffStatuses ADD TeachingCredentialTypeCode VARCHAR(50) NULL;
    --END
	
    --IF COL_LENGTH('RDS.DimK12StaffStatuses', 'TeachingCredentialTypeDescription') IS NULL
    --BEGIN
    --    ALTER TABLE RDS.DimK12StaffStatuses ADD TeachingCredentialTypeDescription VARCHAR(200) NULL;
    --END

-----------------------------------------------
--CIID-8648 changes	
-----------------------------------------------

	--Add PSEnrollmentStatus to the Fact table
    IF COL_LENGTH('RDS.FactK12StudentCounts', 'CteOutcomeIndicatorId') IS NULL
    BEGIN
        ALTER TABLE RDS.FactK12StudentCounts ADD CteOutcomeIndicatorId BIGINT NULL;
    END
       
	IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys fk
    JOIN sys.tables t ON fk.parent_object_id = t.object_id
    WHERE t.name = 'FactK12StudentCounts'
      AND fk.name = 'FK_FactK12StudentCounts_CteOutcomeIndicatorId'
	)
	BEGIN
		ALTER TABLE RDS.FactK12StudentCounts
		ADD CONSTRAINT FK_FactK12StudentCounts_CteOutcomeIndicatorId
		FOREIGN KEY (CteOutcomeIndicatorId)
		REFERENCES RDS.DimPsEnrollmentStatuses(DimPSEnrollmentStatusId);
	END

    IF COL_LENGTH('RDS.FactK12StudentCounts', 'CteOutcomeIndicatorId') IS NOT NULL
    BEGIN
    	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [DF_FactK12StudentCounts_CteOutcomeIndicatorId] DEFAULT ((-1)) FOR [CteOutcomeIndicatorId];
    END

