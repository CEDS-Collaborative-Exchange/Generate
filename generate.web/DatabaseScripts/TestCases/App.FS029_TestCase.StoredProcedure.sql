﻿CREATE PROCEDURE [App].[FS029_TestCase]
	@SchoolYear SMALLINT
AS
BEGIN
	--BEGIN TRANSACTIONs
		
		DECLARE @charterLeaCount as int = 0
		SELECT @charterLeaCount = count(distinct LEAIdentifierSea) 
		FROM staging.K12Organization sko
			LEFT JOIN staging.SourceSystemReferenceData sssrd
				ON sko.LEA_Type = sssrd.InputCode
				AND sssrd.TableName = 'RefLeaType'
				AND sko.SchoolYear = sssrd.SchoolYear
		WHERE sssrd.OutputCode = 'IndependentCharterDistrict'

		 --Define the test
		DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
		IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS029_UnitTestCASE') 
		BEGIN
			SET @expectedResult = 1
			INSERT INTO App.SqlUnitTest (
				[UnitTestName]
				, [StoredProcedureName]
				, [TestScope]
				, [IsActive]
			)
			VALUES (
				'FS029_UnitTestCASE'
				, 'FS029_TestCASE'				
				, 'FS029'
				, 1
			)
			SET @SqlUnitTestId = @@IDENTITY
		END 
		ELSE 
		BEGIN
			SELECT 
				@SqlUnitTestId = SqlUnitTestId
			FROM App.SqlUnitTest 
			WHERE UnitTestName = 'FS029_UnitTestCASE'
		END

		 --Clear out last run
		DELETE FROM App.SqlUnitTestCASEResult WHERE SqlUnitTestId = @SqlUnitTestId

		IF OBJECT_ID('tempdb..#leas_staging') IS NOT NULL
		DROP TABLE #leas_staging
		IF OBJECT_ID('tempdb..#leas_reporting') IS NOT NULL
		DROP TABLE #leas_reporting
		IF OBJECT_ID('tempdb..#schools_staging') IS NOT NULL
		DROP TABLE #schools_staging
		IF OBJECT_ID('tempdb..#schools_reporting') IS NOT NULL
		DROP TABLE #schools_reporting

		SELECT
		DISTINCT 
			sko.LEAIdentifierSea
		  	, sko.LEAIdentifierNCES
		  	, sko.LEA_SupervisoryUnionIdentificationNumber
		  	, sko.LEAOrganizationName
		  	, sko.LEA_WebSiteAddress
		  	, CASE sssrd1.OutputCode
				WHEN 'Open' THEN 1 
				WHEN 'Closed' THEN 2 
				WHEN 'New' THEN 3 
				WHEN 'Added' THEN 4 
				WHEN 'ChangedBoundary' THEN 5 
				WHEN 'Inactive' THEN 6 
				WHEN 'FutureAgency' THEN 7 
				WHEN 'Reopened' THEN 8 
				WHEN 'Open_1' THEN 1 
				WHEN 'Closed_1' THEN 2 
				WHEN 'New_1' THEN 3 
				WHEN 'Added_1' THEN 4 
				WHEN 'ChangedBoundary_1' THEN 5 
				WHEN 'Inactive_1' THEN 6 
				WHEN 'FutureAgency_1' THEN 7 
				WHEN 'Reopened_1' THEN 8 
				ELSE NULL
			END LEA_OperationalStatus
		  	, sko.LEA_OperationalStatusEffectiveDate
		  	, sko.LEA_CharterLeaStatus
		  	, sko.LEA_CharterSchoolIndicator
		  	, isnull(sko.LEA_Type, -1) LEA_Type
		  	, sko.LEA_IsReportedFederally
		  	, sko.LEA_RecordStartDateTime
		  	, sko.LEA_RecordEndDateTime
			, REPLACE(REPLACE(REPLACE(phone.TelephoneNumber,'-',''),'(',''),')','') AS TelephoneNumber
		  	, mailing.AddressStreetNumberAndName as MailingAddressStreetNumberAndName
		  	, mailing.AddressApartmentRoomOrSuiteNumber as MailingAddressApartmentRoomOrSuiteNumber
		  	, mailing.AddressCity as MailingAddressCity
		  	, mailing.StateAbbreviation as MailingStateAbbreviation
		  	, mailing.AddressPostalCode as MailingAddressPostalCode
		  	, physical.AddressStreetNumberAndName as PhysicalAddressStreetNumberAndName
		  	, physical.AddressApartmentRoomOrSuiteNumber as PhysicalAddressApartmentRoomOrSuiteNumber
		  	, physical.AddressCity as PhysicalAddressCity
		  	, physical.StateAbbreviation as PhysicalStateAbbreviation
		  	, physical.AddressPostalCode as PhysicalAddressPostalCode
		INTO #leas_staging
		FROM Staging.K12Organization sko
		left join (select OrganizationIdentifier, AddressStreetNumberAndName, AddressApartmentRoomOrSuiteNumber, AddressCity, StateAbbreviation, AddressPostalCode
		  			from Staging.OrganizationAddress
		  			where AddressTypeForOrganization in ('Mailing','Mailing_1') 
				) mailing on mailing.OrganizationIdentifier = sko.LEAIdentifierSea
		left join (select OrganizationIdentifier, AddressStreetNumberAndName, AddressApartmentRoomOrSuiteNumber, AddressCity, StateAbbreviation, AddressPostalCode
		  			from Staging.OrganizationAddress
		  			where AddressTypeForOrganization in ('Physical', 'Physical_1') 
				) physical on physical.OrganizationIdentifier = sko.LEAIdentifierSea
		left join Staging.OrganizationPhone phone on phone.OrganizationIdentifier = sko.LEAIdentifierSea
		LEFT JOIN staging.SourceSystemReferenceData sssrd1
			ON sko.Lea_OperationalStatus = sssrd1.InputCode
			AND sssrd1.TableName = 'RefOperationalStatus'
			AND sssrd1.TableFilter = '000174'
			AND sko.SchoolYear = sssrd1.SchoolYear
		where sko.SchoolYear = @SchoolYear and isnull(sko.LEA_IsReportedFederally,0) = 1 
		and phone.OrganizationIdentifier IS NOT NULL	

		select	 distinct
		   	OrganizationStateId
		  	, OrganizationNcesId
		  	, SupervisoryUnionIdentificationNumber
		  	, OrganizationName
		  	, WebSite
		  	, OperationalStatus
		  	, EffectiveDate
		  	, CharterLeaStatus
		  	, CharterSchoolIndicator
		  	, LEAType
		  	, Telephone
		  	, MailingAddressStreet
		  	, MailingAddressApartmentRoomOrSuiteNumber
		  	, MailingAddressCity
		  	, MailingAddressState
		  	, MailingAddressPostalCode
		  	, PhysicalAddressStreet
		  	, PhysicalAddressApartmentRoomOrSuiteNumber
		  	, PhysicalAddressCity
		  	, PhysicalAddressState
		  	, PhysicalAddressPostalCode
		INTO #leas_reporting
		from RDS.ReportEDFactsOrganizationCounts
		where reportcode = 'c029' 
		and ReportLevel = 'LEA' 
		and ReportYear = @SchoolYear

