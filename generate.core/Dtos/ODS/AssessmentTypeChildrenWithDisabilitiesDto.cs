using System;
using System.Collections.Generic;
using System.Text;

namespace generate.core.Dtos.ODS
{
    public class AssessmentTypeChildrenWithDisabilitiesDto
    {
        public int RefAssessmentTypeChildrenWithDisabilitiesId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }
    }
}

