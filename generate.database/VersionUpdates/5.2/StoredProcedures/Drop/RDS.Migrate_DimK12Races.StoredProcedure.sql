﻿IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimRaces]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimRaces]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimK12Races]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimK12Races]