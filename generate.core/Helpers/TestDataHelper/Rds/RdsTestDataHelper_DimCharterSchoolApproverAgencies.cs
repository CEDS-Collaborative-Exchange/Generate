using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using generate.core.Models.RDS;

namespace generate.core.Helpers.TestDataHelper.Rds
{
 public static partial class RdsTestDataHelper
 {
     public static RdsTestDataObject GetRdsTestData_DimCharterSchoolAuthorizers()
     {
         // SeedValue = 50000

         var testData = new RdsTestDataObject();


            testData = new RdsTestDataObject()
            {
                TestDataSection = "DimCharterSchoolAuthorizers",
                TestDataSectionDescription = "DimCharterSchoolAuthorizers Data",
                DimCharterSchoolAuthorizers = new List<generate.core.Models.RDS.DimCharterSchoolAuthorizer>()
             {
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = -1,
                     //OrganizationId = null,
                     Name = null,
                     //SeaOrganizationId = null,
                     StateIdentifier = null,
                     State = null,
                     StateCode = null,
                     StateANSICode = null,
                     //OrganizationType = null

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 1,
                     //OrganizationId = 367454,
                     Name = "Kingstowne Elementary",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "367454",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 2,
                     //OrganizationId = 682455,
                     Name = "Ruhenstroth Junior High",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "682455",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"
                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 3,
                     //OrganizationId = 207469,
                     Name = "Elim Elementary",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "207469",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA",

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 4,
                     //OrganizationId = 819331,
                     Name = "Red Hill High School",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "819331",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 5,
                     //OrganizationId = 834586,
                     Name = "Gambrills Elementary",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "834586",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 6,
                     //OrganizationId = 241569,
                     Name = "Lake Tansi Middle School",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "241569",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 7,
                     //OrganizationId = 704805,
                     Name = "The Pinery Junior High",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "704805",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 8,
                     //OrganizationId = 251449,
                     Name = "Cheriton Junior High",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "251449",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 9,
                     //OrganizationId = 155052,
                     Name = "Hammon Academy",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "155052",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 10,
                     //OrganizationId = 412267,
                     Name = "Timber Lakes Junior High",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "412267",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 11,
                     //OrganizationId = 248805,
                     Name = "Biloxi High School",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "248805",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 12,
                     //OrganizationId = 263331,
                     Name = "Speculator Elementary",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "263331",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 13,
                     //OrganizationId = 627802,
                     Name = "Conneaut Lake Middle School",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "627802",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 14,
                     //OrganizationId = 178310,
                     Name = "Fairbanks Academy",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "178310",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 15,
                     //OrganizationId = 384876,
                     Name = "Holiday Junior High",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "384876",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 16,
                     //OrganizationId = 363012,
                     Name = "East Norwich High School",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "363012",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 17,
                     //OrganizationId = 647016,
                     Name = "Mariaville Lake Junior High",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "647016",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 18,
                     //OrganizationId = 112587,
                     Name = "Avondale High School",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "112587",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 19,
                     //OrganizationId = 869544,
                     Name = "Stonybrook High School",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "869544",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 20,
                     //OrganizationId = 389426,
                     Name = "Froid Junior High",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "389426",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 21,
                     //OrganizationId = 348079,
                     Name = "Turpin Hills Middle School",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "348079",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 22,
                     //OrganizationId = 258239,
                     Name = "Edgar Springs Junior High",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "258239",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 23,
                     //OrganizationId = 159249,
                     Name = "Rio Rico Academy",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "159249",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 24,
                     //OrganizationId = 189303,
                     Name = "Barnegat Light High School",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "189303",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 25,
                     //OrganizationId = 469846,
                     Name = "Fuller Heights Academy",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "469846",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 26,
                     //OrganizationId = 609196,
                     Name = "Brielle High School",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "609196",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 },
                 new generate.core.Models.RDS.DimCharterSchoolAuthorizer()
                 {
                     DimCharterSchoolAuthorizerId = 27,
                     //OrganizationId = 254539,
                     Name = "Carter Middle School",
                     //SeaOrganizationId = "48",
                     StateIdentifier = "254539",
                     State = "Texas",
                     StateCode = "TX",
                     StateANSICode = "48",
                     //OrganizationType = "LEA"

                 }
             },

            };

            return testData;
     }
 }
}

