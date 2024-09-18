using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class StaffCredential
    {
        public int? RefTeachingCredentialTypeId { get; set; }
        public int? RefTeachingCredentialBasisId { get; set; }
        public int? RefChildDevAssociateTypeId { get; set; }
        public int? RefParaprofessionalQualificationId { get; set; }
        public bool? TechnologySkillsStandardsMet { get; set; }
        public string DiplomaOrCredentialAwardDate { get; set; }
        public int? RefProgramSponsorTypeId { get; set; }
        public bool? CteinstructorIndustryCertification { get; set; }
        public int PersonCredentialId { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public int StaffCredentialId { get; set; }

        public virtual PersonCredential PersonCredential { get; set; }
        public virtual RefParaprofessionalQualification RefParaprofessionalQualification { get; set; }
        public virtual RefProgramSponsorType RefProgramSponsorType { get; set; }
        public virtual RefTeachingCredentialBasis RefTeachingCredentialBasis { get; set; }
        public virtual RefTeachingCredentialType RefTeachingCredentialType { get; set; }
    }
}
