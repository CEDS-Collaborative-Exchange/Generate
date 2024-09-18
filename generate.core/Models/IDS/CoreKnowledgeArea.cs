using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class CoreKnowledgeArea
    {
        public int CoreKnowledgeAreaId { get; set; }
        public int ProfessionalDevelopmentActivityId { get; set; }
        public int RefCoreKnowledgeAreaId { get; set; }

        public virtual StaffProfessionalDevelopmentActivity ProfessionalDevelopmentActivity { get; set; }
        public virtual RefCoreKnowledgeArea RefCoreKnowledgeArea { get; set; }
    }
}
