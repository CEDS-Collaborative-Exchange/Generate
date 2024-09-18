using System;
using System.Collections.Generic;
using System.Text;

namespace generate.core.Models.RDS
{
	public partial class DimK12SchoolStateStatus
	{
		public int DimK12SchoolStateStatusId { get; set; }

		public int? SchoolStateStatusId { get; set; }
		public string SchoolStateStatusCode { get; set; }
        public string SchoolStateStatusDescription { get; set; }
        public string SchoolStateStatusEdFactsCode { get; set; }

		public List<FactOrganizationCount> FactOrganizationCounts { get; set; }
	}
}
