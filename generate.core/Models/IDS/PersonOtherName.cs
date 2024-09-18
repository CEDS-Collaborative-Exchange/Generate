using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonOtherName
    {
        public int PersonOtherNameId { get; set; }
        public int PersonId { get; set; }
        public int? RefOtherNameTypeId { get; set; }
        public string OtherName { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefOtherNameType RefOtherNameType { get; set; }
    }
}
