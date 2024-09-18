using System;
using System.Collections.Generic;
using System.Text;

namespace generate.core.Models.RDS
{
    public class FactK12StudentAttendanceReport
    {
        public int FactK12StudentAttendanceReportId { get; set; }

        public string ReportCode { get; set; }
        public string ReportYear { get; set; }
        public string ReportLevel { get; set; }
        public string CategorySetCode { get; set; }
        public string Categories { get; set; }
        public string TableTypeAbbrv { get; set; }
        public string TotalIndicator { get; set; }

        public string StateANSICode { get; set; }
        public string StateCode { get; set; }
        public string StateName { get; set; }
        //public int? OrganizationId { get; set; }
        public string OrganizationNcesId { get; set; }
        public string OrganizationStateId { get; set; }
        public string OrganizationName { get; set; }
        public string ParentOrganizationStateId { get; set; }


        public string ECODISSTATUS { get; set; }
        public string HOMELESSSTATUS { get; set; }
        public string LEPSTATUS { get; set; }
        public string MIGRANTSTATUS { get; set; }
        public string SEX { get; set; }
        public string MILITARYCONNECTEDSTATUS { get; set; }
        public string HOMELESSUNACCOMPANIEDYOUTHSTATUS { get; set; }
        public string HOMELESSNIGHTTIMERESIDENCE { get; set; }


        public string ATTENDANCE { get; set; }
        public string RACE { get; set; }

        public decimal StudentAttendanceRate { get; set; }


    }
}
