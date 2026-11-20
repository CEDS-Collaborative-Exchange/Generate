IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimEnrollmentStatuses]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimEnrollmentStatuses]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimK12EnrollmentStatuses]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimK12EnrollmentStatuses]