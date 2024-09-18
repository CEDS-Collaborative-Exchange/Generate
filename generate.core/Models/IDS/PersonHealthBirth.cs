using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonHealthBirth
    {
        public int PersonId { get; set; }
        public int? WeeksOfGestation { get; set; }
        public bool? MultipleBirthIndicator { get; set; }
        public string WeightAtBirth { get; set; }
        public int? RefTrimesterWhenPrenatalCareBeganId { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefTrimesterWhenPrenatalCareBegan RefTrimesterWhenPrenatalCareBegan { get; set; }
    }
}
