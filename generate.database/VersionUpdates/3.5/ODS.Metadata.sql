-- Metadata changes for the ODS schema
----------------------------------
SET NOCOUNT ON
BEGIN TRY
	BEGIN TRANSACTION

	declare @gradeLevelTypeId as int

	IF NOT EXISTS(SELECT 1 FROM ods.RefK12StaffClassification WHERE Code = 'SchoolPsychologist')
	BEGIN	
		INSERT INTO [ODS].[RefK12StaffClassification] ([Description],[Code],[Definition],[RefJurisdictionId],[SortOrder])
		VALUES ('School Psychologist','SchoolPsychologist','Professional staff member who provides direct and indirect support, including prevention and intervention, to evaluate and address student’s intellectual development, academic success, social-emotional learning, and mental and behavioral health.',
				NULL,'55.00')		
	END

	IF NOT EXISTS(SELECT 1 FROM ods.RefK12StaffClassification WHERE Code = 'Pre-KindergartenTeachers')
	BEGIN	
		INSERT INTO [ODS].[RefK12StaffClassification] ([Description],[Code],[Definition],[RefJurisdictionId],[SortOrder])
		VALUES ('Pre-Kindergarten Teachers','Pre-KindergartenTeachers','Teachers of a group or class that is part of a public school program that is taught during the year or years preceding kindergarten.',
				NULL,'57.00')
	END

		UPDATE [ODS].[RefK12StaffClassification]
		SET Definition = 'Professional staff members whose activities are concerned with the direct support of students and who nurture, but do not instruct students as well as supervisors of those professional staff members.'
		FROM [ODS].[RefK12StaffClassification]
		WHERE Description = 'Student Support Services Staff'
		AND Code = 'StudentSupportServicesStaff'


	SET IDENTITY_INSERT ods.RefAdditionalTargetedSupport ON

		IF NOT EXISTS(SELECT 1 FROM ods.RefAdditionalTargetedSupport WHERE Code = 'ADDLTSI')
		BEGIN	
			INSERT INTO [ODS].[RefAdditionalTargetedSupport] ([RefAdditionalTargetedSupportId],[Description],[Code],[Definition],
																[RefJurisdictionId],[SortOrder])
			VALUES (1,'Additional Targeted Support and Improvement','ADDLTSI','Additional Targeted Support and Improvement',	NULL,'1.00')		
		END

		IF NOT EXISTS(SELECT 1 FROM ods.RefAdditionalTargetedSupport WHERE Code = 'NOTADDLTSI')
		BEGIN	
			INSERT INTO [ODS].[RefAdditionalTargetedSupport] ([RefAdditionalTargetedSupportId],[Description],[Code],[Definition],
																[RefJurisdictionId],[SortOrder])
			VALUES (2,'Not Additional Targeted Support and Improvement','NOTADDLTSI','Not Additional Targeted Support and Improvement',	NULL,'2.00')		
		END


	SET IDENTITY_INSERT ods.RefAdditionalTargetedSupport OFF
	   	  
	SET IDENTITY_INSERT ods.RefComprehensiveSupportImprovement ON

	IF NOT EXISTS(SELECT 1 FROM ods.RefComprehensiveSupportImprovement WHERE Code = 'CSI')
	BEGIN	
		INSERT INTO [ODS].[RefComprehensiveSupportImprovement] ([RefComprehensiveSupportImprovementId],[Description],[Code],[Definition],																		[RefJurisdictionId],[SortOrder])
		VALUES (1,'Comprehensive Support and Improvement','CSI','Comprehensive Support and Improvement',	NULL,'1.00')		
	END

	IF NOT EXISTS(SELECT 1 FROM ods.RefComprehensiveSupportImprovement WHERE Code = 'CSIEXIT')
	BEGIN	
		INSERT INTO [ODS].[RefComprehensiveSupportImprovement] ([RefComprehensiveSupportImprovementId],[Description],[Code],[Definition],
																[RefJurisdictionId],[SortOrder])
		VALUES (2,'CSI - Exit Status','CSIEXIT','Comprehensive Support and Improvement - Exit Status',	NULL,'2.00')		
	END

	IF NOT EXISTS(SELECT 1 FROM ods.RefComprehensiveSupportImprovement WHERE Code = 'NOTCSI')
	BEGIN	
		INSERT INTO [ODS].[RefComprehensiveSupportImprovement] ([RefComprehensiveSupportImprovementId],[Description],[Code],[Definition],
																[RefJurisdictionId],[SortOrder])
		VALUES (3,'Not CSI','NOTCSI','Not Comprehensive Support Improvement',	NULL,'3.00')		
	END


	SET IDENTITY_INSERT ods.RefComprehensiveSupportImprovement OFF
	   	
	
	SET IDENTITY_INSERT ods.RefTargetedSupportImprovement ON

	IF NOT EXISTS(SELECT 1 FROM ods.RefTargetedSupportImprovement WHERE Code = 'TSI')
	BEGIN	
		INSERT INTO [ODS].[RefTargetedSupportImprovement] ([RefTargetedSupportImprovementId],[Description],[Code],[Definition],[RefJurisdictionId],
															[SortOrder])
		VALUES (1,'Targeted Support and Improvement','TSI','Targeted Support and Improvement',	NULL,'1.00')		
	END

	IF NOT EXISTS(SELECT 1 FROM ods.RefTargetedSupportImprovement WHERE Code = 'TSIEXIT')
	BEGIN	
		INSERT INTO [ODS].[RefTargetedSupportImprovement] ([RefTargetedSupportImprovementId],[Description],[Code],[Definition],[RefJurisdictionId],
															[SortOrder])
		VALUES (2,'TSI - Exit Status','TSIEXIT','Targeted Support and Improvement - Exit Status',	NULL,'2.00')		
	END

	IF NOT EXISTS(SELECT 1 FROM ods.RefTargetedSupportImprovement WHERE Code = 'NOTTSI')
	BEGIN	
		INSERT INTO [ODS].[RefTargetedSupportImprovement] ([RefTargetedSupportImprovementId],[Description],[Code],[Definition],[RefJurisdictionId],
															[SortOrder])
		VALUES (3,'Not TSI','NOTTSI','Not Targeted Support and Improvement',	NULL,'3.00')		
	END


	SET IDENTITY_INSERT ods.RefTargetedSupportImprovement OFF

	IF NOT EXISTS(select 1 from ods.RefCharterSchoolManagementOrganizationType where Code = 'SMNP')
	INSERT INTO [ODS].[RefCharterSchoolManagementOrganizationType]
           ([Description]
           ,[Code]
           ,[Definition]
           ,[RefJurisdictionId]
           ,[SortOrder])
	VALUES('Single Management (non-profit)','SMNP',
			'A non-profit organization that is not a Charter Management Organization or Education Management Organization and that provides management services to one charter school.'
			 ,NULL,'4.00')
			    
	IF NOT EXISTS(select 1 from ods.RefCharterSchoolManagementOrganizationType where Code = 'SMFP')
	INSERT INTO [ODS].[RefCharterSchoolManagementOrganizationType]
			   ([Description]
			   ,[Code]
			   ,[Definition]
			   ,[RefJurisdictionId]
			   ,[SortOrder])
	VALUES('Single Management (for-profit)'
			   ,'SMFP'
			   ,'A for-profit entity that is not a Charter Management Organization or Education Management Organization and that provides management services to one charter school.'
			   ,NULL
			   ,'5.00')

	IF NOT EXISTS(select 1 from ods.RefStateAppropriationMethod where Code = 'STEAPRDRCT')
	INSERT INTO [ODS].[RefStateAppropriationMethod]
           ([Description]
           ,[Code]
           ,[Definition]
           ,[RefJurisdictionId]
           ,[SortOrder])
	VALUES('Direct from state','STEAPRDRCT','Charter school receives allocations and appropriations directly from the state',NULL,'1.00')

	IF NOT EXISTS(select 1 from ods.RefStateAppropriationMethod where Code = 'STEAPRTHRULEA')
	INSERT INTO [ODS].[RefStateAppropriationMethod]
           ([Description]
           ,[Code]
           ,[Definition]
           ,[RefJurisdictionId]
           ,[SortOrder])
	VALUES('Through local school district','STEAPRTHRULEA','Charter school receives appropriations allocated by the state through the local school district with no local school district control on allocation of funds (e.g. passthrough allocations)',NULL,'2.00')

	IF NOT EXISTS(select 1 from ods.RefStateAppropriationMethod where Code = 'STEAPRALLOCLEA')
	INSERT INTO [ODS].[RefStateAppropriationMethod]
           ([Description]
           ,[Code]
           ,[Definition]
           ,[RefJurisdictionId]
           ,[SortOrder])
	VALUES('Allocation by local school district','STEAPRALLOCLEA','Local school district receives appropriation of funds from state and allocates funding to charter school, local school district has similar decision making control on charter school’s use of funds as district has for traditional public schools (e.g. district operated charter school).',NULL,'3.00')

		
	select @gradeLevelTypeId = RefGradeLevelTypeId from ods.RefGradeLevelType where Code = '000100'

	IF NOT EXISTS(select 1 from ods.RefGradeLevel where Code = 'ABE' and RefGradeLevelTypeId = @gradeLevelTypeId)
	BEGIN
		INSERT INTO [ODS].[RefGradeLevel]
				   ([Description]
				   ,[Code]
				   ,[Definition]
				   ,[RefGradeLevelTypeId]
				   ,[SortOrder])
		VALUES('Adult Basic Education','ABE','Adult Basic Education is a grade offered by the education institution.',@gradeLevelTypeId,23.00)
	END

	select @gradeLevelTypeId = RefGradeLevelTypeId from ods.RefGradeLevelType where Code = '001210'

	IF NOT EXISTS(select 1 from ods.RefGradeLevel where Code = 'ABE' and RefGradeLevelTypeId = @gradeLevelTypeId)
	BEGIN
		INSERT INTO [ODS].[RefGradeLevel]
				   ([Description]
				   ,[Code]
				   ,[Definition]
				   ,[RefGradeLevelTypeId]
				   ,[SortOrder])
		VALUES('Adult Basic Education','ABE','Adult Basic Education is a grade offered by the education institution.',@gradeLevelTypeId,23.00)
	END

	--IF(EXISTS(SELECT 1 FROM ODS.RefOrganizationRelationship))
	--BEGIN
	--	Update ods.organizationrelationship set RefOrganizationRelationshipId = NULL

	--	DELETE FROM ODS.RefOrganizationRelationship
	--	DBCC CHECKIDENT ('ods.RefOrganizationRelationship', RESEED, 0)
	--END;
	
	-- Only insert records into ODS.RefOrganizationRelationship if the table is empty
	IF(NOT EXISTS(SELECT 1 FROM ODS.RefOrganizationRelationship))
    BEGIN
		
		SET IDENTITY_INSERT ODS.RefOrganizationRelationship ON

        INSERT INTO ODS.RefOrganizationRelationship (RefOrganizationRelationshipId, [Description], [Code], [Definition], [RefJurisdictionId], [SortOrder]) values
        (1, 'Authorizing Body', 'AuthorizingBody', 'The primary entity with legal authority to create or close the organization.', NULL, 1)
		
		INSERT INTO ODS.RefOrganizationRelationship (RefOrganizationRelationshipId, [Description], [Code], [Definition], [RefJurisdictionId], [SortOrder]) values
        (2, 'Operating Body', 'OperatingBody', 'The entity responsible for operating the organization.', NULL, 2)

		INSERT INTO ODS.RefOrganizationRelationship (RefOrganizationRelationshipId, [Description], [Code], [Definition], [RefJurisdictionId], [SortOrder]) values
        (3, 'Secondary Authorizing Body', 'SecondaryAuthorizingBody', 'The secondary entity with legal authority to create or close the organization.', NULL, 3)

		SET IDENTITY_INSERT ODS.RefOrganizationRelationship OFF
    END;

	

	IF EXISTS(SELECT 1 FROM ods.RefTitleIIILanguageInstructionProgramType WHERE Code = 'Other' and SortOrder = 11.00)
	BEGIN
		UPDATE 	ODS.RefTitleIIILanguageInstructionProgramType SET Description = 'Newcomer Programs' , 
		Code = 'NewcomerPrograms', [Definition] = 'The type of Title III language instructional program is Newcomer Programs.'
		WHERE Code = 'Other' and SortOrder = 11.00			 
	END

	IF NOT EXISTS(SELECT 1 FROM ods.RefTitleIIILanguageInstructionProgramType WHERE Code = 'Other' and SortOrder = 12.00)
	BEGIN	
		INSERT INTO [ODS].[RefTitleIIILanguageInstructionProgramType] ([Description],[Code],[Definition],[RefJurisdictionId],[SortOrder])
		VALUES ('Other','Other','The type of Title III language instructional program is in a category not yet included in CEDS.',
				NULL,'12.00')		
	END

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
END CATCH
 
SET NOCOUNT OFF