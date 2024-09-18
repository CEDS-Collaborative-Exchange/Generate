using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class FactPersonnelCountReportDto
    {
        public int FactPersonnelCountReportDtoId { get; set; }

        // Organization

        public string StateANSICode { get; set; }
        public string StateAbbreviationCode { get; set; }
        public string StateAbbreviationDescription { get; set; }
        //public int OrganizationId { get; set; }
        public string OrganizationIdentifierNces { get; set; }
        public string OrganizationIdentifierSea { get; set; }
        public string OrganizationName { get; set; }

        // Categories
        public string SPECIALEDUCATIONAGEGROUPTAUGHT { get; set; }
        public string EDFACTSCERTIFICATIONSTATUS { get; set; }
        public string K12STAFFCLASSIFICATION { get; set; }
        public string SPECIALEDUCATIONTEACHERQUALIFICATIONSTATUS { get; set; }
        public string SPECIALEDUCATIONSUPPORTSERVICESCATEGORY { get; set; }
        public string TITLEIPROGRAMSTAFFCATEGORY { get; set; }

        //  public string MEPSESSSTF { get; set; }
        public string TITLEIIIACCOUNTABILITYPROGRESSSTATUS { get; set; }
        public string FORMERENGLISHLEARNERYEARSTATUS { get; set; }
        public string TITLEIIILANGUAGEINSTRUCTION { get; set; }
        public string PROFICIENCYSTATUS { get; set; }
        //  public string ASSESSEDFIRSTTIME { get; set; }

        public string EMERGENCYORPROVISIONALCREDENTIALSTATUS { get; set; }
        public string EDFACTSTEACHEROUTOFFIELDSTATUS { get; set; }
        public string EDFACTSTEACHERINEXPERIENCEDSTATUS { get; set; }


        // File Submission properties
        public string ParentOrganizationIdentifierSea { get; set; }
        public string TableTypeAbbrv { get; set; }
        public string TotalIndicator { get; set; }

        // Count
        public int StaffCount { get; set; }
        public decimal StaffFTE { get; set; }


    }
}
