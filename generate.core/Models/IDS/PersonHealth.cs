using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonHealth
    {
        public int PersonHealthId { get; set; }
        public int PersonId { get; set; }
        public DateTime? VisionScreeningDate { get; set; }
        public int? RefVisionScreeningStatusId { get; set; }
        public DateTime? HearingScreeningDate { get; set; }
        public int? RefHearingScreeningStatusId { get; set; }
        public DateTime DentalScreeningDate { get; set; }
        public int? RefDentalScreeningStatusId { get; set; }
        public int? RefHealthInsuranceCoverageId { get; set; }
        public int? RefDentalInsuranceCoverageTypeId { get; set; }
        public int? RefMedicalAlertIndicatorId { get; set; }
        public string HealthScreeningEquipmentUsed { get; set; }
        public string HealthScreeningFollowUpRecommendation { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefDentalInsuranceCoverageType RefDentalInsuranceCoverageType { get; set; }
        public virtual RefDentalScreeningStatus RefDentalScreeningStatus { get; set; }
        public virtual RefHealthInsuranceCoverage RefHealthInsuranceCoverage { get; set; }
        public virtual RefHearingScreeningStatus RefHearingScreeningStatus { get; set; }
        public virtual RefMedicalAlertIndicator RefMedicalAlertIndicator { get; set; }
        public virtual RefVisionScreeningStatus RefVisionScreeningStatus { get; set; }
    }
}
