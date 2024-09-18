using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12schoolGradeOffered
    {
        public int K12schoolGradeOfferedId { get; set; }
        public int K12schoolId { get; set; }
        public int RefGradeLevelId { get; set; }
        public DateTime RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }

        public virtual K12school K12school { get; set; }
        public virtual RefGradeLevel RefGradeLevel { get; set; }
    }
}
