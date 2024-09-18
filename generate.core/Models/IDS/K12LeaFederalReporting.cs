using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12leaFederalReporting
    {
        public int OrganizationId { get; set; }
        public int? RefBarrierToEducatingHomelessId { get; set; }
        public bool? DesegregationOrderOrPlan { get; set; }
        public bool? HarassmentOrBullyingPolicy { get; set; }
        public int? RefIntegratedTechnologyStatusId { get; set; }
        public decimal? StateAssessmentAdminFunding { get; set; }
        public decimal? StateAssessStandardsFunding { get; set; }
        public bool? TerminatedTitleIiiprogramFailure { get; set; }
        public int? InterscholasticSportsMaleOnly { get; set; }
        public int? InterscholasticSportsFemaleOnly { get; set; }
        public int? InterscholasticTeamsMaleOnly { get; set; }
        public int? InterscholasticTeamsFemaleOnly { get; set; }
        public int? InterscholasticSportParticipantsMale { get; set; }
        public int? InterscholasticSportParticipantsFemale { get; set; }

        public virtual K12lea Organization { get; set; }
        public virtual RefBarrierToEducatingHomeless RefBarrierToEducatingHomeless { get; set; }
        public virtual RefIntegratedTechnologyStatus RefIntegratedTechnologyStatus { get; set; }
    }
}
