using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class CteStudentAcademicRecord
    {
        public int OrganizationPersonRoleId { get; set; }
        public decimal? CreditsAttemptedCumulative { get; set; }
        public decimal? CreditsEarnedCumulative { get; set; }
        public int? RefProfessionalTechnicalCredentialTypeId { get; set; }
        public string DiplomaOrCredentialAwardDate { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefProfessionalTechnicalCredentialType RefProfessionalTechnicalCredentialType { get; set; }
    }
}
