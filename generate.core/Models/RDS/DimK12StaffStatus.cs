using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimK12StaffStatus
    {
        public int DimK12StaffStatusId { get; set; }

        public string K12StaffClassificationCode { get; set; }
        public string K12StaffClassificationDescription { get; set; }
        public string K12StaffClassificationEdFactsCode { get; set; }

        public string QualificationStatusCode { get; set; }
        public string QualificationStatusDescription { get; set; }
        public string QualificationStatusEdFactsCode { get; set; }

        public string CertificationStatusCode { get; set; }
        public string CertificationStatusDescription { get; set; }
        public string CertificationStatusEdFactsCode { get; set; }

        public string SpecialEducationAgeGroupTaughtCode { get; set; }
        public string SpecialEducationAgeGroupTaughtDescription { get; set; }
        public string SpecialEducationAgeGroupTaughtEdFactsCode { get; set; }

		public string UnexperiencedStatusCode { get; set; }
		public string UnexperiencedStatusDescription { get; set; }
		public string UnexperiencedStatusEdFactsCode { get; set; }

		public string EmergencyOrProvisionalCredentialStatusCode { get; set; }
		public string EmergencyOrProvisionalCredentialStatusDescription { get; set; }
		public string EmergencyOrProvisionalCredentialStatusEdFactsCode { get; set; }

		public string OutOfFieldStatusCode { get; set; }
		public string OutOfFieldStatusDescription { get; set; }
		public string OutOfFieldStatusEdFactsCode { get; set; }


		public List<FactK12StaffCount> FactPersonnelCounts { get; set; }

    }
}
