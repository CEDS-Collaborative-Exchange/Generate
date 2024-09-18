using System;
using System.Collections;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class FactTable_DimensionTable
    {
        public int FactTableId { get; set; }
        public FactTable FactTable { get; set; }
        public int DimensionTableId { get; set; }
        public DimensionTable DimensionTable { get; set; }


    }
}
