using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimDiscipline
    {
        public int DimDisciplineId { get; set; }


        public int? DisciplinaryActionTakenId { get; set; }
        public string DisciplinaryActionTakenCode { get; set; }
        public string DisciplinaryActionTakenDescription { get; set; }
        public string DisciplinaryActionTakenEdFactsCode { get; set; }


        public int? DisciplineMethodOfChildrenWithDisabilitiesId { get; set; }
        public string DisciplineMethodOfChildrenWithDisabilitiesCode { get; set; }
        public string DisciplineMethodOfChildrenWithDisabilitiesDescription { get; set; }
        public string DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode { get; set; }

        
        public int? IdeaInterimRemovalReasonId { get; set; }
        public string IdeaInterimRemovalReasonCode { get; set; }
        public string IdeaInterimRemovalReasonDescription { get; set; }
        public string IdeaInterimRemovalReasonEdFactsCode { get; set; }


        public int? IdeaInterimRemovalId { get; set; }
        public string IdeaInterimRemovalCode { get; set; }
        public string IdeaInterimRemovalDescription { get; set; }
        public string IdeaInterimRemovalEdFactsCode { get; set; }


        public int? EducationalServicesAfterRemovalId { get; set; }
        public string EducationalServicesAfterRemovalCode { get; set; }
        public string EducationalServicesAfterRemovalDescription { get; set; }
        public string EducationalServicesAfterRemovalEdFactsCode { get; set; }

        public int? DisciplineELStatusId { get; set; }
        public string DisciplineELStatusCode { get; set; }
        public string DisciplineELStatusDescription { get; set; }
        public string DisciplineELStatusEdFactsCode { get; set; }


        public List<FactK12StudentDiscipline> FactStudentDisciplines { get; set; }

    }
}
