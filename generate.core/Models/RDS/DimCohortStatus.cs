using System;
using System.Collections.Generic;
using System.Text;

namespace generate.core.Models.RDS
{
	public partial class DimCohortStatus
	{
		public int DimCohortStatusId { get; set; }

		public int CohortStatusId { get; set; }
		public string CohortStatusCode { get; set; }
		public string CohortStatusDescription { get; set; }
		public string CohortStatusEdFactsCode { get; set; }

		public List<FactK12StudentCount> FactStudentCounts { get; set; }
	}
}
