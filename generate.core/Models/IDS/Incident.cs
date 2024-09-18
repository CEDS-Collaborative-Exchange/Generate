using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class Incident
    {
        public Incident()
        {
            IncidentPerson = new HashSet<IncidentPerson>();
            K12studentDiscipline = new HashSet<K12studentDiscipline>();
        }

        public int IncidentId { get; set; }
        public string IncidentIdentifier { get; set; }
        public DateTime? IncidentDate { get; set; }
        public TimeSpan? IncidentTime { get; set; }
        public int? RefIncidentTimeDescriptionCodeId { get; set; }
        public string IncidentDescription { get; set; }
        public int? RefIncidentBehaviorId { get; set; }
        public int? RefIncidentBehaviorSecondaryId { get; set; }
        public int? RefIncidentInjuryTypeId { get; set; }
        public int? RefWeaponTypeId { get; set; }
        public string IncidentCost { get; set; }
        public int? OrganizationPersonRoleId { get; set; }
        public int? IncidentReporterId { get; set; }
        public int? RefIncidentReporterTypeId { get; set; }
        public int? RefIncidentLocationId { get; set; }
        public int? RefFirearmTypeId { get; set; }
        public string RegulationViolatedDescription { get; set; }
        public bool? RelatedToDisabilityManifestationInd { get; set; }
        public bool? ReportedToLawEnforcementInd { get; set; }
        public int? RefIncidentMultipleOffenseTypeId { get; set; }
        public int? RefIncidentPerpetratorInjuryTypeId { get; set; }

        public virtual ICollection<IncidentPerson> IncidentPerson { get; set; }
        public virtual ICollection<K12studentDiscipline> K12studentDiscipline { get; set; }
        public virtual Person IncidentReporter { get; set; }
        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefFirearmType RefFirearmType { get; set; }
        public virtual RefIncidentBehavior RefIncidentBehavior { get; set; }
        public virtual RefIncidentBehaviorSecondary RefIncidentBehaviorSecondary { get; set; }
        public virtual RefIncidentInjuryType RefIncidentInjuryType { get; set; }
        public virtual RefIncidentLocation RefIncidentLocation { get; set; }
        public virtual RefIncidentMultipleOffenseType RefIncidentMultipleOffenseType { get; set; }
        public virtual RefIncidentPerpetratorInjuryType RefIncidentPerpetratorInjuryType { get; set; }
        public virtual RefIncidentReporterType RefIncidentReporterType { get; set; }
        public virtual RefIncidentTimeDescriptionCode RefIncidentTimeDescriptionCode { get; set; }
        public virtual RefWeaponType RefWeaponType { get; set; }
    }
}
