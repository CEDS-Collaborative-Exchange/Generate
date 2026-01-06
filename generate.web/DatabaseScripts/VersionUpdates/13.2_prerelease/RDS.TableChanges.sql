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

	--Add the new columns to the PSEnrollmentSStatuses dimension
    IF COL_LENGTH('RDS.DimPsEnrollmentStatuses', 'PostsecondaryEnrollmentStatusCode') IS NULL
    BEGIN
        ALTER TABLE RDS.DimPsEnrollmentStatuses ADD PostsecondaryEnrollmentStatusCode VARCHAR(50) NULL;
    END

    IF COL_LENGTH('RDS.DimPsEnrollmentStatuses', 'PostsecondaryEnrollmentStatusDescription') IS NULL
    BEGIN
        ALTER TABLE RDS.DimPsEnrollmentStatuses ADD PostsecondaryEnrollmentStatusDescription VARCHAR(200) NULL;
    END

    IF COL_LENGTH('RDS.DimPsEnrollmentStatuses', 'PostsecondaryEnrollmentStatusEdFactsCode') IS NULL
    BEGIN
        ALTER TABLE RDS.DimPsEnrollmentStatuses ADD PostsecondaryEnrollmentStatusEdFactsCode VARCHAR(50) NULL;
    END

    IF COL_LENGTH('RDS.DimPsEnrollmentStatuses', 'PostsecondaryEnrollmentActionCode') IS NULL
    BEGIN
        ALTER TABLE RDS.DimPsEnrollmentStatuses ADD PostsecondaryEnrollmentActionCode VARCHAR(50) NULL;
    END

    IF COL_LENGTH('RDS.DimPsEnrollmentStatuses', 'PostsecondaryEnrollmentActionDescription') IS NULL
    BEGIN
        ALTER TABLE RDS.DimPsEnrollmentStatuses ADD PostsecondaryEnrollmentActionDescription VARCHAR(200) NULL;
    END

    IF COL_LENGTH('RDS.DimPsEnrollmentStatuses', 'PostsecondaryEnrollmentActionEdFactsCode') IS NULL
    BEGIN
        ALTER TABLE RDS.DimPsEnrollmentStatuses ADD PostsecondaryEnrollmentActionEdFactsCode VARCHAR(50) NULL;
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



