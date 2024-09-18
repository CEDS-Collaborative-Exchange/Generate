using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class QuarterlyEmploymentRecord
    {
        public int QuarterlyEmploymentRecordId { get; set; }
        public int PersonId { get; set; }
        public decimal? Earnings { get; set; }
        public string EmploymentNaicscode { get; set; }
        public DateTime? ReferencePeriodStartDate { get; set; }
        public DateTime? ReferencePeriodEndDate { get; set; }
        public int? RefEradministrativeDataSourceId { get; set; }
        public int? RefEmploymentLocationId { get; set; }
        public int? RefEmployedPriorToEnrollmentId { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefEmployedPriorToEnrollment RefEmployedPriorToEnrollment { get; set; }
        public virtual RefEmploymentLocation RefEmploymentLocation { get; set; }
        public virtual RefEradministrativeDataSource RefEradministrativeDataSource { get; set; }
    }
}
