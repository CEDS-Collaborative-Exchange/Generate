using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class OrganizationGradeOffered
    {
        public int Id { get; set; }
        public string OrganizationIdentifier { get; set; }
        public string GradeOffered { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public string SchoolYear { get; set; }
        public string DataCollectionName { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
