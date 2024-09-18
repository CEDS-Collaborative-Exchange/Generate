using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationCalendarDay
    {
        public int OrganizationCalendarDayId { get; set; }
        public int OrganizationCalendarId { get; set; }
        public string DayName { get; set; }
        public string AlternateDayName { get; set; }

        public virtual OrganizationCalendar OrganizationCalendar { get; set; }
    }
}
