using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonDegreeOrCertificate
    {
        public int PersonDegreeOrCertificateId { get; set; }
        public int PersonId { get; set; }
        public string DegreeOrCertificateTitleOrSubject { get; set; }
        public int? RefDegreeOrCertificateTypeId { get; set; }
        public DateTime? AwardDate { get; set; }
        public string NameOfInstitution { get; set; }
        public int? RefHigherEducationInstitutionAccreditationStatusId { get; set; }
        public int? RefEducationVerificationMethodId { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefDegreeOrCertificateType RefDegreeOrCertificateType { get; set; }
        public virtual RefEducationVerificationMethod RefEducationVerificationMethod { get; set; }
        public virtual RefHigherEducationInstitutionAccreditationStatus RefHigherEducationInstitutionAccreditationStatus { get; set; }
    }
}
