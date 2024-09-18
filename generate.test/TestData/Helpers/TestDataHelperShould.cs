using generate.shared.Utilities;
using generate.testdata;
using generate.testdata.Helpers;
using generate.testdata.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace generate.test.TestData.Helpers
{
    public class TestDataHelperShould
    {
        private readonly ITestDataHelper _testDataHelper;

        public TestDataHelperShould()
        {
            _testDataHelper = new TestDataHelper();
        }

        #region Dates

        [Fact]
        public void GetSessionStartDate()
        {
            var rnd = new Random();
            var year = 2018;
            var actual = _testDataHelper.GetSessionStartDate(rnd, year);
            var expected = year - 1;

            Assert.IsType<DateTime>(actual);
            Assert.Equal(expected, actual.Year);
        }

        [Fact]
        public void GetSessionEndDate()
        {
            var rnd = new Random();
            var year = 2018;
            var actual = _testDataHelper.GetSessionEndDate(rnd, year);
            var expected = year;

            Assert.IsType<DateTime>(actual);
            Assert.Equal(expected, actual.Year);
        }

        [Fact]
        public void GetRandomDate()
        {
            var rnd = new Random();
            var year = DateTime.Now.Year;
            var actual = _testDataHelper.GetRandomDate(rnd, 0, 0);
            var expected = year;

            Assert.IsType<DateTime>(actual);
            Assert.Equal(expected, actual.Year);
        }


        [Fact]
        public void GetSchoolYearDate()
        {
            var rnd = new Random();
            var year = DateTime.Now.Year;
            var actual = _testDataHelper.GetSchoolYearDate(rnd, 5, 5);
            var expected = year - 5;

            Assert.IsType<DateTime>(actual);
            Assert.Equal(expected, actual.Year);
        }


        [Fact]
        public void GetBirthDate()
        {
            var rnd = new Random();
            var year = DateTime.Now.Year;
            var actual = _testDataHelper.GetBirthDate(rnd, 5, 5);
            var expected = year - 5;

            Assert.IsType<DateTime>(actual);
            Assert.Equal(expected, actual.Year);
        }

        [Fact]
        public void GetQualifyingArrivalDate()
        {
            var rnd = new Random();
            var date = DateTime.Now.AddDays(5);
            var actual = _testDataHelper.GetQualifyingArrivalDate(rnd, date);

            Assert.IsType<DateTime>(actual);
            Assert.True(actual <= date);
            Assert.True(actual >= date.AddDays(-45));

        }


        [Fact]
        public void GetEntryDate()
        {
            var rnd = new Random();
            var date = DateTime.Now;
            var actual = _testDataHelper.GetEntryDate(rnd, date);

            Assert.IsType<DateTime>(actual);
            Assert.True(actual >= date);

        }

        [Fact]
        public void GetExitDate()
        {
            var rnd = new Random();
            var startDate = DateTime.Now;
            var endDate = startDate.AddDays(10);
            var actual = _testDataHelper.GetExitDate(rnd, startDate, endDate);

            Assert.IsType<DateTime>(actual);
            Assert.True(actual >= startDate);
            Assert.True(actual <= endDate);

        }


        [Fact]
        public void GetRandomDateInRange()
        {
            var rnd = new Random();
            var startDate = DateTime.Now;
            var endDate = startDate.AddDays(10);
            var actual = _testDataHelper.GetRandomDateInRange(rnd, startDate, endDate);

            Assert.IsType<DateTime>(actual);
            Assert.True(actual >= startDate);
            Assert.True(actual <= endDate);

        }


        [Fact]
        public void GetRandomDateAfter()
        {
            var rnd = new Random();
            var startDate = DateTime.Now;
            var endDate = startDate.AddDays(10);
            var actual = _testDataHelper.GetRandomDateAfter(rnd, startDate, 10, endDate);

            Assert.IsType<DateTime>(actual);
            Assert.True(actual >= startDate);
            Assert.True(actual <= endDate);

            actual = _testDataHelper.GetRandomDateAfter(rnd, startDate, 10);

            Assert.IsType<DateTime>(actual);
            Assert.True(actual >= startDate);
            Assert.True(actual <= endDate);

        }

        #endregion

        #region Lookup Functions

        [Fact]
        public void GetRandomObject()
        {
            var rnd = new Random();
            List<int> ids = new List<int>();
            ids.Add(1);
            ids.Add(2);

            int testId = _testDataHelper.GetRandomObject<int>(rnd, ids);

            Assert.InRange<int>(testId, 1, 2);
        }

        [Fact]
        public void GetRandomObjects()
        {
            var rnd = new Random();
            List<int> ids = new List<int>();
            ids.Add(1);
            ids.Add(2);

            List<int> testIds = _testDataHelper.GetRandomObjects<int>(rnd, ids, 2);

            Assert.NotEmpty(testIds);
            Assert.Equal(2, testIds.Count);
        }

        [Fact]
        public void GetRandomObjects_QuanityGreaterThanCount()
        {
            var rnd = new Random();
            List<int> ids = new List<int>();
            ids.Add(1);
            ids.Add(2);

            List<int> testIds = _testDataHelper.GetRandomObjects<int>(rnd, ids, 3);

            Assert.NotEmpty(testIds);
            Assert.Equal(2, testIds.Count);
        }


        [Fact]
        public void GetRandomInt()
        {
            var rnd = new Random();
            List<int> ids = new List<int>();
            ids.Add(1);
            ids.Add(2);

            int testId = _testDataHelper.GetRandomInt(rnd, ids);

            Assert.InRange<int>(testId, 1, 2);
        }

        [Fact]
        public void GetRandomIntInRange()
        {
            var rnd = new Random();
            int testId = _testDataHelper.GetRandomIntInRange(rnd, 1, 5);

            Assert.InRange<int>(testId, 1, 5);
        }


        [Fact]
        public void GetRandomDecimalInRange()
        {
            var rnd = new Random();
            decimal testId = _testDataHelper.GetRandomDecimalInRange(rnd, 1, 5);

            Assert.InRange<decimal>(testId, 1, 5);
        }

        [Fact]
        public void GetRandomIntWeighted()
        {
            var rnd = new Random();
            int testId = _testDataHelper.GetRandomIntWeighted(rnd, 1, 5, 1, 5, 0.80);

            Assert.InRange<int>(testId, 1, 5);
        }


        [Fact]
        public void GetRandomString()
        {
            var rnd = new Random();
            List<string> strings = new List<string>();
            strings.Add("1");
            strings.Add("2");

            string testId = _testDataHelper.GetRandomString(rnd, strings);

            Assert.NotNull(testId);
        }

        [Fact]
        public void GetWeightedSelectionBool()
        {
            var rnd = new Random();
            List<DataDistribution<bool>> items = new List<DataDistribution<bool>>();

            items.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 0 });
            items.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 1000 });


            bool item = _testDataHelper.GetWeightedSelection(rnd, items);

            Assert.False(item);

        }


        [Fact]
        public void GetWeightedSelectionBoolQuestion()
        {
            var rnd = new Random();
            List<DataDistribution<bool?>> items = new List<DataDistribution<bool?>>();

            items.Add(new DataDistribution<bool?>() { Option = true, ExpectedDistribution = 0 });
            items.Add(new DataDistribution<bool?>() { Option = false, ExpectedDistribution = 0 });
            items.Add(new DataDistribution<bool?>() { Option = null, ExpectedDistribution = 1000 });


            bool? item = _testDataHelper.GetWeightedSelection(rnd, items);

            Assert.Null(item);

        }

        [Fact]
        public void GetWeightedSelectionInt()
        {
            var rnd = new Random();
            List<DataDistribution<int>> items = new List<DataDistribution<int>>();

            items.Add(new DataDistribution<int>() { Option = 1, ExpectedDistribution = 0 });
            items.Add(new DataDistribution<int>() { Option = 4, ExpectedDistribution = 1000 });


            int item = _testDataHelper.GetWeightedSelection(rnd, items);

            Assert.Equal(4, item);

        }


        [Fact]
        public void GetWeightedSelectionString()
        {
            var rnd = new Random();
            List<DataDistribution<string>> items = new List<DataDistribution<string>>();

            items.Add(new DataDistribution<string>() { Option = "1", ExpectedDistribution = 0 });
            items.Add(new DataDistribution<string>() { Option = "4", ExpectedDistribution = 1000 });


            string item = _testDataHelper.GetWeightedSelection(rnd, items);

            Assert.Equal("4", item);

        }


        [Fact]
        public void MakeAcronym()
        {
            string input = "George Washington High School";
            string output = _testDataHelper.MakeAcronym(input);

            Assert.Equal("GWHS", output);

        }

        #endregion

        #region Dummy Data

        [Fact]
        public void ListofSexes()
        {
            var actual = _testDataHelper.ListofSexes();

            Assert.IsType<List<string>>(actual);
            Assert.NotEmpty(actual);
        }

        [Fact]
        public void ListofMaleNames()
        {
            var actual = _testDataHelper.ListofMaleNames();

            Assert.IsType<List<string>>(actual);
            Assert.NotEmpty(actual);
        }

        [Fact]
        public void ListofFemaleNames()
        {
            var actual = _testDataHelper.ListofFemaleNames();

            Assert.IsType<List<string>>(actual);
            Assert.NotEmpty(actual);
        }


        [Fact]
        public void ListofLastNames()
        {
            var actual = _testDataHelper.ListofLastNames();

            Assert.IsType<List<string>>(actual);
            Assert.NotEmpty(actual);
        }

        [Fact]
        public void ListofPlaceNames()
        {
            var actual = _testDataHelper.ListofPlaceNames();

            Assert.IsType<List<string>>(actual);
            Assert.NotEmpty(actual);
        }

        [Fact]
        public void ListofSchoolNameTypes()
        {
            var actual = _testDataHelper.ListofSchoolNameTypes();

            Assert.IsType<List<string>>(actual);
            Assert.NotEmpty(actual);
        }


        [Fact]
        public void ListofStreetTypes()
        {
            var actual = _testDataHelper.ListofStreetTypes();

            Assert.IsType<List<string>>(actual);
            Assert.NotEmpty(actual);
        }

        [Fact]
        public void GetK12SeaName()
        {
            var actual = _testDataHelper.GetK12SeaName("Colorado");

            Assert.Equal("Colorado State Education Agency", actual);
        }

        [Fact]
        public void GetK12LeaName()
        {
            var rnd = new Random();
            List<string> lst = new List<string>();
            lst.Add("Test");

            var actual = _testDataHelper.GetK12LeaName(rnd, lst);

            Assert.Equal("Test School District", actual);
        }


        [Fact]
        public void GetK12SchoolName()
        {
            var rnd = new Random();
            List<string> lst = new List<string>();
            lst.Add("Test");

            List<string> lst2 = new List<string>();
            lst2.Add("High School");

            var actual = _testDataHelper.GetK12SchoolName(rnd, lst, lst2);

            Assert.Equal("Test High School", actual);
        }


        [Fact]
        public void GetK12SchoolName_SpecificType()
        {
            var rnd = new Random();
            List<string> lst = new List<string>();
            lst.Add("Test");

            var actual = _testDataHelper.GetK12SchoolName(rnd, lst, "High School");

            Assert.Equal("Test High School", actual);
        }


        [Fact]
        public void GetStreetName()
        {
            var rnd = new Random();
            List<string> lst = new List<string>();
            lst.Add("Test");

            List<string> lst2 = new List<string>();
            lst2.Add("Boulevard");

            var actual = _testDataHelper.GetStreetName(rnd, lst, lst2);

            Assert.Equal("Test Boulevard", actual);
        }


        [Fact]
        public void GetCityName()
        {
            var rnd = new Random();
            List<string> lst = new List<string>();
            lst.Add("Test");


            var actual = _testDataHelper.GetCityName(rnd, lst);

            Assert.Equal("Test", actual);
        }

        [Fact]
        public void GetUnitType()
        {
            var rnd = new Random();
            List<string> lst = new List<string>();
            lst.Add("Suite #");


            var actual = _testDataHelper.GetUnitType(rnd, lst);

            Assert.Equal("Suite #", actual);
        }


        #endregion

    }
}
