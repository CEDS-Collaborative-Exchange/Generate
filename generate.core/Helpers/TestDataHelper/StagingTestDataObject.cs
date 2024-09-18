using generate.core.Models.Staging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.TestDataHelper
{
    public class StagingTestDataObject
    {
        #region Metadata
        public string TestDatatype { get; set; }
        public string TestDataSection { get; set; }
        public string TestDataSectionDescription { get; set; }

        public int SeedValue { get; set; }


        public int QuantityOfLeas { get; set; }
        public int QuantityOfSchools { get; set; }
        public int QuantityOfStudents { get; set; }
        public int QuantityOfPersonnel { get; set; }

        #endregion

        #region Data

        // Global

        public List<K12Enrollment> K12Enrollments { get; set; }
        public List<K12Organization> K12Organizations { get; set; }
        public List<K12ProgramEnrollment> K12ProgramEnrollments { get; set; }
        public List<K12StudentCourseSection> K12StudentCourseSections { get; set; }
        public List<Migrant> Migrants { get; set; }
        public List<OrganizationAddress> OrganizationAddresses { get; set; }
        public List<OrganizationCalendarSession> OrganizationCalendarSessions { get; set; }
        public List<OrganizationCustomSchoolIndicatorStatusType> OrganizationCustomSchoolIndicatorStatusTypes { get; set; }
        public List<OrganizationFederalFunding> OrganizationFederalFundings { get; set; }
        public List<OrganizationGradeOffered> OrganizationGradeOffereds { get; set; }
        public List<OrganizationPhone> OrganizationPhones { get; set; }
        public List<OrganizationProgramType> OrganizationProgramTypes { get; set; }
        public List<OrganizationSchoolComprehensiveAndTargetedSupport> OrganizationSchoolComprehensiveAndTargetedSupports { get; set; }
        public List<IdeaDisabilityType> IdeaDisabilityTypes { get; set; }
        public List<K12SchoolComprehensiveSupportIdentificationType> K12SchoolComprehensiveSupportIdentificationTypes { get; set; }
        public List<K12SchoolTargetedSupportIdentificationType> K12SchoolTargetedSupportIdentificationType { get; set; }
        public List<K12StaffAssignment> StaffAssignments { get; set; }
        public List<OrganizationSchoolIndicatorStatus> OrganizationSchoolIndicatorStatuses { get; set; }
        public List<K12PersonRace> PersonRaces { get; set; }
        public List<PersonStatus> PersonStatuses { get; set; }
        public List<ProgramParticipationCte> ProgramParticipationCTEs { get; set; }
        public List<ProgramParticipationNorDClass> ProgramParticipationNorDs { get; set; }
        public List<ProgramParticipationSpecialEducation> ProgramParticipationSpecialEducations { get; set; }
        public List<ProgramParticipationTitleI> ProgramParticipationTitleIs { get; set; }
        public List<ProgramParticipationTitleIII> ProgramParticipationTitleIIIs { get; set; }
        public List<PsInstitution> PsInstitutions { get; set; }
        public List<PsStudentAcademicAward> PsStudentAcademicAwards { get; set; }
        public List<PsStudentAcademicRecord> PsStudentAcademicRecords { get; set; }
        public List<PsStudentEnrollment> PsStudentEnrollments { get; set; }
        public List<SourceSystemReferenceData> SourceSystemReferenceDatas { get; set; }
        public List<StateDefinedCustomIndicator> StateDefinedCustomIndicators { get; set; }
        public List<StateDetail> StateDetails { get; set; }
        public List<StagingValidationResult> ValidationErrorss { get; set; }
        public List<CharterSchoolManagementOrganization> CharterSchoolManagementOrganizations { get; set; }
        //public List<K12SchoolTargetedSupportIdentificationType> K12SchoolTargetedSupportIdentificationTypes { get; set; }
        //public List<K12SchoolComprehensiveSupportIdentificationType> K12SchoolComprehensiveSupportIdentificationTypes { get; set; }
        public List<Assessment> Assessments { get; set; }
        public List<AssessmentResult> AssessmentResults { get; set; }
        public List<CharterSchoolAuthorizer> CharterSchoolAuthorizers { get; set; }
        public List<DataCollection> DataCollections { get; set; }
        public List<Discipline> Disciplines { get; set; }
        public List<Disability> Disabilities { get; set; }
        public List<IndicatorStatusCustomType> IndicatorStatusCustomTypes { get; set; }
        public List<AccessibleEducationMaterialAssignment> AccessibleEducationMaterialAssignments { get; set; }
        public List<AccessibleEducationMaterialProvider> AccessibleEducationMaterialProviders { get; set; }

        #endregion
    }
}
