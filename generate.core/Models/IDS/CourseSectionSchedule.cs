using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class CourseSectionSchedule
    {
        public int CourseSectionScheduleId { get; set; }
        public int OrganizationId { get; set; }
        public string ClassMeetingDays { get; set; }
        public TimeSpan? ClassBeginningTime { get; set; }
        public TimeSpan? ClassEndingTime { get; set; }
        public string ClassPeriod { get; set; }
        public string TimeDayIdentifier { get; set; }

        public virtual CourseSection Organization { get; set; }
    }
}
