using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefCourseAcademicGradeStatusCode
    {
        public RefCourseAcademicGradeStatusCode()
        {
            PsStudentSection = new HashSet<PsStudentSection>();
        }

        public int RefCourseAcademicGradeStatusCodeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PsStudentSection> PsStudentSection { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
