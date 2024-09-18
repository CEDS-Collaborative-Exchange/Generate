CREATE OR ALTER PROCEDURE [App].[FS029_TestCase]
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

		DROP TABLE IF EXISTS #leas_staging
		DROP TABLE IF EXISTS #leas_reporting
		DROP TABLE IF EXISTS #schools_staging
		DROP TABLE IF EXISTS #schools_reporting

		SELECT
		DISTINCT 
		   ske.LEA_Identifier_State
		  ,ske.LEA_Identifier_NCES
		  ,ske.LEA_SupervisoryUnionIdentificationNumber
		  ,ske.LEA_Name
		  ,ske.LEA_WebSiteAddress
		  ,case when ske.LEA_OperationalStatus = 'Open' then 1
				when ske.LEA_OperationalStatus = 'Closed' then 2
				when ske.LEA_OperationalStatus = 'New' then 3
				when ske.LEA_OperationalStatus = 'Added' then 4
				when ske.LEA_OperationalStatus = 'ChangedBoundary' then 5
				when ske.LEA_OperationalStatus = 'Inactive' then 6
				when ske.LEA_OperationalStatus = 'FutureAgency' then 7
				else NULL
			end as LEA_OperationalStatus
		  ,ske.LEA_OperationalStatusEffectiveDate
		  ,ske.LEA_CharterLeaStatus
		  ,ske.LEA_CharterSchoolIndicator
		  ,ske.LEA_Type
		  ,ske.LEA_IsReportedFederally
		  ,ske.LEA_RecordStartDateTime
		  ,ske.LEA_RecordEndDateTime
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
		FROM Staging.K12Organization ske
		left join (select OrganizationIdentifier, AddressStreetNumberAndName, AddressCity, StateAbbreviation, AddressPostalCode
		  from Staging.OrganizationAddress
		  where AddressTypeForOrganization = 'Mailing' ) mailing on mailing.OrganizationIdentifier = ske.LEA_Identifier_State
		left join (select OrganizationIdentifier, AddressStreetNumberAndName, AddressCity, StateAbbreviation, AddressPostalCode
		  from Staging.OrganizationAddress
		  where AddressTypeForOrganization = 'Physical' ) physical on physical.OrganizationIdentifier = ske.LEA_Identifier_State
		left join Staging.OrganizationPhone phone on phone.OrganizationIdentifier = ske.LEA_Identifier_State
		

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
			 ,CASE WHEN s.LEA_Name = r.OrganizationName THEN 1 
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
			 ,CASE WHEN s.LEA_WebSiteAddress = r.Website THEN 1 
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
			 ,CASE WHEN s.LEA_OperationalStatus = r.OperationalStatus THEN 1 
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
			  END = r.CharterLeaStatus THEN 1 
				   ELSE 0 END
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
			 ,CASE WHEN s.LEA_CharterSchoolIndicator = r.CharterSchoolIndicator THEN 1 
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
			 ,CASE WHEN s.LEA_Type = r.LEAType THEN 1 
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
			 ,CASE WHEN s.MailingAddressStreetNumberAndName = r.MailingAddressStreet THEN 1 
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
			 ,CASE WHEN s.MailingStateAbbreviation = r.MailingAddressState THEN 1 
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
			 ,CASE WHEN s.MailingAddressCity = r.MailingAddressCity THEN 1 
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
			 ,CASE WHEN s.MailingAddressPostalCode = r.MailingAddressPostalCode THEN 1 
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
			 ,CASE WHEN s.PhysicalAddressStreetNumberAndName = r.PhysicalAddressStreet THEN 1 
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
			 ,CASE WHEN s.PhysicalStateAbbreviation = r.PhysicalAddressState THEN 1 
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
			 ,CASE WHEN s.PhysicalAddressCity = r.PhysicalAddressCity THEN 1 
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
			 ,CASE WHEN s.PhysicalAddressPostalCode = r.PhysicalAddressPostalCode THEN 1 
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
		   ske.LEA_Identifier_State
		  ,ske.LEA_Identifier_NCES
		  ,ske.School_Identifier_State
		  ,ske.School_Identifier_NCES
		  ,ske.School_Name
		  ,ske.School_WebSiteAddress
		  ,case when ske.School_OperationalStatus = 'Open' then 1
				when ske.School_OperationalStatus = 'Closed' then 2
				when ske.School_OperationalStatus = 'New' then 3
				when ske.School_OperationalStatus = 'Added' then 4
				when ske.School_OperationalStatus = 'ChangedBoundary' then 5
				when ske.School_OperationalStatus = 'Inactive' then 6
				when ske.School_OperationalStatus = 'FutureAgency' then 7
				else NULL
			end as School_OperationalStatus
		  ,ske.School_OperationalStatusEffectiveDate
		  ,CASE WHEN ske.School_CharterSchoolIndicator = 1 then 'YES' ELSE 'NO' END as School_CharterSchoolStatus
		  ,ske.School_Type
		  ,ske.School_IsReportedFederally
		  ,ske.School_RecordStartDateTime
		  ,ske.School_RecordEndDateTime
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
		FROM Staging.K12Organization ske
		left join (select OrganizationIdentifier, AddressStreetNumberAndName, AddressCity, StateAbbreviation, AddressPostalCode
		  from Staging.OrganizationAddress
		  where AddressTypeForOrganization = 'Mailing' ) mailing on mailing.OrganizationIdentifier = ske.School_Identifier_State
		left join (select OrganizationIdentifier, AddressStreetNumberAndName, AddressCity, StateAbbreviation, AddressPostalCode
		  from Staging.OrganizationAddress
		  where AddressTypeForOrganization = 'Physical' ) physical on physical.OrganizationIdentifier = ske.School_Identifier_State
		left join Staging.OrganizationPhone phone on phone.OrganizationIdentifier = ske.School_Identifier_State

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
			 ,CASE WHEN s.School_Name = r.OrganizationName THEN 1 
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
			 ,CASE WHEN s.School_WebSiteAddress = r.Website THEN 1 
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
			 ,CASE WHEN s.School_OperationalStatus = r.OperationalStatus THEN 1 
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
			 ,CASE WHEN s.School_CharterSchoolStatus = r.CharterSchoolStatus THEN 1 
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
			 ,CASE WHEN s.School_CharterSchoolStatus = r.CharterSchoolStatus THEN 1 
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
			 ,CASE WHEN s.School_Type = r.SchoolType THEN 1 
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
			 ,CASE WHEN s.MailingAddressStreetNumberAndName = r.MailingAddressStreet THEN 1 
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
			 ,CASE WHEN s.MailingStateAbbreviation = r.MailingAddressState THEN 1 
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
			 ,CASE WHEN s.MailingAddressCity = r.MailingAddressCity THEN 1 
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
			 ,CASE WHEN s.MailingAddressPostalCode = r.MailingAddressPostalCode THEN 1 
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
			 ,CASE WHEN s.PhysicalAddressStreetNumberAndName = r.PhysicalAddressStreet THEN 1 
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
			 ,CASE WHEN s.PhysicalStateAbbreviation = r.PhysicalAddressState THEN 1 
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
			 ,CASE WHEN s.PhysicalAddressCity = r.PhysicalAddressCity THEN 1 
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
			 ,CASE WHEN s.PhysicalAddressPostalCode = r.PhysicalAddressPostalCode THEN 1 
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