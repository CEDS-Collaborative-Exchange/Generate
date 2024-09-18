using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAssessmentAssetIdentifierType
    {
        public RefAssessmentAssetIdentifierType()
        {
            AssessmentAsset = new HashSet<AssessmentAsset>();
        }

        public int RefAssessmentAssetIdentifierTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentAsset> AssessmentAsset { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
