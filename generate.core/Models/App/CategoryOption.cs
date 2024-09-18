using System;
using System.Collections;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class CategoryOption
    {
        public int CategoryOptionId { get; set; }

        public int CategoryId { get; set; }
        public Category Category { get; set; }

        public int? CategorySetId { get; set; }
        public CategorySet CategorySet { get; set; }


        public int EdFactsCategoryCodeId { get; set; }

        public string CategoryOptionCode { get; set; }
        public string CategoryOptionName { get; set; }
        public int? CategoryOptionSequence { get; set; }


    }
}
