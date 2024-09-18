using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class StateDefinedCustomIndicator
    {
        public int Id { get; set; }
        public string Code { get; set; }
        public string Description { get; set; }
        public string Definition { get; set; }
        public int? RefIndicatorStatusCustomTypeId { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
