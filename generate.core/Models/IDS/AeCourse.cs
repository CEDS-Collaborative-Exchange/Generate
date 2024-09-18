using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AeCourse
    {
        public int OrganizationId { get; set; }
        public int? RefCourseLevelTypeId { get; set; }
        public int? RefCareerClusterId { get; set; }

        public virtual RefCareerCluster RefCareerCluster { get; set; }
    }
}
