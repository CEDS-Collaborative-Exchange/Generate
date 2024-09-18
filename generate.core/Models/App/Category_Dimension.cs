using System;
using System.Collections;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class Category_Dimension
    {
        public int CategoryId { get; set; }
        public Category Category { get; set; }
        public int DimensionId { get; set; }
        public Dimension Dimension { get; set; }


    }
}
