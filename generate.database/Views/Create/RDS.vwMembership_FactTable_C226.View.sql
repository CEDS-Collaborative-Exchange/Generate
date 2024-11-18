USE [generate]
GO

/****** Object:  View [RDS].[vwMembership_FactTable_C226]    Script Date: 11/18/2024 11:54:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE   VIEW [RDS].[vwMembership_FactTable_C226] 
AS
	SELECT a.[FactK12StudentCountId]
		  ,a.[SchoolYear]
		  ,a.[K12StudentId]
		  ,a.[K12StudentStudentIdentifierState]
		  ,a.[BirthDate]
		  ,a.[FirstName]
		  ,a.[LastOrSurname]
		  ,a.[MiddleName]
		  ,a.[SexCode]
		  ,a.[StateANSICode]
		  ,a.[StateAbbreviationCode]
		  ,a.[StateAbbreviationDescription]
		  ,a.[SeaOrganizationIdentifierSea]
		  ,a.[SeaOrganizationName]
		  ,a.[LeaIdentifierSea]
		  ,a.[LeaOrganizationName]
		  ,a.[SchoolIdentifierSea]
		  ,a.[DimK12SchoolId]
		  ,a.[NameOfInstitution]
		  ,a.[SchoolOperationalStatus]
		  ,a.[SchoolTypeCode]
		  ,a.[NationalSchoolLunchProgramDirectCertificationIndicatorCode]
		  ,a.[EligibilityStatusForSchoolFoodServiceProgramsEdFactsCode]
		  ,a.[EconomicDisadvantageStatusCode]
		  ,a.[RaceEdFactsCode]
		  ,a.[GradeLevelEdFactsCode]
		  ,a.[Grade]
		  ,a.[ProgramParticipationFosterCareCode]
		  ,a.[ProgramParticipationFosterCareEdFactsCode]
		  ,a.[TitleIProgramTypeEdFactsCode]
	  FROM [generate].[debug].[vwMembership_FactTable] a
		WHERE EconomicDisadvantageStatusCode = 'Yes' 
		AND SchoolOperationalStatus IN ('Open','New') 
		AND SchoolTypeCode in ('CareerAndTechnical','Alternative','Special','Regular')
		--ORDER BY 1
GO



/*
CREATE VIEW RDS.vwMembership_FactTable_c226
AS
    SELECT  
          SchoolYear
		, StateANSICode
		, StateAbbreviationCode
		, StateAbbreviationDescription
		, SeaOrganizationIdentifierSea
		, SeaOrganizationName
        , K12StudentStudentIdentifierState
        , LeaIdentifierSea
        , SchoolIdentifierSea
        , NameOfInstitution
    FROM [debug].[vwMembership_FactTable] fact
    INNER JOIN rds.DimK12Schools rdks
        ON fact.DimK12SchoolId = rdks.DimK12SchoolId
    WHERE fact.EconomicDisadvantageStatusCode = 'Yes'
    AND rdks.SchoolOperationalStatus NOT IN ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
    AND fact.SchoolTypeCode <> 'Reportable'
*/