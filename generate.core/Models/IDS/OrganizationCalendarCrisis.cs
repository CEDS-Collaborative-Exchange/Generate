using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationCalendarCrisis
    {
        public int OrganizationCalendarCrisisId { get; set; }
        public int OrganizationId { get; set; }
        public string Code { get; set; }
        public string Name { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string Type { get; set; }
        public string CrisisDescription { get; set; }
        public DateTime? CrisisEndDate { get; set; }

        public virtual Organization Organization { get; set; }
    }
}
