﻿using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class FactStudentAssessmentReportDto
    {
        public int FactStudentAssessmentReportDtoId { get; set; }
        // Organization

        public string StateANSICode { get; set; }
        public string StateAbbreviationCode { get; set; }
        public string StateAbbreviationDescription { get; set; }
        public string OrganizationIdentifierNces { get; set; }
        public string OrganizationIdentifierSea { get; set; }
        public string OrganizationName { get; set; }

        // Categories

        public string ECONOMICDISADVANTAGESTATUS { get; set; }
        public string HOMELESSNESSSTATUS { get; set; }
        public string ENGLISHLEARNERSTATUS { get; set; }
        public string MIGRANTSTATUS { get; set; }
        public string SEX { get; set; }
        public string MILITARYCONNECTEDSTUDENTINDICATOR { get; set; }
        public string HOMELESSUNACCOMPANIEDYOUTHSTATUS { get; set; }
        public string HOMELESSPRIMARYNIGHTTIMERESIDENCE { get; set; }

        public string ASSESSMENTACADEMICSUBJECT { get; set; }
        public string ASSESSMENTTYPE { get; set; }
        public string FULLYEARSTATUS { get; set; }
        public string GRADELEVEL { get; set; }
        public string PARTICIPATIONSTATUS { get; set; }
        public string PERFORMANCELEVEL { get; set; }


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
        public string SINGLEPARENTORSINGLEPREGNANTWOMANSTATUS { get; set; }
        public string CTEAEDISPLACEDHOMEMAKERINDICATOR { get; set; }
        public string CTENONTRADITIONALGENDERSTATUS { get; set; }
        public string PLACEMENTSTATUS { get; set; }
        public string PLACEMENTTYPE { get; set; }
        public string REPRESENTATIONSTATUS { get; set; }
        public string CTEGRADUATIONRATEINCLUSION { get; set; }
        public string TESTRESULT { get; set; }

        public string LONGTERMSTATUS { get; set; }
        public string NEGLECTEDORDELINQUENTPROGRAMTYPE { get; set; }

        public string PROGRESSLEVEL { get; set; }
        public string EDFACTSACADEMICORCAREERANDTECHNICALOUTCOMETYPE { get; set; }
        public string EDFACTSACADEMICORCAREERANDTECHNICALOUTCOMEEXITTYPE { get; set; }
        public string PERKINSLEPSTATUS { get; set; }

        public string TITLEIINSTRUCTIONALSERVICES { get; set; }
        public string TITLEISUPPORTSERVICES { get; set; }
        public string TITLEISCHOOLSTATUS { get; set; }
        public string TITLEIPROGRAMTYPE { get; set; }

        // File Submission properties
        public string ParentOrganizationIdentifierSea { get; set; }
        public string TableTypeAbbrv { get; set; }
        public string TotalIndicator { get; set; }
        public int AssessmentCount { get; set; }


    }
}
