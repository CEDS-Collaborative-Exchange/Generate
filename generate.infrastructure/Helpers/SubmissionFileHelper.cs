using generate.core.Interfaces.Helpers;
using System;
using System.Collections.Generic;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.infrastructure.Utilities
{
    public static class SubmissionFileHelper
    {
        public static string GetLeaIdentifier(string factTableName, string reportLevel)
        {
            string field = "";
            if (factTableName == "FactOrganizationCounts")
            {
                if (reportLevel == "lea") { field = "OrganizationStateId"; }
                else if (reportLevel == "sch") { field = "ParentOrganizationStateId"; }
            }
            else
            {
                if (reportLevel == "lea") { field = "OrganizationIdentifierSea"; }
                else if (reportLevel == "sch") { field = "ParentOrganizationIdentifierSea"; }
            }
            return field;
        }

        public static string GetNCESIdentifier(string factTableName, string reportLevel)
        {
            string field = "";
            if (factTableName == "FactOrganizationCounts")
            {
                if (reportLevel == "lea") { field = "OrganizationNcesId"; }
                else if (reportLevel == "sch") { field = "ParentOrganizationNcesId"; }
            }
            else
            {
                if (reportLevel == "lea") { field = "OrganizationIdentifierNces"; }
                else if (reportLevel == "sch") { field = "ParentOrganizationIdentifierNces"; }
            }
            return field;
        }

        public static string GetStateSchoolIdentifier(string factTableName)
        {
            string field = "";
            if (factTableName == "FactOrganizationCounts")
            {
                field = "OrganizationStateId";
            }
            else
            {
                field = "OrganizationIdentifierSea";
            }
            return field;
        }

        public static string GetAmount(string factFieldName, string reportCode)
        {
            string field = factFieldName;
            string reportCodes = "199,200,201,202,206";
            if (reportCode == "150") { field = "StudentRate"; }
            else if (reportCode == "035") { field = "FederalFundAllocated"; }
            else if (reportCodes.Contains(reportCode)) { field = "INDICATORSTATUS"; }
            else if (reportCode == "205") { field = "PROGRESSACHIEVINGENGLISHLANGUAGE"; }
            return field;
        }

    }
}