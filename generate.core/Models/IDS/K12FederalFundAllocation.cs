using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12FederalFundAllocation
    {
        public int K12FederalFundAllocationId { get; set; }
        public int OrganizationCalendarSessionId { get; set; }

      //  public int OrganizationId { get; set; }
        public string FederalProgramCode { get; set; }
        public int? RefFederalProgramFundingAllocationTypeId { get; set; }
        public decimal? FederalProgramsFundingAllocation { get; set; }
        public decimal? FundsTransferAmount { get; set; }

        public decimal? SchoolImprovementAllocation { get; set; }
        public bool? LeaTransferabilityOfFunds { get; set; }
        public int? RefLeaFundsTransferTypeId { get; set; }

        public decimal? SchoolImprovementReservedPercent { get; set; }

        public decimal? SesPerPupilExpenditure { get; set; }

        public int? NumberOfImmigrantProgramSubgrants { get; set; }

        public int? RefReapAlternativeFundingStatusId { get; set; }

        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }


        //  public virtual K12sea Organization { get; set; }
        public virtual OrganizationCalendarSession OrganizationCalendarSession { get; set; }  
        public virtual RefFederalProgramFundingAllocationType RefFederalProgramFundingAllocationType { get; set; }
        public virtual RefLeaFundsTransferType RefLeaFundsTransferType { get; set; }
        public virtual RefReapAlternativeFundingStatus RefReapAlternativeFundingStatus { get; set; }     



    }
}
