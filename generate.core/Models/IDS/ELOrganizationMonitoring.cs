using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElorganizationMonitoring
    {
        public int ElorganizationMonitoringId { get; set; }
        public int OrganizationId { get; set; }
        public DateTime? VisitStartDate { get; set; }
        public DateTime? VisitEndDate { get; set; }
        public int? RefPurposeOfMonitoringVisitId { get; set; }
        public string TypeOfMonitoring { get; set; }
        public int? RefOrganizationMonitoringNotificationsId { get; set; }

        public virtual Organization Organization { get; set; }
        public virtual RefOrganizationMonitoringNotifications RefOrganizationMonitoringNotifications { get; set; }
        public virtual RefPurposeOfMonitoringVisit RefPurposeOfMonitoringVisit { get; set; }
    }
}
