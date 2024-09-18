using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonDetail
    {
        public int PersonDetailId { get; set; }
        public int PersonId { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string GenerationCode { get; set; }
        public string Prefix { get; set; }
        public DateTime? Birthdate { get; set; }
        public int? RefSexId { get; set; }
        public bool? HispanicLatinoEthnicity { get; set; }
        public int? RefUscitizenshipStatusId { get; set; }
        public int? RefVisaTypeId { get; set; }
        public int? RefStateOfResidenceId { get; set; }
        public int? RefProofOfResidencyTypeId { get; set; }
        public int? RefHighestEducationLevelCompletedId { get; set; }
        public int? RefPersonalInformationVerificationId { get; set; }
        public string BirthdateVerification { get; set; }
        public int? RefTribalAffiliationId { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefEducationLevel RefHighestEducationLevelCompleted { get; set; }
        public virtual RefPersonalInformationVerification RefPersonalInformationVerification { get; set; }
        public virtual RefProofOfResidencyType RefProofOfResidencyType { get; set; }
        public virtual RefSex RefSex { get; set; }
        public virtual RefState RefStateOfResidence { get; set; }
        public virtual RefTribalAffiliation RefTribalAffiliation { get; set; }
        public virtual RefUscitizenshipStatus RefUscitizenshipStatus { get; set; }
        public virtual RefVisaType RefVisaType { get; set; }
    }
}
