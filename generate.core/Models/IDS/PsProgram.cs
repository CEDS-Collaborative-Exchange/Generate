using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PsProgram
    {
        public PsProgram()
        {
            PsstudentProgram = new HashSet<PsstudentProgram>();
        }

        public int PsProgramId { get; set; }
        public int OrganizationId { get; set; }
        public int? RefCipVersionId { get; set; }
        public int? RefCipCodeId { get; set; }
        public decimal? ProgramLengthHours { get; set; }
        public int? RefProgramLengthHoursTypeId { get; set; }
        public string NormalLengthTimeForCompletion { get; set; }
        public int? RefTimeForCompletionUnitsId { get; set; }
        public int? RefPsexitOrWithdrawalTypeId { get; set; }
        public int? RefPsprogramLevelId { get; set; }
        public int? RefDqpcategoriesOfLearningId { get; set; }

        public virtual ICollection<PsstudentProgram> PsstudentProgram { get; set; }
        public virtual Organization Organization { get; set; }
        public virtual RefCipCode RefCipCode { get; set; }
        public virtual RefCipVersion RefCipVersion { get; set; }
        public virtual RefDqpcategoriesOfLearning RefDqpcategoriesOfLearning { get; set; }
        public virtual RefProgramLengthHoursType RefProgramLengthHoursType { get; set; }
        public virtual RefPsexitOrWithdrawalType RefPsexitOrWithdrawalType { get; set; }
        public virtual RefPsprogramLevel RefPsprogramLevel { get; set; }
        public virtual RefTimeForCompletionUnits RefTimeForCompletionUnits { get; set; }
    }
}
