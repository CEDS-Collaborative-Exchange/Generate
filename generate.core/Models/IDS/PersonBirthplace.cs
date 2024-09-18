using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonBirthplace
    {
        public int PersonId { get; set; }
        public string City { get; set; }
        public int? RefStateId { get; set; }
        public int? RefCountryId { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefCountry RefCountry { get; set; }
        public virtual RefState RefState { get; set; }
    }
}
