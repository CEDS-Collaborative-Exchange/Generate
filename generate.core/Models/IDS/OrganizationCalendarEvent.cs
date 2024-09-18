using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationCalendarEvent
    {
        public int OrganizationCalendarEventId { get; set; }
        public int OrganizationCalendarId { get; set; }
        public string Name { get; set; }
        public DateTime EventDate { get; set; }
        public int? RefCalendarEventType { get; set; }

        public virtual OrganizationCalendar OrganizationCalendar { get; set; }
        public virtual RefCalendarEventType RefCalendarEventTypeNavigation { get; set; }
    }
}
