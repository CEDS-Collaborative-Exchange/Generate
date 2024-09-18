using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefTeachingCredentialBasis
    {
        public RefTeachingCredentialBasis()
        {
            ProgramParticipationTeacherPrep = new HashSet<ProgramParticipationTeacherPrep>();
            StaffCredential = new HashSet<StaffCredential>();
        }

        public int RefTeachingCredentialBasisId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ProgramParticipationTeacherPrep> ProgramParticipationTeacherPrep { get; set; }
        public virtual ICollection<StaffCredential> StaffCredential { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
