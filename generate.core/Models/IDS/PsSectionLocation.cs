using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PsSectionLocation
    {
        public int OrganizationId { get; set; }
        public string CourseInstructionSiteName { get; set; }
        public int? RefCourseInstructionSiteTypeId { get; set; }

        public virtual PsSection Organization { get; set; }
        public virtual RefCourseInstructionSiteType RefCourseInstructionSiteType { get; set; }
    }
}
