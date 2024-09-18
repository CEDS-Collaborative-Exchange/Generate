using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PsStudentAcademicRecord
    {
        public int PsStudentAcademicRecordId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public string AcademicYearDesignator { get; set; }
        public int? RefAcademicTermDesignatorId { get; set; }
        public decimal? GradePointAverage { get; set; }
        public decimal? GradePointAverageCumulative { get; set; }
        public decimal? DualCreditDualEnrollmentCredits { get; set; }
        public int? AdvancedPlacementCreditsAwarded { get; set; }
        public int? RefProfessionalTechCredentialTypeId { get; set; }
        public string DiplomaOrCredentialAwardDate { get; set; }
        public string EnteringTerm { get; set; }
        public int? CourseTotal { get; set; }
        public int? RefCreditHoursAppliedOtherProgramId { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefAcademicTermDesignator RefAcademicTermDesignator { get; set; }
        public virtual RefCreditHoursAppliedOtherProgram RefCreditHoursAppliedOtherProgram { get; set; }
        public virtual RefProfessionalTechnicalCredentialType RefProfessionalTechCredentialType { get; set; }
    }
}
