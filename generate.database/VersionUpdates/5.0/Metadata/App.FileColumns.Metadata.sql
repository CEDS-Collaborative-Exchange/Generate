-- Set DimensionId on FileColumns

set nocount on
begin try
 
	begin transaction

		SELECT MIN(FileColumnId) as MinId, ColumnLength, ColumnName, DataType, DisplayName, XMLElementName INTO #Dupes FROM App.FileColumns GROUP BY ColumnLength, ColumnName, DataType, DisplayName, XMLElementName HAVING COUNT(*) > 1

		-- Deletes all child records of duplicate FileSubmission duplicates
		DELETE afsfc
		FROM #Dupes d
		JOIN App.FileColumns afc
			ON  afc.ColumnLength   = d.ColumnLength
			AND afc.ColumnName	   = d.ColumnName
			AND afc.DataType	   = d.DataType
			AND afc.DisplayName	   = d.DisplayName
			AND afc.XMLElementName = d.XMLElementName
			AND afc.FileColumnId   <> d.MinId
		JOIN App.FileSubmission_FileColumns afsfc
			ON afc.FileColumnId = afsfc.FileColumnId
		LEFT JOIN App.FileSubmission_FileColumns doesitexist
			ON afsfc.FileSubmissionId = doesitexist.FileSubmissionId
			AND doesitexist.FileColumnId = d.MinId
		WHERE doesitexist.FileColumnId IS NOT NULL
			
		-- Update any new FileSubmission_FileColumns that were created this release that point to the duplicate FileColumns
		UPDATE afsfc
		SET afsfc.FileColumnId = MinId 
		FROM #Dupes d
		JOIN App.FileColumns afc
			ON  afc.ColumnLength   = d.ColumnLength
			AND afc.ColumnName	   = d.ColumnName
			AND afc.DataType	   = d.DataType
			AND afc.DisplayName	   = d.DisplayName
			AND afc.XMLElementName = d.XMLElementName
			AND afc.FileColumnId   <> d.MinId
		JOIN App.FileSubmission_FileColumns afsfc
			ON afc.FileColumnId = afsfc.FileColumnId
		LEFT JOIN App.FileSubmission_FileColumns doesitexist
			ON afsfc.FileSubmissionId = doesitexist.FileSubmissionId
			AND doesitexist.FileColumnId = d.MinId
		WHERE doesitexist.FileColumnId IS NULL

		--Delete all duplicate FileColumns  
		DELETE afc
		FROM #Dupes d
		JOIN App.FileColumns afc
			ON  afc.ColumnLength   = d.ColumnLength
			AND afc.ColumnName	   = d.ColumnName
			AND afc.DataType	   = d.DataType
			AND afc.DisplayName	   = d.DisplayName
			AND afc.XMLElementName = d.XMLElementName
			AND afc.FileColumnId   <> d.MinId
		LEFT JOIN App.FileSubmission_FileColumns doesitexist
			ON doesitexist.FileColumnId = afc.FileColumnId
		WHERE doesitexist.FileColumnId IS NULL

		DROP TABLE #Dupes
		
		declare @dimensionTableId as int
 
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'Sex') 
		where ColumnName = 'GenderID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'Race') 
		where ColumnName = 'RaceEthnicityID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'Age') 
		where ColumnName = 'AgeID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'PrimaryDisabilityType')
		where ColumnName = 'DisabilityStatusID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'PrimaryDisabilityType')
		where ColumnName = 'DisabilityCategoryID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'IdeaEducationalEnvironment') 
		where ColumnName = 'EdEnvironmentID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'IdeaEducationalEnvironment') 
		where ColumnName = 'EarlyChildEdEnvironmentID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'DisciplineMethodOfChildrenWithDisabilities')
		where ColumnName = 'DisciplineMethodID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'RemovalLength') 
		where ColumnName = 'RemovalLengthID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'IdeaInterimRemoval') 
		where ColumnName = 'RemovalTypeID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'IdeaInterimRemovalReason') 
		where ColumnName = 'RemovalReasonID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'SpecialEducationExitReason')
		where ColumnName = 'BasisOfExitID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'EducationalServicesAfterRemoval') 
		where ColumnName = 'EducationServicesID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'EconomicDisadvantageStatus') 
		where ColumnName = 'EconDisadvantagedStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'AssessmentType') 
		where ColumnName = 'AssessAdministeredID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'HomelessnessStatus') 
		where ColumnName = 'HomelessServedID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'GradeLevel') 
		where ColumnName = 'GradeLevelID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'PerformanceLevel') 
		where ColumnName = 'PerformanceLevelID'
		
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'MigrantStatus') 
		where ColumnName = 'MigrantStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'FullYearStatus') 
		where ColumnName = 'FullAcademicYearStatusID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'ParticipationStatus') 
		where ColumnName = 'TestingStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'AgeGroup') 
		where ColumnName = 'AgeGroupID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'CertificationStatus') 
		where ColumnName = 'CertificationStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'QualificationStatus') 
		where ColumnName = 'QualificationID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'AssessmentSubject') 
		where ColumnName = 'SubjectID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'EligibilityStatusForSchoolFoodServiceProgram') 
		where ColumnName = 'LunchProgramStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'FosterCareProgram') 
		where ColumnName = 'FosterCareStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'MilitaryConnectedStudentIndicator') 
		where ColumnName = 'MilitaryConnectedStudentStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'TitleIProgramType') 
		where ColumnName = 'TitleIProgramTypeID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'TitleIInstructionalServices') 
		where ColumnName = 'TitleIInstSrvcTypeID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'TitleISupportServices') 
		where ColumnName = 'TitleISupportSrvcID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'Language') 
		where ColumnName = 'HomeLanguageID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'HIGHSCHOOLDIPLOMATYPE') 
		where ColumnName = 'DiplomaCredentialTypeID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'MobilityStatus12MO') 
		where ColumnName = 'MobilityStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'MobilityStatusSY') 
		where ColumnName = 'MobilityStatSYID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'ReferralStatus') 
		where ColumnName = 'ReferralStatusID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'MigrantPrioritizedForServices') 
		where ColumnName = 'PrioritySrvcID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'ContinuationOfServicesReason') 
		where ColumnName = 'ContinuationID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'MepFundsStatus') 
		where ColumnName = 'ConsolidatedMepFundsStatus'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'MepServicesType') 
		where ColumnName = 'ServiceReceivedID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'SHAREDTIMESTATUS') 
		where ColumnName = 'SharedTimeInd'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'TITLEISCHOOLSTATUS') 
		where ColumnName = 'TitleISchoolStatus'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'MAGNETSTATUS') 
		where ColumnName = 'MagnetSchoolStatus'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'NSLPSTATUS') 
		where ColumnName = 'NSLPstatus'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'VirtualSchoolStatus') 
		where ColumnName = 'VirtualSchoolStatus'

		select @dimensionTableId = DimensionTableId from app.DimensionTables where DimensionTableName = 'DimK12StaffCategories'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'K12StaffClassification' 
		and DimensionTableId = @dimensionTableId) 
		where ColumnName = 'StaffCategoryID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'GRADELEVEL') 
		where ColumnName = 'AgeGradeID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'TITLEIIIPROGRAMPARTICIPATION') 
		where ColumnName = 'ProgramParticipationID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'TITLEIIIACCOUNTABILITYPROGRESSSTATUS') 
		where ColumnName = 'AMAOID'

		--update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'PROFICIENCYSTATUS') 
		--where ColumnName = 'EnglishProficiencyLevelID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'PARTICIPATIONSTATUS') 
		where ColumnName = 'TestingStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'ASSESSEDFIRSTTIME') 
		where ColumnName = 'FirstAssessmentID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'RepresentationStatus') 
		where ColumnName = 'RepresentativeStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'SingleParent') 
		where ColumnName = 'SingleParentPregnantStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'DisplacedHomeMaker') 
		where ColumnName = 'DisplacedHomemakerID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'NonTraditionalEnrollee') 
		where ColumnName = 'NonTraditionalEnrolleesID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'TestResult') 
		where ColumnName = 'TestResultsID'
	
		Update fc set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'ENGLISHLEARNERSTATUS')
		from app.FileColumns fc 
		inner join app.FileSubmission_FileColumns ffc on fc.FileColumnId = ffc.FileColumnId
		inner join app.FileSubmissions fs on ffc.FileSubmissionId = fs.FileSubmissionId
		inner join app.GenerateReports r on fs.GenerateReportId = r.GenerateReportId
		where ReportCode <> 'c126' and ColumnName = 'LEPStatusID'

		Update fc set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'FORMERENGLISHLEARNERYEARSTATUS')
		from app.FileColumns fc 
		inner join app.FileSubmission_FileColumns ffc on fc.FileColumnId = ffc.FileColumnId
		inner join app.FileSubmissions fs on ffc.FileSubmissionId = fs.FileSubmissionId
		inner join app.GenerateReports r on fs.GenerateReportId = r.GenerateReportId
		where ReportCode = 'c126' and ColumnName = 'LEPStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'Section504Status')
		where ColumnName = 'DisabilityStatus504ID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'NeglectedOrDelinquentProgramType')
		where ColumnName = 'NegDelProgTypeID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'LongTermStatus')
		where ColumnName = 'NegDelStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'AcademicOrVocationalOutcome')
		where ColumnName = 'AcadVocOutcomeID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'ASSESSMENTPROGRESSLEVEL')
		where ColumnName = 'ProgressLevelID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'UNEXPERIENCEDSTATUS')
		where ColumnName = 'InexperiencedStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'OUTOFFIELDSTATUS')
		where ColumnName = 'OutOfFieldID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'EMERGENCYORPROVISIONALCREDENTIALSTATUS')
		where ColumnName = 'ProvCredentialStatusID'

		Update fc set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'SpecialEducationSupportServicesCategory')
		from app.FileSubmissions fs
		inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
		inner join app.FileColumns fc on fc.FileColumnId = fsfc.FileColumnId
		inner join app.GenerateReports r on r.GenerateReportId = fs.GenerateReportId
		where r.ReportCode = 'c099' and fc.ColumnName = 'StaffCategoryID'

		--End of CIID-4822

	/*CIID-3965 remove extra comma at the end of each record in the EDFacts file
		This ticket was opened for FS194, but the fix affects:
		reportcode	SubmissionYear
		c050		2018
		c050		2019
		c050		2020
		c050		2021
		c050		2022
		c193		2018
		c194		2018
		c194		2019
		c194		2020
		c194		2021
		c194		2022
		c198		2018
		c201		2018
		c201		2019
		c201		2020
		c202		2018
		c202		2019
		c202		2020
		c205		2018
		c205		2019
		c205		2020
	*/
	UPDATE app.FileColumns
	SET DataType = 'Control Character'
	WHERE ColumnName = 'CarriageReturn/LineFeed'
	AND DataType <> 'Control Character'
	/*CIID-3965 ends*/
	
	commit transaction
 
end try
 
begin catch
	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end
	declare @msg as nvarchar(max)
	set @msg = ERROR_MESSAGE()
	declare @sev as int
	set @sev = ERROR_SEVERITY()
	RAISERROR(@msg, @sev, 1)
end catch
 
set nocount off
