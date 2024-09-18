using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ProgramParticipationTeacherPrep
    {
        public ProgramParticipationTeacherPrep()
        {
            TeacherEducationCredentialExam = new HashSet<TeacherEducationCredentialExam>();
        }

        public int? RefTeacherPrepEnrollmentStatusId { get; set; }
        public int? RefTeacherPrepCompleterStatusId { get; set; }
        public int? RefSupervisedClinicalExperienceId { get; set; }
        public int? ClinicalExperienceClockHours { get; set; }
        public int? RefTeachingCredentialBasisId { get; set; }
        public int? RefTeachingCredentialTypeId { get; set; }
        public int? RefCriticalTeacherShortageCandidateId { get; set; }
        public int? RefAltRouteToCertificationOrLicensureId { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public int PersonProgramParticipationId { get; set; }
        public int ProgramParticipationTeacherPrepId { get; set; }

        public virtual ICollection<TeacherEducationCredentialExam> TeacherEducationCredentialExam { get; set; }
        public virtual PersonProgramParticipation PersonProgramParticipation { get; set; }
        public virtual RefAltRouteToCertificationOrLicensure RefAltRouteToCertificationOrLicensure { get; set; }
        public virtual RefCriticalTeacherShortageCandidate RefCriticalTeacherShortageCandidate { get; set; }
        public virtual RefSupervisedClinicalExperience RefSupervisedClinicalExperience { get; set; }
        public virtual RefTeacherPrepCompleterStatus RefTeacherPrepCompleterStatus { get; set; }
        public virtual RefTeacherPrepEnrollmentStatus RefTeacherPrepEnrollmentStatus { get; set; }
        public virtual RefTeachingCredentialBasis RefTeachingCredentialBasis { get; set; }
        public virtual RefTeachingCredentialType RefTeachingCredentialType { get; set; }
    }
}
