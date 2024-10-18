using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class FactK12StudentAssessmentReport
    {
        public int FactK12StudentAssessmentReportId { get; set; }

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
        public string OrganizationNcesId { get; set; }
        public string OrganizationStateId { get; set; }
        public string OrganizationName { get; set; }
        public string ParentOrganizationStateId { get; set; }

        public string ECODISSTATUS { get; set; }
        public string HOMELESSSTATUS { get; set; }
        public string LEPSTATUS { get; set; }
        public string MIGRANTSTATUS { get; set; }
        public string SEX { get; set; }
        public string MILITARYCONNECTEDSTATUS { get; set; }
        public string HOMELESSUNACCOMPANIEDYOUTHSTATUS { get; set; }
        public string HOMELESSNIGHTTIMERESIDENCE { get; set; }

        public string ASSESSMENTSUBJECT { get; set; }
        public string ASSESSMENTTYPE { get; set; }
        public string FULLYEARSTATUS { get; set; }
        public string GRADELEVEL { get; set; }
        public string PARTICIPATIONSTATUS { get; set; }
        public string PERFORMANCELEVEL { get; set; }

        public string SPECIALEDUCATIONEXITREASON { get; set; }
        public string PRIMARYDISABILITYTYPE { get; set; }
        public string IDEAINDICATOR { get; set; }
        public string IDEAEDUCATIONALENVIRONMENT { get; set; }
        public string SECTION504STATUS { get; set; }
        public string CTEPROGRAM { get; set; }
        public string TITLEIIIIMMIGRANTPARTICIPATIONSTATUS { get; set; }
        public string ELIGIBILITYSTATUSFORSCHOOLFOODSERVICEPROGRAM { get; set; }
        public string FOSTERCAREPROGRAM { get; set; }
        public string TITLEIIIPROGRAMPARTICIPATION { get; set; }
        public string HOMELESSSERVICEDINDICATOR { get; set; }

        public string RACE { get; set; }

        public string TITLEIIIACCOUNTABILITYPROGRESSSTATUS { get; set; }
        public string FORMERENGLISHLEARNERYEARSTATUS { get; set; }
        public string TITLEIIILANGUAGEINSTRUCTION { get; set; }
        public string PROFICIENCYSTATUS { get; set; }
        public string ASSESSEDFIRSTTIME { get; set; }


        public string HIGHSCHOOLDIPLOMATYPE { get; set; }
        public string MOBILITYSTATUS12MO { get; set; }
        public string MOBILITYSTATUSSY { get; set; }
        public string REFERRALSTATUS { get; set; }
        public string SINGLEPARENTORSINGLEPREGNANTWOMAN { get; set; }
        public string CTEAEDISPLACEDHOMEMAKERINDICATOR { get; set; }
        public string CTENONTRADITIONALGENDERSTATUS { get; set; }
        public string PLACEMENTSTATUS { get; set; }
        public string PLACEMENTTYPE { get; set; }
        public string REPRESENTATIONSTATUS { get; set; }
        public string CTEGRADUATIONRATEINCLUSION { get; set; }
        public string TESTRESULT { get; set; }

		public string LONGTERMSTATUS { get; set; }
		public string NEGLECTEDORDELINQUENTPROGRAMTYPE { get; set; }
        public string ASSESSMENTPROGRESSLEVEL { get; set; }
        public string ACADEMICORVOCATIONALOUTCOME { get; set; }
        public string ACADEMICORVOCATIONALEXITOUTCOME { get; set; }
        public string LEPPERKINSSTATUS { get; set; }

        public string TITLEIINSTRUCTIONALSERVICES { get; set; }
        public string TITLEISUPPORTSERVICES { get; set; }
        public string TITLEISCHOOLSTATUS { get; set; }
        public string TITLEIPROGRAMTYPE { get; set; }

        public int AssessmentCount { get; set; }


    }
}
