using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class Elenrollment
    {
        public int OrganizationPersonRoleId { get; set; }
        public DateTime? ApplicationDate { get; set; }
        public DateTime? EnrollmentDate { get; set; }
        public int? RefIdeaenvironmentElid { get; set; }
        public decimal? NumberOfDaysInAttendance { get; set; }
        public int? RefFoodServiceParticipationId { get; set; }
        public int? RefServiceOptionId { get; set; }
        public int? ElclassSectionId { get; set; }
        public int? RefElfederalFundingTypeId { get; set; }

        public virtual ElclassSection ElclassSection { get; set; }
        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefElfederalFundingType RefElfederalFundingType { get; set; }
        public virtual RefFoodServiceParticipation RefFoodServiceParticipation { get; set; }
        public virtual RefIdeaenvironmentEl RefIdeaenvironmentEl { get; set; }
        public virtual RefServiceOption RefServiceOption { get; set; }
    }
}
