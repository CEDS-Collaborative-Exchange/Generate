CREATE PROCEDURE [App].[FS029_TestCase]
	@SchoolYear SMALLINT
AS
BEGIN

BEGIN TRY
	BEGIN TRANSACTION
		

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
		   sko.LEA_Identifier_State
		  ,sko.LEA_Identifier_NCES
		  ,sko.LEA_SupervisoryUnionIdentificationNumber
		  ,sko.LEA_Name
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
		  ,sko.LEA_Type
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
		  where AddressTypeForOrganization = 'Mailing' ) mailing on mailing.OrganizationIdentifier = sko.LEA_Identifier_State
		left join (select OrganizationIdentifier, AddressStreetNumberAndName, AddressCity, StateAbbreviation, AddressPostalCode
		  from Staging.OrganizationAddress
		  where AddressTypeForOrganization = 'Physical' ) physical on physical.OrganizationIdentifier = sko.LEA_Identifier_State
		left join Staging.OrganizationPhone phone on phone.OrganizationIdentifier = sko.LEA_Identifier_State
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
		from rds.FactOrganizationCountReports
		where reportcode = 'c029' and ReportLevel = 'LEA' and ReportYear = @SchoolYear


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
			 ,'LEA Name Match ' + s.LEA_Identifier_State
			 ,s.LEA_Name
			 ,r.OrganizationName
			 ,CASE WHEN isnull(s.LEA_Name,'') = isnull(r.OrganizationName,'') THEN 1 
				   ELSE 0 END as LEANameMatch
			 ,GETDATE()
		 FROM #leas_staging s
		 left JOIN #leas_reporting r 
			 ON s.LEA_Identifier_State = r.OrganizationStateId

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
			 ,'LEA WebSite Match ' + s.LEA_Identifier_State
			 ,s.LEA_WebSiteAddress
			 ,r.Website
			 ,CASE WHEN isnull(s.LEA_WebSiteAddress,'') = isnull(r.Website,'') THEN 1 
				   ELSE 0 END as LEAWebSiteMatch
			 ,GETDATE()
		 FROM #leas_staging s
		 left JOIN #leas_reporting r 
			 ON s.LEA_Identifier_State = r.OrganizationStateId


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
			 ,'LEA OperationalStatus Match ' + s.LEA_Identifier_State
			 ,s.LEA_OperationalStatus
			 ,r.OperationalStatus
			 ,CASE WHEN isnull(s.LEA_OperationalStatus,'') = isnull(r.OperationalStatus,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #leas_staging s
		 left JOIN #leas_reporting r 
			 ON s.LEA_Identifier_State = r.OrganizationStateId


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
			 ,'CharterLeaStatus Match ' + s.LEA_Identifier_State
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
			 ON s.LEA_Identifier_State = r.OrganizationStateId
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
			 ,'LEA CharterSchoolIndicator Match ' + s.LEA_Identifier_State
			 ,s.LEA_CharterSchoolIndicator
			 ,r.CharterSchoolIndicator
			 ,CASE WHEN isnull(s.LEA_CharterSchoolIndicator,'') = isnull(r.CharterSchoolIndicator,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #leas_staging s
		 left JOIN #leas_reporting r 
			 ON s.LEA_Identifier_State = r.OrganizationStateId

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
			 ,'LEAType Match ' + s.LEA_Identifier_State
			 ,s.LEA_Type
			 ,r.LEAType
			 ,CASE WHEN isnull(s.LEA_Type,'') = isnull(r.LEAType,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #leas_staging s
		 left JOIN #leas_reporting r 
			 ON s.LEA_Identifier_State = r.OrganizationStateId


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
			 ,'Mailing Address Match ' + s.LEA_Identifier_State
			 ,s.MailingAddressStreetNumberAndName
			 ,r.MailingAddressStreet
			 ,CASE WHEN isnull(s.MailingAddressStreetNumberAndName,'') = isnull(r.MailingAddressStreet,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #leas_staging s
		 left JOIN #leas_reporting r 
			 ON s.LEA_Identifier_State = r.OrganizationStateId


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
			 ,'Mailing Address State Match ' + s.LEA_Identifier_State
			 ,s.MailingStateAbbreviation
			 ,r.MailingAddressState
			 ,CASE WHEN isnull(s.MailingStateAbbreviation,'') = isnull(r.MailingAddressState,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #leas_staging s
		 left JOIN #leas_reporting r 
			 ON s.LEA_Identifier_State = r.OrganizationStateId

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
			 ,'Mailing Address City Match ' + s.LEA_Identifier_State
			 ,s.MailingAddressCity
			 ,r.MailingAddressCity
			 ,CASE WHEN isnull(s.MailingAddressCity,'') = isnull(r.MailingAddressCity,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #leas_staging s
		 left JOIN #leas_reporting r 
			 ON s.LEA_Identifier_State = r.OrganizationStateId

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
			 ,'Mailing Address Postal Match ' + s.LEA_Identifier_State
			 ,s.MailingAddressPostalCode
			 ,r.MailingAddressPostalCode
			 ,CASE WHEN isnull(s.MailingAddressPostalCode,'') = isnull(r.MailingAddressPostalCode,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #leas_staging s
		 left JOIN #leas_reporting r 
			 ON s.LEA_Identifier_State = r.OrganizationStateId


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
			 ,'Physical Address Match ' + s.LEA_Identifier_State
			 ,s.PhysicalAddressStreetNumberAndName
			 ,r.PhysicalAddressStreet
			 ,CASE WHEN isnull(s.PhysicalAddressStreetNumberAndName,'') = isnull(r.PhysicalAddressStreet,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #leas_staging s
		 left JOIN #leas_reporting r 
			 ON s.LEA_Identifier_State = r.OrganizationStateId


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
			 ,'Physical Address State Match ' + s.LEA_Identifier_State
			 ,s.PhysicalStateAbbreviation
			 ,r.PhysicalAddressState
			 ,CASE WHEN isnull(s.PhysicalStateAbbreviation,'') = isnull(r.PhysicalAddressState,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #leas_staging s
		 left JOIN #leas_reporting r 
			 ON s.LEA_Identifier_State = r.OrganizationStateId

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
			 ,'Physical Address City Match ' + s.LEA_Identifier_State
			 ,s.PhysicalAddressCity
			 ,r.PhysicalAddressCity
			 ,CASE WHEN isnull(s.PhysicalAddressCity,'') = isnull(r.PhysicalAddressCity,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #leas_staging s
		 left JOIN #leas_reporting r 
			 ON s.LEA_Identifier_State = r.OrganizationStateId

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
			 ,'Physical Address Postal Match ' + s.LEA_Identifier_State
			 ,s.PhysicalAddressPostalCode
			 ,r.PhysicalAddressPostalCode
			 ,CASE WHEN isnull(s.PhysicalAddressPostalCode,'') = isnull(r.PhysicalAddressPostalCode,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #leas_staging s
		 left JOIN #leas_reporting r 
			 ON s.LEA_Identifier_State = r.OrganizationStateId


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
			 ,'LEA Telephone Match ' + s.LEA_Identifier_State
			 ,s.TelephoneNumber
			 ,r.Telephone
			 ,CASE WHEN ISNULL(s.TelephoneNumber, '')  = ISNULL(r.Telephone, '') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #leas_staging s
		 left JOIN #leas_reporting r 
			 ON s.LEA_Identifier_State = r.OrganizationStateId


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
			 ,'LEA Supervisory Identification Number Match ' + s.LEA_Identifier_State
			 ,s.LEA_SupervisoryUnionIdentificationNumber
			 ,r.SupervisoryUnionIdentificationNumber
			 ,CASE WHEN ISNULL(s.LEA_SupervisoryUnionIdentificationNumber, '') = ISNULL(r.SupervisoryUnionIdentificationNumber, '') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #leas_staging s
		 left JOIN #leas_reporting r 
			 ON s.LEA_Identifier_State = r.OrganizationStateId


		SELECT
		DISTINCT 
		   sko.LEA_Identifier_State
		  ,sko.LEA_Identifier_NCES
		  ,sko.School_Identifier_State
		  ,sko.School_Identifier_NCES
		  ,sko.School_Name
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
		  ,CASE WHEN isnull(sko.School_CharterSchoolIndicator,0) = 1 then 'YES' ELSE 'NO' END as School_CharterSchoolStatus
		  ,CASE sssrd3.OutputCode 
				WHEN 'Regular' THEN 1
				WHEN 'Special' THEN 2
				WHEN 'CareerAndTechnical' THEN 3
				WHEN 'Alternative' THEN 4
				WHEN 'Reportable' THEN 5
				ELSE NULL
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
		  where AddressTypeForOrganization = 'Mailing' ) mailing on mailing.OrganizationIdentifier = sko.School_Identifier_State
		left join (select OrganizationIdentifier, AddressStreetNumberAndName, AddressCity, StateAbbreviation, AddressPostalCode
		  from Staging.OrganizationAddress
		  where AddressTypeForOrganization = 'Physical' ) physical on physical.OrganizationIdentifier = sko.School_Identifier_State
		left join Staging.OrganizationPhone phone on phone.OrganizationIdentifier = sko.School_Identifier_State
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
		from rds.FactOrganizationCountReports
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
			 ,'School Name Match ' + s.School_Identifier_State
			 ,s.School_Name
			 ,r.OrganizationName
			 ,CASE WHEN isnull(s.School_Name,'') = isnull(r.OrganizationName,'') THEN 1 
				   ELSE 0 END as SchoolNameMatch
			 ,GETDATE()
		 FROM #schools_staging s
		 left JOIN #schools_reporting r 
			 ON s.School_Identifier_State = r.OrganizationStateId

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
			 ,'School WebSite Match ' + s.School_Identifier_State
			 ,s.School_WebSiteAddress
			 ,r.Website
			 ,CASE WHEN isnull(s.School_WebSiteAddress,'') = isnull(r.Website,'') THEN 1 
				   ELSE 0 END as SchoolWebSiteMatch
			 ,GETDATE()
		 FROM #schools_staging s
		 left JOIN #schools_reporting r 
			 ON s.School_Identifier_State = r.OrganizationStateId


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
			 ,'School OperationalStatus Match ' + s.School_Identifier_State
			 ,s.School_OperationalStatus
			 ,r.OperationalStatus
			 ,CASE WHEN isnull(s.School_OperationalStatus,'') = isnull(r.OperationalStatus,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #schools_staging s
		 left JOIN #schools_reporting r 
			 ON s.School_Identifier_State = r.OrganizationStateId


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
			 ,'CharterSchoolStatus Match ' + s.School_Identifier_State
			 ,s.School_CharterSchoolStatus
			 ,r.CharterSchoolStatus
			 ,CASE WHEN isnull(s.School_CharterSchoolStatus,'') = isnull(r.CharterSchoolStatus,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #schools_staging s
		 left JOIN #schools_reporting r 
			 ON s.School_Identifier_State = r.OrganizationStateId


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
			 ,'School CharterSchoolIndicator Match ' + s.School_Identifier_State
			 ,s.School_CharterSchoolStatus
			 ,r.CharterSchoolStatus
			 ,CASE WHEN isnull(s.School_CharterSchoolStatus,'') = isnull(r.CharterSchoolStatus,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #schools_staging s
		 left JOIN #schools_reporting r 
			 ON s.School_Identifier_State = r.OrganizationStateId

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
			 ,'SchoolType Match ' + s.School_Identifier_State
			 ,s.School_Type
			 ,r.SchoolType
			 ,CASE WHEN isnull(s.School_Type,'') = isnull(r.SchoolType,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #schools_staging s
		 left JOIN #schools_reporting r 
			 ON s.School_Identifier_State = r.OrganizationStateId


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
			 ,'Mailing Address Match ' + s.School_Identifier_State
			 ,s.MailingAddressStreetNumberAndName
			 ,r.MailingAddressStreet
			 ,CASE WHEN isnull(s.MailingAddressStreetNumberAndName,'') = isnull(r.MailingAddressStreet,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #schools_staging s
		 left JOIN #schools_reporting r 
			 ON s.School_Identifier_State = r.OrganizationStateId


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
			 ,'Mailing Address State Match ' + s.School_Identifier_State
			 ,s.MailingStateAbbreviation
			 ,r.MailingAddressState
			 ,CASE WHEN isnull(s.MailingStateAbbreviation,'') = isnull(r.MailingAddressState,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #schools_staging s
		 left JOIN #schools_reporting r 
			 ON s.School_Identifier_State = r.OrganizationStateId

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
			 ,'Mailing Address City Match ' + s.School_Identifier_State
			 ,s.MailingAddressCity
			 ,r.MailingAddressCity
			 ,CASE WHEN isnull(s.MailingAddressCity,'') = isnull(r.MailingAddressCity,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #schools_staging s
		 left JOIN #schools_reporting r 
			 ON s.School_Identifier_State = r.OrganizationStateId

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
			 ,'Mailing Address Postal Match ' + s.School_Identifier_State
			 ,s.MailingAddressPostalCode
			 ,r.MailingAddressPostalCode
			 ,CASE WHEN isnull(s.MailingAddressPostalCode,'') = isnull(r.MailingAddressPostalCode,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #schools_staging s
		 left JOIN #schools_reporting r 
			 ON s.School_Identifier_State = r.OrganizationStateId


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
			 ,'Physical Address Match ' + s.School_Identifier_State
			 ,s.PhysicalAddressStreetNumberAndName
			 ,r.PhysicalAddressStreet
			 ,CASE WHEN isnull(s.PhysicalAddressStreetNumberAndName,'') = isnull(r.PhysicalAddressStreet,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #schools_staging s
		 left JOIN #schools_reporting r 
			 ON s.School_Identifier_State = r.OrganizationStateId


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
			 ,'Physical Address State Match ' + s.School_Identifier_State
			 ,s.PhysicalStateAbbreviation
			 ,r.PhysicalAddressState
			 ,CASE WHEN isnull(s.PhysicalStateAbbreviation,'') = isnull(r.PhysicalAddressState,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #schools_staging s
		 left JOIN #schools_reporting r 
			 ON s.School_Identifier_State = r.OrganizationStateId

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
			 ,'Physical Address City Match ' + s.School_Identifier_State
			 ,s.PhysicalAddressCity
			 ,r.PhysicalAddressCity
			 ,CASE WHEN isnull(s.PhysicalAddressCity,'') = isnull(r.PhysicalAddressCity,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #schools_staging s
		 left JOIN #schools_reporting r 
			 ON s.School_Identifier_State = r.OrganizationStateId

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
			 ,'Physical Address Postal Match ' + s.School_Identifier_State
			 ,s.PhysicalAddressPostalCode
			 ,r.PhysicalAddressPostalCode
			 ,CASE WHEN isnull(s.PhysicalAddressPostalCode,'') = isnull(r.PhysicalAddressPostalCode,'') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #schools_staging s
		 left JOIN #schools_reporting r 
			 ON s.School_Identifier_State = r.OrganizationStateId


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
			 ,'School Telephone Match ' + s.School_Identifier_State
			 ,s.TelephoneNumber
			 ,r.Telephone
			 ,CASE WHEN ISNULL(s.TelephoneNumber, '') = ISNULL(r.Telephone, '') THEN 1 
				   ELSE 0 END
			 ,GETDATE()
		 FROM #schools_staging s
		 left JOIN #schools_reporting r 
			 ON s.School_Identifier_State = r.OrganizationStateId






		drop table #leas_staging
		drop table #leas_reporting
		drop table #schools_staging
		drop table #schools_reporting







	COMMIT TRANSACTION

	END TRY
	BEGIN CATCH

	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION
	END

	DECLARE @msg AS NVARCHAR(MAX)
	SET @msg = ERROR_MESSAGE()

	DECLARE @sev AS INT
	SET @sev = ERROR_SEVERITY()

	RAISERROR(@msg, @sev, 1)

	END CATCH; 


END