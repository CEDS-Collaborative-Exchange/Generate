using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PsStudentAdmissionTest
    {
        public int PsStudentAdmissionTestId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public int RefStandardizedAdmissionTestId { get; set; }
        public decimal? StandardizedAdmissionTestScore { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefStandardizedAdmissionTest RefStandardizedAdmissionTest { get; set; }
    }
}
