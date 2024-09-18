using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefProfessionalTechnicalCredentialType
    {
        public RefProfessionalTechnicalCredentialType()
        {
            AeStudentAcademicRecord = new HashSet<AeStudentAcademicRecord>();
            CteStudentAcademicRecord = new HashSet<CteStudentAcademicRecord>();
            K12studentAcademicRecord = new HashSet<K12studentAcademicRecord>();
            PsStudentAcademicRecord = new HashSet<PsStudentAcademicRecord>();
            WorkforceProgramParticipation = new HashSet<WorkforceProgramParticipation>();
        }

        public int RefProfessionalTechnicalCredentialTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AeStudentAcademicRecord> AeStudentAcademicRecord { get; set; }
        public virtual ICollection<CteStudentAcademicRecord> CteStudentAcademicRecord { get; set; }
        public virtual ICollection<K12studentAcademicRecord> K12studentAcademicRecord { get; set; }
        public virtual ICollection<PsStudentAcademicRecord> PsStudentAcademicRecord { get; set; }
        public virtual ICollection<WorkforceProgramParticipation> WorkforceProgramParticipation { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
