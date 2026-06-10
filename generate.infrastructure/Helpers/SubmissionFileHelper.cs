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
        public static string GetLeaIdentifier(string factTableName, string reportLevel, string columnName)
        {
            return (factTableName, reportLevel, columnName) switch
            {
                ("FactOrganizationCounts", "lea", _) => "OrganizationStateId",
                ("FactOrganizationCounts", "sch", "StateSchoolIDNumber") => "OrganizationStateId",
                ("FactOrganizationCounts", "sch", _) => "ParentOrganizationStateId",
                (_, "lea", _) => "OrganizationIdentifierSea",
                (_, "sch", "StateSchoolIDNumber") => "OrganizationIdentifierSea",
                (_, "sch", _) => "ParentOrganizationIdentifierSea",
                _ => ""
            };
        }

        public static string GetNCESIdentifier(string factTableName, string reportLevel, string columnName)
        {
            return (factTableName, reportLevel, columnName) switch
            {
                ("FactOrganizationCounts", "lea", _) => "OrganizationNcesId",
                ("FactOrganizationCounts", "sch", "NCESSchoolIDNumber") => "OrganizationNcesId",
                ("FactOrganizationCounts", "sch", _) => "ParentOrganizationNcesId",
                (_, "lea", _) => "OrganizationIdentifierNces",
                (_, "sch", "NCESSchoolIDNumber") => "OrganizationIdentifierNces",
                (_, "sch", _) => "ParentOrganizationIdentifierNces",
                _ => ""
            };
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