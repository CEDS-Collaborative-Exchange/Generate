﻿using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PsStudentEmployment
    {
        public int OrganizationPersonRoleId { get; set; }
        public int? RefEmployedWhileEnrolledId { get; set; }
        public int? RefEmployedAfterExitId { get; set; }
        public string EmploymentNaicsCode { get; set; }
        public int? RefEmploymentStatusWhileEnrolledId { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefEmployedAfterExit RefEmployedAfterExit { get; set; }
        public virtual RefEmployedWhileEnrolled RefEmployedWhileEnrolled { get; set; }
        public virtual RefEmploymentStatusWhileEnrolled RefEmploymentStatusWhileEnrolled { get; set; }
    }
}
