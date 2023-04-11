		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'DisabilityStatus')
		where ColumnName = 'DisabilityStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'IdeaEducationalEnvironmentForEarlyChildhood') 
		where ColumnName = 'EdEnvironmentID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'IdeaEducationalEnvironmentForSchoolAge') 
		where ColumnName = 'EarlyChildEdEnvironmentID'
	
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'EconomicDisadvantageStatus') 
		where ColumnName = 'EconDisadvantagedStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'AssessmentPerformanceLevelIdentifier') 
		where ColumnName = 'PerformanceLevelID'
		
		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'AssessmentRegistrationParticipationIndicator') 
		where ColumnName = 'TestingStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'EdFactsCertificationStatus') 
		where ColumnName = 'CertificationStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'SpecialEducationTeacherQualificationStatus') 
		where ColumnName = 'QualificationID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'AssessmentAcademicSubject') 
		where ColumnName = 'SubjectID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'EligibilityStatusForSchoolFoodServicePrograms') 
		where ColumnName = 'LunchProgramStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'ProgramParticipationFosterCare') 
		where ColumnName = 'FosterCareStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'MilitaryConnectedStudentIndicator') 
		where ColumnName = 'MilitaryConnectedStudentStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'TitleISupportServices') 
		where ColumnName = 'TitleISupportSrvcID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'TitleIIIImmigrantStatus') 
		where ColumnName = 'ProgramParticipationID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'SingleParentOrSinglePregnantWomanStatus') 
		where ColumnName = 'SingleParentPregnantStatusID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'CteAeDisplacedHomemakerIndicator') 
		where ColumnName = 'DisplacedHomemakerID'

		update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'Section504Status')
		where ColumnName = 'DisabilityStatus504ID'
