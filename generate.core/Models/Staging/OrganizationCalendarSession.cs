using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class OrganizationCalendarSession
    {
        public int Id { get; set; }
        public string OrganizationIdentifier { get; set; }
        public string OrganizationType { get; set; }
        public string CalendarYear { get; set; }
        public DateTime? BeginDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string SessionType { get; set; }
        public string AcademicTermDesignator { get; set; }
        public string DataCollectionName { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
