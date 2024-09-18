using System;
using System.Collections.Generic;
using System.Text;

namespace generate.core.Models.RDS
{
	public partial class DimIndicatorStatusType
	{
		public int DimIndicatorStatusTypeId { get; set; }

		public int? IndicatorStatusTypeId { get; set; }
		public string IndicatorStatusTypeCode { get; set; }
		public string IndicatorStatusTypeDescription { get; set; }
        public string IndicatorStatusTypeEdFactsCode { get; set; }


        public List<FactOrganizationStatusCount> FactOrganizationStatusCount { get; set; }
	}
}
