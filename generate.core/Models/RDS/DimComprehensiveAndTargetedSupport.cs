using System;
using System.Collections.Generic;
using System.Text;

namespace generate.core.Models.RDS
{
	public partial class DimComprehensiveAndTargetedSupport
    {
		public int DimComprehensiveAndTargetedSupportId { get; set; }

        public int ComprehensiveAndTargetedSupportId { get; set; }
        public string ComprehensiveAndTargetedSupportCode { get; set; }
		public string ComprehensiveAndTargetedSupportDescription { get; set; }
		public string ComprehensiveAndTargetedSupportEdFactsCode { get; set; }

        public int ComprehensiveSupportId { get; set; }
        public string ComprehensiveSupportCode { get; set; }
        public string ComprehensiveSupportDescription { get; set; }
        public string ComprehensiveSupportEdFactsCode { get; set; }

        public int TargetedSupportId { get; set; }
        public string TargetedSupportCode { get; set; }
        public string TargetedSupportDescription { get; set; }
        public string TargetedSupportEdFactsCode { get; set; }

        public int AdditionalTargetedSupportandImprovementId { get; set; }
        public string AdditionalTargetedSupportandImprovementCode { get; set; }
        public string AdditionalTargetedSupportandImprovementDescription { get; set; }
        public string AdditionalTargetedSupportandImprovementEdFactsCode { get; set; }

        public int ComprehensiveSupportImprovementId { get; set; }
        public string ComprehensiveSupportImprovementCode { get; set; }
        public string ComprehensiveSupportImprovementDescription { get; set; }
        public string ComprehensiveSupportImprovementEdFactsCode { get; set; }

        public int TargetedSupportImprovementId { get; set; }
        public string TargetedSupportImprovementCode { get; set; }
        public string TargetedSupportImprovementDescription { get; set; }
        public string TargetedSupportImprovementEdFactsCode { get; set; }

        public List<FactK12StudentDiscipline> FactStudentDisciplines { get; set; }
	}
}
