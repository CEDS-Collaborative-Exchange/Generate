using System;
using System.Collections;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class Category
    {
        public int CategoryId { get; set; }
        public int EdFactsCategoryId { get; set; }

        public string CategoryCode { get; set; }
        public string CategoryName { get; set; }
        public int? CategorySequence { get; set; }


        public List<CategoryOption> CategoryOptions { get; set; }
        public List<CategorySet_Category> CategorySet_Categories { get; set; }
        public List<Category_Dimension> Category_Dimensions { get; set; }

    }
}
