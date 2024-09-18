using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class IndicatorStatusCustomType
    {
        public int Id { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public string DataCollectionName { get; set; }
        //public int? DataCollectionId { get; set; }
    }
}
