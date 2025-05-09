﻿using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class OrganizationSchoolIndicatorStatus
    {
        public int Id { get; set; }
        public string SchoolIdentifierSea { get; set; }
        public string IndicatorStatusType { get; set; }
        public string IndicatorStatus { get; set; }
        public string IndicatorStatusSubgroupType { get; set; }
        public string IndicatorStatusSubgroup { get; set; }
        public string StatedDefinedIndicatorStatus { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public string SchoolYear { get; set; }
        public string DataCollectionName { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
