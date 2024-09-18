using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefHigherEducationInstitutionAccreditationStatus
    {
        public RefHigherEducationInstitutionAccreditationStatus()
        {
            PersonDegreeOrCertificate = new HashSet<PersonDegreeOrCertificate>();
        }

        public int RefHigherEducationInstitutionAccreditationStatusId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PersonDegreeOrCertificate> PersonDegreeOrCertificate { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
