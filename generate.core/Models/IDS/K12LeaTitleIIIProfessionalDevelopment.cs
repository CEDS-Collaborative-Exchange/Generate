using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12leaTitleIiiprofessionalDevelopment
    {
        public int K12leatitleIiiprofessionalDevelopmentId { get; set; }
        public int OrganizationId { get; set; }
        public int RefTitleIiiprofessionalDevelopmentTypeId { get; set; }

        public virtual K12lea Organization { get; set; }
        public virtual RefTitleIiiprofessionalDevelopmentType RefTitleIiiprofessionalDevelopmentType { get; set; }
    }
}
