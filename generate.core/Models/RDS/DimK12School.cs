using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimK12School
    {
        public int DimK12SchoolId { get; set; }

        // School       
        public string NameOfInstitution { get; set; }
        public string SchoolIdentifierState { get; set; }
        public string PriorSchoolIdentifierState { get; set; }
        public string SchoolIdentifierNces { get; set; }

        public string CharterSchoolAuthorizerIdPrimary { get; set; }
        public string CharterSchoolAuthorizerIdSecondary { get; set; }

        //School statuses
        public bool? CharterSchoolIndicator { get; set; }
        public string CharterSchoolContractApprovalDate { get; set; }
        public string CharterSchoolContractRenewalDate { get; set; }
        public string CharterSchoolContractIdNumber { get; set; }
        // LEA        
        public string LeaName { get; set; }
        public string LeaIdentifierState { get; set; }
        public string PriorLeaIdentifierState { get; set; }
        public string LeaIdentifierNces { get; set; }

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
        public int? SchoolTypeId { get; set; }
        public string SchoolTypeCode { get; set; }
        public string SchoolTypeDescription { get; set; }
        public string SchoolTypeEdFactsCode { get; set; }
        public string SchoolOperationalStatus { get; set; }
        public string SchoolOperationalStatusEdFactsCode { get; set; }
        public string CharterSchoolStatus { get; set; }
        public string ReconstitutedStatus { get; set; }
        public string UpdatedSchoolOperationalStatusEdFactsCode { get; set; }
        public string UpdatedSchoolOperationalStatus { get; set; }

        public bool? ReportedFederally { get; set; }

        public List<FactK12StudentCount> FactStudentCounts { get; set; }
        public List<FactK12StudentDiscipline> FactStudentDisciplines { get; set; }
        public List<FactK12StudentAssessment> FactStudentAssessments { get; set; }
        public List<FactK12StaffCount> FactPersonnelCounts { get; set; }

        public List<FactOrganizationCount> FactOrganizationCounts { get; set; }

		public List<FactOrganizationStatusCount> FactOrganizationStatusCount { get; set; }

        public List<FactK12StudentAttendance> FactK12StudentAttendance { get; set; }

      
    }
}
