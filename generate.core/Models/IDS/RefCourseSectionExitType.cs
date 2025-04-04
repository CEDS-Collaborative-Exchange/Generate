﻿using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefCourseSectionExitType
    {
        public RefCourseSectionExitType()
        {
            K12studentCourseSection = new HashSet<K12studentCourseSection>();
        }

        public int RefCourseSectionExitTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12studentCourseSection> K12studentCourseSection { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
