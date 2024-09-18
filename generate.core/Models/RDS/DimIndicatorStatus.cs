using System;
using System.Collections.Generic;
using System.Text;

namespace generate.core.Models.RDS
{
	public partial class DimIndicatorStatus
	{
		public int DimIndicatorStatusId { get; set; }

		public int? IndicatorStatusId { get; set; }
		public string IndicatorStatusCode { get; set; }
		public string IndicatorStatusDescription { get; set; }
		public string IndicatorStatusEdFactsCode { get; set; }

		public List<FactOrganizationStatusCount> FactOrganizationStatusCount { get; set; }
	}
}
