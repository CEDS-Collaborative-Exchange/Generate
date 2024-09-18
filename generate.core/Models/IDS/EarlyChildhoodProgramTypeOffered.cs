using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class EarlyChildhoodProgramTypeOffered
    {
        public int EarlyChildhoodProgramTypeOfferedId { get; set; }
        public int OrganizationId { get; set; }
        public int RefEarlyChildhoodProgramEnrollmentTypeId { get; set; }
        public bool? InclusiveSettingIndicator { get; set; }
        public int? RefCommunityBasedTypeId { get; set; }

        public virtual Organization Organization { get; set; }
        public virtual RefCommunityBasedType RefCommunityBasedType { get; set; }
        public virtual RefEarlyChildhoodProgramEnrollmentType RefEarlyChildhoodProgramEnrollmentType { get; set; }
    }
}
