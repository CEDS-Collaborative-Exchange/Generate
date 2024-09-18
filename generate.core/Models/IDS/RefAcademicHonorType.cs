using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAcademicHonorType
    {
        public RefAcademicHonorType()
        {
            K12studentAcademicHonor = new HashSet<K12studentAcademicHonor>();
        }

        public int RefAcademicHonorTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12studentAcademicHonor> K12studentAcademicHonor { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
