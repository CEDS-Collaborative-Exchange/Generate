using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefCourseGpaApplicability
    {
        public RefCourseGpaApplicability()
        {
            CteCourse = new HashSet<CteCourse>();
            K12course = new HashSet<K12course>();
            K12studentCourseSection = new HashSet<K12studentCourseSection>();
            PsSection = new HashSet<PsSection>();
        }

        public int RefCourseGpaapplicabilityId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<CteCourse> CteCourse { get; set; }
        public virtual ICollection<K12course> K12course { get; set; }
        public virtual ICollection<K12studentCourseSection> K12studentCourseSection { get; set; }
        public virtual ICollection<PsSection> PsSection { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
