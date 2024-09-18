using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationCalendarSession
    {
        public OrganizationCalendarSession()
        {
            CourseSection = new HashSet<CourseSection>();
            K12studentSession = new HashSet<K12studentSession>();
            LearnerActivity = new HashSet<LearnerActivity>();
            OrganizationFinancial = new HashSet<OrganizationFinancial>();
            K12LeaFederalFunds = new HashSet<K12LeaFederalFunds>();
            K12FederalFundAllocation = new HashSet<K12FederalFundAllocation>();
            K12seaFederalFunds = new HashSet<K12seaFederalFunds>();

        }

        public int OrganizationCalendarSessionId { get; set; }
        public string Designator { get; set; }
        public DateTime? BeginDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? RefSessionTypeId { get; set; }
        public decimal? InstructionalMinutes { get; set; }
        public string Code { get; set; }
        public string Description { get; set; }
        public bool? MarkingTermIndicator { get; set; }
        public bool? SchedulingTermIndicator { get; set; }
        public bool? AttendanceTermIndicator { get; set; }
        public int? OrganizationCalendarId { get; set; }
        public int? DaysInSession { get; set; }
        public DateTime? FirstInstructionDate { get; set; }
        public DateTime? LastInstructionDate { get; set; }
        public int? MinutesPerDay { get; set; }
        public TimeSpan? SessionStartTime { get; set; }
        public TimeSpan? SessionEndTime { get; set; }

        public virtual ICollection<CourseSection> CourseSection { get; set; }
        public virtual ICollection<K12studentSession> K12studentSession { get; set; }
        public virtual ICollection<LearnerActivity> LearnerActivity { get; set; }
        public virtual ICollection<OrganizationFinancial> OrganizationFinancial { get; set; }
        public virtual OrganizationCalendar OrganizationCalendar { get; set; }
        public virtual RefSessionType RefSessionType { get; set; }
        public virtual ICollection<K12LeaFederalFunds> K12LeaFederalFunds { get; set; }
        public virtual ICollection<K12FederalFundAllocation> K12FederalFundAllocation { get; set; }
        public virtual ICollection<K12seaFederalFunds> K12seaFederalFunds { get; set; }
    }
}
