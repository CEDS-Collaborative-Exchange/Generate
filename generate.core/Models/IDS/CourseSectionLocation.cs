using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class CourseSectionLocation
    {
        public int CourseSectionLocationId { get; set; }
        public int LocationId { get; set; }
        public int OrganizationId { get; set; }
        public int? RefInstructionLocationTypeId { get; set; }

        public virtual Classroom Location { get; set; }
        public virtual CourseSection Organization { get; set; }
        public virtual RefInstructionLocationType RefInstructionLocationType { get; set; }
    }
}
