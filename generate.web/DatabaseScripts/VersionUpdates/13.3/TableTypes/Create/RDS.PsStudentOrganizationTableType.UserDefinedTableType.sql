CREATE TYPE [RDS].[PsStudentOrganizationTableType] AS TABLE(
	[DimPsStudentId] [int] NULL,
	[PersonId] [int] NULL,
	[DimDateId] [int] NULL,
	[DimPsInstitutionId] [int] NULL,
	[PsInstitutionOrganizationId] [int] NULL,
	[DimOrganizationCalendarSessionId] [int] NULL,
	[DimAcademicTermDesignatorId] [int] NULL,
	[OrganizationPersonRoleId] [int] NULL
)
