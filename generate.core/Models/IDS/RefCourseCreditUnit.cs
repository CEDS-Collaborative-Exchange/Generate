using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefCourseCreditUnit
    {
        public RefCourseCreditUnit()
        {
            Course = new HashSet<Course>();
            ProfessionalDevelopmentActivity = new HashSet<ProfessionalDevelopmentActivity>();
            StaffProfessionalDevelopmentActivity = new HashSet<StaffProfessionalDevelopmentActivity>();
        }

        public int RefCourseCreditUnitId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<Course> Course { get; set; }
        public virtual ICollection<ProfessionalDevelopmentActivity> ProfessionalDevelopmentActivity { get; set; }
        public virtual ICollection<StaffProfessionalDevelopmentActivity> StaffProfessionalDevelopmentActivity { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
