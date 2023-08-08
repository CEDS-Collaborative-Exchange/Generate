CREATE PROCEDURE [App].[FS029_TestCase]
	@SchoolYear SMALLINT
AS
BEGIN

BEGIN TRY
	--BEGIN TRANSACTIONs
		

		DECLARE @charterLeaCount AS INT
		SELECT @charterLeaCount = count(OrganizationId) FROM dbo.K12Lea WHERE CharterSchoolIndicator = 1

		 --Define the test
		DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
		IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS029_UnitTestCASE') 
		BEGIN
			SET @expectedResult = 1
			INSERT INTO App.SqlUnitTest 
			(
				  [UnitTestName]
				, [StoredProcedureName]
				, [TestScope]
				, [IsActive]
			)
			VALUES 
			(
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
		  ,sko.LEAIdentifierNCES
		  ,sko.LEA_SupervisoryUnionIdentificationNumber
		  ,sko.LEAOrganizationName
		  ,sko.LEA_WebSiteAddress
		  , CASE sssrd1.OutputCode
				WHEN 'Open' THEN 1 
				WHEN 'Closed' THEN 2 
				WHEN 'New' THEN 3 
				WHEN 'Added' THEN 4 
				WHEN 'ChangedBoundary' THEN 5 
				WHEN 'Inactive' THEN 6 
				WHEN 'FutureAgency' THEN 7 
				WHEN 'Reopened' THEN 8 
				ELSE NULL
			  END LEA_OperationalStatus
		  ,sko.LEA_OperationalStatusEffectiveDate
		  ,sko.LEA_CharterLeaStatus
		  ,sko.LEA_CharterSchoolIndicator
		  ,isnull(sko.LEA_Type, -1) LEA_Type
		  ,sko.LEA_IsReportedFederally
		  ,sko.LEA_RecordStartDateTime
		  ,sko.LEA_RecordEndDateTime
		  , phone.TelephoneNumber
		  , mailing.AddressStreetNumberAndName as MailingAddressStreetNumberAndName
		  , mailing.AddressCity as MailingAddressCity
		  , mailing.StateAbbreviation as MailingStateAbbreviation
		  , mailing.AddressPostalCode as MailingAddressPostalCode
		  , physical.AddressStreetNumberAndName as PhysicalAddressStreetNumberAndName
		  , physical.AddressCity as PhysicalAddressCity
		  , physical.StateAbbreviation as PhysicalStateAbbreviation
		  , physical.AddressPostalCode as PhysicalAddressPostalCode
		INTO #leas_staging
		FROM Staging.K12Organization sko
		left join (select OrganizationIdentifier, AddressStreetNumberAndName, AddressCity, StateAbbreviation, AddressPostalCode
		  from Staging.OrganizationAddress
		  where AddressTypeForOrganization = 'Mailing' ) mailing on mailing.OrganizationIdentifier = sko.LEAIdentifierSea
		left join (select OrganizationIdentifier, AddressStreetNumberAndName, AddressCity, StateAbbreviation, AddressPostalCode
		  from Staging.OrganizationAddress
		  where AddressTypeForOrganization = 'Physical' ) physical on physical.OrganizationIdentifier = sko.LEAIdentifierSea
		left join Staging.OrganizationPhone phone on phone.OrganizationIdentifier = sko.LEAIdentifierSea
		LEFT JOIN staging.SourceSystemReferenceData sssrd1
			ON sko.Lea_OperationalStatus = sssrd1.InputCode
			AND sssrd1.TableName = 'RefOperationalStatus'
			AND sssrd1.TableFilter = '000174'
			AND sko.SchoolYear = sssrd1.SchoolYear
		where sko.SchoolYear = @SchoolYear and isnull(sko.LEA_IsReportedFederally,0) = 1	

		select	 distinct
		   OrganizationStateId
		  ,OrganizationNcesId
		  ,SupervisoryUnionIdentificationNumber
		  ,OrganizationName
		  ,WebSite
		  ,OperationalStatus
		  ,EffectiveDate
		  ,CharterLeaStatus
		  ,CharterSchoolIndicator
		  ,LEAType
		  ,Telephone
		  , MailingAddressStreet
		  , MailingAddressCity
		  , MailingAddressState
		  , MailingAddressPostalCode
		  , PhysicalAddressStreet
		  , PhysicalAddressCity
		  , PhysicalAddressState
		  , PhysicalAddressPostalCode
		INTO #leas_reporting
		from RDS.ReportEDFactsOrganizationCounts
		where reportcode = 'c029' and ReportLevel = 'LEA' and ReportYear = @SchoolYear

--select * from #leas_staging --where LeaIdentifierSea = 
--return
		 INSERT INTO App.SqlUnitTestCASEResult 
		 (
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

		 INSERT INTO App.SqlUnitTestCASEResult 
		 (
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


		 INSERT INTO App.SqlUnitTestCASEResult 
		 (
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


		INSERT INTO App.SqlUnitTestCASEResult 
		 (
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
				WHEN s.LEA_CharterSchoolIndicator = 1 
					AND leaType.Code = 'RegularNotInSupervisoryUnion' THEN ISNULL(s.LEA_CharterLeaStatus, 'MISSING') 
				ELSE IIF(@charterLeaCount > 0,'NOTCHR','NA') 
			  END AS LEA_CharterLeaStatus
			 ,r.CharterLeaStatus
			 ,CASE WHEN 
			 CASE 
				WHEN s.LEA_CharterSchoolIndicator = 1 
					AND leaType.Code = 'RegularNotInSupervisoryUnion' THEN ISNULL(s.LEA_CharterLeaStatus, 'MISSING') 
				ELSE IIF(@charterLeaCount > 0,'NOTCHR','NA') 
			  END = isnull(r.CharterLeaStatus,'') THEN 1 
				   ELSE 'MISSING' END
			 ,GETDATE()
		 FROM #leas_staging s
		 left JOIN #leas_reporting r 
			 ON s.LEAIdentifierSea = r.OrganizationStateId
		 left JOIN dbo.RefLeaType leaType 
			ON s.LEA_Type = leaType.RefLeaTypeId



		 INSERT INTO App.SqlUnitTestCASEResult 
		 (
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

		 INSERT INTO App.SqlUnitTestCASEResult 
		 (
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
			 ,s.LEA_Type
			 ,r.LEAType
			 ,CASE WHEN isnull(s.LEA_Type,'') = isnull(r.LEAType,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #leas_staging s
		 left JOIN #leas_reporting r 
			 ON s.LEAIdentifierSea = r.OrganizationStateId


		 INSERT INTO App.SqlUnitTestCASEResult 
		 (
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


		INSERT INTO App.SqlUnitTestCASEResult 
		 (
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

		INSERT INTO App.SqlUnitTestCASEResult 
		 (
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

		INSERT INTO App.SqlUnitTestCASEResult 
		 (
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


		INSERT INTO App.SqlUnitTestCASEResult 
		 (
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


		INSERT INTO App.SqlUnitTestCASEResult 
		 (
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

		INSERT INTO App.SqlUnitTestCASEResult 
		 (
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

		INSERT INTO App.SqlUnitTestCASEResult 
		 (
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


		INSERT INTO App.SqlUnitTestCASEResult 
		 (
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


		INSERT INTO App.SqlUnitTestCASEResult 
		 (
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
		  ,sko.LEAIdentifierNCES
		  ,sko.SchoolIdentifierSea
		  ,sko.SchoolIdentifierNCES
		  ,sko.SchoolOrganizationName
		  ,sko.School_WebSiteAddress
		  ,CASE sssrd1.OutputCode
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
		  ,sko.School_OperationalStatusEffectiveDate
		  ,CASE sko.School_CharterSchoolIndicator
				when 1 then 'YES' 
				when 0 then 'NO' 
				ELSE 'MISSING' 
			END as School_CharterSchoolStatus
		  ,CASE sssrd3.OutputCode 
				WHEN 'Regular' THEN 1
				WHEN 'Special' THEN 2
				WHEN 'CareerAndTechnical' THEN 3
				WHEN 'Alternative' THEN 4
				WHEN 'Reportable' THEN 5
				ELSE -1
			END as School_Type
		  ,sko.School_IsReportedFederally
		  ,sko.School_RecordStartDateTime
		  ,sko.School_RecordEndDateTime
		  , phone.TelephoneNumber
		  , mailing.AddressStreetNumberAndName as MailingAddressStreetNumberAndName
		  , mailing.AddressCity as MailingAddressCity
		  , mailing.StateAbbreviation as MailingStateAbbreviation
		  , mailing.AddressPostalCode as MailingAddressPostalCode
		  , physical.AddressStreetNumberAndName as PhysicalAddressStreetNumberAndName
		  , physical.AddressCity as PhysicalAddressCity
		  , physical.StateAbbreviation as PhysicalStateAbbreviation
		  , physical.AddressPostalCode as PhysicalAddressPostalCode
		INTO #schools_staging
		FROM Staging.K12Organization sko
		left join (select OrganizationIdentifier, AddressStreetNumberAndName, AddressCity, StateAbbreviation, AddressPostalCode
		  from Staging.OrganizationAddress
		  where AddressTypeForOrganization = 'Mailing' ) mailing on mailing.OrganizationIdentifier = sko.SchoolIdentifierSea
		left join (select OrganizationIdentifier, AddressStreetNumberAndName, AddressCity, StateAbbreviation, AddressPostalCode
		  from Staging.OrganizationAddress
		  where AddressTypeForOrganization = 'Physical' ) physical on physical.OrganizationIdentifier = sko.SchoolIdentifierSea
		left join Staging.OrganizationPhone phone on phone.OrganizationIdentifier = sko.SchoolIdentifierSea
		LEFT JOIN staging.SourceSystemReferenceData sssrd1
			ON sko.School_OperationalStatus = sssrd1.InputCode
			AND sssrd1.TableName = 'RefOperationalStatus'
			AND sssrd1.TableFilter = '000533'
			AND sko.SchoolYear = sssrd1.SchoolYear
		LEFT JOIN staging.SourceSystemReferenceData sssrd3
			ON sko.School_Type = sssrd3.InputCode
			AND sssrd3.TableName = 'RefSchoolType'
			AND sko.SchoolYear = sssrd3.SchoolYear

		where sko.SchoolYear = @SchoolYear and isnull(sko.School_IsReportedFederally,0) = 1

		select distinct   
		   ParentOrganizationStateId
		  ,ParentOrganizationNcesId
		  ,OrganizationStateId
		  ,OrganizationNcesId
		  ,OrganizationName
		  ,WebSite
		  ,OperationalStatus
		  ,EffectiveDate
		  ,CharterSchoolStatus
		  ,SchoolType
		  ,Telephone
		  , MailingAddressStreet
		  , MailingAddressCity
		  , MailingAddressState
		  , MailingAddressPostalCode
		  , PhysicalAddressStreet
		  , PhysicalAddressCity
		  , PhysicalAddressState
		  , PhysicalAddressPostalCode
		INTO #schools_reporting
		from RDS.ReportEDFactsOrganizationCounts
		where reportcode = 'c029' and ReportLevel = 'SCH' and ReportYear = @SchoolYear



		 INSERT INTO App.SqlUnitTestCASEResult 
		 (
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

		 INSERT INTO App.SqlUnitTestCASEResult 
		 (
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


		 INSERT INTO App.SqlUnitTestCASEResult 
		 (
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


		INSERT INTO App.SqlUnitTestCASEResult 
		 (
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


		 INSERT INTO App.SqlUnitTestCASEResult 
		 (
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

		 INSERT INTO App.SqlUnitTestCASEResult 
		 (
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


		 INSERT INTO App.SqlUnitTestCASEResult 
		 (
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


		INSERT INTO App.SqlUnitTestCASEResult 
		 (
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

		INSERT INTO App.SqlUnitTestCASEResult 
		 (
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

		INSERT INTO App.SqlUnitTestCASEResult 
		 (
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


		INSERT INTO App.SqlUnitTestCASEResult 
		 (
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


		INSERT INTO App.SqlUnitTestCASEResult 
		 (
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

		INSERT INTO App.SqlUnitTestCASEResult 
		 (
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

		INSERT INTO App.SqlUnitTestCASEResult 
		 (
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


		INSERT INTO App.SqlUnitTestCASEResult 
		 (
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






		drop table #leas_staging
		drop table #leas_reporting
		drop table #schools_staging
		drop table #schools_reporting







	--COMMIT TRANSACTION

	END TRY
	BEGIN CATCH

	--IF @@TRANCOUNT > 0
	--BEGIN
	--	ROLLBACK TRANSACTION
	--END

	DECLARE @msg AS NVARCHAR(MAX)
	SET @msg = ERROR_MESSAGE()

	DECLARE @sev AS INT
	SET @sev = ERROR_SEVERITY()

	RAISERROR(@msg, @sev, 1)

	END CATCH; 


END