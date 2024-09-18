using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class Location
    {
        public Location()
        {
            AssessmentParticipantSession = new HashSet<AssessmentParticipantSession>();
            OrganizationLocation = new HashSet<OrganizationLocation>();
        }

        public int LocationId { get; set; }

        public virtual ICollection<AssessmentParticipantSession> AssessmentParticipantSession { get; set; }
        public virtual Classroom Classroom { get; set; }
        public virtual Facility Facility { get; set; }
        public virtual LocationAddress LocationAddress { get; set; }
        public virtual ICollection<OrganizationLocation> OrganizationLocation { get; set; }
    }
}
