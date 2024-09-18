using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonMilitary
    {
        public int PersonId { get; set; }
        public int? RefMilitaryActiveStudentIndicatorId { get; set; }
        public int? RefMilitaryConnectedStudentIndicatorId { get; set; }
        public int? RefMilitaryVeteranStudentIndicatorId { get; set; }
        public int? RefMilitaryBranchId { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefMilitaryActiveStudentIndicator RefMilitaryActiveStudentIndicator { get; set; }
        public virtual RefMilitaryBranch RefMilitaryBranch { get; set; }
        public virtual RefMilitaryConnectedStudentIndicator RefMilitaryConnectedStudentIndicator { get; set; }
        public virtual RefMilitaryVeteranStudentIndicator RefMilitaryVeteranStudentIndicator { get; set; }
    }
}
