using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefDentalInsuranceCoverageType
    {
        public RefDentalInsuranceCoverageType()
        {
            PersonHealth = new HashSet<PersonHealth>();
        }

        public int RefDentalInsuranceCoverageTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PersonHealth> PersonHealth { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
