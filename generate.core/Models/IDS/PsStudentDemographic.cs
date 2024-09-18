using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PsStudentDemographic
    {
        public int OrganizationPersonRoleId { get; set; }
        public int? RefDependencyStatusId { get; set; }
        public int? RefTuitionResidencyTypeId { get; set; }
        public int? RefCampusResidencyTypeId { get; set; }
        public int? RefPsLepTypeId { get; set; }
        public int? RefPaternalEducationLevelId { get; set; }
        public int? RefMaternalEducationLevelId { get; set; }
        public int? RefCohortExclusionId { get; set; }
        public int? NumberOfDependents { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefCampusResidencyType RefCampusResidencyType { get; set; }
        public virtual RefCohortExclusion RefCohortExclusion { get; set; }
        public virtual RefDependencyStatus RefDependencyStatus { get; set; }
        public virtual RefEducationLevel RefMaternalEducationLevel { get; set; }
        public virtual RefEducationLevel RefPaternalEducationLevel { get; set; }
        public virtual RefPsLepType RefPsLepType { get; set; }
        public virtual RefTuitionResidencyType RefTuitionResidencyType { get; set; }
    }
}
