using System;
using System.Collections;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class CategorySet_Category
    {
        public int CategorySetId { get; set; }
        public CategorySet CategorySet { get; set; }
        public int CategoryId { get; set; }
        public Category Category { get; set; }


    }
}
