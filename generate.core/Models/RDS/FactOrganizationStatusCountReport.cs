using System;
using System.Collections.Generic;
using System.Text;

namespace generate.core.Models.RDS
{
	public partial class FactOrganizationStatusCountReport
	{
		public int FactOrganizationStatusCountReportId { get; set; }
		public string Categories { get; set; }
		public string CategorySetCode { get; set; }
		public string ReportCode { get; set; }
		public string ReportYear { get; set; }
		public string ReportLevel { get; set; }
        public string StateANSICode { get; set; }
        public string StateAbbreviationCode { get; set; }
        public string StateAbbreviationDescription { get; set; }
        //public int OrganizationId { get; set; }
        public string OrganizationName { get; set; }
        public string OrganizationIdentifierNces { get; set; }
        public string OrganizationIdentifierSea { get; set; }
        public string ParentOrganizationIdentifierSea { get; set; }
        public string ParentOrganizationName { get; set; }
		public string TableTypeAbbrv { get; set; }
        public string RACE { get; set; }
		public string DISABILITY { get; set; }
		public string LEPSTATUS { get; set; }
		public string ECODISSTATUS { get; set; }
		//public string SEX { get; set; }
		public string INDICATORSTATUS { get; set; }
		public string STATEDEFINEDSTATUSCODE { get; set; }
		public int OrganizationStatusCount { get; set; }
		public string STATEDEFINEDCUSTOMINDICATORCODE { get; set; }
		public string INDICATORSTATUSTYPECODE { get; set; }
	}
}
