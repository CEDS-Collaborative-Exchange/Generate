using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefDisciplineMethodFirearms
    {
        public RefDisciplineMethodFirearms()
        {
            K12studentDiscipline = new HashSet<K12studentDiscipline>();
        }

        public int RefDisciplineMethodFirearmsId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12studentDiscipline> K12studentDiscipline { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
