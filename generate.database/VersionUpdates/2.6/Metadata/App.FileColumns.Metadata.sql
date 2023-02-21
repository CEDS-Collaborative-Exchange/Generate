-- Set DimensionId on FileColumns

set nocount on
begin try
 
	begin transaction
 
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'Sex') 
		where ColumnName = 'GenderID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'Race') 
		where ColumnName = 'RaceEthnicityID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'Age') 
		where ColumnName = 'AgeID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'Disability')
		where ColumnName = 'DisabilityStatusID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'Disability')
		where ColumnName = 'DisabilityCategoryID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'EducEnv') 
		where ColumnName = 'EdEnvironmentID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'EducEnv') 
		where ColumnName = 'EarlyChildEdEnvironmentID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'DisciplineMethod')
		where ColumnName = 'DisciplineMethodID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'RemovalLength') 
		where ColumnName = 'RemovalLengthID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'RemovalType') 
		where ColumnName = 'RemovalTypeID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'RemovalReason') 
		where ColumnName = 'RemovalReasonID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'BasisOfExit')
		where ColumnName = 'BasisOfExitID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'EducationalServices') 
		where ColumnName = 'EducationServicesID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'EcoDisStatus') 
		where ColumnName = 'EconDisadvantagedStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'AssessmentType') 
		where ColumnName = 'AssessAdministeredID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'HomelessStatus') 
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

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'FoodServiceEligibility') 
		where ColumnName = 'LunchProgramStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'FosterCareProgram') 
		where ColumnName = 'FosterCareStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'MilitaryConnectedStatus') 
		where ColumnName = 'MilitaryConnectedStudentStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'Title1ProgramType') 
		where ColumnName = 'TitleIProgramTypeID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'Title1InstructionalServices') 
		where ColumnName = 'TitleIInstSrvcTypeID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'Title1SupportServices') 
		where ColumnName = 'TitleISupportSrvcID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'Language') 
		where ColumnName = 'HomeLanguageID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'DIPLOMACREDENTIALTYPE') 
		where ColumnName = 'DiplomaCredentialTypeID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'MobilityStatus12MO') 
		where ColumnName = 'MobilityStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'MobilityStatusSY') 
		where ColumnName = 'MobilityStatSYID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'ReferralStatus') 
		where ColumnName = 'ReferralStatusID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'MigrantPriorityForServices') 
		where ColumnName = 'PrioritySrvcID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'Continuation') 
		where ColumnName = 'ContinuationID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'MepFundsStatus') 
		where ColumnName = 'MEPFundStatus'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'MepServices') 
		where ColumnName = 'ServiceReceivedID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'SHAREDTIMESTATUS') 
		where ColumnName = 'SharedTimeInd'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'TITLE1SCHOOLSTATUS') 
		where ColumnName = 'TitleISchoolStatus'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'MAGNETSTATUS') 
		where ColumnName = 'MagnetSchoolStatus'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'NSLPSTATUS') 
		where ColumnName = 'NSLPstatus'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'VirtualSchoolStatus') 
		where ColumnName = 'VirtualSchoolStatus'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'STAFFCATEGORYCCD') 
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
	
		Update fc set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'LEPSTATUS')
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

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'Section504Program')
		where ColumnName = 'DisabilityStatus504ID'

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
