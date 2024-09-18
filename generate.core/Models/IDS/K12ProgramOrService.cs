using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12programOrService
    {
        public int OrganizationId { get; set; }
        public int? RefPrekindergartenDailyLengthId { get; set; }
        public int? RefKindergartenDailyLengthId { get; set; }
        public int? RefProgramGiftedEligibilityId { get; set; }
        public int? RefMepSessionTypeId { get; set; }
        public int? RefMepProjectTypeId { get; set; }
        public bool? ProgramInMultiplePurposeFacility { get; set; }
        public int? RefTitleIinstructionalServicesId { get; set; }
        public int? RefTitleIprogramTypeId { get; set; }
        public DateTime RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }

        public virtual Organization Organization { get; set; }
        public virtual RefProgramDayLength RefKindergartenDailyLength { get; set; }
        public virtual RefMepProjectType RefMepProjectType { get; set; }
        public virtual RefMepSessionType RefMepSessionType { get; set; }
        public virtual RefProgramDayLength RefPrekindergartenDailyLength { get; set; }
        public virtual RefProgramGiftedEligibility RefProgramGiftedEligibility { get; set; }
        public virtual RefTitleIinstructionalServices RefTitleIinstructionalServices { get; set; }
        public virtual RefTitleIprogramType RefTitleIprogramType { get; set; }
    }
}
