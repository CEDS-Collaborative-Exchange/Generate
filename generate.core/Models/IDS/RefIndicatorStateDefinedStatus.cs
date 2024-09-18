using System;
using System.Collections.Generic;
using System.Text;

namespace generate.core.Models.IDS
{
	public partial class RefIndicatorStateDefinedStatus
	{
		public RefIndicatorStateDefinedStatus()
		{
			K12schoolIndicatorStatus = new HashSet<K12schoolIndicatorStatus>();
		}

		public int RefIndicatorStateDefinedStatusId { get; set; }
		public string Description { get; set; }
		public string Code { get; set; }
		public string Definition { get; set; }
		public int? RefJurisdictionId { get; set; }
		public decimal? SortOrder { get; set; }

		public virtual ICollection<K12schoolIndicatorStatus> K12schoolIndicatorStatus { get; set; }
		public virtual Organization RefJurisdiction { get; set; }
	}
}
