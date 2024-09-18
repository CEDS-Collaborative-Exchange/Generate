using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.TestDataHelper
{
    public class IdsTestDataObject
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

        public List<Role> Roles { get; set; }

        public List<Assessment> Assessments { get; set; }
        public List<AssessmentForm> AssessmentForms { get; set; }
        public List<AssessmentSubtest> AssessmentSubtests { get; set; }
        public List<AssessmentPerformanceLevel> AssessmentPerformanceLevels { get; set; }
        public List<AssessmentAdministration> AssessmentAdministrations { get; set; }

        public List<RefIndicatorStatusCustomType> RefIndicatorStatusCustomTypes { get; set; }

        // Organization
        public List<Organization> Organizations { get; set; }
        public List<OrganizationDetail> OrganizationDetails { get; set; }

        public List<OrganizationWebsite> OrganizationWebsites { get; set; }
        public List<OrganizationTelephone> OrganizationTelephones { get; set; }

        public List<Location> Locations { get; set; }
        public List<OrganizationLocation> OrganizationLocations { get; set; }
        public List<LocationAddress> LocationAddresses { get; set; }

        public List<OrganizationIdentifier> OrganizationIdentifiers { get; set; }

        public List<OrganizationIndicator> OrganizationIndicators { get; set; }

        public List<K12titleIiilanguageInstruction> K12titleIiilanguageInstructions { get; set; }
        public List<OrganizationRelationship> OrganizationRelationships { get; set; }
        public List<OrganizationOperationalStatus> OrganizationOperationalStatuses { get; set; }
        public List<OrganizationFederalAccountability> OrganizationFederalAccountabilities { get; set; }

        public List<OrganizationCalendar> OrganizationCalendars { get; set; }
        public List<OrganizationCalendarSession> OrganizationCalendarSessions { get; set; }
        public List<K12FederalFundAllocation> K12FederalFundAllocations { get; set; }
        public List<OrganizationProgramType> OrganizationProgramTypes { get; set; }

        // SEA
        public int SeaOrganizationId { get; set; }
        public List<K12sea> K12Seas { get; set; }

        // LEA
        public List<int> LeaOrganizationIds { get; set; }
        public List<K12lea> K12Leas { get; set; }
        public List<K12leaTitleIsupportService> K12LeaTitleISupportServices { get; set; }
        public List<K12programOrService> K12ProgramOrServices { get; set; }
        public List<K12LeaFederalFunds> K12LeaFederalFunds { get; set; }
        public List<OrganizationFinancial> OrganizationFinancials { get; set; }
        public List<FinancialAccount> FinancialAccounts { get; set; }

        // School
        public List<int> SchoolOrganizationIds { get; set; }
        public List<K12school> K12Schools { get; set; }
        public List<K12schoolImprovement> K12SchoolImprovements { get; set; }
        public List<K12schoolGradeOffered> K12SchoolGradeOffereds { get; set; }
        public List<K12schoolStatus> K12SchoolStatuses { get; set; }

        public List<K12schoolIndicatorStatus> K12SchoolIndicatorStatuses { get; set; }

        public List<AssessmentAdministrationOrganization> AssessmentAdministrationOrganizations { get; set; }
        public List<K12CharterSchoolAuthorizer> K12CharterSchoolAuthorizers { get; set; }
        public List<K12CharterSchoolManagementOrganization> K12CharterSchoolManagementOrganizations { get; set; }

        // Persons
        public List<Person> Persons { get; set; }
        public List<PersonDetail> PersonDetails { get; set; }

        public List<OrganizationPersonRole> OrganizationPersonRoles { get; set; }
        public List<OrganizationPersonRoleRelationship> OrganizationPersonRoleRelations { get; set; }
        public List<PersonStatus> PersonStatuses { get; set; }
        public List<PersonDisability> PersonDisabilities { get; set; }
        public List<PersonHomelessness> PersonHomelessnesses { get; set; }
        public List<PersonLanguage> PersonLanguages { get; set; }
        public List<PersonDemographicRace> PersonDemographicRaces { get; set; }

        public List<PersonIdentifier> PersonIdentifiers { get; set; }


        // Students
        public List<int> StudentPersonIds { get; set; }
        public List<K12organizationStudentResponsibility> K12organizationStudentResponsibilities { get; set; }

        public List<K12studentDiscipline> K12studentDisciplines { get; set; }
        public List<Incident> Incidents { get; set; }

        public List<K12studentEnrollment> K12studentEnrollments { get; set; }

        public List<K12studentCohort> K12studentCohorts { get; set; }
        public List<K12studentAcademicRecord> K12studentAcademicRecords { get; set; }
        public List<RoleAttendance> RoleAttendances { get; set; }
        public List<PersonProgramParticipation> PersonProgramParticipations { get; set; }

        public List<AssessmentRegistration> AssessmentRegistrations { get; set; }

        public List<ProgramParticipationSpecialEducation> ProgramParticipationSpecialEducations { get; set; }
        public List<ProgramParticipationCte> ProgramParticipationCtes { get; set; }
        public List<WorkforceEmploymentQuarterlyData> WorkforceEmploymentQuarterlyDatas { get; set; }
        public List<WorkforceProgramParticipation> WorkforceProgramParticipations { get; set; }
        public List<ProgramParticipationTitleIiilep> ProgramParticipationTitleIiileps { get; set; }
        public List<ProgramParticipationMigrant> ProgramParticipationMigrants { get; set; }
        public List<ProgramParticipationNeglected> ProgramParticipationNeglecteds { get; set; }
        public List<ProgramParticipationNeglectedProgressLevel> ProgramParticipationNeglectedProgressLevels { get; set; }
        public List<AssessmentResult> AssessmentResults { get; set; }
        public List<AssessmentResult_PerformanceLevel> AssessmentResult_PerformanceLevels { get; set; }

        // Personnel
        public List<int> PersonnelPersonIds { get; set; }
        public List<K12staffAssignment> K12staffAssignments { get; set; }
        public List<AeStaff> AeStaffs { get; set; }
        public List<PersonCredential> PersonCredentials { get; set; }
        public List<StaffCredential> StaffCredentials { get; set; }
        #endregion

    }
}
