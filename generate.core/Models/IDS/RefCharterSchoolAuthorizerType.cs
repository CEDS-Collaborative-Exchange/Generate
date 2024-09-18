using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefCharterSchoolAuthorizerType
    {
        public RefCharterSchoolAuthorizerType()
        {
            K12CharterSchoolAuthorizer = new HashSet<K12CharterSchoolAuthorizer>();
        }

        public int RefCharterSchoolAuthorizerTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }
        public virtual ICollection<K12CharterSchoolAuthorizer> K12CharterSchoolAuthorizer { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
