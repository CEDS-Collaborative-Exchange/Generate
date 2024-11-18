using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Models.RDS
{
    public partial class ReportEDFactsPersistentlyDangerous
    {
        public int ReportEDFactsPersistentlyDangerousId { get; set; }

        public string ReportCode { get; set; }
        public string ReportYear { get; set; }
        public string ReportLevel { get; set; }
        public string CategorySetCode { get; set; }
        //public string TableTypeAbbrv { get; set; }
        //public string TotalIndicator { get; set; }


        public string StateANSICode { get; set; }
        public string StateCode { get; set; }
        public string StateName { get; set; }
        public string OrganizationNcesId { get; set; }
        public string OrganizationStateId { get; set; }
        public string OrganizationName { get; set; }
        public string ParentOrganizationStateId { get; set; }
        public string ParentOrganizationNcesId { get; set; }
        public string OperationalStatus { get; set; }
        public string OperationalStatusId { get; set; }
        public string LeaStateIdentifier { get; set; }
        public string LeaNcesIdentifier { get; set; }

        public string PERSISTENTLYDANGEROUSSTATUS { get; set; }
        public int OrganizationCount { get; set; }
    }
}
