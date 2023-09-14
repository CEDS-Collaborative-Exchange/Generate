CREATE PROCEDURE [dbo].[Get_AssessmentTypeChildrenWithDisabilities]
@grade as varchar(50)
AS
BEGIN

    -- Hard coding for now. Will need to be refactored when Assessment Types are added to CEDS
	IF @grade IN ('03', '04', '05', '06', '07', '08')
	BEGIN

		SELECT 1 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Regular assessments based on grade-level achievement standards without accommodations' as [Description], 
			   'REGASSWOACC' as Code, 'Regular assessments based on grade-level achievement standards without accommodations' as [Definition], NULL as RefJurisdictionId, 1 as SortOrder
		UNION
		SELECT 2 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Regular assessments based on grade-level achievement standards without accommodations' as [Description], 
			   'REGASSWACC' as Code, 'Regular assessments based on grade-level achievement standards with accommodations' as [Definition], NULL as RefJurisdictionId, 2 as SortOrder
		UNION
		SELECT 3 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Alternate assessments based on alternate achievement standards' as [Description], 
			   'ALTASSALTACH' as Code, 'Alternate assessments based on alternate achievement standards' as [Definition], NULL as RefJurisdictionId, 3 as SortOrder
		UNION
		SELECT 4 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Advanced assessment without accommodations' as [Description], 
			   'ADVASMTWOACC' as Code, 'Advanced assessment without accommodations' as [Definition], NULL as RefJurisdictionId, 4 as SortOrder
		UNION
		SELECT 5 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Advanced assessment with accommodations' as [Description], 
			   'ADVASMTWACC' as Code, 'Advanced assessment with accommodations' as [Definition], NULL as RefJurisdictionId, 5 as SortOrder
		UNION
		SELECT 6 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Innovative assessment Demonstration Authority (IADA) pilot assessment without accommodations' as [Description], 
			   'IADAPLASMTWOACC' as Code, 'Innovative assessment Demonstration Authority (IADA) pilot assessment without accommodations' as [Definition], NULL as RefJurisdictionId, 6 as SortOrder
		UNION
		SELECT 7 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Innovative assessment Demonstration Authority (IADA) pilot assessment with accommodations' as [Description], 
			   'IADAPLASMTWACC' as Code, 'Innovative assessment Demonstration Authority (IADA) pilot assessment with accommodations' as [Definition], NULL as RefJurisdictionId, 7 as SortOrder

			--SELECT [RefAssessmentTypeChildrenWithDisabilitiesId]
			--  ,[Description]
			--  ,[Code]
			--  ,[Definition]
			--  ,[RefJurisdictionId]
			--  ,[SortOrder]
		 -- FROM [dbo].[RefAssessmentTypeChildrenWithDisabilities]

	END
	ELSE
	BEGIN

		SELECT 1 as RefAssessmentTypeChildrenWithDisabilitiesId, 'High school regular assessment I, without accommodations' as [Description], 
			   'HSREGASMTIWOACC' as Code, 'High school regular assessment I, without accommodations' as [Definition], NULL as RefJurisdictionId, 1 as SortOrder
		UNION
		SELECT 2 as RefAssessmentTypeChildrenWithDisabilitiesId, 'High school regular assessment I, with accommodations' as [Description], 
			   'HSREGASMTIWACC' as Code, 'High school regular assessment I, with accommodations' as [Definition], NULL as RefJurisdictionId, 2 as SortOrder
		UNION
		SELECT 3 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Alternate assessment' as [Description], 
			   'ALTASSALTACH' as Code, 'Alternate assessment' as [Definition], NULL as RefJurisdictionId, 3 as SortOrder
		UNION
		SELECT 4 as RefAssessmentTypeChildrenWithDisabilitiesId, 'High school regular assessment II, without accommodations' as [Description], 
			   'HSREGASMT2WOACC' as Code, 'High school regular assessment II, without accommodations' as [Definition], NULL as RefJurisdictionId, 4 as SortOrder
		UNION
		SELECT 5 as RefAssessmentTypeChildrenWithDisabilitiesId, 'High school regular assessment II, with accommodations' as [Description], 
			   'HSREGASMT2WACC' as Code, 'High school regular assessment II, with accommodations' as [Definition], NULL as RefJurisdictionId, 5 as SortOrder
		UNION
		SELECT 6 as RefAssessmentTypeChildrenWithDisabilitiesId, 'High school regular assessment III, without accommodations' as [Description], 
			   'HSREGASMT3WOACC' as Code, 'High school regular assessment III, without accommodations' as [Definition], NULL as RefJurisdictionId, 6 as SortOrder
		UNION
		SELECT 7 as RefAssessmentTypeChildrenWithDisabilitiesId, 'High school regular assessment III, with accommodations' as [Description], 
			   'HSREGASMT3WACC' as Code, 'High school regular assessment III, with accommodations' as [Definition], NULL as RefJurisdictionId, 7 as SortOrder
		UNION
		SELECT 8 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Advanced assessment without accommodations' as [Description], 
			   'ADVASMTWOACC' as Code, 'Advanced assessment without accommodations' as [Definition], NULL as RefJurisdictionId, 8 as SortOrder
		UNION
		SELECT 9 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Advanced assessment with accommodations' as [Description], 
			   'ADVASMTWACC' as Code, 'Advanced assessment with accommodations' as [Definition], NULL as RefJurisdictionId, 9 as SortOrder
		UNION
		SELECT 10 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Innovative Assessment Demonstration Authority (IADA) pilot assessment without accommodations' as [Description], 
			   'IADAPLASMTWOACC' as Code, 'Innovative Assessment Demonstration Authority (IADA) pilot assessment without accommodations' as [Definition], NULL as RefJurisdictionId, 10 as SortOrder
		UNION
		SELECT 11 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Innovative Assessment Demonstration Authority (IADA) pilot assessment with accommodations' as [Description], 
			   'IADAPLASMTWACC' as Code, 'Innovative Assessment Demonstration Authority (IADA) pilot assessment with accommodations' as [Definition], NULL as RefJurisdictionId, 11 as SortOrder
		UNION
		SELECT 12 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Locally-selected nationally recognized high school assessment without accommodations' as [Description], 
			   'LSNRHSASMTWOACC' as Code, 'Locally-selected nationally recognized high school assessment without accommodations' as [Definition], NULL as RefJurisdictionId, 12 as SortOrder
		UNION
		SELECT 13 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Locally-selected nationally recognized high school assessment with accommodations' as [Description], 
			   'LSNRHSASMTWACC' as Code, 'Locally-selected nationally recognized high school assessment with accommodations' as [Definition], NULL as RefJurisdictionId, 13 as SortOrder



	END

END