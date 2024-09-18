using System;
using System.Collections.Generic;
using System.Text;

namespace generate.core.Models.RDS
{
	public partial class DimStateDefinedCustomIndicator
	{
		public int DimStateDefinedCustomIndicatorId { get; set; }

		public string StateDefinedCustomIndicatorCode { get; set; }
		public string StateDefinedCustomIndicatorDescription { get; set; }

		public List<FactOrganizationStatusCount> FactOrganizationStatusCount { get; set; }
	}
}
