using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12CharterSchoolAuthorizer
    {
        public int K12CharterSchoolAuthorizerId { get; set; }
        public int OrganizationId { get; set; }
        public int RefCharterSchoolAuthorizerTypeId { get; set; }
        public virtual Organization Organization { get; set; }
        public virtual RefCharterSchoolAuthorizerType RefCharterSchoolAuthorizerType { get; set; }
    }


}
