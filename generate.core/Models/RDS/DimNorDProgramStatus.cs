using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimNorDProgramStatus
    {

        public int DimNorDProgramStatusId { get; set; }
        public int? LongTermStatusId { get; set; }
        public string LongTermStatusCode { get; set; }
        public string LongTermStatusDescription { get; set; }
        public string LongTermStatusEdFactsCode { get; set; }

        public int? NeglectedProgramTypeId { get; set; }
        public string NeglectedProgramTypeCode { get; set; }
        public string NeglectedProgramTypeDescription { get; set; }
        public string NeglectedProgramTypeEdFactsCode { get; set; }

        
        public List<FactK12StudentCount> FactK12StudentCounts { get; set; }
		public List<FactK12StudentAssessment> FactK12StudentAssessments { get; set; }
    }
}
