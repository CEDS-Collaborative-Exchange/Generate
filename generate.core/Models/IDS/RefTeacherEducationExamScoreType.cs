using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefTeacherEducationExamScoreType
    {
        public RefTeacherEducationExamScoreType()
        {
            TeacherEducationCredentialExam = new HashSet<TeacherEducationCredentialExam>();
        }

        public int RefTeacherEducationExamScoreTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<TeacherEducationCredentialExam> TeacherEducationCredentialExam { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
