using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12schoolImprovement
    {
        public int K12schoolImprovementId { get; set; }
        public int K12schoolId { get; set; }
        public int? RefSchoolImprovementStatusId { get; set; }
        public int? RefSchoolImprovementFundsId { get; set; }
        public int? RefSigInterventionTypeId { get; set; }
        public DateTime? SchoolImprovementExitDate { get; set; }

        public virtual K12school K12school { get; set; }
        public virtual RefSchoolImprovementFunds RefSchoolImprovementFunds { get; set; }
        public virtual RefSchoolImprovementStatus RefSchoolImprovementStatus { get; set; }
        public virtual RefSigInterventionType RefSigInterventionType { get; set; }
    }
}
