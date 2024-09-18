using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12school
    {
        public K12school()
        {
            K12schoolCorrectiveAction = new HashSet<K12schoolCorrectiveAction>();
            K12schoolGradeOffered = new HashSet<K12schoolGradeOffered>();
            K12schoolImprovement = new HashSet<K12schoolImprovement>();
            K12schoolStatus = new HashSet<K12schoolStatus>();
			K12schoolIndicatorStatus = new HashSet<K12schoolIndicatorStatus>();
		}

        public int OrganizationId { get; set; }
        public int? RefSchoolTypeId { get; set; }
        public int? RefSchoolLevelId { get; set; }
        public int? RefAdministrativeFundingControlId { get; set; }
        public bool? CharterSchoolIndicator { get; set; }
        public int? RefCharterSchoolTypeId { get; set; }
        public int? RefIncreasedLearningTimeTypeId { get; set; }
        public int? RefStatePovertyDesignationId { get; set; }
        public string CharterSchoolApprovalYear { get; set; }
        public string AccreditationAgencyName { get; set; }
        public bool? CharterSchoolOpenEnrollmentIndicator { get; set; }
        public DateTime? CharterSchoolContractApprovalDate { get; set; }
        public string CharterSchoolContractIdNumber { get; set; }
        public DateTime? CharterSchoolContractRenewalDate { get; set; }
        public int? K12CharterSchoolManagementOrganizationId { get; set; }
        public int K12schoolId { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }

        public virtual ICollection<K12schoolCorrectiveAction> K12schoolCorrectiveAction { get; set; }
        public virtual ICollection<K12schoolGradeOffered> K12schoolGradeOffered { get; set; }
        public virtual ICollection<K12schoolImprovement> K12schoolImprovement { get; set; }
        public virtual ICollection<K12schoolStatus> K12schoolStatus { get; set; }
		public virtual ICollection<K12schoolIndicatorStatus> K12schoolIndicatorStatus { get; set; }
		public virtual Organization Organization { get; set; }
        public virtual RefAdministrativeFundingControl RefAdministrativeFundingControl { get; set; }
        public virtual RefCharterSchoolType RefCharterSchoolType { get; set; }
        public virtual RefIncreasedLearningTimeType RefIncreasedLearningTimeType { get; set; }
        public virtual RefSchoolLevel RefSchoolLevel { get; set; }
        public virtual RefSchoolType RefSchoolType { get; set; }
        public virtual RefStatePovertyDesignation RefStatePovertyDesignation { get; set; }
        //public virtual K12CharterSchoolAuthorizer K12CharterSchoolAuthorizer { get; set; }
        public virtual K12CharterSchoolManagementOrganization K12CharterSchoolManagementOrganization { get; set; }

    }

    
}
