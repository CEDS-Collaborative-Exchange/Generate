using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefSchoolFoodServiceProgram
    {
        public RefSchoolFoodServiceProgram()
        {
            ProgramParticipationFoodService = new HashSet<ProgramParticipationFoodService>();
        }

        public int RefSchoolFoodServiceProgramId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdiction { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ProgramParticipationFoodService> ProgramParticipationFoodService { get; set; }
        public virtual Organization RefJurisdictionNavigation { get; set; }
    }
}
