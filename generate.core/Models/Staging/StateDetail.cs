using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class StateDetail
    {
        public int Id { get; set; }
        public string StateAbbreviationCode { get; set; }
        public string SeaOrganizationName { get; set; }
        public string SeaOrganizationShortName { get; set; }
        public string SeaOrganizationIdentifierSea { get; set; }
        public string Sea_WebSiteAddress { get; set; }
        public string SeaContact_FirstName { get; set; }
        public string SeaContact_LastOrSurname { get; set; }
        public string SeaContact_PersonalTitleOrPrefix { get; set; }
        public string SeaContact_ElectronicMailAddress { get; set; }
        public string SeaContact_PhoneNumber { get; set; }
        public string SeaContact_Identifier { get; set; }
        public string SeaContact_PositionTitle { get; set; }
        public string CteGraduationRateInclusion { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public string SchoolYear { get; set; }
        public string DataCollectionName { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
