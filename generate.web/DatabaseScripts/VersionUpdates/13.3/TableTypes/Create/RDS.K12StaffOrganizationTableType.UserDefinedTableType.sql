CREATE TYPE [RDS].[K12StaffOrganizationTableType] AS TABLE(
	[DimK12StaffId] [int] NULL,
	[PersonId] [int] NULL,
	[DimCountDateId] [int] NULL,
	[DimSeaId] [int] NULL,
	[DimIeuId] [int] NULL,
	[DimLeaId] [int] NULL,
	[DimK12SchoolId] [int] NULL,
	[IeuOrganizationId] [int] NULL,
	[LeaOrganizationId] [int] NULL,
	[K12SchoolOrganizationId] [int] NULL,
	[LeaOrganizationPersonRoleId] [int] NULL,
	[K12SchoolOrganizationPersonRoleId] [int] NULL,
	[LeaEntryDate] [datetime] NULL,
	[LeaExitDate] [datetime] NULL,
	[K12SchoolEntryDate] [datetime] NULL,
	[K12SchoolExitDate] [datetime] NULL
)