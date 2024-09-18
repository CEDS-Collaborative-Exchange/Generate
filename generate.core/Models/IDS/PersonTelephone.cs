using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonTelephone
    {
        public int PersonTelephoneId { get; set; }
        public int PersonId { get; set; }
        public string TelephoneNumber { get; set; }
        public bool PrimaryTelephoneNumberIndicator { get; set; }
        public int? RefPersonTelephoneNumberTypeId { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefPersonTelephoneNumberType RefPersonTelephoneNumberType { get; set; }
    }
}
