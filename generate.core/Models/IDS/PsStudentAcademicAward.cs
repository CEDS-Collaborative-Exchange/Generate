using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PsStudentAcademicAward
    {
        public int PsStudentAcademicAwardId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public string AcademicAwardDate { get; set; }
        public int? RefAcademicAwardLevelId { get; set; }
        public string AcademicAwardTitle { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefAcademicAwardLevel RefAcademicAwardLevel { get; set; }
    }
}
