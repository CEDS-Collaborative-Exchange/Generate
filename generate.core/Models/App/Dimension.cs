using System;
using System.Collections;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class Dimension
    {
        public int DimensionId { get; set; }
        public int DimensionTableId { get; set; }
        public string DimensionFieldName { get; set; }
        public bool IsCalculated { get; set; }
        public bool IsOrganizationLevelSpecific { get; set; }
        public DimensionTable DimensionTable { get; set; }
        public List<Category_Dimension> Category_Dimensions { get; set; }

    }
}
