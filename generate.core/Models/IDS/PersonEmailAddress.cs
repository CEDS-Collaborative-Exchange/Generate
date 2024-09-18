using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonEmailAddress
    {
        public int PersonEmailAddressId { get; set; }
        public int PersonId { get; set; }
        public string EmailAddress { get; set; }
        public int? RefEmailTypeId { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefEmailType RefEmailType { get; set; }
    }
}
