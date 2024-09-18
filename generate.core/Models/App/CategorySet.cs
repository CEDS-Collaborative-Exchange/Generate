using System;
using System.Collections;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class CategorySet
    {
        public int CategorySetId { get; set; }

        public int GenerateReportId { get; set; }
        public GenerateReport GenerateReport { get; set; }

        public int OrganizationLevelId { get; set; }
        public OrganizationLevel OrganizationLevel { get; set; }

        public string SubmissionYear { get; set; }


        public int EdFactsTableTypeGroupId { get; set; }

        public string CategorySetCode { get; set; }
        public string CategorySetName { get; set; }
        public int? CategorySetSequence { get; set; }
        public string ExcludeOnFilter { get; set; }
        public string IncludeOnFilter { get; set; }
        public string ViewDefinition { get; set; }

        public int? TableTypeId { get; set; }

        public List<CategorySet_Category> CategorySet_Categories { get; set; }
        public TableType TableType { get; set; }

    }
}
