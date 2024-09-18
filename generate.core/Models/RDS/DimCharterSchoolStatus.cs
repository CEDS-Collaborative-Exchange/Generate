using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimCharterSchoolStatus
    {
        public int DimCharterSchoolStatusId { get; set; }

        public int? AppropriationMethodId { get; set; }
        public string AppropriationMethodCode { get; set; }
        public string AppropriationMethodDescription { get; set; }
        public string AppropriationMethodEdFactsCode { get; set; }

		public List<FactOrganizationCount> FactOrganizationCounts { get; set; }
    }
}
