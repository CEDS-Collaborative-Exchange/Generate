using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class Person
    {
        public Person()
        {
            Achievement = new HashSet<Achievement>();
            AssessmentRegistrationAssignedByPerson = new HashSet<AssessmentRegistration>();
            AssessmentRegistrationPerson = new HashSet<AssessmentRegistration>();
            AssessmentSessionStaffRole = new HashSet<AssessmentSessionStaffRole>();
            ElenrollmentOtherFunding = new HashSet<ElenrollmentOtherFunding>();
            Incident = new HashSet<Incident>();
            IncidentPerson = new HashSet<IncidentPerson>();
            IndividualizedProgramService = new HashSet<IndividualizedProgramService>();
            LearnerActivityAssignedByPerson = new HashSet<LearnerActivity>();
            LearnerActivityPerson = new HashSet<LearnerActivity>();
            LearningGoal = new HashSet<LearningGoal>();
            LearningResourcePeerRating = new HashSet<LearningResourcePeerRating>();
            OrganizationPersonRole = new HashSet<OrganizationPersonRole>();
            PersonAddress = new HashSet<PersonAddress>();
            PersonAllergy = new HashSet<PersonAllergy>();
            PersonAssessmentPersonalNeedsProfile = new HashSet<PersonAssessmentPersonalNeedsProfile>();
            PersonCareerEducationPlan = new HashSet<PersonCareerEducationPlan>();
            PersonCredential = new HashSet<PersonCredential>();
            PersonDegreeOrCertificate = new HashSet<PersonDegreeOrCertificate>();
            PersonDemographicRace = new HashSet<PersonDemographicRace>();
            PersonDetail = new HashSet<PersonDetail>();
            PersonDisability = new HashSet<PersonDisability>();
            PersonEmailAddress = new HashSet<PersonEmailAddress>();
            PersonFamily = new HashSet<PersonFamily>();
            PersonHealth = new HashSet<PersonHealth>();
            PersonIdentifier = new HashSet<PersonIdentifier>();
            PersonImmunization = new HashSet<PersonImmunization>();
            PersonLanguage = new HashSet<PersonLanguage>();
            PersonOtherName = new HashSet<PersonOtherName>();
            PersonReferral = new HashSet<PersonReferral>();
            PersonRelationshipPerson = new HashSet<PersonRelationship>();
            PersonRelationshipRelatedPerson = new HashSet<PersonRelationship>();
            PersonStatus = new HashSet<PersonStatus>();
            PersonTelephone = new HashSet<PersonTelephone>();
            QuarterlyEmploymentRecord = new HashSet<QuarterlyEmploymentRecord>();
        }

        public int PersonId { get; set; }
        public int? PersonMasterId { get; set; }

        public virtual ICollection<Achievement> Achievement { get; set; }
        public virtual ICollection<AssessmentRegistration> AssessmentRegistrationAssignedByPerson { get; set; }
        public virtual ICollection<AssessmentRegistration> AssessmentRegistrationPerson { get; set; }
        public virtual ICollection<AssessmentSessionStaffRole> AssessmentSessionStaffRole { get; set; }
        public virtual ElchildDemographic ElchildDemographic { get; set; }
        public virtual ElchildDevelopmentalAssessment ElchildDevelopmentalAssessment { get; set; }
        public virtual ElchildHealth ElchildHealth { get; set; }
        public virtual ElchildIndividualizedProgram ElchildIndividualizedProgram { get; set; }
        public virtual ElchildOutcomeSummary ElchildOutcomeSummary { get; set; }
        public virtual ElchildTransitionPlan ElchildTransitionPlan { get; set; }
        public virtual ICollection<ElenrollmentOtherFunding> ElenrollmentOtherFunding { get; set; }
        public virtual ICollection<Incident> Incident { get; set; }
        public virtual ICollection<IncidentPerson> IncidentPerson { get; set; }
        public virtual ICollection<IndividualizedProgramService> IndividualizedProgramService { get; set; }
        public virtual ICollection<LearnerActivity> LearnerActivityAssignedByPerson { get; set; }
        public virtual ICollection<LearnerActivity> LearnerActivityPerson { get; set; }
        public virtual ICollection<LearningGoal> LearningGoal { get; set; }
        public virtual ICollection<LearningResourcePeerRating> LearningResourcePeerRating { get; set; }
        public virtual ICollection<OrganizationPersonRole> OrganizationPersonRole { get; set; }
        public virtual ICollection<PersonAddress> PersonAddress { get; set; }
        public virtual ICollection<PersonAllergy> PersonAllergy { get; set; }
        public virtual ICollection<PersonAssessmentPersonalNeedsProfile> PersonAssessmentPersonalNeedsProfile { get; set; }
        public virtual PersonBirthplace PersonBirthplace { get; set; }
        public virtual ICollection<PersonCareerEducationPlan> PersonCareerEducationPlan { get; set; }
        public virtual ICollection<PersonCredential> PersonCredential { get; set; }
        public virtual ICollection<PersonDegreeOrCertificate> PersonDegreeOrCertificate { get; set; }
        public virtual ICollection<PersonDemographicRace> PersonDemographicRace { get; set; }
        public virtual ICollection<PersonDetail> PersonDetail { get; set; }
        public virtual ICollection<PersonDisability> PersonDisability { get; set; }
        public virtual ICollection<PersonEmailAddress> PersonEmailAddress { get; set; }
        public virtual ICollection<PersonFamily> PersonFamily { get; set; }
        public virtual ICollection<PersonHealth> PersonHealth { get; set; }
        public virtual PersonHealthBirth PersonHealthBirth { get; set; }
        public virtual PersonHomelessness PersonHomelessness { get; set; }
        public virtual ICollection<PersonIdentifier> PersonIdentifier { get; set; }
        public virtual ICollection<PersonImmunization> PersonImmunization { get; set; }
        public virtual ICollection<PersonLanguage> PersonLanguage { get; set; }
        public virtual PersonMilitary PersonMilitary { get; set; }
        public virtual ICollection<PersonOtherName> PersonOtherName { get; set; }
        public virtual ICollection<PersonReferral> PersonReferral { get; set; }
        public virtual ICollection<PersonRelationship> PersonRelationshipPerson { get; set; }
        public virtual ICollection<PersonRelationship> PersonRelationshipRelatedPerson { get; set; }
        public virtual ICollection<PersonStatus> PersonStatus { get; set; }
        public virtual ICollection<PersonTelephone> PersonTelephone { get; set; }
        public virtual ICollection<QuarterlyEmploymentRecord> QuarterlyEmploymentRecord { get; set; }
        public virtual StaffExperience StaffExperience { get; set; }
    }
}
