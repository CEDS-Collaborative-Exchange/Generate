using System;
using System.Collections.Generic;


namespace generate.core.Models.RDS
{
    public partial class BridgeLeaGradeLevel
    {
        public int LeaId { get; set; }
        public int GradeLevelId { get; set; }

        public DimLea DimLea { get; set; }
        public DimGradeLevel DimGradeLevel { get; set; }
    }
}
