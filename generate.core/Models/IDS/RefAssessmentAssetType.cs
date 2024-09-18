using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAssessmentAssetType
    {
        public RefAssessmentAssetType()
        {
            AssessmentAsset = new HashSet<AssessmentAsset>();
        }

        public int RefAssessmentAssetTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentAsset> AssessmentAsset { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
