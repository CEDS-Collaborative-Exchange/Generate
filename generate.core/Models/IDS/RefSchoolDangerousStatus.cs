using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Models.IDS
{
    public partial class RefSchoolDangerousStatus
    {
        public RefSchoolDangerousStatus()
        {
            K12schoolStatus = new HashSet<K12schoolStatus>();
        }

        public int RefSchoolDangerousStatusId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }


        public virtual ICollection<K12schoolStatus> K12schoolStatus { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
