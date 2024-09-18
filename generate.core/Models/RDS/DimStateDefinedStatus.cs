using System;
using System.Collections.Generic;
using System.Text;

namespace generate.core.Models.RDS
{
	public partial class DimStateDefinedStatus
	{
		public int DimStateDefinedStatusId { get; set; }

		public string StateDefinedStatusCode { get; set; }
		public string StateDefinedStatusDescription { get; set; }

		public List<FactOrganizationStatusCount> FactOrganizationStatusCount { get; set; }
	}
}
