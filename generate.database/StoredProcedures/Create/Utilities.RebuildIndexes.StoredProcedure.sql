CREATE PROCEDURE [Utilities].[RebuildIndexes]
AS 
BEGIN

	/*
		This utility will rebuild the Indexes on all of the staging tables.  
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
	
END 