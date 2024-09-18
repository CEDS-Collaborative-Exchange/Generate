using System.Collections.Generic;

namespace generate.core.Models.IDS
{
	public partial class RefUnexperiencedStatus
	{
		public RefUnexperiencedStatus()
		{
			K12staffAssignment = new HashSet<K12staffAssignment>();
		}

		public int RefUnexperiencedStatusId { get; set; }
		public string Description { get; set; }
		public string Code { get; set; }
		public string Definition { get; set; }
		public int? RefJurisdictionId { get; set; }
		public decimal? SortOrder { get; set; }

		public virtual ICollection<K12staffAssignment> K12staffAssignment { get; set; }
		public virtual Organization RefJurisdiction { get; set; }
	}
}

