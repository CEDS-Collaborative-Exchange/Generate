using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefTitleIiiprofessionalDevelopmentType
    {
        public RefTitleIiiprofessionalDevelopmentType()
        {
            K12leaTitleIiiprofessionalDevelopment = new HashSet<K12leaTitleIiiprofessionalDevelopment>();
        }

        public int RefTitleIiiprofessionalDevelopmentTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12leaTitleIiiprofessionalDevelopment> K12leaTitleIiiprofessionalDevelopment { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
