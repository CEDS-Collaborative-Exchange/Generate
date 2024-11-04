using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class PsInstitution
    {
        public int Id { get; set; }
        public string OrganizationName { get; set; }
        public string InstitutionIpedsUnitId { get; set; }
        public string Website { get; set; }
        public string OrganizationOperationalStatus { get; set; }
        public DateTime? OperationalStatusEffectiveDate { get; set; }
        public string MostPrevalentLevelOfInstitutionCode { get; set; }
        public string PredominantCalendarSystem { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public string SchoolYear { get; set; }
        public string DataCollectionName { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
