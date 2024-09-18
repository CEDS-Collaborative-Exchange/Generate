using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class ReportEDFactsK12StaffCount
    {
        public int ReportEDFactsK12StaffCountId { get; set; }

        public string ReportCode { get; set; }
        public string ReportYear { get; set; }
        public string ReportLevel { get; set; }
        public string CategorySetCode { get; set; }
        public string Categories { get; set; }
        public string TableTypeAbbrv { get; set; }
        public string TotalIndicator { get; set; }

        public string StateANSICode { get; set; }
        public string StateAbbreviationCode { get; set; }
        public string StateAbbreviationDescription { get; set; }
        //public int OrganizationId { get; set; }
        public string OrganizationIdentifierNces { get; set; }
        public string OrganizationIdentifierSea { get; set; }
        public string OrganizationName { get; set; }
        public string ParentOrganizationIdentifierSea { get; set; }

        public string SPECIALEDUCATIONAGEGROUPTAUGHT { get; set; }
        public string EDFACTSCERTIFICATIONSTATUS { get; set; }
        public string K12STAFFCLASSIFICATION { get; set; }
        public string SPECIALEDUCATIONTEACHERQUALIFICATIONSTATUS { get; set; }
        public string SPECIALEDUCATIONSUPPORTSERVICESCATEGORY { get; set; }
        public string TITLEIPROGRAMSTAFFCATEGORY { get; set; }

        //  public string MEPSESSSTF { get; set; }
        public string TITLEIIIACCOUNTABILITYPROGRESSSTATUS { get; set; }
        public string FORMERENGLISHLEARNERYEARSTATUS { get; set; }
        public string TITLEIIILANGUAGEINSTRUCTIONPROGRAMTYPE { get; set; }
        public string PROFICIENCYSTATUS { get; set; }
        public string TEACHINGCREDENTIALTYPE { get; set; }
        public string PARAPROFESSIONALQUALIFICATIONSTATUS { get; set; }
        //  public string ASSESSEDFIRSTTIME { get; set; }

        //public string EMERGENCYORPROVISIONALCREDENTIALSTATUS { get; set; }
        public string EDFACTSTEACHEROUTOFFIELDSTATUS { get; set; }
        public string EDFACTSTEACHERINEXPERIENCEDSTATUS { get; set; }


        public int StaffCount { get; set; }
        public decimal StaffFullTimeEquivalency { get; set; }

      //  public string MEPSESSSTF { get; set; }


    }
}