--select * from #leas_staging --where LeaIdentifierSea = 
--return
		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'LEA Name Match'
			,'LEA Name Match ' + s.LEAIdentifierSea
			,s.LEAOrganizationName
			,r.OrganizationName
			,CASE WHEN isnull(s.LEAOrganizationName,'') = isnull(r.OrganizationName,'') THEN 1 
				ELSE 0 END as LEANameMatch
			,GETDATE()
		FROM #leas_staging s
		left JOIN #leas_reporting r 
			ON s.LEAIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'LEA WebSite Match'
			,'LEA WebSite Match ' + s.LEAIdentifierSea
			,s.LEA_WebSiteAddress
			,r.Website
			,CASE WHEN isnull(s.LEA_WebSiteAddress,'') = isnull(r.Website,'') THEN 1 
				ELSE 0 END as LEAWebSiteMatch
			,GETDATE()
		FROM #leas_staging s
		left JOIN #leas_reporting r 
			ON s.LEAIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'LEA OperationalStatus Match'
			,'LEA OperationalStatus Match ' + s.LEAIdentifierSea
			,s.LEA_OperationalStatus
			,r.OperationalStatus
			,CASE WHEN isnull(s.LEA_OperationalStatus,'') = isnull(r.OperationalStatus,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #leas_staging s
		left JOIN #leas_reporting r 
			ON s.LEAIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		 )

		SELECT distinct
			@SqlUnitTestId
			,'CharterLeaStatus Match'
			,'CharterLeaStatus Match ' + s.LEAIdentifierSea

			, CASE 
				WHEN ISNULL(sssrd.OutputCode,'MISSING') <> 'IndependentCharterDistrict'
					AND @charterLeaCount > 0 THEN 'NOTCHR'
				WHEN ISNULL(sssrd.OutputCode,'MISSING') <> 'IndependentCharterDistrict'
					AND @charterLeaCount = 0 THEN 'NA'
				ELSE ISNULL(sssrd2.OutputCode, 'MISSING')
			END  AS LEA_CharterLeaStatus		

			,r.CharterLeaStatus
			,CASE WHEN 
				CASE 
					WHEN ISNULL(sssrd.OutputCode,'MISSING') <> 'IndependentCharterDistrict'
						AND @charterLeaCount > 0 THEN 'NOTCHR'
					WHEN ISNULL(sssrd.OutputCode,'MISSING') <> 'IndependentCharterDistrict'
						AND @charterLeaCount = 0 THEN 'NA'
					ELSE ISNULL(sssrd2.OutputCode, 'MISSING')
				END
				= isnull(r.CharterLeaStatus,'MISSING') THEN 1
				ELSE 0
			END
			,GETDATE()

		FROM #leas_staging s
		LEFT JOIN #leas_reporting r 
			ON s.LEAIdentifierSea = r.OrganizationStateId
		LEFT JOIN staging.SourceSystemReferenceData sssrd
			ON s.LEA_Type = sssrd.InputCode
			AND sssrd.TableName = 'RefLeaType'
			AND sssrd.SchoolYear = @SchoolYear
		LEFT JOIN staging.SourceSystemReferenceData sssrd2
			ON s.LEA_CharterLeaStatus = sssrd2.InputCode
			AND sssrd2.TableName = 'RefCharterLeaStatus'
			AND sssrd2.SchoolYear = @SchoolYear

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'LEA CharterSchoolIndicator Match'
			,'LEA CharterSchoolIndicator Match ' + s.LEAIdentifierSea
			,s.LEA_CharterSchoolIndicator
			,r.CharterSchoolIndicator
			,CASE WHEN isnull(s.LEA_CharterSchoolIndicator,'') = isnull(r.CharterSchoolIndicator,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #leas_staging s
		left JOIN #leas_reporting r 
			ON s.LEAIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'LEAType Match'
			,'LEAType Match ' + s.LEAIdentifierSea
			,replace(s.LEA_Type, '_1','')
			,r.LEAType
			,CASE WHEN isnull(replace(s.LEA_Type, '_1',''), '') = isnull(r.LEAType, '') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #leas_staging s
		LEFT JOIN staging.SourceSystemReferenceData sssrd
			ON s.LEA_Type = sssrd.InputCode
			AND sssrd.TableName = 'RefLeaType'
			AND sssrd.SchoolYear = @SchoolYear
		LEFT JOIN #leas_reporting r 
			ON s.LEAIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'Mailing Address Apartment Room Or Suite Match'
			,'Mailing Address Match ' + s.LEAIdentifierSea
			,s.MailingAddressApartmentRoomOrSuiteNumber
			,r.MailingAddressApartmentRoomOrSuiteNumber
			,CASE WHEN isnull(s.MailingAddressApartmentRoomOrSuiteNumber,'') = isnull(r.MailingAddressApartmentRoomOrSuiteNumber,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #leas_staging s
		left JOIN #leas_reporting r 
			ON s.LEAIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'Mailing Address Match'
			,'Mailing Address Match ' + s.LEAIdentifierSea
			,s.MailingAddressStreetNumberAndName
			,r.MailingAddressStreet
			,CASE WHEN isnull(s.MailingAddressStreetNumberAndName,'') = isnull(r.MailingAddressStreet,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #leas_staging s
		left JOIN #leas_reporting r 
			ON s.LEAIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'Mailing Address State Match'
			,'Mailing Address State Match ' + s.LEAIdentifierSea
			,s.MailingStateAbbreviation
			,r.MailingAddressState
			,CASE WHEN isnull(s.MailingStateAbbreviation,'') = isnull(r.MailingAddressState,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #leas_staging s
		left JOIN #leas_reporting r 
			ON s.LEAIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'Mailing Address City Match'
			,'Mailing Address City Match ' + s.LEAIdentifierSea
			,s.MailingAddressCity
			,r.MailingAddressCity
			,CASE WHEN isnull(s.MailingAddressCity,'') = isnull(r.MailingAddressCity,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #leas_staging s
		left JOIN #leas_reporting r 
			ON s.LEAIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'Mailing Address Postal Match'
			,'Mailing Address Postal Match ' + s.LEAIdentifierSea
			,s.MailingAddressPostalCode
			,r.MailingAddressPostalCode
			,CASE WHEN isnull(s.MailingAddressPostalCode,'') = isnull(r.MailingAddressPostalCode,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #leas_staging s
		left JOIN #leas_reporting r 
			ON s.LEAIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'Physical Address Match'
			,'Physical Address Match ' + s.LEAIdentifierSea
			,s.PhysicalAddressStreetNumberAndName
			,r.PhysicalAddressStreet
			,CASE WHEN isnull(s.PhysicalAddressStreetNumberAndName,'') = isnull(r.PhysicalAddressStreet,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #leas_staging s
		left JOIN #leas_reporting r 
			ON s.LEAIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'Physical Address Apartment Room Or Suite Match'
			,'Physical Address Match ' + s.LEAIdentifierSea
			,s.PhysicalAddressApartmentRoomOrSuiteNumber
			,r.PhysicalAddressApartmentRoomOrSuiteNumber
			,CASE WHEN isnull(s.PhysicalAddressApartmentRoomOrSuiteNumber,'') = isnull(r.PhysicalAddressApartmentRoomOrSuiteNumber,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #leas_staging s
		left JOIN #leas_reporting r 
			ON s.LEAIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'Physical Address State Match'
			,'Physical Address State Match ' + s.LEAIdentifierSea
			,s.PhysicalStateAbbreviation
			,r.PhysicalAddressState
			,CASE WHEN isnull(s.PhysicalStateAbbreviation,'') = isnull(r.PhysicalAddressState,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #leas_staging s
		left JOIN #leas_reporting r 
			ON s.LEAIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'Physical Address City Match'
			,'Physical Address City Match ' + s.LEAIdentifierSea
			,s.PhysicalAddressCity
			,r.PhysicalAddressCity
			,CASE WHEN isnull(s.PhysicalAddressCity,'') = isnull(r.PhysicalAddressCity,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #leas_staging s
		left JOIN #leas_reporting r 
			ON s.LEAIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'Physical Address Postal Match'
			,'Physical Address Postal Match ' + s.LEAIdentifierSea
			,s.PhysicalAddressPostalCode
			,r.PhysicalAddressPostalCode
			,CASE WHEN isnull(s.PhysicalAddressPostalCode,'') = isnull(r.PhysicalAddressPostalCode,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #leas_staging s
		left JOIN #leas_reporting r 
			ON s.LEAIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'LEA Telephone Match'
			,'LEA Telephone Match ' + s.LEAIdentifierSea
			,s.TelephoneNumber
			,r.Telephone
			,CASE WHEN ISNULL(s.TelephoneNumber, '')  = ISNULL(r.Telephone, '') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #leas_staging s
		left JOIN #leas_reporting r 
			ON s.LEAIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'LEA Supervisory Identification Number Match' 
			,'LEA Supervisory Identification Number Match ' + s.LEAIdentifierSea
			,s.LEA_SupervisoryUnionIdentificationNumber
			,r.SupervisoryUnionIdentificationNumber
			,CASE WHEN ISNULL(s.LEA_SupervisoryUnionIdentificationNumber, '') = ISNULL(r.SupervisoryUnionIdentificationNumber, '') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #leas_staging s
		left JOIN #leas_reporting r 
			ON s.LEAIdentifierSea = r.OrganizationStateId

		SELECT
		DISTINCT 
			sko.LEAIdentifierSea
			, sko.LEAIdentifierNCES
			, sko.SchoolIdentifierSea
			, sko.SchoolIdentifierNCES
			, sko.SchoolOrganizationName
			, sko.School_WebSiteAddress
			, CASE sssrd1.OutputCode
				WHEN 'Open' THEN 1 
				WHEN 'Closed' THEN 2 
				WHEN 'New' THEN 3 
				WHEN 'Added' THEN 4 
				WHEN 'ChangedAgency' THEN 5 
				WHEN 'Inactive' THEN 6 
				WHEN 'FutureSchool' THEN 7 
				WHEN 'Reopened' THEN 8 
				ELSE NULL
			end as School_OperationalStatus
			, sko.School_OperationalStatusEffectiveDate
			, CASE sko.School_CharterSchoolIndicator
				when 1 then 'YES' 
				when 0 then 'NO' 
				ELSE 'MISSING' 
			END as School_CharterSchoolStatus
			, CASE sssrd3.OutputCode 
				WHEN 'Regular' THEN 1
				WHEN 'Special' THEN 2
				WHEN 'CareerAndTechnical' THEN 3
				WHEN 'Alternative' THEN 4
				WHEN 'Reportable' THEN 5
				ELSE -1
			END as School_Type
			, sko.School_IsReportedFederally
			, sko.School_RecordStartDateTime
			, sko.School_RecordEndDateTime
			, REPLACE(REPLACE(REPLACE(phone.TelephoneNumber,'-',''),'(',''),')','') AS TelephoneNumber
			, mailing.AddressStreetNumberAndName as MailingAddressStreetNumberAndName
			, mailing.AddressApartmentRoomOrSuiteNumber as MailingAddressApartmentRoomOrSuiteNumber
			, mailing.AddressCity as MailingAddressCity
			, mailing.StateAbbreviation as MailingStateAbbreviation
			, mailing.AddressPostalCode as MailingAddressPostalCode
			, physical.AddressStreetNumberAndName as PhysicalAddressStreetNumberAndName
			, physical.AddressApartmentRoomOrSuiteNumber as PhysicalAddressApartmentRoomOrSuiteNumber
			, physical.AddressCity as PhysicalAddressCity
			, physical.StateAbbreviation as PhysicalStateAbbreviation
			, physical.AddressPostalCode as PhysicalAddressPostalCode
			, sko.PriorSchoolIdentifierSea as PriorSchoolStateIdentifier
			, sko.School_PriorLeaIdentifierSea as PriorLeaStateIdentifier
		INTO #schools_staging
		FROM Staging.K12Organization sko
		INNER JOIN staging.SourceSystemReferenceData sssrd3
			ON sko.School_Type = sssrd3.InputCode
			AND sssrd3.TableName = 'RefSchoolType'
			AND sko.SchoolYear = sssrd3.SchoolYear
		left join (select OrganizationIdentifier, AddressStreetNumberAndName, AddressApartmentRoomOrSuiteNumber, AddressCity, StateAbbreviation, AddressPostalCode
			from Staging.OrganizationAddress
			where AddressTypeForOrganization in ('Mailing','Mailing_1') ) mailing on mailing.OrganizationIdentifier = sko.SchoolIdentifierSea
		left join (select OrganizationIdentifier, AddressStreetNumberAndName, AddressApartmentRoomOrSuiteNumber, AddressCity, StateAbbreviation, AddressPostalCode
			from Staging.OrganizationAddress
			where AddressTypeForOrganization in ('Physical','Physical_1') ) physical on physical.OrganizationIdentifier = sko.SchoolIdentifierSea
		left join Staging.OrganizationPhone phone on phone.OrganizationIdentifier = sko.SchoolIdentifierSea
		LEFT JOIN staging.SourceSystemReferenceData sssrd1
			ON sko.School_OperationalStatus = sssrd1.InputCode
			AND sssrd1.TableName = 'RefOperationalStatus'
			AND sssrd1.TableFilter = '000533'
			AND sko.SchoolYear = sssrd1.SchoolYear
		where sko.SchoolYear = @SchoolYear and isnull(sko.School_IsReportedFederally,0) = 1
		and ISNULL(sko.SchoolIdentifierSea, '') <> ''
		and phone.OrganizationIdentifier IS NOT NULL

		select distinct   
			ParentOrganizationStateId
			, ParentOrganizationNcesId
			, OrganizationStateId
			, OrganizationNcesId
			, OrganizationName
			, WebSite
			, OperationalStatus
			, EffectiveDate
			, CharterSchoolStatus
			, SchoolType
			, Telephone
			, MailingAddressStreet
			, MailingAddressCity
			, MailingAddressApartmentRoomOrSuiteNumber
			, MailingAddressState
			, MailingAddressPostalCode
			, PhysicalAddressStreet
			, PhysicalAddressApartmentRoomOrSuiteNumber
			, PhysicalAddressCity
			, PhysicalAddressState
			, PhysicalAddressPostalCode
			, PriorSchoolStateIdentifier
			, PriorLeaStateIdentifier
		INTO #schools_reporting
		from RDS.ReportEDFactsOrganizationCounts
		where reportcode = 'c029' and ReportLevel = 'SCH' and ReportYear = @SchoolYear

		INSERT INTO App.SqlUnitTestCASEResult (
				[SqlUnitTestId]
				,[TestCASEName]
				,[TestCASEDetails]
				,[ExpectedResult]
				,[ActualResult]
				,[Passed]
				,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'School Name Match'
			,'School Name Match ' + s.SchoolIdentifierSea
			,s.SchoolOrganizationName
			,r.OrganizationName
			,CASE WHEN isnull(s.SchoolOrganizationName,'') = isnull(r.OrganizationName,'') THEN 1 
				ELSE 0 END as SchoolNameMatch
			,GETDATE()
		FROM #schools_staging s
		left JOIN #schools_reporting r 
			ON s.SchoolIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'School WebSite Match'
			,'School WebSite Match ' + s.SchoolIdentifierSea
			,s.School_WebSiteAddress
			,r.Website
			,CASE WHEN isnull(s.School_WebSiteAddress,'') = isnull(r.Website,'') THEN 1 
				ELSE 0 END as SchoolWebSiteMatch
			,GETDATE()
		FROM #schools_staging s
		left JOIN #schools_reporting r 
			ON s.SchoolIdentifierSea = r.OrganizationStateId
			
		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'School OperationalStatus Match'
			,'School OperationalStatus Match ' + s.SchoolIdentifierSea
			,s.School_OperationalStatus
			,r.OperationalStatus
			,CASE WHEN isnull(s.School_OperationalStatus,'') = isnull(r.OperationalStatus,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #schools_staging s
		left JOIN #schools_reporting r 
			ON s.SchoolIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
				[SqlUnitTestId]
				,[TestCASEName]
				,[TestCASEDetails]
				,[ExpectedResult]
				,[ActualResult]
				,[Passed]
				,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'CharterSchoolStatus Match'
			,'CharterSchoolStatus Match ' + s.SchoolIdentifierSea
			,s.School_CharterSchoolStatus
			,r.CharterSchoolStatus
			,CASE WHEN isnull(s.School_CharterSchoolStatus,'') = isnull(r.CharterSchoolStatus,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #schools_staging s
		left JOIN #schools_reporting r 
			ON s.SchoolIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'School CharterSchoolIndicator Match'
			,'School CharterSchoolIndicator Match ' + s.SchoolIdentifierSea
			,s.School_CharterSchoolStatus
			,r.CharterSchoolStatus
			,CASE WHEN isnull(s.School_CharterSchoolStatus,'') = isnull(r.CharterSchoolStatus,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #schools_staging s
		left JOIN #schools_reporting r 
			ON s.SchoolIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'SchoolType Match'
			,'SchoolType Match ' + s.SchoolIdentifierSea
			,s.School_Type
			,r.SchoolType
			,CASE WHEN isnull(s.School_Type,'') = isnull(r.SchoolType,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #schools_staging s
		left JOIN #schools_reporting r 
			ON s.SchoolIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'Mailing Address Match'
			,'Mailing Address Match ' + s.SchoolIdentifierSea
			,s.MailingAddressStreetNumberAndName
			,r.MailingAddressStreet
			,CASE WHEN isnull(s.MailingAddressStreetNumberAndName,'') = isnull(r.MailingAddressStreet,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #schools_staging s
		left JOIN #schools_reporting r 
			ON s.SchoolIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'Mailing Address Apartment Room Or Suite Number Match'
			,'Mailing Address Match ' + s.SchoolIdentifierSea
			,s.MailingAddressApartmentRoomOrSuiteNumber
			,r.MailingAddressApartmentRoomOrSuiteNumber
			,CASE WHEN isnull(s.MailingAddressApartmentRoomOrSuiteNumber,'') = isnull(r.MailingAddressApartmentRoomOrSuiteNumber,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #schools_staging s
		left JOIN #schools_reporting r 
			ON s.SchoolIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'Mailing Address State Match'
			,'Mailing Address State Match ' + s.SchoolIdentifierSea
			,s.MailingStateAbbreviation
			,r.MailingAddressState
			,CASE WHEN isnull(s.MailingStateAbbreviation,'') = isnull(r.MailingAddressState,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #schools_staging s
		left JOIN #schools_reporting r 
			ON s.SchoolIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'Mailing Address City Match'
			,'Mailing Address City Match ' + s.SchoolIdentifierSea
			,s.MailingAddressCity
			,r.MailingAddressCity
			,CASE WHEN isnull(s.MailingAddressCity,'') = isnull(r.MailingAddressCity,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #schools_staging s
		left JOIN #schools_reporting r 
			ON s.SchoolIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'Mailing Address Postal Match'
			,'Mailing Address Postal Match ' + s.SchoolIdentifierSea
			,s.MailingAddressPostalCode
			,r.MailingAddressPostalCode
			,CASE WHEN isnull(s.MailingAddressPostalCode,'') = isnull(r.MailingAddressPostalCode,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #schools_staging s
		left JOIN #schools_reporting r 
			ON s.SchoolIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'Physical Address Match'
			,'Physical Address Match ' + s.SchoolIdentifierSea
			,s.PhysicalAddressStreetNumberAndName
			,r.PhysicalAddressStreet
			,CASE WHEN isnull(s.PhysicalAddressStreetNumberAndName,'') = isnull(r.PhysicalAddressStreet,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #schools_staging s
		left JOIN #schools_reporting r 
			ON s.SchoolIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'Physical Address Apartment Room Or Suite Number Match'
			,'Physical Address Match ' + s.SchoolIdentifierSea
			,s.PhysicalAddressApartmentRoomOrSuiteNumber
			,r.PhysicalAddressApartmentRoomOrSuiteNumber
			,CASE WHEN isnull(s.PhysicalAddressApartmentRoomOrSuiteNumber,'') = isnull(r.PhysicalAddressApartmentRoomOrSuiteNumber,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #schools_staging s
		left JOIN #schools_reporting r 
			ON s.SchoolIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'Physical Address State Match'
			,'Physical Address State Match ' + s.SchoolIdentifierSea
			,s.PhysicalStateAbbreviation
			,r.PhysicalAddressState
			,CASE WHEN isnull(s.PhysicalStateAbbreviation,'') = isnull(r.PhysicalAddressState,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #schools_staging s
		left JOIN #schools_reporting r 
			ON s.SchoolIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'Physical Address City Match'
			,'Physical Address City Match ' + s.SchoolIdentifierSea
			,s.PhysicalAddressCity
			,r.PhysicalAddressCity
			,CASE WHEN isnull(s.PhysicalAddressCity,'') = isnull(r.PhysicalAddressCity,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #schools_staging s
		left JOIN #schools_reporting r 
			ON s.SchoolIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'Physical Address Postal Match'
			,'Physical Address Postal Match ' + s.SchoolIdentifierSea
			,s.PhysicalAddressPostalCode
			,r.PhysicalAddressPostalCode
			,CASE WHEN isnull(s.PhysicalAddressPostalCode,'') = isnull(r.PhysicalAddressPostalCode,'') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #schools_staging s
		left JOIN #schools_reporting r 
			ON s.SchoolIdentifierSea = r.OrganizationStateId

		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'School Telephone Match'
			,'School Telephone Match ' + s.SchoolIdentifierSea
			,s.TelephoneNumber
			,r.Telephone
			,CASE WHEN ISNULL(s.TelephoneNumber, '') = ISNULL(r.Telephone, '') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #schools_staging s
		left JOIN #schools_reporting r 
			ON s.SchoolIdentifierSea = r.OrganizationStateId

		-- CIID-6443 ---------------------------------------------------
		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'PriorSchoolStateIdentifier Match'
			,'PriorSchoolStateIdentifier Match ' + s.PriorSchoolStateIdentifier
			,s.PriorSchoolStateIdentifier
			,r.PriorSchoolStateIdentifier
			,CASE WHEN ISNULL(s.PriorSchoolStateIdentifier, '') = ISNULL(r.PriorSchoolStateIdentifier, '') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #schools_staging s
		left JOIN #schools_reporting r 
			ON s.SchoolIdentifierSea = r.OrganizationStateId

	-- CIID-6443 ------------------------------------------------------
		INSERT INTO App.SqlUnitTestCASEResult (
			[SqlUnitTestId]
			,[TestCASEName]
			,[TestCASEDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT distinct
			@SqlUnitTestId
			,'PriorLEAStateIdentifier Match'
			,'PriorLEAStateIdentifier Match ' + s.PriorLeaStateIdentifier
			,s.PriorLeaStateIdentifier
			,r.PriorLeaStateIdentifier
			,CASE WHEN ISNULL(s.PriorLeaStateIdentifier, '') = ISNULL(r.PriorLeaStateIdentifier, '') THEN 1 
				ELSE 0 END
			,GETDATE()
		FROM #schools_staging s
		left JOIN #schools_reporting r 
			ON s.SchoolIdentifierSea = r.OrganizationStateId



		drop table #leas_staging
		drop table #leas_reporting
		drop table #schools_staging
		drop table #schools_reporting

	--COMMIT TRANSACTION

	-- IF THE TEST PRODUCES NO RESULTS INSERT A RECORD TO INDICATE THIS
	if not exists 
		(select top 1 * 
			from app.sqlunittest t
				inner join app.SqlUnitTestCaseResult r
					on t.SqlUnitTestId = r.SqlUnitTestId
			where t.SqlUnitTestId = @SqlUnitTestId
		)
	begin
		INSERT INTO App.SqlUnitTestCaseResult (
			SqlUnitTestId
			, TestCaseName
			, TestCaseDetails
			, ExpectedResult
			, ActualResult
			, Passed
			, TestDateTime
		)
		SELECT DISTINCT
			@SqlUnitTestId
			, 'NO TEST RESULTS'
			, 'NO TEST RESULTS'
			, -1
			, -1
			, NULL
			, GETDATE()
	end

	--check the results
	--select *
	--from App.SqlUnitTestCaseResult sr
	--	inner join App.SqlUnitTest s
	--		on s.SqlUnitTestId = sr.SqlUnitTestId
	--where s.UnitTestName like '%029%'
	--and passed = 0
	--and convert(date, TestDateTime) = convert(date, GETDATE())

END