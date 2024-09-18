using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12schoolStatus
    {
		public int K12schoolId { get; set; }
        public int? RefMagnetSpecialProgramId { get; set; }
        public int? RefAlternativeSchoolFocusId { get; set; }
        public int? RefInternetAccessId { get; set; }
        public int? RefRestructuringActionId { get; set; }
        public int? RefTitleIschoolStatusId { get; set; }
        public int? RefNSLPStatusId { get; set; }
        public int? RefSchoolImprovementStatusId { get; set; }
        public int? RefSchoolDangerousStatusId { get; set; }
        public int? RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId { get; set; }
        public int? RefComprehensiveAndTargetedSupportId { get; set; }
        public int? RefComprehensiveSupportId { get; set; }
        public int? RefTargetedSupportId { get; set; }
        public bool? ConsolidatedMepFundsStatus { get; set; }
        public int K12schoolStatusId { get; set; }         

        public int? RefVirtualSchoolStatusId { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public string ProgressAcheivingEnglishLearnerProficiencyStateDefinedStatus { get; set; }

		public virtual K12school K12school { get; set; }
        public virtual RefAlternativeSchoolFocus RefAlternativeSchoolFocus { get; set; }
        public virtual RefInternetAccess RefInternetAccess { get; set; }
        public virtual RefMagnetSpecialProgram RefMagnetSpecialProgram { get; set; }
        public virtual RefRestructuringAction RefRestructuringAction { get; set; }
        public virtual RefTitleIschoolStatus RefTitleIschoolStatus { get; set; }
        public virtual RefNSLPStatus RefNSLPStatus { get; set; }
        public virtual RefSchoolImprovementStatus RefSchoolImprovementStatus { get; set; }
        public virtual RefSchoolDangerousStatus RefSchoolDangerousStatus { get; set; }
        public virtual RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus { get; set; }
        public virtual RefVirtualSchoolStatus RefVirtualSchoolStatus { get; set; }

        public virtual RefComprehensiveAndTargetedSupport RefComprehensiveAndTargetedSupport { get; set; }
		public virtual RefComprehensiveSupport RefComprehensiveSupport { get; set; }
		public virtual RefTargetedSupport RefTargetedSupport { get; set; }

    }
}
