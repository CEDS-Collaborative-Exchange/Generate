using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonIdentifier
    {
        public int PersonIdentifierId { get; set; }
        public int PersonId { get; set; }
        public string Identifier { get; set; }
        public int RefPersonIdentificationSystemId { get; set; }
        public int? RefPersonalInformationVerificationId { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefPersonIdentificationSystem RefPersonIdentificationSystem { get; set; }
        public virtual RefPersonalInformationVerification RefPersonalInformationVerification { get; set; }
    }
}
