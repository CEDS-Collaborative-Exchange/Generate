using generate.core.Config;
using generate.core.Helpers.ReferenceData;
using generate.core.Helpers.TestDataHelper;
using generate.core.Models.IDS;
using generate.infrastructure.Contexts;
using generate.testdata.DataGenerators;
using generate.testdata.Helpers;
using generate.testdata.Profiles;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace generate.test.TestData.DataGenerators
{
    public class OdsTestDataGeneratorShould
    {
        private void ValidateOrganizationTestData(IdsTestDataObject testData)
        {
            Assert.NotNull(testData);

            Assert.NotEqual(0, testData.SeaOrganizationId);
            Assert.NotEmpty(testData.LeaOrganizationIds);
            Assert.NotEmpty(testData.SchoolOrganizationIds);
            Assert.NotEmpty(testData.Organizations);
            Assert.NotEmpty(testData.OrganizationDetails);
            Assert.NotEmpty(testData.OrganizationIdentifiers);
            Assert.NotEmpty(testData.OrganizationIndicators);
            Assert.NotEmpty(testData.K12Leas);
            Assert.NotEmpty(testData.K12Schools);
            Assert.NotEmpty(testData.OrganizationWebsites);
            Assert.NotEmpty(testData.OrganizationTelephones);
            Assert.NotEmpty(testData.Locations);
            Assert.NotEmpty(testData.OrganizationLocations);
            Assert.NotEmpty(testData.LocationAddresses);
            Assert.NotEmpty(testData.K12LeaTitleISupportServices);
            Assert.NotEmpty(testData.K12ProgramOrServices);
            Assert.NotEmpty(testData.K12titleIiilanguageInstructions);
            Assert.NotEmpty(testData.OrganizationRelationships);
            Assert.NotEmpty(testData.OrganizationOperationalStatuses);
            Assert.NotEmpty(testData.OrganizationFederalAccountabilities);

            Assert.NotEmpty(testData.OrganizationCalendars);
            Assert.NotEmpty(testData.OrganizationCalendarSessions);
            Assert.NotEmpty(testData.K12FederalFundAllocations);
            Assert.NotEmpty(testData.K12SchoolImprovements);

        }

        private void ValidateOrganizationCalendars(IEnumerable<OrganizationCalendar> organizationCalendars)
        {
            Assert.NotEmpty(organizationCalendars);

            foreach (var item in organizationCalendars)
            {
                Assert.NotNull(item.CalendarCode);
                Assert.NotNull(item.CalendarYear);
                Assert.NotNull(item.CalendarDescription);
            }
        }
        
        private void ValidateOrganizationCalendarSessions(IEnumerable<OrganizationCalendarSession> organizationCalendarSessions)
        {
            Assert.NotEmpty(organizationCalendarSessions);

            foreach (var item in organizationCalendarSessions)
            {
                Assert.NotNull(item.Designator);
                Assert.NotNull(item.Code);
                Assert.NotNull(item.Description);
                Assert.NotNull(item.RefSessionTypeId);
                Assert.NotNull(item.BeginDate);
                Assert.NotNull(item.EndDate);
            }
        }

        private void ValidateLeaK12FederalFundAllocations(IEnumerable<K12FederalFundAllocation> k12FederalFundAllocations)
        {
            Assert.NotEmpty(k12FederalFundAllocations);

            foreach (var item in k12FederalFundAllocations)
            {
                Assert.NotNull(item.RecordStartDateTime);
                Assert.NotNull(item.RecordEndDateTime);
                Assert.NotNull(item.FederalProgramCode);
                Assert.NotNull(item.SchoolImprovementAllocation);

                Assert.NotNull(item.FederalProgramsFundingAllocation);
                Assert.NotNull(item.RefReapAlternativeFundingStatusId);
                Assert.NotNull(item.RefFederalProgramFundingAllocationTypeId);
            }
        }

        private void ValidateSchoolK12FederalFundAllocations(IEnumerable<K12FederalFundAllocation> k12FederalFundAllocations)
        {
            Assert.NotEmpty(k12FederalFundAllocations);

            foreach (var item in k12FederalFundAllocations)
            {
                Assert.NotNull(item.RecordStartDateTime);
                Assert.NotNull(item.RecordEndDateTime);
                Assert.NotNull(item.FederalProgramCode);
                Assert.NotNull(item.SchoolImprovementAllocation);

            }
        }

        private void ValidateK12LeaFederalFunds(IEnumerable<K12LeaFederalFunds> k12LeaFederalFunds)
        {
            Assert.NotEmpty(k12LeaFederalFunds);

            foreach (var item in k12LeaFederalFunds)
            {
                Assert.NotNull(item.RecordStartDateTime);
                Assert.NotNull(item.RecordEndDateTime);
                Assert.NotNull(item.ParentalInvolvementReservationFunds);
            }
        }

        private void ValidateOrganizationDetails(IEnumerable<OrganizationDetail> organizationDetails)
        {
            Assert.NotEmpty(organizationDetails);

            foreach (var item in organizationDetails)
            {
                Assert.NotNull(item.Name);
                Assert.NotNull(item.ShortName);
                Assert.NotNull(item.RecordStartDateTime);
                Assert.NotNull(item.RefOrganizationTypeId);
            }
        }

        private void ValidateOrganizationWebsites(IEnumerable<OrganizationWebsite> organizationWebsites)
        {
            Assert.NotEmpty(organizationWebsites);

            foreach (var item in organizationWebsites)
            {
                Assert.NotNull(item.Website);
            }
        }

        private void ValidateOrganizationTelephones(IEnumerable<OrganizationTelephone> organizationTelephones)
        {
            Assert.NotEmpty(organizationTelephones);

            foreach (var item in organizationTelephones)
            {
                Assert.NotNull(item.TelephoneNumber);
            }
        }

        private void ValidateOrganizationLocations(IEnumerable<OrganizationLocation> organizationLocationss)
        {
            Assert.NotEmpty(organizationLocationss);

            foreach (var item in organizationLocationss)
            {
                Assert.NotNull(item.RefOrganizationLocationTypeId);
            }
        }

        private void ValidateLocationAddresses(IEnumerable<LocationAddress> locationAddresses)
        {
            Assert.NotEmpty(locationAddresses);

            foreach (var item in locationAddresses)
            {
                Assert.NotNull(item.StreetNumberAndName);
                Assert.NotNull(item.PostalCode);
                Assert.NotNull(item.City);
                Assert.NotNull(item.RefStateId);
            }
        }

        private void ValidateOrganizationIdentifiers(IEnumerable<OrganizationIdentifier> organizationIdentifiers)
        {
            Assert.NotEmpty(organizationIdentifiers);

            foreach (var item in organizationIdentifiers)
            {
                Assert.NotNull(item.Identifier);
                Assert.NotNull(item.RefOrganizationIdentificationSystemId);
                Assert.NotNull(item.RefOrganizationIdentifierTypeId);
            }
        }

        private void ValidateOrganizationIndicators(IEnumerable<OrganizationIndicator> organizationIndicators)
        {
            Assert.NotEmpty(organizationIndicators);

            foreach (var item in organizationIndicators)
            {
                Assert.NotNull(item.IndicatorValue);
            }
        }

        private void ValidateK12titleIiilanguageInstructions(IEnumerable<K12titleIiilanguageInstruction> k12titleIiilanguageInstructions)
        {
            Assert.NotEmpty(k12titleIiilanguageInstructions);

        }

        private void ValidateOrganizationRelationships(IEnumerable<OrganizationRelationship> organizationRelationships)
        {
            Assert.NotEmpty(organizationRelationships);

        }


        private void ValidateOrganizationOperationalStatuses(IEnumerable<OrganizationOperationalStatus> organizationOperationalStatus)
        {
            Assert.NotEmpty(organizationOperationalStatus);

        }



        private void ValidateSeas(IdsTestDataObject testData)
        {

            ValidateOrganizationDetails(testData.OrganizationDetails.Where(x => x.OrganizationId == testData.SeaOrganizationId));


            ValidateOrganizationWebsites(testData.OrganizationWebsites.Where(x => x.OrganizationId == testData.SeaOrganizationId));

            ValidateOrganizationTelephones(testData.OrganizationTelephones.Where(x => x.OrganizationId == testData.SeaOrganizationId));

            var organizationLocations = testData.OrganizationLocations.Where(x => x.OrganizationId == testData.SeaOrganizationId);
            ValidateOrganizationLocations(organizationLocations);

            var organizationLocationIds = organizationLocations.Select(x => x.LocationId);
            ValidateLocationAddresses(testData.LocationAddresses.Where(x => organizationLocationIds.Contains(x.LocationId)));

            ValidateOrganizationIdentifiers(testData.OrganizationIdentifiers.Where(x => x.OrganizationId == testData.SeaOrganizationId));

        }

        private void ValidateLeas(IdsTestDataObject testData)
        {
            ValidateOrganizationDetails(testData.OrganizationDetails.Where(x => testData.LeaOrganizationIds.Contains(x.OrganizationId)));

            var refLeaTypes = RefLeaTypeHelper.GetData();
            var supervisoryUnionType = refLeaTypes.Single(x => x.Code == "SupervisoryUnion");
            var specializedPublicSchoolDistrictType = refLeaTypes.Single(x => x.Code == "SpecializedPublicSchoolDistrict");

            foreach (var item in testData.K12Leas)
            {
                Assert.NotNull(item.RefLeaTypeId);
                Assert.NotNull(item.CharterSchoolIndicator);
                
                if (item.RefLeaTypeId == supervisoryUnionType.RefLeaTypeId || item.RefLeaTypeId == specializedPublicSchoolDistrictType.RefLeaTypeId)
                {
                    Assert.NotNull(item.SupervisoryUnionIdentificationNumber);
                }
            }

            ValidateOrganizationWebsites(testData.OrganizationWebsites.Where(x => testData.LeaOrganizationIds.Contains(x.OrganizationId)));

            ValidateOrganizationTelephones(testData.OrganizationTelephones.Where(x => testData.LeaOrganizationIds.Contains(x.OrganizationId)));

            var organizationLocations = testData.OrganizationLocations.Where(x => testData.LeaOrganizationIds.Contains(x.OrganizationId));
            ValidateOrganizationLocations(organizationLocations);

            var organizationLocationIds = organizationLocations.Select(x => x.LocationId);
            ValidateLocationAddresses(testData.LocationAddresses.Where(x => organizationLocationIds.Contains(x.LocationId)));

            ValidateOrganizationIdentifiers(testData.OrganizationIdentifiers.Where(x => testData.LeaOrganizationIds.Contains(x.OrganizationId)));

            ValidateOrganizationIndicators(testData.OrganizationIndicators.Where(x => testData.LeaOrganizationIds.Contains(x.OrganizationId)));


            foreach (var item in testData.K12ProgramOrServices.Where(x => testData.LeaOrganizationIds.Contains(x.OrganizationId)))
            {
                Assert.NotNull(item.RefTitleIinstructionalServicesId);
                Assert.NotNull(item.RefTitleIprogramTypeId);
                Assert.NotNull(item.RefMepProjectTypeId);
            }

            ValidateK12titleIiilanguageInstructions(testData.K12titleIiilanguageInstructions.Where(x => testData.LeaOrganizationIds.Contains(x.OrganizationId)));

            ValidateOrganizationRelationships(testData.OrganizationRelationships.Where(x => testData.LeaOrganizationIds.Contains(x.OrganizationId)));

            ValidateOrganizationOperationalStatuses(testData.OrganizationOperationalStatuses.Where(x => testData.LeaOrganizationIds.Contains(x.OrganizationId)));

            foreach (var item in testData.OrganizationFederalAccountabilities.Where(x => testData.LeaOrganizationIds.Contains(x.OrganizationId)))
            {
                Assert.NotNull(item.RefGunFreeSchoolsActReportingStatusId);
            }

            var leaOrganizationCalendars = testData.OrganizationCalendars.Where(x => testData.LeaOrganizationIds.Contains(x.OrganizationId));

            if (leaOrganizationCalendars.Any())
            {

                ValidateOrganizationCalendars(leaOrganizationCalendars);

                var organizationCalendarIds = leaOrganizationCalendars.Select(x => x.OrganizationCalendarId).ToList();

                ValidateOrganizationCalendarSessions(testData.OrganizationCalendarSessions.Where(x => organizationCalendarIds.Contains((int)x.OrganizationCalendarId)));

                var organizationCalendarSessionIds = testData.OrganizationCalendarSessions.Where(x => organizationCalendarIds.Contains((int)x.OrganizationCalendarId)).Select(x => x.OrganizationCalendarId).ToList();

                ValidateLeaK12FederalFundAllocations(testData.K12FederalFundAllocations.Where(x => organizationCalendarSessionIds.Contains(x.OrganizationCalendarSessionId)));
                ValidateK12LeaFederalFunds(testData.K12LeaFederalFunds.Where(x => organizationCalendarSessionIds.Contains(x.OrganizationCalendarSessionId)));

            }


        }


        private void ValidateSchools(IdsTestDataObject testData)
        {
            ValidateOrganizationDetails(testData.OrganizationDetails.Where(x => testData.SchoolOrganizationIds.Contains(x.OrganizationId)));

            
            foreach (var item in testData.K12Schools)
            {
                Assert.NotNull(item.RefSchoolTypeId);
                Assert.NotNull(item.CharterSchoolIndicator);
                Assert.NotNull(item.RefStatePovertyDesignationId);
            }

            ValidateOrganizationWebsites(testData.OrganizationWebsites.Where(x => testData.SchoolOrganizationIds.Contains(x.OrganizationId)));

            ValidateOrganizationTelephones(testData.OrganizationTelephones.Where(x => testData.SchoolOrganizationIds.Contains(x.OrganizationId)));

            var organizationLocations = testData.OrganizationLocations.Where(x => testData.SchoolOrganizationIds.Contains(x.OrganizationId));
            ValidateOrganizationLocations(organizationLocations);

            var organizationLocationIds = organizationLocations.Select(x => x.LocationId);
            ValidateLocationAddresses(testData.LocationAddresses.Where(x => organizationLocationIds.Contains(x.LocationId)));

            ValidateOrganizationIdentifiers(testData.OrganizationIdentifiers.Where(x => testData.SchoolOrganizationIds.Contains(x.OrganizationId)));

            ValidateOrganizationIndicators(testData.OrganizationIndicators.Where(x => testData.SchoolOrganizationIds.Contains(x.OrganizationId)));

            ValidateK12titleIiilanguageInstructions(testData.K12titleIiilanguageInstructions.Where(x => testData.SchoolOrganizationIds.Contains(x.OrganizationId)));

            ValidateOrganizationRelationships(testData.OrganizationRelationships.Where(x => testData.SchoolOrganizationIds.Contains(x.OrganizationId)));

            ValidateOrganizationOperationalStatuses(testData.OrganizationOperationalStatuses.Where(x => testData.SchoolOrganizationIds.Contains(x.OrganizationId)));

            foreach (var item in testData.OrganizationFederalAccountabilities.Where(x => testData.SchoolOrganizationIds.Contains(x.OrganizationId)))
            {
                Assert.NotNull(item.RefGunFreeSchoolsActReportingStatusId);
                Assert.NotNull(item.RefHighSchoolGraduationRateIndicatorId);
                Assert.NotNull(item.RefReconstitutedStatusId);
                Assert.NotNull(item.RefCteGraduationRateInclusionId);
                Assert.NotNull(item.AmaoAypProgressAttainmentLepStudents);
                Assert.NotNull(item.PersistentlyDangerousStatus);

            }


            if (testData.OrganizationCalendars.Any(x => testData.SchoolOrganizationIds.Contains(x.OrganizationId)))
            {


                ValidateOrganizationCalendars(testData.OrganizationCalendars.Where(x => testData.SchoolOrganizationIds.Contains(x.OrganizationId)));

                var organizationCalendarIds = testData.OrganizationCalendars.Where(x => testData.SchoolOrganizationIds.Contains(x.OrganizationId)).Select(x => x.OrganizationCalendarId).ToList();

                ValidateOrganizationCalendarSessions(testData.OrganizationCalendarSessions.Where(x => organizationCalendarIds.Contains((int)x.OrganizationCalendarId)));

                var organizationCalendarSessionIds = testData.OrganizationCalendarSessions.Where(x => organizationCalendarIds.Contains((int)x.OrganizationCalendarId)).Select(x => x.OrganizationCalendarId).ToList();

                ValidateSchoolK12FederalFundAllocations(testData.K12FederalFundAllocations.Where(x => organizationCalendarSessionIds.Contains(x.OrganizationCalendarSessionId)));

            }

            Assert.NotEmpty(testData.K12SchoolGradeOffereds);

        }

        private void ValidateStudentTestData(IdsTestDataObject testData)
        {
            Assert.NotNull(testData);

            Assert.NotEmpty(testData.StudentPersonIds);
            Assert.NotEmpty(testData.Persons);
            Assert.NotEmpty(testData.PersonDetails);
            Assert.NotEmpty(testData.PersonStatuses);
            Assert.NotEmpty(testData.PersonIdentifiers);

            foreach (var item in testData.PersonDetails.Where(x => testData.StudentPersonIds.Contains(x.PersonId)))
            {
                Assert.NotNull(item.FirstName);
                Assert.NotNull(item.LastName);
                Assert.NotNull(item.RecordStartDateTime);
                Assert.NotNull(item.Birthdate);
                Assert.NotNull(item.HispanicLatinoEthnicity);
            }


        }


        private void ValidateRoleTestData(IdsTestDataObject testData)
        {
            Assert.NotNull(testData);
            Assert.NotEmpty(testData.Roles);

        }


        private void ValidatePersonnelTestData(IdsTestDataObject testData)
        {
            Assert.NotNull(testData);

            //Assert.NotEmpty(testData.StudentPersonIds);
            //Assert.NotEmpty(testData.Persons);
            //Assert.NotEmpty(testData.PersonDetails);

            //Assert.Equal(studentCount, testData.Persons.Count);
            //Assert.Equal(studentCount, testData.PersonDetails.Count);

            //foreach (var item in testData.PersonDetails.Where(x => testData.StudentPersonIds.Contains(x.PersonId)))
            //{
            //    Assert.NotNull(item.FirstName);
            //    Assert.NotNull(item.LastName);
            //    Assert.NotNull(item.RecordStartDateTime);
            //    Assert.NotNull(item.Birthdate);
            //    Assert.NotNull(item.HispanicLatinoEthnicity);
            //}


        }

        /*
        [Fact]
        public void GetTestData()
        {

            // Arrange
            int studentCount = 100;

            var odsTestDataGenerator = new OdsTestDataGenerator(new OutputHelper(), new TestDataHelper(), new OdsTestDataProfile());

            int generateOrganizationId = 0;
            int seaOrganizationId = 0;
            RefState refState = RefStateHelper.GetData().FirstOrDefault();
            var testData = odsTestDataGenerator.GetFreshTestDataObject();
            var rnd = new Random(1000);
            testData = odsTestDataGenerator.CreateGenerateOrganization(testData, out generateOrganizationId);
            testData = odsTestDataGenerator.CreateRoles(testData, generateOrganizationId);
            testData = odsTestDataGenerator.CreateSea(rnd, testData, out seaOrganizationId, out refState);

            // Act
            testData = odsTestDataGenerator.CreateOrganizations(rnd, studentCount, 1, refState);

            //Assert

            //ValidateRoleTestData(testData);
            ValidateOrganizationTestData(testData);
            //ValidateStudentTestData(testData);
            //ValidatePersonnelTestData(testData);

            //ValidateSeas(testData);
            ValidateLeas(testData);
            ValidateSchools(testData);

        }


        [Fact]
        public void GetTestData_MultipleSeas()
        {

            // Arrange
            int studentCount = 100;

            var testDataProfile = new OdsTestDataProfile();
            testDataProfile.QuantityOfSeas = 20;

            var odsTestDataGenerator = new OdsTestDataGenerator(new OutputHelper(), new TestDataHelper(), testDataProfile);
            
            int generateOrganizationId = 0;
            int seaOrganizationId = 0;
            RefState refState = RefStateHelper.GetData().FirstOrDefault();
            var testData = odsTestDataGenerator.GetFreshTestDataObject();
            var rnd = new Random(1000);
            testData = odsTestDataGenerator.CreateGenerateOrganization(testData, out generateOrganizationId);
            testData = odsTestDataGenerator.CreateRoles(testData, generateOrganizationId);
            testData = odsTestDataGenerator.CreateSea(rnd, testData, out seaOrganizationId, out refState);

            // Act
            testData = odsTestDataGenerator.CreateOrganizations(rnd, studentCount, 1, refState);

            //Assert

            //ValidateRoleTestData(testData);
            ValidateOrganizationTestData(testData);
            //ValidateStudentTestData(testData);
            //ValidatePersonnelTestData(testData);

            //ValidateSeas(testData);
            ValidateLeas(testData);
            ValidateSchools(testData);
        }
        */

        [Fact]
        public void GenerateTestData_Sql()
        {

            // Arrange
            var odsTestDataGenerator = new IdsTestDataGenerator(new OutputHelper(), new TestDataHelper(), new IdsTestDataProfile());

            // Act
            odsTestDataGenerator.GenerateTestData(1000, 10, DateTime.Now.Year, "sql", "console", "");

            //Assert
            Assert.True(true);


        }

        [Fact]
        public void GenerateTestData_CSharp()
        {

            // Arrange
            var odsTestDataGenerator = new IdsTestDataGenerator(new OutputHelper(), new TestDataHelper(), new IdsTestDataProfile());

            // Act
            odsTestDataGenerator.GenerateTestData(1000, 10, DateTime.Now.Year, "c#", "console", "");

            //Assert
            Assert.True(true);

        }


        [Fact]
        public void GenerateTestData_Json()
        {

            // Arrange
            var odsTestDataGenerator = new IdsTestDataGenerator(new OutputHelper(), new TestDataHelper(), new IdsTestDataProfile());

            // Act
            odsTestDataGenerator.GenerateTestData(1000, 10, DateTime.Now.Year, "json", "console", "");

            //Assert
            Assert.True(true);
        }


        [Fact]
        public void GenerateTestData_Execute()
        {

            // Arrange
            var odsTestDataGenerator = new IdsTestDataGenerator(new OutputHelper(), new TestDataHelper(), new IdsTestDataProfile());

            // Act
            odsTestDataGenerator.GenerateTestData(1000, 10, DateTime.Now.Year, "sql", "execute", "");

            //Assert
            Assert.True(true);
        }

    }
}
