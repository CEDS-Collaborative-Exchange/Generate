using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationFederalAccountability
    {
        public int OrganizationFederalAccountabilityId { get; set; }
        public int OrganizationId { get; set; }
        public int? RefAypStatusId { get; set; }
        public bool? AlternateAypApproachIndicator { get; set; }
        public bool? AypAppealChangedDesignation { get; set; }
        public DateTime? AypAppealProcessDate { get; set; }
        public bool? AypAppealProcessDesignation { get; set; }
        public int? AmaoAypProgressAttainmentLepStudents { get; set; }
        public int? AmaoProficiencyAttainmentLepStudents { get; set; }
        public int? AmaoProgressAttainmentLepStudents { get; set; }
        public int? RefGunFreeSchoolsActReportingStatusId { get; set; }
        public int? RefHighSchoolGraduationRateIndicatorId { get; set; }
        public int? RefParticipationStatusMathId { get; set; }
        public int? RefParticipationStatusRlaId { get; set; }
        public int? RefProficiencyTargetStatusMathId { get; set; }
        public int? RefProficiencyTargetStatusRlaid { get; set; }
        public bool? PersistentlyDangerousStatus { get; set; }
        public int? RefReconstitutedStatusId { get; set; }
        public int? RefElementaryMiddleAdditionalId { get; set; }
        public string AccountabilityReportTitle { get; set; }
        public int? RefCteGraduationRateInclusionId { get; set; }

        public virtual RefAmaoAttainmentStatus AmaoAypProgressAttainmentLepStudentsNavigation { get; set; }
        public virtual RefAmaoAttainmentStatus AmaoProficiencyAttainmentLepStudentsNavigation { get; set; }
        public virtual RefAmaoAttainmentStatus AmaoProgressAttainmentLepStudentsNavigation { get; set; }
        public virtual Organization Organization { get; set; }
        public virtual RefAypStatus RefAypStatus { get; set; }
        public virtual RefCteGraduationRateInclusion RefCteGraduationRateInclusion { get; set; }
        public virtual RefElementaryMiddleAdditional RefElementaryMiddleAdditional { get; set; }
        public virtual RefGunFreeSchoolsActReportingStatus RefGunFreeSchoolsActStatusReporting { get; set; }
        public virtual RefHighSchoolGraduationRateIndicator RefHighSchoolGraduationRateIndicatorNavigation { get; set; }
        public virtual RefParticipationStatusAyp RefParticipationStatusMath { get; set; }
        public virtual RefParticipationStatusAyp RefParticipationStatusRla { get; set; }
        public virtual RefProficiencyTargetAyp RefProficiencyTargetStatusMath { get; set; }
        public virtual RefProficiencyTargetAyp RefProficiencyTargetStatusRla { get; set; }
        public virtual RefReconstitutedStatus RefReconstitutedStatus { get; set; }
    }
}
