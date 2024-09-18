using generate.core.Models.App;
using generate.core.Models.IDS;
using System;
using System.Collections;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public class FactOrganizationCount
    {
        public int FactOrganizationCountId { get; set; }

        //Facts
        public int OrganizationCount { get; set; }
        public int TitleIParentalInvolveRes { get; set; }
        public int TitleIPartAAllocations { get; set; }
        public int? SchoolImprovementFunds { get; set; }


        //Dimensions (defining fact granuality)
        public int FactTypeId { get; set; }
        public int SchoolYearId { get; set; }
        public int SeaId { get; set; }
        public int LeaId { get; set; }
        public int K12SchoolId { get; set; }
        public int K12StaffId { get; set; }


        // ensions (reporting)
        public int SchoolStatusId { get; set; }
        public int TitleIStatusId { get; set; }
        public int CharterSchoolApproverAgencyId { get; set; }
        public int CharterSchoolManagerOrganizationId { get; set; }
        public int CharterSchoolSecondaryApproverAgencyId { get; set; }
        public int CharterSchoolUpdatedManagerOrganizationId { get; set; }
        public int OrganizationStatusId { get; set; }


        public int SchoolStateStatusId { get; set; }
        public int ComprehensiveAndTargetedSupportId { get; set; }
        public string FederalFundAllocationType { get; set; }
        public string FederalProgramCode { get; set; }
        public int FederalFundAllocated { get; set; }
        public int CharterSchoolStatusId { get; set; }




        public DimFactType DimFactType { get; set; }
        public DimDate DimCountDate { get; set; }
        public DimSea DimSea { get; set; }
        public DimLea DimLea { get; set; }
        public DimK12School DimSchool { get; set; }
        public DimK12SchoolStatus DimSchoolStatus { get; set; }
        public DimTitleIStatus DimTitle1Status { get; set; }
        public DimK12Staff DimPersonnel { get; set; }
        public DimCharterSchoolAuthorizer DimCharterSchoolAuthorizer { get; set; }
        public DimCharterSchoolManagementOrganization DimCharterSchoolManagementOrganization { get; set; }
        public DimCharterSchoolAuthorizer DimCharterSchoolSecondaryAuthorizer { get; set; }
        public DimCharterSchoolManagementOrganization DimCharterSchoolUpdatedManagementOrganization { get; set; }
        public DimK12OrganizationStatus DimOrganizationStatus { get; set; }

        public DimK12SchoolStateStatus DimSchoolStateStatus { get; set; }
        public DimCharterSchoolStatus DimCharterSchoolStatus { get; set; }

    }
}
