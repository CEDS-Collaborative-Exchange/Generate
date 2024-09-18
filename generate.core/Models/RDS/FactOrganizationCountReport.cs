using System;
using System.Collections.Generic;


namespace generate.core.Models.RDS
{
    public partial class FactOrganizationCountReport
    {
        public int FactOrganizationCountReportId { get; set; }

        public string ReportCode { get; set; }
        public string ReportYear { get; set; }
        public string ReportLevel { get; set; }
        public string CategorySetCode { get; set; }
        public string Categories { get; set; }
        public string TableTypeAbbrv { get; set; }
        public string TotalIndicator { get; set; }


        public string StateANSICode { get; set; }
        public string StateCode { get; set; }
        public string StateName { get; set; }
        public int OrganizationId { get; set; }
        public string OrganizationNcesId { get; set; }
        public string OrganizationStateId { get; set; }
        public string OrganizationName { get; set; }
        public string ParentOrganizationStateId { get; set; }
        public string ParentOrganizationNcesId { get; set; }


        public string SHAREDTIMESTATUS { get; set; }
        public string TITLE1SCHOOLSTATUS { get; set; }
        public string MAGNETSTATUS { get; set; }
        public string NSLPSTATUS { get; set; }
        public string VIRTUALSCHSTATUS { get; set; }

        public string PERSISTENTLYDANGEROUSSTATUS { get; set; }
        public string IMPROVEMENTSTATUS { get; set; }
        public string STATEPOVERTYDESIGNATION { get; set; }
        public int? SCHOOLIMPROVEMENTFUNDS { get; set; }

        public string CHARTERSCHOOLMANAGEMENTORGANIZATION { get; set; }
        public string CHARTERSCHOOLUPDATEDMANAGEMENTORGANIZATION { get; set; }

        public string CSSOFirstName { get; set; }
        public string CSSOLastName { get; set; }
        public string CSSOTitle { get; set; }
        public string CSSOTelephone { get; set; }
        public string CSSOEmail { get; set; }
        public string Website { get; set; }
        public string Telephone { get; set; }
        public string MailingAddressStreet { get; set; }
        public string MailingAddressStreet2 { get; set; }
        public string MailingAddressCity { get; set; }
        public string MailingAddressState { get; set; }
        public string MailingAddressPostalCode { get; set; }
        public string MailingAddressPostalCode2 { get; set; }
        public string PhysicalAddressStreet { get; set; }
        public string PhysicalAddressStreet2 { get; set; }
        public string PhysicalAddressCity { get; set; }
        public string PhysicalAddressState { get; set; }
        public string PhysicalAddressPostalCode { get; set; }
        public string PhysicalAddressPostalCode2 { get; set; }
        public string SupervisoryUnionIdentificationNumber { get; set; }
        public string OperationalStatus { get; set; }
        public string OperationalStatusId { get; set; }
        public string UpdatedOperationalStatus { get; set; }
        public string UpdatedOperationalStatusId { get; set; }
        public string LEAType { get; set; }
        public string LEATypeDescription { get; set; }
        public string SchoolType { get; set; }
        public string SchoolTypeDescription { get; set; }
        public string ReconstitutedStatus { get; set; }
        public string OutOfStateIndicator { get; set; }
        public string CharterSchoolStatus { get; set; }
        public string CharterLeaStatus { get; set; }
        public string CharterSchoolAuthorizer { get; set; }
        public string CharterSchoolSecondaryAuthorizer { get; set; }
        public string GRADELEVEL { get; set; }
        public string EffectiveDate { get; set; }
        public string PriorLeaStateIdentifier { get; set; }
        public string PriorSchoolStateIdentifier { get; set; }

        public int? EconomicallyDisadvantagedStudentCount { get; set; }

        public string McKinneyVentoSubgrantRecipient { get; set; }

        public string PROGRESSACHIEVINGENGLISHLANGUAGE { get; set; }
        public string STATEDEFINEDSTATUS { get; set; }

        public int OrganizationCount { get; set; }
        public int TitleiParentalInvolveRes { get; set; }
        public int TitleiPartaAllocations { get; set; }

        //lea
        public string LeaStateIdentifier { get; set; }
        public string LeaNcesIdentifier { get; set; }
        public string ManagementOrganizationType { get; set; }

        public string CharterSchoolContractIdNumber { get; set; }
        public string CharterContractApprovalDate { get; set; }
        public string CharterContractRenewalDate { get; set; }

        public string REAPAlternativeFundingStatus { get; set; }
        public string GunFreeStatus { get; set; }
        public string GraduationRate { get; set; }
        public string FederalFundAllocationType { get; set; }
        public string FederalProgramCode { get; set; }
        public int? FederalFundAllocated { get; set; }

        public string ComprehensiveAndTargetedSupportCode { get; set; }
        public string ComprehensiveSupportCode { get; set; }
        public string TargetedSupportCode { get; set; }
        public string AdditionalTargetedSupportandImprovementCode { get; set; }
        public string ComprehensiveSupportImprovementCode { get; set; }
        public string TargetedSupportImprovementCode { get; set; }
        public string AppropriationMethodCode { get; set; }
    }
}
