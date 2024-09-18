using System;
using System.Collections.Generic;
using System.Text;

namespace generate.core.Models.IDS
{
	public partial class K12schoolIndicatorStatus
	{
		public int K12SchoolIndicatorStatusId { get; set; }
		public int K12schoolId { get; set; }
		public int RefIndicatorStatusTypeId { get; set; }
		public int? RefIndicatorStateDefinedStatusId { get; set; }
		public int? RefIndicatorStatusSubgroupTypeId { get; set; }
		public string IndicatorStatusSubgroup { get; set; }
		public string IndicatorStatus { get; set; }
		public DateTime? RecordStartDateTime { get; set; }
		public DateTime? RecordEndDateTime { get; set; }
		public int? RefIndicatorStatusCustomTypeId { get; set; }

		public virtual K12school K12school { get; set; }
		public virtual RefIndicatorStatusType RefIndicatorStatusType { get; set; }
		public virtual RefIndicatorStatusSubgroupType RefIndicatorStatusSubgroupType { get; set; }
		public virtual RefIndicatorStateDefinedStatus RefIndicatorStateDefinedStatus { get; set; }
		public virtual RefIndicatorStatusCustomType RefIndicatorStatusCustomType { get; set; }
	}
}
