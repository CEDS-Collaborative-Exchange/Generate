﻿IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimSchoolIdea]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimSchoolIdea]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Migrate_DimK12SchoolIdea]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Migrate_DimK12SchoolIdea]