using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class FactStudentDisciplineReportDto
    {
        public int FactStudentDisciplineReportDtoId { get; set; }

        // Organization

        public string StateANSICode { get; set; }
        public string StateAbbreviationCode { get; set; }
        public string StateAbbreviationDescription { get; set; }
        public string OrganizationIdentifierNces { get; set; }
        public string OrganizationIdentifierSea { get; set; }
        public string OrganizationName { get; set; }

        // Categories

        public string AGE { get; set; }

        public string ECONOMICDISADVANTAGESTATUS { get; set; }
        public string HOMELESSNESSSTATUS { get; set; }
        public string ENGLISHLEARNERSTATUS { get; set; }
        public string MIGRANTSTATUS { get; set; }
        public string SEX { get; set; }
        public string MILITARYCONNECTEDSTUDENTINDICATOR { get; set; }
        public string HOMELESSUNACCOMPANIEDYOUTHSTATUS { get; set; }
        public string HOMELESSPRIMARYNIGHTTIMERESIDENCE { get; set; }

        public string SPECIALEDUCATIONEXITREASON { get; set; }
        public string IDEADISABILITYTYPE { get; set; }
        public string IDEAINDICATOR { get; set; }
        public string IDEAEDUCATIONALENVIRONMENTFOREARLYCHILDHOOD { get; set; }
        public string IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE { get; set; }

        public string SECTION504STATUS { get; set; }
        public string CTEPARTICIPANT { get; set; }
        public string TITLEIIIIMMIGRANTPARTICIPATIONSTATUS { get; set; }
        public string ELIGIBILITYSTATUSFORSCHOOLFOODSERVICEPROGRAMS { get; set; }
        public string PROGRAMPARTICIPATIONFOSTERCARE { get; set; }
        public string TITLEIIIIMMIGRANTSTATUS { get; set; }
        public string HOMELESSSERVICEDINDICATOR { get; set; }


        public string DISCIPLINARYACTIONTAKEN { get; set; }
        public string DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES { get; set; }
        public string EDUCATIONALSERVICESAFTERREMOVAL { get; set; }
        public string IDEAINTERIMREMOVALREASON { get; set; }
        public string IDEAINTERIMREMOVAL { get; set; }


        public string REMOVALLENGTH { get; set; }

        public string RACE { get; set; }

        public string DISCIPLINEELSTATUS { get; set; }
        public string FIREARMTYPE { get; set; }
        public string GRADELEVEL { get; set; }

        public string DISCIPLINEMETHODFORFIREARMSINCIDENTS { get; set; }
        public string IDEADISCIPLINEMETHODFORFIREARMSINCIDENTS { get; set; }
        public string SINGLEPARENTORSINGLEPREGNANTWOMANSTATUS { get; set; }
        public string CTEAEDISPLACEDHOMEMAKERINDICATOR { get; set; }
        public string CTENONTRADITIONALGENDERSTATUS { get; set; }
        public string REPRESENTATIONSTATUS { get; set; }
        public string CTEGRADUATIONRATEINCLUSION { get; set; }
        public string PERKINSLEPSTATUS { get; set; }



        // File Submission properties
        public string ParentOrganizationIdentifierSea { get; set; }
        public string TableTypeAbbrv { get; set; }
        public string TotalIndicator { get; set; }

        // Count

        public int DisciplineCount { get; set; }


    }
}
