using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PsInstitution
    {
        public PsInstitution()
        {
            PsPriceOfAttendance = new HashSet<PsPriceOfAttendance>();
        }

        public int OrganizationId { get; set; }
        public int? RefCarnegieBasicClassificationId { get; set; }
        public int? RefControlOfInstitutionId { get; set; }
        public int? RefLevelOfInstitutionId { get; set; }
        public int? RefPredominantCalendarSystemId { get; set; }
        public int? RefTenureSystemId { get; set; }
        public bool? VirtualIndicator { get; set; }
        public bool? InstitutionallyControlledHousingStatus { get; set; }
        public int? RefAdmissionConsiderationLevelId { get; set; }
        public int? RefAdmissionConsiderationTypeId { get; set; }

        public virtual ICollection<PsPriceOfAttendance> PsPriceOfAttendance { get; set; }
        public virtual Organization Organization { get; set; }
        public virtual RefAdmissionConsiderationLevel RefAdmissionConsiderationLevel { get; set; }
        public virtual RefAdmissionConsiderationType RefAdmissionConsiderationType { get; set; }
        public virtual RefCarnegieBasicClassification RefCarnegieBasicClassification { get; set; }
        public virtual RefControlOfInstitution RefControlOfInstitution { get; set; }
        public virtual RefLevelOfInstitution RefLevelOfInstitution { get; set; }
        public virtual RefPredominantCalendarSystem RefPredominantCalendarSystem { get; set; }
        public virtual RefTenureSystem RefTenureSystem { get; set; }
    }
}
