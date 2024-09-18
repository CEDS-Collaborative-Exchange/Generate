using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Dtos.App
{
    public class CategorySetDto
    {
        public int CategorySetId { get; set; }
        public string OrganizationLevelCode { get; set; }
        public string SubmissionYear { get; set; }
        public string CategorySetCode { get; set; }
        public string CategorySetName { get; set; }
        public string ViewDefinition { get; set; }
        public string ExcludeOnFilter { get; set; }
        public string IncludeOnFilter { get; set; }
        public List<string> Categories { get; set; }
        public List<CategorySetCategoryOptionDto> CategoryOptions { get; set; }
    }
}
