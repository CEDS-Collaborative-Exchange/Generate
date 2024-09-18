using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Dtos.RDS
{
    public class MembershipReportDto
    {
        public int FileRecordNumber { get; set; }
        public string StateANSICode { get; set; }
        public string StateAbbreviationCode { get; set; }
        public string ParentOrganizationIdentifierSea { get; set; }
        public string OrganizationIdentifierSea { get; set; }
        public string OrganizationName { get; set; }
        public string GRADELEVEL { get; set; }
        public string RACE { get; set; }
        public string SEX { get; set; }
        public string TotalIndicator { get; set; }
        public int StudentCount { get; set; }

    }
}


