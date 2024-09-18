using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class OrganizationSchoolComprehensiveAndTargetedSupport
    {
        public int Id { get; set; }
        public string SchoolIdentifierState { get; set; }
        public string SchoolComprehensiveAndTargetedSupport { get; set; }
        public string SchoolComprehensiveSupport { get; set; }
        public string SchoolTargetedSupport { get; set; }
        public string SchoolYear { get; set; }
        public string DataCollectionName { get; set; }
        //public int? DataCollectionId { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
