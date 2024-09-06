CREATE TYPE [RDS].[K12StudentOrganizationTableType] AS TABLE(
	  DimK12StudentId INT
	, PersonId INT
	, DimCountDateId INT
	, DimSeaId INT 
	, DimIeuId INT 
	, DimLeaId INT 
	, DimK12SchoolId INT 
	, IeuOrganizationId INT NULL
	, LeaOrganizationId INT NULL
	, K12SchoolOrganizationId INT NULL
	, LeaOrganizationPersonRoleId INT NULL
	, K12SchoolOrganizationPersonRoleId INT NULL
	, LeaEntryDate DATETIME NULL
	, LeaExitDate DATETIME NULL
	, K12SchoolEntryDate DATETIME NULL
	, K12SchoolExitDate DATETIME NULL
)
