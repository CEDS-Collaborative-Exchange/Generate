using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12staffAssignment
    {
        public K12staffAssignment()
        {
            TeacherStudentDataLinkExclusion = new HashSet<TeacherStudentDataLinkExclusion>();
        }

        public int OrganizationPersonRoleId { get; set; }
        public int? RefK12staffClassificationId { get; set; }
        public int? RefProfessionalEducationJobClassificationId { get; set; }
        public int? RefTeachingAssignmentRoleId { get; set; }
        public bool? PrimaryAssignment { get; set; }
        public bool? TeacherOfRecord { get; set; }
        public int? RefClassroomPositionTypeId { get; set; }
        public decimal? FullTimeEquivalency { get; set; }
        public decimal? ContributionPercentage { get; set; }
        public bool? ItinerantTeacher { get; set; }
        public bool? HighlyQualifiedTeacherIndicator { get; set; }
        public bool? SpecialEducationTeacher { get; set; }
        public int? RefSpecialEducationStaffCategoryId { get; set; }
        public bool? SpecialEducationRelatedServicesPersonnel { get; set; }
        public bool? SpecialEducationParaprofessional { get; set; }
        public int? RefSpecialEducationAgeGroupTaughtId { get; set; }
        public int? RefMepStaffCategoryId { get; set; }
        public int? RefTitleIprogramStaffCategoryId { get; set; }
        public int? RefUnexperiencedStatusId { get; set; }
        public int? RefEmergencyOrProvisionalCredentialStatusId { get; set; }
        public int? RefOutOfFieldStatusId { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public int K12staffAssignmentId { get; set; }

		public virtual ICollection<TeacherStudentDataLinkExclusion> TeacherStudentDataLinkExclusion { get; set; }
        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefClassroomPositionType RefClassroomPositionType { get; set; }
        public virtual RefK12staffClassification RefK12staffClassification { get; set; }
        public virtual RefMepStaffCategory RefMepStaffCategory { get; set; }
        public virtual RefProfessionalEducationJobClassification RefProfessionalEducationJobClassification { get; set; }
        public virtual RefSpecialEducationAgeGroupTaught RefSpecialEducationAgeGroupTaught { get; set; }
        public virtual RefSpecialEducationStaffCategory RefSpecialEducationStaffCategory { get; set; }
        public virtual RefTeachingAssignmentRole RefTeachingAssignmentRole { get; set; }
        public virtual RefTitleIprogramStaffCategory RefTitleIprogramStaffCategory { get; set; }
		public virtual RefUnexperiencedStatus RefUnexperiencedStatus { get; set; }
		public virtual RefEmergencyOrProvisionalCredentialStatus RefEmergencyOrProvisionalCredentialStatus { get; set; }
		public virtual RefOutOfFieldStatus RefOutOfFieldStatus { get; set; }

	}
}
