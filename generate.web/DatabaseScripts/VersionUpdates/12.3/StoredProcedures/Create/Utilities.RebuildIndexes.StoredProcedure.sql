CREATE PROCEDURE [Utilities].[RebuildIndexes]
AS 
BEGIN

	/*
		This utility will rebuild the Indexes on all of the staging tables
		and the RDS dimension and fact tables.  
		The performance of indexes degrades over time making queries 
		against these tables less efficient.  Rebuilding the index restores
		it to optimal performance.  Occasionally rebuilding indexes is 
		good practice.
	*/

	ALTER INDEX ALL ON Staging.Assessment											  REBUILD;
	ALTER INDEX ALL ON Staging.AssessmentResult										  REBUILD;
	ALTER INDEX ALL ON Staging.CharterSchoolAuthorizer								  REBUILD;
	ALTER INDEX ALL ON Staging.CharterSchoolManagementOrganization					  REBUILD;
	ALTER INDEX ALL ON Staging.Discipline											  REBUILD;
	ALTER INDEX ALL ON Staging.IdeaDisabilityType									  REBUILD;
	ALTER INDEX ALL ON Staging.IndicatorStatusCustomType							  REBUILD;
	ALTER INDEX ALL ON Staging.K12Enrollment										  REBUILD;
	ALTER INDEX ALL ON Staging.K12Organization										  REBUILD;
	ALTER INDEX ALL ON Staging.K12PersonRace										  REBUILD;
	ALTER INDEX ALL ON Staging.K12ProgramParticipation								  REBUILD;
	ALTER INDEX ALL ON Staging.K12SchoolComprehensiveSupportIdentificationType		  REBUILD;
	ALTER INDEX ALL ON Staging.K12StaffAssignment									  REBUILD;
	ALTER INDEX ALL ON Staging.K12StudentCourseSection								  REBUILD;
	ALTER INDEX ALL ON Staging.Migrant												  REBUILD;
	ALTER INDEX ALL ON Staging.OrganizationAddress									  REBUILD;
	ALTER INDEX ALL ON Staging.OrganizationCalendarSession							  REBUILD;
	ALTER INDEX ALL ON Staging.OrganizationCustomSchoolIndicatorStatusType			  REBUILD;
	ALTER INDEX ALL ON Staging.OrganizationFederalFunding							  REBUILD;
	ALTER INDEX ALL ON Staging.OrganizationGradeOffered								  REBUILD;
	ALTER INDEX ALL ON Staging.OrganizationPhone									  REBUILD;
	ALTER INDEX ALL ON Staging.OrganizationProgramType								  REBUILD;
	ALTER INDEX ALL ON Staging.OrganizationSchoolComprehensiveAndTargetedSupport	  REBUILD;
	ALTER INDEX ALL ON Staging.OrganizationSchoolIndicatorStatus					  REBUILD;
	ALTER INDEX ALL ON Staging.PersonStatus											  REBUILD;
	ALTER INDEX ALL ON Staging.ProgramParticipationCTE								  REBUILD;
	ALTER INDEX ALL ON Staging.ProgramParticipationNorD								  REBUILD;
	ALTER INDEX ALL ON Staging.ProgramParticipationSpecialEducation					  REBUILD;
	ALTER INDEX ALL ON Staging.ProgramParticipationTitleI							  REBUILD;
	ALTER INDEX ALL ON Staging.ProgramParticipationTitleIII							  REBUILD;
	ALTER INDEX ALL ON Staging.PsInstitution										  REBUILD;
	ALTER INDEX ALL ON Staging.PsStudentAcademicAward								  REBUILD;
	ALTER INDEX ALL ON Staging.PsStudentAcademicRecord								  REBUILD;
	ALTER INDEX ALL ON Staging.PsStudentEnrollment									  REBUILD;
	ALTER INDEX ALL ON Staging.SourceSystemReferenceData							  REBUILD;
	ALTER INDEX ALL ON Staging.StateDefinedCustomIndicator							  REBUILD;
	ALTER INDEX ALL ON Staging.StateDetail											  REBUILD;
	
	ALTER INDEX ALL ON RDS.DimAssessmentAccommodations								  REBUILD;
	ALTER INDEX ALL ON RDS.DimAssessmentAdministrations								  REBUILD;
	ALTER INDEX ALL ON RDS.DimAssessmentPerformanceLevels							  REBUILD;
	ALTER INDEX ALL ON RDS.DimAssessmentRegistrations								  REBUILD;
	ALTER INDEX ALL ON RDS.DimAssessmentResults										  REBUILD;
	ALTER INDEX ALL ON RDS.DimAssessments											  REBUILD;
	ALTER INDEX ALL ON RDS.DimDisciplineStatuses									  REBUILD;
	ALTER INDEX ALL ON RDS.DimEconomicallyDisadvantagedStatuses						  REBUILD;
	ALTER INDEX ALL ON RDS.DimEnglishLearnerStatuses								  REBUILD;
	ALTER INDEX ALL ON RDS.DimFirearms												  REBUILD;
	ALTER INDEX ALL ON RDS.DimFosterCareStatuses									  REBUILD;
	ALTER INDEX ALL ON RDS.DimGradeLevels											  REBUILD;
	ALTER INDEX ALL ON RDS.DimHomelessnessStatuses									  REBUILD;
	ALTER INDEX ALL ON RDS.DimIdeaDisabilityTypes									  REBUILD;
	ALTER INDEX ALL ON RDS.DimIdeaStatuses											  REBUILD;
	ALTER INDEX ALL ON RDS.DimK12Demographics										  REBUILD;
	ALTER INDEX ALL ON RDS.DimK12Schools											  REBUILD;
	ALTER INDEX ALL ON RDS.DimK12SchoolStatuses										  REBUILD;
	ALTER INDEX ALL ON RDS.DimK12StaffCategories									  REBUILD;
	ALTER INDEX ALL ON RDS.DimK12StaffStatuses										  REBUILD;
	ALTER INDEX ALL ON RDS.DimLanguages												  REBUILD;
	ALTER INDEX ALL ON RDS.DimLeas													  REBUILD;
	ALTER INDEX ALL ON RDS.DimMigrantStatuses										  REBUILD;
	ALTER INDEX ALL ON RDS.DimMilitaryStatuses										  REBUILD;
	ALTER INDEX ALL ON RDS.DimNOrDStatuses											  REBUILD;
	ALTER INDEX ALL ON RDS.DimPeople												  REBUILD;
	ALTER INDEX ALL ON RDS.DimRaces													  REBUILD;
	ALTER INDEX ALL ON RDS.DimSchoolYearDataMigrationTypes							  REBUILD;
	ALTER INDEX ALL ON RDS.DimSchoolYears											  REBUILD;
	ALTER INDEX ALL ON RDS.DimSeas													  REBUILD;
	ALTER INDEX ALL ON RDS.DimTitleIIIStatuses										  REBUILD;
	ALTER INDEX ALL ON RDS.DimTitleIStatuses										  REBUILD;
	
	ALTER INDEX ALL ON RDS.FactK12StaffCounts										  REBUILD;	
	ALTER INDEX ALL ON RDS.FactK12StudentAssessments								  REBUILD;	
	ALTER INDEX ALL ON RDS.FactK12StudentCounts										  REBUILD;	
	ALTER INDEX ALL ON RDS.FactK12StudentDisciplines								  REBUILD;	
	ALTER INDEX ALL ON RDS.FactOrganizationCounts									  REBUILD;	

END 