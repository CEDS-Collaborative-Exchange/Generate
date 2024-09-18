using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PsPriceOfAttendance
    {
        public int PspriceOfAttendanceId { get; set; }
        public int OrganizationId { get; set; }
        public string SessionDesignator { get; set; }
        public decimal? TuitionPublished { get; set; }
        public int? RefTuitionUnitId { get; set; }
        public decimal? BoardCharges { get; set; }
        public decimal? RoomCharges { get; set; }
        public decimal? BooksAndSuppliesCosts { get; set; }
        public decimal? RequiredStudentFees { get; set; }
        public decimal? ComprehensiveFee { get; set; }
        public decimal? OtherStudentExpenses { get; set; }
        public decimal? PriceOfAttendance { get; set; }
        public string IpedscollectionYearDesignator { get; set; }

        public virtual PsInstitution Organization { get; set; }
        public virtual RefTuitionUnit RefTuitionUnit { get; set; }
    }
}
