using System;
using System.Collections.Generic;
using System.Text;

namespace generate.core.Models.RDS
{
    public partial class DimK12EnrollmentStatus
    {
        public int DimK12EnrollmentStatusId { get; set; }

        public string ExitOrWithdrawalTypeCode { get; set; }
        public string ExitOrWithdrawalTypeDescription { get; set; }

        public string PostSecondaryEnrollmentStatusCode { get; set; }
        public string PostSecondaryEnrollmentStatusDescription { get; set; }
        public string PostSecondaryEnrollmentStatusEdFactsCode { get; set; }

        public string AcademicOrVocationalOutcomeCode { get; set; }
        public string AcademicOrVocationalOutcomeDescription { get; set; }
        public string AcademicOrVocationalOutcomeEdFactsCode { get; set; }

        public string AcademicOrVocationalExitOutcomeCode { get; set; }
        public string AcademicOrVocationalExitOutcomeDescription { get; set; }
        public string AcademicOrVocationalExitOutcomeEdFactsCode { get; set; }

        public string EntryTypeCode { get; set; }
        public string EntryTypeDescription { get; set; }

        public string EnrollmentStatusCode { get; set; }
        public string EnrollmentStatusDescription { get; set; }

        public List<FactK12StudentCount> FactK12StudentCounts { get; set; }
        public List<FactK12StudentAssessment> FactK12StudentAssessments { get; set; }

    }
}
