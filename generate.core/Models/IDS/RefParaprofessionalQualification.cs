using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefParaprofessionalQualification
    {
        public RefParaprofessionalQualification()
        {
            StaffCredential = new HashSet<StaffCredential>();
        }

        public int RefParaprofessionalQualificationId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<StaffCredential> StaffCredential { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
