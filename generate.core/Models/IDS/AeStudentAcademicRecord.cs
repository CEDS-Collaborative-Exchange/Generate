using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AeStudentAcademicRecord
    {
        public int OrganizationPersonRoleId { get; set; }
        public int? RefHighSchoolDiplomaTypeId { get; set; }
        public string DiplomaOrCredentialAwardDate { get; set; }
        public int? RefProfessionalTechnicalCredentialTypeId { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefHighSchoolDiplomaType RefHighSchoolDiplomaType { get; set; }
        public virtual RefProfessionalTechnicalCredentialType RefProfessionalTechnicalCredentialType { get; set; }
    }
}
