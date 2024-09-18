using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonCredential
    {
        public PersonCredential()
        {
            StaffCredential = new HashSet<StaffCredential>();
        }

        public int PersonCredentialId { get; set; }
        public int PersonId { get; set; }
        public string CredentialName { get; set; }
        public int? RefCredentialTypeId { get; set; }
        public DateTime? IssuanceDate { get; set; }
        public DateTime? ExpirationDate { get; set; }
        public int? RefIssuingStateId { get; set; }
        public string ProfessionalCertificateOrLicenseNumber { get; set; }
        public string CredentialOrLicenseAwardEntity { get; set; }

        public virtual EarlyChildhoodCredential EarlyChildhoodCredential { get; set; }
        public virtual ICollection<StaffCredential> StaffCredential { get; set; }
        public virtual Person Person { get; set; }
        public virtual RefCredentialType RefCredentialType { get; set; }
        public virtual RefState RefIssuingState { get; set; }
    }
}
