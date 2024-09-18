using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefProgressLevel
    {
        public RefProgressLevel()
        {
            K12studentAcademicRecord = new HashSet<K12studentAcademicRecord>();
            K12studentCourseSection = new HashSet<K12studentCourseSection>();
        }

        public int RefProgressLevelId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12studentAcademicRecord> K12studentAcademicRecord { get; set; }
        public virtual ICollection<K12studentCourseSection> K12studentCourseSection { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
