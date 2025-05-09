﻿using System;
using System.Collections.Generic;
using System.Text;

namespace generate.core.Models.IDS
{
    public partial class RefAcademicCareerAndTechnicalOutcomesInProgram
    {
        public RefAcademicCareerAndTechnicalOutcomesInProgram()
        {
            ProgramParticipationNeglected = new HashSet<ProgramParticipationNeglected>();
        }

        public int RefAcademicCareerAndTechnicalOutcomesInProgramId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ProgramParticipationNeglected> ProgramParticipationNeglected { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
