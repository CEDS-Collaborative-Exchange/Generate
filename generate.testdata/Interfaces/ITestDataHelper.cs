using System;
using System.Collections.Generic;
using generate.core.Models.IDS;

namespace generate.testdata.Interfaces
{
    public interface ITestDataHelper
    {

        #region Dates & Times
        DateTime GetSessionStartDate(Random rnd, int calendarYear);
        DateTime GetSessionEndDate(Random rnd, int calendarYear);
        DateTime GetRandomDate(Random rnd, int schoolYear, int maxYearsAgo = 0, int maxYearsAhead = 0);
        DateTime GetBirthDate(Random rnd, int schoolYear, int minimumAge = 0, int maximumAge = 105);
        DateTime GetSchoolYearDate(Random rnd, int schoolYear, int minimumAge = 0, int maximumAge = 105);
        DateTime GetQualifyingArrivalDate(Random rnd, DateTime noLaterThanDate);
        DateTime GetEntryDate(Random rnd, DateTime beginDate);
        DateTime GetExitDate(Random rnd, DateTime startDate, DateTime endDate);
        DateTime GetRandomDateInRange(Random rnd, DateTime beginDate, DateTime endDate);
        DateTime GetRandomDateAfter(Random rnd, DateTime beginDate, int maximumDays, DateTime? maximumDate = null);
        TimeSpan GetRandomTimeSpan(Random rnd);
        #endregion

        #region Lookup Functions
        T GetRandomObject<T>(Random rnd, List<T> objects);
        List<T> GetRandomObjects<T>(Random rnd, List<T> objects, int quantity);
        int GetRandomInt(Random rnd, List<int> numbers);
        int GetRandomIntInRange(Random rnd, int min, int max);
        decimal GetRandomDecimalInRange(Random rnd, int min, int max);
        int GetRandomIntWeighted(Random rnd, int min, int max, int typicalMin, int typicalMax, double typicalProbability);
        string GetRandomString(Random rnd, List<string> strings);
        int GetWeightedSelection(Random rnd, List<DataDistribution<int>> items);
        bool GetWeightedSelection(Random rnd, List<DataDistribution<bool>> items);
        bool? GetWeightedSelection(Random rnd, List<DataDistribution<bool?>> items);
        string GetWeightedSelection(Random rnd, List<DataDistribution<string>> items);
        decimal GetWeightedSelection(Random rnd, List<DataDistribution<decimal>> items);
        string MakeAcronym(string input);

        #endregion

        #region Dummy Data
        List<KeyValuePair<string, string>> ListofStates();
        List<string> ListofFemaleNames();
        List<string> ListofLastNames();
        List<string> ListofMaleNames();
        List<string> ListofSexes();
        List<string> ListofPlaceNames();
        List<string> ListofSchoolNameTypes();
        List<string> ListofStreetTypes();
        List<string> ListofUnitTypes();
        string GetK12SeaName(string StateName);
        string GetK12LeaName(Random rnd, List<string> placeNames);
        string GetK12SchoolName(Random rnd, List<string> placeNames, List<string> schoolTypes);
        string GetK12SchoolName(Random rnd, List<string> placeNames, string schoolType);
        string GetStreetName(Random rnd, List<string> placeNames, List<string> streetTypes);
        string GetCityName(Random rnd, List<string> placeNames);
        string GetUnitType(Random rnd, List<string> unitTypes);

        #endregion

    }
}