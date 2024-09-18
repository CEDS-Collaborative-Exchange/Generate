using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefExitOrWithdrawalStatus
    {
        public RefExitOrWithdrawalStatus()
        {
            K12studentCourseSection = new HashSet<K12studentCourseSection>();
            K12studentEnrollment = new HashSet<K12studentEnrollment>();
        }

        public int RefExitOrWithdrawalStatusId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12studentCourseSection> K12studentCourseSection { get; set; }
        public virtual ICollection<K12studentEnrollment> K12studentEnrollment { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
