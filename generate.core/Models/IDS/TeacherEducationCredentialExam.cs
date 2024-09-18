using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class TeacherEducationCredentialExam
    {
        public int? RefTeacherEducationCredentialExamId { get; set; }
        public int? RefTeacherEducationExamScoreTypeId { get; set; }
        public int? RefTeacherEducationTestCompanyId { get; set; }
        public int ProgramParticipationTeacherPrepId { get; set; }
        public int TeacherEducationCredentialExamId { get; set; }

        public virtual ProgramParticipationTeacherPrep ProgramParticipationTeacherPrep { get; set; }
        public virtual RefTeacherEducationCredentialExam RefTeacherEducationCredentialExam { get; set; }
        public virtual RefTeacherEducationExamScoreType RefTeacherEducationExamScoreType { get; set; }
        public virtual RefTeacherEducationTestCompany RefTeacherEducationTestCompany { get; set; }
    }
}
