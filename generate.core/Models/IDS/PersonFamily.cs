using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonFamily
    {
        public int PersonFamilyId { get; set; }
        public int PersonId { get; set; }
        public string FamilyIdentifier { get; set; }
        public int? NumberOfPeopleInFamily { get; set; }
        public int? NumberOfPeopleInHousehold { get; set; }
        public decimal? FamilyIncome { get; set; }
        public int? RefFamilyIncomeSourceId { get; set; }
        public int? RefIncomeCalculationMethodId { get; set; }
        public int? RefProofOfResidencyTypeId { get; set; }
        public int? RefElprogramEligibilityId { get; set; }
        public int? RefHighestEducationLevelCompletedId { get; set; }
        public int? RefCommunicationMethodId { get; set; }
        public bool? IncludedInCountedFamilySize { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefCommunicationMethod RefCommunicationMethod { get; set; }
        public virtual RefElprogramEligibility RefElprogramEligibility { get; set; }
        public virtual RefFamilyIncomeSource RefFamilyIncomeSource { get; set; }
        public virtual RefEducationLevel RefHighestEducationLevelCompleted { get; set; }
        public virtual RefIncomeCalculationMethod RefIncomeCalculationMethod { get; set; }
        public virtual RefProofOfResidencyType RefProofOfResidencyType { get; set; }
    }
}
