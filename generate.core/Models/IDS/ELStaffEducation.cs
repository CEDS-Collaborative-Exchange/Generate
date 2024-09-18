using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElstaffEducation
    {
        public int OrganizationPersonRoleId { get; set; }
        public bool? EcdegreeOrCertificateHolder { get; set; }
        public decimal? TotalCollegeCreditsEarned { get; set; }
        public int? RefEllevelOfSpecializationId { get; set; }
        public decimal? TotalApprovedEccreditsEarned { get; set; }
        public decimal? SchoolAgeEducationPscredits { get; set; }
        public int? RefElprofessionalDevelopmentTopicAreaId { get; set; }

        public virtual Elstaff OrganizationPersonRole { get; set; }
        public virtual RefEllevelOfSpecialization RefEllevelOfSpecialization { get; set; }
        public virtual RefElprofessionalDevelopmentTopicArea RefElprofessionalDevelopmentTopicArea { get; set; }
    }
}
