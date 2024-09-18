using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class StaffExperience
    {
        public int PersonId { get; set; }
        public decimal? YearsOfPriorTeachingExperience { get; set; }
        public decimal? YearsOfPriorAeteachingExperience { get; set; }

        public virtual Person Person { get; set; }
    }
}
