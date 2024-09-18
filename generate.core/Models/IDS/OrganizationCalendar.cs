using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationCalendar
    {
        public OrganizationCalendar()
        {
            OrganizationCalendarDay = new HashSet<OrganizationCalendarDay>();
            OrganizationCalendarEvent = new HashSet<OrganizationCalendarEvent>();
            OrganizationCalendarSession = new HashSet<OrganizationCalendarSession>();
        }

        public int OrganizationCalendarId { get; set; }
        public int OrganizationId { get; set; }
        public string CalendarCode { get; set; }
        public string CalendarDescription { get; set; }
        public string CalendarYear { get; set; }

        public virtual ICollection<OrganizationCalendarDay> OrganizationCalendarDay { get; set; }
        public virtual ICollection<OrganizationCalendarEvent> OrganizationCalendarEvent { get; set; }
        public virtual ICollection<OrganizationCalendarSession> OrganizationCalendarSession { get; set; }
        public virtual Organization Organization { get; set; }
    }
}
