using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class Classroom
    {
        public Classroom()
        {
            CourseSectionLocation = new HashSet<CourseSectionLocation>();
        }

        public int LocationId { get; set; }
        public string ClassroomIdentifier { get; set; }

        public virtual ICollection<CourseSectionLocation> CourseSectionLocation { get; set; }
        public virtual Location Location { get; set; }
    }
}
