using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimLea
    {
        public int DimLeaID { get; set; }

        public string LeaName { get; set; }
        public string LeaIdentifierState { get; set; }
        public string PriorLeaIdentifierState { get; set; }
        public string LeaIdentifierNces { get; set; }
        public string LeaSupervisoryUnionIdentificationNumber { get; set; }

        // SEA        
        public string SeaName { get; set; }
        public string SeaIdentifierState { get; set; }


        // State
        public string StateAnsiCode { get; set; }
        public string StateAbbreviationDescription { get; set; }
        public string StateAbbreviationCode { get; set; }
        public string Website { get; set; }
        public string Telephone { get; set; }

        public string MailingAddressStreet { get; set; }
        public string MailingAddressCity { get; set; }
        public string MailingAddressState { get; set; }
        public string MailingAddressPostalCode { get; set; }

        public string PhysicalAddressStreet { get; set; }
        public string PhysicalAddressCity { get; set; }
        public string PhysicalAddressState { get; set; }
        public string PhysicalAddressPostalCode { get; set; }
        public DateTime RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public DateTime? OperationalStatusEffectiveDate { get; set; }
        public bool OutOfStateIndicator { get; set; }


        public int? LeaTypeId { get; set; }
        public string LeaTypeCode { get; set; }
        public string LeaTypeDescription { get; set; }
        public string LeaTypeEdFactsCode { get; set; }
        public string LeaOperationalStatus { get; set; }
        public string LeaOperationalStatusEdFactsCode { get; set; }
        public string CharterLeaStatus { get; set; }
        public string ReconstitutedStatus { get; set; }
        public string UpdatedLeaOperationalStatusEdFactsCode { get; set; }
        public string UpdatedLeaOperationalStatus { get; set; }

        public bool ReportedFederally { get; set; }

        public List<FactOrganizationCount> FactOrganizationCounts { get; set; }
        public List<FactK12StudentCount> FactStudentCounts { get; set; }
        public List<FactK12StudentDiscipline> FactStudentDisciplines { get; set; }
        public List<FactK12StudentAssessment> FactStudentAssessments { get; set; }
        public List<FactK12StudentAttendance> FactK12StudentAttendance { get; set; }
        public List<BridgeLeaGradeLevel> BridgeLeaGradeLevel { get; set; }

    }
}
