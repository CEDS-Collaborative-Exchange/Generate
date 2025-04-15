using System.Linq;
using generate.core.Models.App;
using System.Collections.Generic;
using System;
using System.Threading.Tasks;
using generate.testdata.Interfaces;

namespace generate.testdata.Helpers
{

    public class TestDataHelper : ITestDataHelper
    {

        private Random _rnd;

        public TestDataHelper()
        {
            _rnd = new Random();
        }

        #region Dates

        public DateTime GetSessionStartDate(Random rnd, int calendarYear)
        {
            DateTime startDate = new DateTime(calendarYear - 1, 8, 5);
            int maximumDays = 30;
            DateTime randomDate = startDate.AddDays(rnd.Next(maximumDays));
            return randomDate;
        }

        public DateTime GetSessionEndDate(Random rnd, int calendarYear)
        {
            DateTime startDate = new DateTime(calendarYear, 5, 5);
            int maximumDays = 30;
            DateTime randomDate = startDate.AddDays(rnd.Next(maximumDays));
            return randomDate;
        }


        public DateTime GetRandomDate(Random rnd, int schoolYear, int maxYearsAgo = 0, int maxYearsAhead = 0)
        {
            DateTime startDate = new DateTime(schoolYear, DateTime.Now.Month, DateTime.Now.Day).AddYears(maxYearsAgo * -1);
            int maximumDays = (maxYearsAgo * 365) + (maxYearsAhead * 365);
            DateTime randomDate = startDate.AddDays(rnd.Next(maximumDays));

            return randomDate;
        }

        public DateTime GetSchoolYearDate(Random rnd, int schoolYear, int minimumAge = 0, int maximumAge = 105)
        {
            DateTime startDate = new DateTime(schoolYear, DateTime.Now.Month, DateTime.Now.Day).AddYears(maximumAge * -1);
            int maximumDays = (maximumAge * 365) - (minimumAge * 365);
            DateTime randomDate = startDate.AddDays(rnd.Next(maximumDays));

            return randomDate;
        }
        
        public DateTime GetBirthDate(Random rnd, int schoolYear, int minimumAge = 0, int maximumAge = 105)
        {
            int day = DateTime.Now.Day;
            if (day > 1) { day = day - 1; }
            DateTime startDate = new DateTime(schoolYear, DateTime.Now.Month, day).AddYears(maximumAge * -1);
            int maximumDays = (maximumAge * 365) - (minimumAge * 365);
            DateTime birthdate = startDate.AddDays(rnd.Next(maximumDays));

            return birthdate;
        }

        public DateTime GetQualifyingArrivalDate(Random rnd, DateTime noLaterThanDate)
        {
            return noLaterThanDate.AddDays(this.GetRandomIntInRange(_rnd, -45, 0));
        }

        public DateTime GetEntryDate(Random rnd, DateTime beginDate)
        {

            List<DataDistribution<bool>> hasEntryDateEqualToSessionBeginDateOptions = new List<DataDistribution<bool>>();
            hasEntryDateEqualToSessionBeginDateOptions.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 90 });
            hasEntryDateEqualToSessionBeginDateOptions.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            bool hasEntryDateEqualToSessionBeginDate = this.GetWeightedSelection(_rnd, hasEntryDateEqualToSessionBeginDateOptions);

            DateTime entryDate = beginDate;

            if (!hasEntryDateEqualToSessionBeginDate)
            {
                int maximumDays = (90);
                entryDate = entryDate.AddDays(rnd.Next(maximumDays));
            }


            return entryDate;
        }

        public DateTime GetExitDate(Random rnd, DateTime startDate, DateTime endDate)
        {
            int fullDuration = (endDate - startDate).Days;
            DateTime exitDate = endDate;

            List<DataDistribution<bool>> hasExitDateEqualToSessionEndDateOptions = new List<DataDistribution<bool>>();
            hasExitDateEqualToSessionEndDateOptions.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 70 });
            hasExitDateEqualToSessionEndDateOptions.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            bool hasExitDateEqualToSessionEndDate = this.GetWeightedSelection(_rnd, hasExitDateEqualToSessionEndDateOptions);
            
            if (!hasExitDateEqualToSessionEndDate)
            {
                exitDate = exitDate.AddDays(rnd.Next(fullDuration) * -1);

                while (startDate > exitDate)
                {
                    exitDate = exitDate.AddDays(rnd.Next(fullDuration) * -1);
                }
            }
            
            return exitDate;
        }

        public DateTime GetRandomDateInRange(Random rnd, DateTime beginDate, DateTime endDate)
        {

            DateTime randomDate = beginDate;

            if (endDate > beginDate)
            {
                int maximumDays = (endDate - beginDate).Days;
                randomDate = randomDate.AddDays(rnd.Next(maximumDays));
            }
            return randomDate;
        }

        public DateTime GetRandomDateAfter(Random rnd, DateTime beginDate, int maximumDays, DateTime? maximumDate = null)
        {
            DateTime randomDate = beginDate;

            int daysToAdd = rnd.Next(maximumDays);
            randomDate = beginDate.AddDays(daysToAdd);

            if (maximumDate.HasValue)
            {
                bool generatedDate = false;
                while (randomDate > maximumDate || !generatedDate)
                {
                    daysToAdd = rnd.Next(maximumDays);
                    randomDate = beginDate.AddDays(daysToAdd);
                    generatedDate = true;
                }
            }

            return randomDate;
        }

        #endregion

        #region Lookup Functions

        public T GetRandomObject<T>(Random rnd, List<T> objects)
        {
            int r = rnd.Next(objects.Count);
            T obj = objects[r];
            return obj;
        }

        public List<T> GetRandomObjects<T>(Random rnd, List<T> objects, int quantity)
        {
            if (quantity > objects.Count)
            {
                quantity = objects.Count;
            }

            List<T> returnedObjects = new List<T>();

            for (int i = 0; i < quantity; i++)
            {
                int r = rnd.Next(objects.Count);
                returnedObjects.Add(objects[r]);
                objects.RemoveAt(r);
            }
            return returnedObjects;
        }

        public int GetRandomInt(Random rnd, List<int> numbers)
        {
            int r = rnd.Next(numbers.Count);
            int randomInt = numbers[r];
            return randomInt;

        }

        public int GetRandomIntInRange(Random rnd, int min, int max)
        {
            int randomInt = rnd.Next(min, max);
            return randomInt;
        }

        public decimal GetRandomDecimalInRange(Random rnd, int min, int max)
        {
            decimal randomDecimal = Convert.ToDecimal(rnd.Next(min, max)) / 100M;
            return randomDecimal;
        }

        public int GetRandomIntWeighted(Random rnd, int min, int max, int typicalMin, int typicalMax, double typicalProbability)
        {
            int randomInt = rnd.Next(min, max);

            while ((randomInt < typicalMin || randomInt > typicalMax) && rnd.NextDouble() < typicalProbability)
            {
                randomInt = rnd.Next(min, max);
            }

            return randomInt;
        }


        public string GetRandomString(Random rnd, List<string> strings)
        {
            string randomString = "";

            int r = rnd.Next(strings.Count);
            randomString = strings[r];

            return randomString;
        }

        public bool GetWeightedSelection(Random rnd, List<DataDistribution<bool>> items)
        {
            int totalWeight = items.Max(i => i.ExpectedDistribution);
            int rndValue = rnd.Next(0, totalWeight);
            var selectedItem = items.First(item => rndValue <= item.ExpectedDistribution);
            return selectedItem.Option;
        }

        public bool? GetWeightedSelection(Random rnd, List<DataDistribution<bool?>> items)
        {
            int totalWeight = items.Max(i => i.ExpectedDistribution);
            int rndValue = rnd.Next(0, totalWeight);
            var selectedItem = items.First(item => rndValue <= item.ExpectedDistribution);
            return selectedItem.Option;
        }

        public int GetWeightedSelection(Random rnd, List<DataDistribution<int>> items)
        {
            int totalWeight = items.Max(i => i.ExpectedDistribution);
            int rndValue = rnd.Next(0, totalWeight);
            var selectedItem = items.First(item => rndValue <= item.ExpectedDistribution);
            return selectedItem.Option;
        }

        public int GetMaxWeightedSelection(Random rnd, List<DataDistribution<int>> items)
        {
            int totalWeight = items.Max(i => i.ExpectedDistribution);
            int rndValue = rnd.Next(totalWeight - 10, totalWeight);
            var selectedItem = items.First(item => rndValue <= item.ExpectedDistribution);
            return selectedItem.Option;
        }

        public string GetWeightedSelection(Random rnd, List<DataDistribution<string>> items)
        {
            int totalWeight = items.Max(i => i.ExpectedDistribution);
            int rndValue = rnd.Next(0, totalWeight);
            var selectedItem = items.First(item => rndValue <= item.ExpectedDistribution);
            return selectedItem.Option;
        }
        public decimal GetWeightedSelection(Random rnd, List<DataDistribution<decimal>> items)
        {
            int totalWeight = items.Max(i => i.ExpectedDistribution);
            int rndValue = rnd.Next(0, totalWeight);
            var selectedItem = items.First(item => rndValue <= item.ExpectedDistribution);
            return selectedItem.Option;
        }
        public string MakeAcronym(string input)
        {
            string acronym = string.Join(string.Empty,
              input.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries).Select(s => s[0])
            );

            return acronym;
        }
        
        #endregion

        #region Dummy Data

        public List<KeyValuePair<string, string>> ListofStates()
        {
            Dictionary<string, string> states = new Dictionary<string, string>();

            states.Add("AK", "Alaska");
            states.Add("AL", "Alabama");
            states.Add("AR", "Arkansas");
            states.Add("AS", "American Samoa");
            states.Add("AZ", "Arizona");
            states.Add("CA", "California");
            states.Add("CO", "Colorado");
            states.Add("CT", "Connecticut");
            states.Add("DC", "District of Columbia");
            states.Add("DE", "Delaware");
            states.Add("FL", "Florida");
            states.Add("FM", "Federated States of Micronesia");
            states.Add("GA", "Georgia");
            states.Add("GU", "Guam");
            states.Add("HI", "Hawaii");
            states.Add("IA", "Iowa");
            states.Add("ID", "Idaho");
            states.Add("IL", "Illinois");
            states.Add("IN", "Indiana");
            states.Add("KS", "Kansas");
            states.Add("KY", "Kentucky");
            states.Add("LA", "Louisiana");
            states.Add("MA", "Massachusetts");
            states.Add("MD", "Maryland");
            states.Add("ME", "Maine");
            states.Add("MH", "Marshall Islands");
            states.Add("MI", "Michigan");
            states.Add("MN", "Minnesota");
            states.Add("MO", "Missouri");
            states.Add("MP", "Northern Marianas");
            states.Add("MS", "Mississippi");
            states.Add("MT", "Montana");
            states.Add("NC", "North Carolina");
            states.Add("ND", "North Dakota");
            states.Add("NE", "Nebraska");
            states.Add("NH", "New Hampshire");
            states.Add("NJ", "New Jersey");
            states.Add("NM", "New Mexico");
            states.Add("NV", "Nevada");
            states.Add("NY", "New York");
            states.Add("OH", "Ohio");
            states.Add("OK", "Oklahoma");
            states.Add("OR", "Oregon");
            states.Add("PA", "Pennsylvania");
            states.Add("PR", "Puerto Rico");
            states.Add("PW", "Palau");
            states.Add("RI", "Rhode Island");
            states.Add("SC", "South Carolina");
            states.Add("SD", "South Dakota");
            states.Add("TN", "Tennessee");
            states.Add("TX", "Texas");
            states.Add("UT", "Utah");
            states.Add("VA", "Virginia");
            states.Add("VI", "Virgin Islands");
            states.Add("VT", "Vermont");
            states.Add("WA", "Washington");
            states.Add("WI", "Wisconsin");
            states.Add("WV", "West Virginia");
            states.Add("WY", "Wyoming");
            states.Add("AA", "Armed Forces America");
            states.Add("AE", "Armed Forces Africa, Canada, Europe, and Mideast");
            states.Add("AP", "Armed Forces Pacific");

            return states.ToList();
        }

        public List<string> ListofSexes()
        {
            List<string> sexes = new List<string>();

            sexes.Add("Male");
            sexes.Add("Female");

            return sexes;
        }
        
        public List<string> ListofMaleNames()
        {
        
            List<string> names = new List<string>();

            names.Add("Aaron");
            names.Add("Abbot");
            names.Add("Abdul");
            names.Add("Abel");
            names.Add("Abraham");
            names.Add("Acton");
            names.Add("Adam");
            names.Add("Addison");
            names.Add("Adrian");
            names.Add("Ahmed");
            names.Add("Aidan");
            names.Add("Akeem");
            names.Add("Aladdin");
            names.Add("Alan");
            names.Add("Alden");
            names.Add("Alec");
            names.Add("Alexander");
            names.Add("Alfonso");
            names.Add("Ali");
            names.Add("Allen");
            names.Add("Allistair");
            names.Add("Alvin");
            names.Add("Amal");
            names.Add("Amery");
            names.Add("Amir");
            names.Add("Amos");
            names.Add("Andrew");
            names.Add("Anil");
            names.Add("Anthony");
            names.Add("Aquila");
            names.Add("Arden");
            names.Add("Aristotle");
            names.Add("Armand");
            names.Add("Armando");
            names.Add("Arsenio");
            names.Add("Arthur");
            names.Add("Asher");
            names.Add("Ashton");
            names.Add("August");
            names.Add("Austin");
            names.Add("Avram");
            names.Add("Axel");
            names.Add("Baker");
            names.Add("Barclay");
            names.Add("Barrett");
            names.Add("Barry");
            names.Add("Basil");
            names.Add("Baxter");
            names.Add("Beau");
            names.Add("Beck");
            names.Add("Benedict");
            names.Add("Benjamin");
            names.Add("Berk");
            names.Add("Bernard");
            names.Add("Bert");
            names.Add("Bevis");
            names.Add("Bill");
            names.Add("Blake");
            names.Add("Blaze");
            names.Add("Bob");
            names.Add("Bobby");
            names.Add("Boris");
            names.Add("Bradley");
            names.Add("Branden");
            names.Add("Brandon");
            names.Add("Brenden");
            names.Add("Brennan");
            names.Add("Brent");
            names.Add("Brett");
            names.Add("Brian");
            names.Add("Brock");
            names.Add("Brody");
            names.Add("Bruce");
            names.Add("Bruno");
            names.Add("Buckminster");
            names.Add("Burke");
            names.Add("Burton");
            names.Add("Cade");
            names.Add("Cadman");
            names.Add("Caesar");
            names.Add("Cain");
            names.Add("Cairo");
            names.Add("Caldwell");
            names.Add("Caleb");
            names.Add("Callum");
            names.Add("Calvin");
            names.Add("Camden");
            names.Add("Cameron");
            names.Add("Carl");
            names.Add("Carlos");
            names.Add("Carson");
            names.Add("Carter");
            names.Add("Cedric");
            names.Add("Chadwick");
            names.Add("Chaim");
            names.Add("Chancellor");
            names.Add("Chandler");
            names.Add("Channing");
            names.Add("Charles");
            names.Add("Chase");
            names.Add("Chester");
            names.Add("Christian");
            names.Add("Christopher");
            names.Add("Ciaran");
            names.Add("Clark");
            names.Add("Clarke");
            names.Add("Clayton");
            names.Add("Clinton");
            names.Add("Coby");
            names.Add("Cody");
            names.Add("Colby");
            names.Add("Cole");
            names.Add("Colin");
            names.Add("Colorado");
            names.Add("Colt");
            names.Add("Colton");
            names.Add("Conan");
            names.Add("Connor");
            names.Add("Cooper");
            names.Add("Craig");
            names.Add("Cruz");
            names.Add("Cullen");
            names.Add("Curran");
            names.Add("Cyrus");
            names.Add("Dale");
            names.Add("Dalton");
            names.Add("Damian");
            names.Add("Damon");
            names.Add("Dane");
            names.Add("Daniel");
            names.Add("Dante");
            names.Add("Daquan");
            names.Add("Darius");
            names.Add("David");
            names.Add("Davis");
            names.Add("Deacon");
            names.Add("Dean");
            names.Add("Declan");
            names.Add("Demetrius");
            names.Add("Dennis");
            names.Add("Derek");
            names.Add("Devin");
            names.Add("Dexter");
            names.Add("Dieter");
            names.Add("Dillon");
            names.Add("Dolan");
            names.Add("Dominic");
            names.Add("Donovan");
            names.Add("Dorian");
            names.Add("Doug");
            names.Add("Douglas");
            names.Add("Drake");
            names.Add("Drew");
            names.Add("Driscoll");
            names.Add("Duncan");
            names.Add("Dustin");
            names.Add("Dylan");
            names.Add("Eagan");
            names.Add("Eaton");
            names.Add("Edan");
            names.Add("Edward");
            names.Add("Elijah");
            names.Add("Elliott");
            names.Add("Elmo");
            names.Add("Elton");
            names.Add("Elvis");
            names.Add("Emerson");
            names.Add("Emery");
            names.Add("Emmanuel");
            names.Add("Enrique");
            names.Add("Erasmus");
            names.Add("Eric");
            names.Add("Erich");
            names.Add("Ethan");
            names.Add("Evan");
            names.Add("Ezekiel");
            names.Add("Ezra");
            names.Add("Felix");
            names.Add("Ferdinand");
            names.Add("Ferris");
            names.Add("Finn");
            names.Add("Fitzgerald");
            names.Add("Fletcher");
            names.Add("Flynn");
            names.Add("Forrest");
            names.Add("Francis");
            names.Add("Frank");
            names.Add("Fritz");
            names.Add("Fuller");
            names.Add("Fulton");
            names.Add("Gabriel");
            names.Add("Gage");
            names.Add("Galvin");
            names.Add("Gannon");
            names.Add("Gareth");
            names.Add("Garrett");
            names.Add("Garrison");
            names.Add("Garth");
            names.Add("Gary");
            names.Add("Gavin");
            names.Add("Geoffrey");
            names.Add("George");
            names.Add("Giacomo");
            names.Add("Gil");
            names.Add("Grady");
            names.Add("Graham");
            names.Add("Graiden");
            names.Add("Grant");
            names.Add("Gray");
            names.Add("Gregory");
            names.Add("Griffin");
            names.Add("Griffith");
            names.Add("Guy");
            names.Add("Hakeem");
            names.Add("Hall");
            names.Add("Hamilton");
            names.Add("Hamish");
            names.Add("Hammett");
            names.Add("Harding");
            names.Add("Harlan");
            names.Add("Harper");
            names.Add("Harrison");
            names.Add("Hasad");
            names.Add("Hashim");
            names.Add("Hayden");
            names.Add("Hayes");
            names.Add("Hector");
            names.Add("Hedley");
            names.Add("Henry");
            names.Add("Herman");
            names.Add("Herrod");
            names.Add("Hilel");
            names.Add("Hiram");
            names.Add("Holmes");
            names.Add("Honorato");
            names.Add("Hop");
            names.Add("Howard");
            names.Add("Hoyt");
            names.Add("Hu");
            names.Add("Hunter");
            names.Add("Hyatt");
            names.Add("Ian");
            names.Add("Ignatius");
            names.Add("Igor");
            names.Add("Ira");
            names.Add("Isaac");
            names.Add("Isaiah");
            names.Add("Ishmael");
            names.Add("Ivan");
            names.Add("Ivor");
            names.Add("Jack");
            names.Add("Jackson");
            names.Add("Jacob");
            names.Add("Jakeem");
            names.Add("Jamal");
            names.Add("James");
            names.Add("Jameson");
            names.Add("Jared");
            names.Add("Jarrod");
            names.Add("Jason");
            names.Add("Jasper");
            names.Add("Jelani");
            names.Add("Jeremy");
            names.Add("Jermaine");
            names.Add("Jerome");
            names.Add("Jerry");
            names.Add("Jesse");
            names.Add("Jin");
            names.Add("Joel");
            names.Add("John");
            names.Add("Jonah");
            names.Add("Jonas");
            names.Add("Jordan");
            names.Add("Joseph");
            names.Add("Joshua");
            names.Add("Josiah");
            names.Add("Judah");
            names.Add("Julian");
            names.Add("Justin");
            names.Add("Kadeem");
            names.Add("Kamal");
            names.Add("Kane");
            names.Add("Kareem");
            names.Add("Kaseem");
            names.Add("Kasimir");
            names.Add("Kasper");
            names.Add("Kato");
            names.Add("Keane");
            names.Add("Keaton");
            names.Add("Keefe");
            names.Add("Keegan");
            names.Add("Keith");
            names.Add("Kelly");
            names.Add("Kennan");
            names.Add("Kennedy");
            names.Add("Kenneth");
            names.Add("Kenyon");
            names.Add("Kermit");
            names.Add("Kevin");
            names.Add("Kibo");
            names.Add("Kieran");
            names.Add("Kirk");
            names.Add("Knox");
            names.Add("Kuame");
            names.Add("Kyle");
            names.Add("Laith");
            names.Add("Lamar");
            names.Add("Lance");
            names.Add("Lane");
            names.Add("Lars");
            names.Add("Lawrence");
            names.Add("Lee");
            names.Add("Len");
            names.Add("Leo");
            names.Add("Leonard");
            names.Add("Leroy");
            names.Add("Lester");
            names.Add("Lev");
            names.Add("Levi");
            names.Add("Lewis");
            names.Add("Linus");
            names.Add("Lionel");
            names.Add("Logan");
            names.Add("Louis");
            names.Add("Lucas");
            names.Add("Lucian");
            names.Add("Lucius");
            names.Add("Luke");
            names.Add("Lyle");
            names.Add("Macaulay");
            names.Add("Macon");
            names.Add("Magee");
            names.Add("Malachi");
            names.Add("Malcolm");
            names.Add("Malik");
            names.Add("Mannix");
            names.Add("Mark");
            names.Add("Marsden");
            names.Add("Marshall");
            names.Add("Martin");
            names.Add("Marvin");
            names.Add("Mason");
            names.Add("Matthew");
            names.Add("Maxwell");
            names.Add("Melvin");
            names.Add("Merrill");
            names.Add("Merritt");
            names.Add("Micah");
            names.Add("Michael");
            names.Add("Mike");
            names.Add("Mohammad");
            names.Add("Moses");
            names.Add("Mufutau");
            names.Add("Murphy");
            names.Add("Myles");
            names.Add("Nash");
            names.Add("Nasim");
            names.Add("Nathan");
            names.Add("Nathaniel");
            names.Add("Nehru");
            names.Add("Neil");
            names.Add("Nero");
            names.Add("Neville");
            names.Add("Nicholas");
            names.Add("Nigel");
            names.Add("Nissim");
            names.Add("Noah");
            names.Add("Noble");
            names.Add("Nolan");
            names.Add("Norman");
            names.Add("Octavius");
            names.Add("Odysseus");
            names.Add("Oleg");
            names.Add("Oliver");
            names.Add("Omar");
            names.Add("Oren");
            names.Add("Orlando");
            names.Add("Orson");
            names.Add("Oscar");
            names.Add("Otto");
            names.Add("Owen");
            names.Add("Paki");
            names.Add("Palmer");
            names.Add("Patrick");
            names.Add("Paul");
            names.Add("Pavel");
            names.Add("Perry");
            names.Add("Peter");
            names.Add("Phelan");
            names.Add("Philip");
            names.Add("Phillip");
            names.Add("Plato");
            names.Add("Porter");
            names.Add("Prescott");
            names.Add("Preston");
            names.Add("Price");
            names.Add("Quamar");
            names.Add("Quentin");
            names.Add("Quinlan");
            names.Add("Quinn");
            names.Add("Rafael");
            names.Add("Rahim");
            names.Add("Raja");
            names.Add("Rajah");
            names.Add("Rajeev");
            names.Add("Ralph");
            names.Add("Randall");
            names.Add("Raphael");
            names.Add("Rashad");
            names.Add("Ray");
            names.Add("Raymond");
            names.Add("Reece");
            names.Add("Reed");
            names.Add("Reese");
            names.Add("Reuben");
            names.Add("Richard");
            names.Add("Rigel");
            names.Add("Robert");
            names.Add("Robin");
            names.Add("Rogan");
            names.Add("Ronan");
            names.Add("Rooney");
            names.Add("Ross");
            names.Add("Roth");
            names.Add("Rudyard");
            names.Add("Russell");
            names.Add("Ryan");
            names.Add("Ryder");
            names.Add("Salvador");
            names.Add("Samson");
            names.Add("Samuel");
            names.Add("Sawyer");
            names.Add("Scott");
            names.Add("Sean");
            names.Add("Sebastian");
            names.Add("Seth");
            names.Add("Shad");
            names.Add("Silas");
            names.Add("Simon");
            names.Add("Slade");
            names.Add("Solomon");
            names.Add("Steel");
            names.Add("Stephen");
            names.Add("Steven");
            names.Add("Stewart");
            names.Add("Stone");
            names.Add("Stuart");
            names.Add("Sumanth");
            names.Add("Sylvester");
            names.Add("Tad");
            names.Add("Talon");
            names.Add("Tanek");
            names.Add("Tanner");
            names.Add("Tarik");
            names.Add("Tate");
            names.Add("Thaddeus");
            names.Add("Thane");
            names.Add("Theodore");
            names.Add("Thomas");
            names.Add("Thor");
            names.Add("Tiger");
            names.Add("Timon");
            names.Add("Timothy");
            names.Add("Tobias");
            names.Add("Todd");
            names.Add("Travis");
            names.Add("Trevor");
            names.Add("Troy");
            names.Add("Tucker");
            names.Add("Tyler");
            names.Add("Tyrone");
            names.Add("Ulric");
            names.Add("Ulysses");
            names.Add("Upton");
            names.Add("Uriel");
            names.Add("Valentine");
            names.Add("Vance");
            names.Add("Vaughan");
            names.Add("Vernon");
            names.Add("Victor");
            names.Add("Vincent");
            names.Add("Vladimir");
            names.Add("Wade");
            names.Add("Walker");
            names.Add("Wallace");
            names.Add("Walter");
            names.Add("Wang");
            names.Add("Warren");
            names.Add("Wesley");
            names.Add("William");
            names.Add("Wing");
            names.Add("Wyatt");
            names.Add("Wylie");
            names.Add("Xander");
            names.Add("Xanthus");
            names.Add("Xavier");
            names.Add("Xenos");
            names.Add("Yardley");
            names.Add("Yasir");
            names.Add("Yoshio");
            names.Add("Yuli");
            names.Add("Zachary");
            names.Add("Zachery");
            names.Add("Zahir");
            names.Add("Zane");
            names.Add("Zeph");
            names.Add("Zephania");
            names.Add("Zeus");

            return names;
        }

        public List<string> ListofFemaleNames()
        {

            List<string> names = new List<string>();

            names.Add("Abra");
            names.Add("Adara");
            names.Add("Adena");
            names.Add("Adria");
            names.Add("Adrienne");
            names.Add("Aiko");
            names.Add("Aileen");
            names.Add("Aimee");
            names.Add("Ainsley");
            names.Add("Alana");
            names.Add("Alea");
            names.Add("Alexa");
            names.Add("Alexandra");
            names.Add("Alexis");
            names.Add("Alfreda");
            names.Add("Alice");
            names.Add("Aline");
            names.Add("Alisa");
            names.Add("Althea");
            names.Add("Alyssa");
            names.Add("Amanda");
            names.Add("Amaya");
            names.Add("Amber");
            names.Add("Amela");
            names.Add("Amelia");
            names.Add("Amena");
            names.Add("Amethyst");
            names.Add("Amity");
            names.Add("Amy");
            names.Add("Angela");
            names.Add("Angelica");
            names.Add("Anika");
            names.Add("Anjolie");
            names.Add("Ana");
            names.Add("Ann");
            names.Add("Anne");
            names.Add("Aphrodite");
            names.Add("April");
            names.Add("Aretha");
            names.Add("Ariana");
            names.Add("Ariel");
            names.Add("Aspen");
            names.Add("Astra");
            names.Add("Aubrey");
            names.Add("Audrey");
            names.Add("Aurelia");
            names.Add("Aurora");
            names.Add("Autumn");
            names.Add("Ava");
            names.Add("Ayanna");
            names.Add("Basia");
            names.Add("Beatrice");
            names.Add("Bell");
            names.Add("Belle");
            names.Add("Bertha");
            names.Add("Bethany");
            names.Add("Beverly");
            names.Add("Bianca");
            names.Add("Blaine");
            names.Add("Blair");
            names.Add("Bo");
            names.Add("Breanna");
            names.Add("Bree");
            names.Add("Brenna");
            names.Add("Brianna");
            names.Add("Brielle");
            names.Add("Britanni");
            names.Add("Brooke");
            names.Add("Cailin");
            names.Add("Callie");
            names.Add("Cally");
            names.Add("Cameran");
            names.Add("Cameron");
            names.Add("Camilla");
            names.Add("Camille");
            names.Add("Candice");
            names.Add("Cara");
            names.Add("Carissa");
            names.Add("Carla");
            names.Add("Carly");
            names.Add("Carol");
            names.Add("Carolyn");
            names.Add("Caryn");
            names.Add("Casey");
            names.Add("Cassady");
            names.Add("Cassandra");
            names.Add("Cassidy");
            names.Add("Catherine");
            names.Add("Cecilia");
            names.Add("Chantale");
            names.Add("Charde");
            names.Add("Charity");
            names.Add("Charlotte");
            names.Add("Chastity");
            names.Add("Chava");
            names.Add("Chelsea");
            names.Add("Cherokee");
            names.Add("Cheryl");
            names.Add("Cheyenne");
            names.Add("Chiquita");
            names.Add("Chloe");
            names.Add("Christen");
            names.Add("Claire");
            names.Add("Clare");
            names.Add("Claudia");
            names.Add("Clementine");
            names.Add("Cleo");
            names.Add("Clio");
            names.Add("Colette");
            names.Add("Colleen");
            names.Add("Constance");
            names.Add("Courtney");
            names.Add("Dacey");
            names.Add("Dahlia");
            names.Add("Dai");
            names.Add("Dakota");
            names.Add("Dana");
            names.Add("Danielle");
            names.Add("Daphne");
            names.Add("Dara");
            names.Add("Darrel");
            names.Add("Darryl");
            names.Add("Daryl");
            names.Add("Deanna");
            names.Add("Deborah");
            names.Add("Debra");
            names.Add("Deirdre");
            names.Add("Delilah");
            names.Add("Demetria");
            names.Add("Denise");
            names.Add("Desiree");
            names.Add("Destiny");
            names.Add("Diana");
            names.Add("Dominique");
            names.Add("Dora");
            names.Add("Doris");
            names.Add("Dorothy");
            names.Add("Ebony");
            names.Add("Echo");
            names.Add("Eden");
            names.Add("Elaine");
            names.Add("Eleanor");
            names.Add("Eliana");
            names.Add("Elizabeth");
            names.Add("Ella");
            names.Add("Emerald");
            names.Add("Emi");
            names.Add("Emily");
            names.Add("Emma");
            names.Add("Erica");
            names.Add("Erin");
            names.Add("Eugenia");
            names.Add("Evangeline");
            names.Add("Eve");
            names.Add("Evelyn");
            names.Add("Faith");
            names.Add("Fallon");
            names.Add("Farrah");
            names.Add("Fatima");
            names.Add("Fay");
            names.Add("Felicia");
            names.Add("Fiona");
            names.Add("Flavia");
            names.Add("Fleur");
            names.Add("Frances");
            names.Add("Francesca");
            names.Add("Fredericka");
            names.Add("Freya");
            names.Add("Gail");
            names.Add("Galena");
            names.Add("Gay");
            names.Add("Gemma");
            names.Add("Genevieve");
            names.Add("Georgia");
            names.Add("Geraldine");
            names.Add("Germaine");
            names.Add("Germane");
            names.Add("Gillian");
            names.Add("Ginger");
            names.Add("Gisela");
            names.Add("Giselle");
            names.Add("Glenna");
            names.Add("Gloria");
            names.Add("Grace");
            names.Add("Gretchen");
            names.Add("Guinevere");
            names.Add("Gwendolyn");
            names.Add("Hadassah");
            names.Add("Hadley");
            names.Add("Halee");
            names.Add("Haley");
            names.Add("Halla");
            names.Add("Hanae");
            names.Add("Hanna");
            names.Add("Hannah");
            names.Add("Harriet");
            names.Add("Haviva");
            names.Add("Hayfa");
            names.Add("Hayley");
            names.Add("Heather");
            names.Add("Hedwig");
            names.Add("Hedy");
            names.Add("Heidi");
            names.Add("Hiroko");
            names.Add("Hollee");
            names.Add("Holly");
            names.Add("Hyacinth");
            names.Add("Idola");
            names.Add("Idona");
            names.Add("Ifeoma");
            names.Add("Ila");
            names.Add("Iliana");
            names.Add("Illana");
            names.Add("Illiana");
            names.Add("Ima");
            names.Add("Imelda");
            names.Add("Imogene");
            names.Add("Ina");
            names.Add("India");
            names.Add("Indigo");
            names.Add("Inez");
            names.Add("Inga");
            names.Add("Ingrid");
            names.Add("Iona");
            names.Add("Irene");
            names.Add("Iris");
            names.Add("Irma");
            names.Add("Isabelle");
            names.Add("Isadora");
            names.Add("Ivana");
            names.Add("Ivory");
            names.Add("Jade");
            names.Add("Jaden");
            names.Add("Jaime");
            names.Add("Jamalia");
            names.Add("Jana");
            names.Add("Jane");
            names.Add("Janna");
            names.Add("Jasmin");
            names.Add("Jaquelyn");
            names.Add("Jayme");
            names.Add("Jemima");
            names.Add("Jena");
            names.Add("Jenna");
            names.Add("Jennifer");
            names.Add("Jescie");
            names.Add("Jessica");
            names.Add("Jessabelle");
            names.Add("Jillian");
            names.Add("Joan");
            names.Add("Jocelyn");
            names.Add("Joelle");
            names.Add("Jolene");
            names.Add("Jolie");
            names.Add("Jordan");
            names.Add("Jorden");
            names.Add("Josephine");
            names.Add("Joy");
            names.Add("Judith");
            names.Add("Julie");
            names.Add("Juliet");
            names.Add("Justina");
            names.Add("Justine");
            names.Add("Kaden");
            names.Add("Kai");
            names.Add("Kaitlin");
            names.Add("Kalia");
            names.Add("Karen");
            names.Add("Karina");
            names.Add("Karly");
            names.Add("Karyn");
            names.Add("Katell");
            names.Add("Katelyn");
            names.Add("Kathleen");
            names.Add("Kay");
            names.Add("Keelie");
            names.Add("Keely");
            names.Add("Keiko");
            names.Add("Kellie");
            names.Add("Kelly");
            names.Add("Kelsey");
            names.Add("Kerry");
            names.Add("Kessie");
            names.Add("Kevyn");
            names.Add("Kiara");
            names.Add("Kiayada");
            names.Add("Kim");
            names.Add("Kimberley");
            names.Add("Kiona");
            names.Add("Kirby");
            names.Add("Kitra");
            names.Add("Kristen");
            names.Add("Kyla");
            names.Add("Kylan");
            names.Add("Kylynn");
            names.Add("Lacey");
            names.Add("Lacota");
            names.Add("Lacy");
            names.Add("Lael");
            names.Add("Lani");
            names.Add("Lara");
            names.Add("Larissa");
            names.Add("Latifah");
            names.Add("Laurel");
            names.Add("Lavinia");
            names.Add("Leah");
            names.Add("Leandra");
            names.Add("Leigh");
            names.Add("Leila");
            names.Add("Leilani");
            names.Add("Lenore");
            names.Add("Lesley");
            names.Add("Leslie");
            names.Add("Libby");
            names.Add("Lila");
            names.Add("Lilah");
            names.Add("Lillian");
            names.Add("Lillith");
            names.Add("Linda");
            names.Add("Lisandra");
            names.Add("Lois");
            names.Add("Lucy");
            names.Add("Lunea");
            names.Add("Lydia");
            names.Add("Lynn");
            names.Add("Lysandra");
            names.Add("Macey");
            names.Add("MacKensie");
            names.Add("MacKenzie");
            names.Add("Macy");
            names.Add("Madaline");
            names.Add("Madeline");
            names.Add("Madeson");
            names.Add("Madison");
            names.Add("Madonna");
            names.Add("Maggie");
            names.Add("Maggy");
            names.Add("Maia");
            names.Add("Maile");
            names.Add("Maisie");
            names.Add("Mallory");
            names.Add("Mara");
            names.Add("Marcia");
            names.Add("Margaret");
            names.Add("Mari");
            names.Add("Mariam");
            names.Add("Mariko");
            names.Add("Marny");
            names.Add("Martena");
            names.Add("Martha");
            names.Add("Martina");
            names.Add("Mary");
            names.Add("Maryam");
            names.Add("Maxine");
            names.Add("Maya");
            names.Add("McKenzie");
            names.Add("Mechelle");
            names.Add("Medge");
            names.Add("Megan");
            names.Add("Meghan");
            names.Add("Melissa");
            names.Add("Melodie");
            names.Add("Melyssa");
            names.Add("Mercedes");
            names.Add("Meredith");
            names.Add("Mia");
            names.Add("Michelle");
            names.Add("Mikayla");
            names.Add("Minerva");
            names.Add("Mira");
            names.Add("Miranda");
            names.Add("Miriam");
            names.Add("Moana");
            names.Add("Molly");
            names.Add("Mona");
            names.Add("Montana");
            names.Add("Morgan");
            names.Add("Myra");
            names.Add("Nada");
            names.Add("Nadine");
            names.Add("Naida");
            names.Add("Naomi");
            names.Add("Natalie");
            names.Add("Nayda");
            names.Add("Nelle");
            names.Add("Nerea");
            names.Add("Nevada");
            names.Add("Neve");
            names.Add("Nichole");
            names.Add("Nicole");
            names.Add("Nina");
            names.Add("Nita");
            names.Add("Noel");
            names.Add("Noelani");
            names.Add("Noelle");
            names.Add("Nomlanga");
            names.Add("Nora");
            names.Add("Nyssa");
            names.Add("Ocean");
            names.Add("Octavia");
            names.Add("Odette");
            names.Add("Olivia");
            names.Add("Oprah");
            names.Add("Orla");
            names.Add("Orli");
            names.Add("Paloma");
            names.Add("Pandora");
            names.Add("Pascale");
            names.Add("Patience");
            names.Add("Patricia");
            names.Add("Paula");
            names.Add("Pearl");
            names.Add("Penelope");
            names.Add("Phoebe");
            names.Add("Phyllis");
            names.Add("Piper");
            names.Add("Priscilla");
            names.Add("Quail");
            names.Add("Quin");
            names.Add("Quinn");
            names.Add("Quintessa");
            names.Add("Quon");
            names.Add("Quyn");
            names.Add("Quynn");
            names.Add("Rachel");
            names.Add("Rae");
            names.Add("Rama");
            names.Add("Ramona");
            names.Add("Rana");
            names.Add("Raya");
            names.Add("Reagan");
            names.Add("Rebecca");
            names.Add("Regan");
            names.Add("Renee");
            names.Add("Rhea");
            names.Add("Rhiannon");
            names.Add("Rhoda");
            names.Add("Rhona");
            names.Add("Rhonda");
            names.Add("Ria");
            names.Add("Riley");
            names.Add("Rina");
            names.Add("Rinah");
            names.Add("Risa");
            names.Add("Roanna");
            names.Add("Roary");
            names.Add("Robin");
            names.Add("Rosalyn");
            names.Add("Rylee");
            names.Add("Sacha");
            names.Add("Sade");
            names.Add("Sage");
            names.Add("Samantha");
            names.Add("Sara");
            names.Add("Sarah");
            names.Add("Sasha");
            names.Add("Savannah");
            names.Add("Scarlet");
            names.Add("Scarlett");
            names.Add("Selma");
            names.Add("September");
            names.Add("Serena");
            names.Add("Serina");
            names.Add("Shaeleigh");
            names.Add("Shafira");
            names.Add("Shaine");
            names.Add("Shannon");
            names.Add("Sharon");
            names.Add("Sharmila");
            names.Add("Shay");
            names.Add("Shea");
            names.Add("Sheila");
            names.Add("Shelby");
            names.Add("Shelley");
            names.Add("Shellie");
            names.Add("Shelly");
            names.Add("Shoshana");
            names.Add("Sierra");
            names.Add("Signe");
            names.Add("Sigourney");
            names.Add("Simone");
            names.Add("Skyler");
            names.Add("Sloane");
            names.Add("Sonia");
            names.Add("Sonya");
            names.Add("Sophia");
            names.Add("Sopoline");
            names.Add("Stacey");
            names.Add("Stacy");
            names.Add("Stella");
            names.Add("Stephanie");
            names.Add("Suki");
            names.Add("Summer");
            names.Add("Susan");
            names.Add("Sybil");
            names.Add("Sydnee");
            names.Add("Sydney");
            names.Add("Sylvia");
            names.Add("Tallulah");
            names.Add("Tamara");
            names.Add("Tamekah");
            names.Add("Tana");
            names.Add("Tanisha");
            names.Add("Tanya");
            names.Add("Tasha");
            names.Add("Tashya");
            names.Add("Tatiana");
            names.Add("Tatum");
            names.Add("Tatyana");
            names.Add("Taylor");
            names.Add("Teagan");
            names.Add("Teegan");
            names.Add("Ulla");
            names.Add("Uma");
            names.Add("Unity");
            names.Add("Upasana");
            names.Add("Urielle");
            names.Add("Ursa");
            names.Add("Ursula");
            names.Add("Uta");
            names.Add("Veda");
            names.Add("Velma");
            names.Add("Venus");
            names.Add("Vera");
            names.Add("Veronica");
            names.Add("Victoria");
            names.Add("Vielka");
            names.Add("Violet");
            names.Add("Virginia");
            names.Add("Vivian");
            names.Add("Vivien");
            names.Add("Wanda");
            names.Add("Wendy");
            names.Add("Whilemina");
            names.Add("Whoopi");
            names.Add("Willa");
            names.Add("Willow");
            names.Add("Wilma");
            names.Add("Winifred");
            names.Add("Winter");
            names.Add("Wynne");
            names.Add("Wynter");
            names.Add("Wyoming");
            names.Add("Xandra");
            names.Add("Xantha");
            names.Add("Xaviera");
            names.Add("Xena");
            names.Add("Xyla");
            names.Add("Yael");
            names.Add("Yeo");
            names.Add("Yoko");
            names.Add("Yolanda");
            names.Add("Yvette");
            names.Add("Yvonne");
            names.Add("Zelda");
            names.Add("Zelenia");
            names.Add("Zena");
            names.Add("Zenaida");
            names.Add("Zenia");
            names.Add("Zia");
            names.Add("Zoe");
            names.Add("Zorita");

            return names;

        }

        public List<string> ListofLastNames()
        {

            List<string> names = new List<string>();

            names.Add("Abbott");
            names.Add("Acevedo");
            names.Add("Acosta");
            names.Add("Aguilar");
            names.Add("Aguirre");
            names.Add("Allison");
            names.Add("Alston");
            names.Add("Armstrong");
            names.Add("Arnold");
            names.Add("Ashley");
            names.Add("Atkinson");
            names.Add("Avery");
            names.Add("Avila");
            names.Add("Ayers");
            names.Add("Bailey");
            names.Add("Baker");
            names.Add("Ball");
            names.Add("Ballard");
            names.Add("Banks");
            names.Add("Barlow");
            names.Add("Barnes");
            names.Add("Barnett");
            names.Add("Barrett");
            names.Add("Barry");
            names.Add("Bartlett");
            names.Add("Bass");
            names.Add("Battle");
            names.Add("Beach");
            names.Add("Bean");
            names.Add("Beard");
            names.Add("Beck");
            names.Add("Becker");
            names.Add("Bell");
            names.Add("Bender");
            names.Add("Bennett");
            names.Add("Benton");
            names.Add("Berg");
            names.Add("Berger");
            names.Add("Bernard");
            names.Add("Best");
            names.Add("Bird");
            names.Add("Black");
            names.Add("Blackburn");
            names.Add("Blackwell");
            names.Add("Blair");
            names.Add("Blake");
            names.Add("Blanchard");
            names.Add("Blankenship");
            names.Add("Bolton");
            names.Add("Bond");
            names.Add("Booth");
            names.Add("Bowers");
            names.Add("Bowman");
            names.Add("Boyd");
            names.Add("Boyle");
            names.Add("Bradley");
            names.Add("Bradshaw");
            names.Add("Brady");
            names.Add("Branch");
            names.Add("Brennan");
            names.Add("Brewer");
            names.Add("Briggs");
            names.Add("Bright");
            names.Add("Britt");
            names.Add("Brown");
            names.Add("Bruce");
            names.Add("Bryan");
            names.Add("Bryant");
            names.Add("Buchanan");
            names.Add("Bullock");
            names.Add("Burch");
            names.Add("Burgess");
            names.Add("Burke");
            names.Add("Burks");
            names.Add("Burns");
            names.Add("Burris");
            names.Add("Burt");
            names.Add("Burton");
            names.Add("Bush");
            names.Add("Byers");
            names.Add("Byrd");
            names.Add("Cabrera");
            names.Add("Cain");
            names.Add("Caldwell");
            names.Add("Calhoun");
            names.Add("Camacho");
            names.Add("Cameron");
            names.Add("Cantu");
            names.Add("Carey");
            names.Add("Carney");
            names.Add("Carpenter");
            names.Add("Carroll");
            names.Add("Carter");
            names.Add("Case");
            names.Add("Cash");
            names.Add("Castillo");
            names.Add("Castro");
            names.Add("Chambers");
            names.Add("Chan");
            names.Add("Chandler");
            names.Add("Chaney");
            names.Add("Chang");
            names.Add("Chase");
            names.Add("Christensen");
            names.Add("Christian");
            names.Add("Church");
            names.Add("Clark");
            names.Add("Clay");
            names.Add("Clemons");
            names.Add("Cleveland");
            names.Add("Cochran");
            names.Add("Coffey");
            names.Add("Cohen");
            names.Add("Collins");
            names.Add("Colon");
            names.Add("Combs");
            names.Add("Compton");
            names.Add("Conley");
            names.Add("Conrad");
            names.Add("Conway");
            names.Add("Cooke");
            names.Add("Cote");
            names.Add("Cotton");
            names.Add("Craft");
            names.Add("Craig");
            names.Add("Cross");
            names.Add("Cunningham");
            names.Add("Curtis");
            names.Add("Dale");
            names.Add("Dalton");
            names.Add("Daniel");
            names.Add("Daniels");
            names.Add("Daugherty");
            names.Add("David");
            names.Add("Davidson");
            names.Add("Davis");
            names.Add("Dawson");
            names.Add("Dean");
            names.Add("Dejesus");
            names.Add("Delacruz");
            names.Add("Delaney");
            names.Add("Deleon");
            names.Add("Dennis");
            names.Add("Dickenson");
            names.Add("Dickerson");
            names.Add("Dickson");
            names.Add("Dixon");
            names.Add("Dodson");
            names.Add("Dominguez");
            names.Add("Donaldson");
            names.Add("Dorsey");
            names.Add("Dudley");
            names.Add("Duran");
            names.Add("Durham");
            names.Add("Eaton");
            names.Add("Edwards");
            names.Add("Elliott");
            names.Add("Ellison");
            names.Add("Emerson");
            names.Add("England");
            names.Add("Erickson");
            names.Add("Espinoza");
            names.Add("Estes");
            names.Add("Ewing");
            names.Add("Farmer");
            names.Add("Farrell");
            names.Add("Faulkner");
            names.Add("Ferguson");
            names.Add("Fernandez");
            names.Add("Ferrell");
            names.Add("Figueroa");
            names.Add("Finley");
            names.Add("Fisher");
            names.Add("Fitzgerald");
            names.Add("Fitzpatrick");
            names.Add("Fletcher");
            names.Add("Flores");
            names.Add("Floyd");
            names.Add("Forbes");
            names.Add("Ford");
            names.Add("Foreman");
            names.Add("Foster");
            names.Add("Fowler");
            names.Add("Fox");
            names.Add("Franco");
            names.Add("Frank");
            names.Add("Franklin");
            names.Add("Franks");
            names.Add("Frazier");
            names.Add("Freeman");
            names.Add("French");
            names.Add("Fry");
            names.Add("Fuentes");
            names.Add("Gaines");
            names.Add("Gallagher");
            names.Add("Galloway");
            names.Add("Garcia");
            names.Add("Garrett");
            names.Add("Gay");
            names.Add("Gentry");
            names.Add("Gibson");
            names.Add("Giles");
            names.Add("Gill");
            names.Add("Gilliam");
            names.Add("Gilmore");
            names.Add("Giovanitti");            
            names.Add("Glass");
            names.Add("Golden");
            names.Add("Gonzales");
            names.Add("Good");
            names.Add("Goodman");
            names.Add("Gordon");
            names.Add("Gossling");           
            names.Add("Gould");
            names.Add("Graham");
            names.Add("Graves");
            names.Add("Gray");
            names.Add("Greer");
            names.Add("Gregory");
            names.Add("Griffin");
            names.Add("Griffith");
            names.Add("Guthrie");
            names.Add("Gutierrez");
            names.Add("Guy");
            names.Add("Guzman");
            names.Add("Haley");
            names.Add("Hall");
            names.Add("Hancock");
            names.Add("Haney");
            names.Add("Hansen");
            names.Add("Hanson");
            names.Add("Hardin");
            names.Add("Harding");
            names.Add("Hardy");
            names.Add("Harper");
            names.Add("Harrington");
            names.Add("Harris");
            names.Add("Hart");
            names.Add("Hatfield");
            names.Add("Haynes");
            names.Add("Head");
            names.Add("Heath");
            names.Add("Hebert");
            names.Add("Henderson");
            names.Add("Hendricks");
            names.Add("Hendrix");
            names.Add("Henry");
            names.Add("Henson");
            names.Add("Hernandez");
            names.Add("Herrera");
            names.Add("Herring");
            names.Add("Hess");
            names.Add("Hewitt");
            names.Add("Hicks");
            names.Add("Hinton");
            names.Add("Hobbs");
            names.Add("Hodges");
            names.Add("Hogan");
            names.Add("Holcomb");
            names.Add("Holden");
            names.Add("Holland");
            names.Add("Holloway");
            names.Add("Holman");
            names.Add("Holt");
            names.Add("Hood");
            names.Add("Hooper");
            names.Add("Hoover");
            names.Add("Hopkins");
            names.Add("Hopper");
            names.Add("Horn");
            names.Add("House");
            names.Add("Howard");
            names.Add("Hubbard");
            names.Add("Huber");
            names.Add("Huff");
            names.Add("Hull");
            names.Add("Hunt");
            names.Add("Hunter");
            names.Add("Hurley");
            names.Add("Hurst");
            names.Add("Ingram");
            names.Add("Irwin");
            names.Add("Jackson");
            names.Add("James");
            names.Add("Jarvis");
            names.Add("Jefferson");
            names.Add("Jenkins");
            names.Add("Jennings");
            names.Add("Jensen");
            names.Add("Johns");
            names.Add("Johnson");
            names.Add("Jones");
            names.Add("Jordan");
            names.Add("Joseph");
            names.Add("Joyce");
            names.Add("Joyner");
            names.Add("Juarez");
            names.Add("Justice");
            names.Add("Keith");
            names.Add("Kelly");
            names.Add("Kennedy");
            names.Add("Kent");
            names.Add("Kerr");
            names.Add("Key");
            names.Add("Kim");
            names.Add("King");
            names.Add("Kirk");
            names.Add("Klein");
            names.Add("Kline");
            names.Add("Knowles");
            names.Add("Knox");
            names.Add("Koch");
            names.Add("Kramer");
            names.Add("Lambert");
            names.Add("Lancaster");
            names.Add("Lane");
            names.Add("Lang");
            names.Add("Langley");
            names.Add("Lawson");
            names.Add("Leach");
            names.Add("Lee");
            names.Add("Leonard");
            names.Add("Levy");
            names.Add("Lindsay");
            names.Add("Lindsey");
            names.Add("Little");
            names.Add("Logan");
            names.Add("Lopez");
            names.Add("Lott");
            names.Add("Lowery");
            names.Add("Luna");
            names.Add("Lynch");
            names.Add("Lynn");
            names.Add("Lyons");
            names.Add("Macdonald");
            names.Add("Macias");
            names.Add("Mack");
            names.Add("Mann");
            names.Add("Manning");
            names.Add("Marquez");
            names.Add("Marsh");
            names.Add("Marshall");
            names.Add("Massey");
            names.Add("Mathews");
            names.Add("Matthews");
            names.Add("Maxwell");
            names.Add("May");
            names.Add("Mayer");
            names.Add("Maynard");
            names.Add("Mayo");
            names.Add("Mays");
            names.Add("Mccarthy");
            names.Add("Mcclain");
            names.Add("Mcconnell");
            names.Add("Mccormick");
            names.Add("Mcdaniel");
            names.Add("Mcgee");
            names.Add("Mcgowan");
            names.Add("Mcintosh");
            names.Add("Mckay");
            names.Add("Mckee");
            names.Add("Mckinney");
            names.Add("Mclean");
            names.Add("Mcmahon");
            names.Add("Mcmillan");
            names.Add("Meadows");
            names.Add("Medina");
            names.Add("Mejia");
            names.Add("Melendez");
            names.Add("Mendez");
            names.Add("Mercado");
            names.Add("Mercer");
            names.Add("Merritt");
            names.Add("Meyer");
            names.Add("Meyers");
            names.Add("Michael");
            names.Add("Miles");
            names.Add("Mills");
            names.Add("Mitchell");
            names.Add("Molina");
            names.Add("Montgomery");
            names.Add("Moody");
            names.Add("Moon");
            names.Add("Mooney");
            names.Add("Morales");
            names.Add("Moreno");
            names.Add("Morris");
            names.Add("Morrison");
            names.Add("Morse");
            names.Add("Mosley");
            names.Add("Mueller");
            names.Add("Mullen");
            names.Add("Nash");
            names.Add("Navarro");
            names.Add("Newton");
            names.Add("Nicholson");
            names.Add("Nielsen");
            names.Add("Nieves");
            names.Add("Nixon");
            names.Add("Noel");
            names.Add("Nolan");
            names.Add("Norris");
            names.Add("Nunez");
            names.Add("Obrien");
            names.Add("Ochoa");
            names.Add("Oconnor");
            names.Add("Odonnell");
            names.Add("Oliver");
            names.Add("Olsen");
            names.Add("Oneal");
            names.Add("Oneill");
            names.Add("Orr");
            names.Add("Ortiz");
            names.Add("Osborn");
            names.Add("Padilla");
            names.Add("Page");
            names.Add("Park");
            names.Add("Parker");
            names.Add("Parrish");
            names.Add("Parsons");
            names.Add("Pate");
            names.Add("Patel");
            names.Add("Patrick");
            names.Add("Patterson");
            names.Add("Patton");
            names.Add("Paul");
            names.Add("Payne");
            names.Add("Pearson");
            names.Add("Pena");
            names.Add("Perry");
            names.Add("Peters");
            names.Add("Petersen");
            names.Add("Peterson");
            names.Add("Phelps");
            names.Add("Pierce");
            names.Add("Pittman");
            names.Add("Pollard");
            names.Add("Porter");
            names.Add("Potter");
            names.Add("Potts");
            names.Add("Powell");
            names.Add("Powers");
            names.Add("Pratt");
            names.Add("Price");
            names.Add("Pugh");
            names.Add("Quinn");
            names.Add("Ramirez");
            names.Add("Randall");
            names.Add("Randolph");
            names.Add("Rasmussen");
            names.Add("Ratliff");
            names.Add("Reed");
            names.Add("Reeves");
            names.Add("Reyes");
            names.Add("Reynolds");
            names.Add("Rhodes");
            names.Add("Rice");
            names.Add("Richard");
            names.Add("Richardson");
            names.Add("Richmond");
            names.Add("Riddle");
            names.Add("Riggs");
            names.Add("Rivas");
            names.Add("Rivera");
            names.Add("Rivers");
            names.Add("Roach");
            names.Add("Roberson");
            names.Add("Roberts");
            names.Add("Robertson");
            names.Add("Robinson");
            names.Add("Rocha");
            names.Add("Rodgers");
            names.Add("Rodriguez");
            names.Add("Rodriquez");
            names.Add("Rojas");
            names.Add("Roman");
            names.Add("Romero");
            names.Add("Rosales");
            names.Add("Rosario");
            names.Add("Roth");
            names.Add("Roy");
            names.Add("Russell");
            names.Add("Russo");
            names.Add("Rutledge");
            names.Add("Ryan");
            names.Add("Salas");
            names.Add("Salazar");
            names.Add("Salinas");
            names.Add("Sampson");
            names.Add("Sandoval");
            names.Add("Sanford");
            names.Add("Santiago");
            names.Add("Santos");
            names.Add("Savage");
            names.Add("Schneider");
            names.Add("Schroeder");
            names.Add("Schwartz");
            names.Add("Sears");
            names.Add("Sellers");
            names.Add("Sexton");
            names.Add("Shaffer");
            names.Add("Sharp");
            names.Add("Sharpe");
            names.Add("Shaw");
            names.Add("Shelton");
            names.Add("Shepherd");
            names.Add("Sheppard");
            names.Add("Sherman");
            names.Add("Shields");
            names.Add("Short");
            names.Add("Silva");
            names.Add("Simon");
            names.Add("Sims");
            names.Add("Singleton");
            names.Add("Skinner");
            names.Add("Slater");
            names.Add("Sloan");
            names.Add("Snider");
            names.Add("Snow");
            names.Add("Solomon");
            names.Add("Sosa");
            names.Add("Soto");
            names.Add("Sparks");
            names.Add("Spencer");
            names.Add("Stafford");
            names.Add("Stanley");
            names.Add("Stephens");
            names.Add("Stevens");
            names.Add("Stevenson");
            names.Add("Stokes");
            names.Add("Stout");
            names.Add("Strickland");
            names.Add("Stuart");
            names.Add("Summers");
            names.Add("Sutton");
            names.Add("Sweet");
            names.Add("Sykes");
            names.Add("Tanner");
            names.Add("Tate");
            names.Add("Thomas");
            names.Add("Thornton");
            names.Add("Tillman");
            names.Add("Townsend");
            names.Add("Tran");
            names.Add("Trevino");
            names.Add("Trujillo");
            names.Add("Turner");
            names.Add("Tyler");
            names.Add("Tyson");
            names.Add("Underwood");
            names.Add("Valdez");
            names.Add("Valencia");
            names.Add("Valentine");
            names.Add("Valenzuela");
            names.Add("Vance");
            names.Add("Vaughn");
            names.Add("Vega");
            names.Add("Velasquez");
            names.Add("Velazquez");
            names.Add("Villarreal");
            names.Add("Vincent");
            names.Add("Vinson");
            names.Add("Wade");
            names.Add("Wagner");
            names.Add("Walker");
            names.Add("Walsh");
            names.Add("Walters");
            names.Add("Walton");
            names.Add("Ward");
            names.Add("Ware");
            names.Add("Warner");
            names.Add("Warren");
            names.Add("Washington");
            names.Add("Waters");
            names.Add("Watson");
            names.Add("Watts");
            names.Add("Weaver");
            names.Add("Weber");
            names.Add("Webster");
            names.Add("Weeks");
            names.Add("Weiss");
            names.Add("Welch");
            names.Add("Whitaker");
            names.Add("Whitehead");
            names.Add("Whitfield");
            names.Add("Whitley");
            names.Add("Wilcox");
            names.Add("Williams");
            names.Add("Williamson");
            names.Add("Wilson");
            names.Add("Winters");
            names.Add("Wise");
            names.Add("Wolfe");
            names.Add("Wood");
            names.Add("Woodard");
            names.Add("Woods");
            names.Add("Wooten");
            names.Add("Workman");
            names.Add("Wright");
            names.Add("Yates");
            names.Add("York");
            names.Add("Zamora");

            return names;

        }

        public List<string> ListofPlaceNames()
        {

            List<string> names = new List<string>();

            names.Add("Adell");
            names.Add("Adrian");
            names.Add("Aguilar");
            names.Add("Alberta");
            names.Add("Alice Acres");
            names.Add("Allamuchy");
            names.Add("Allenville");
            names.Add("Altamahaw");
            names.Add("Alturas");
            names.Add("Alvord");
            names.Add("Amador City");
            names.Add("Ambler");
            names.Add("Andes");
            names.Add("Ansted");
            names.Add("Antwerp");
            names.Add("Anvik");
            names.Add("Apache Creek");
            names.Add("Arboles");
            names.Add("Archer");
            names.Add("Argyle");
            names.Add("Arivaca");
            names.Add("Asbury");
            names.Add("Aspen Park");
            names.Add("Astatula");
            names.Add("Audubon");
            names.Add("Auxier");
            names.Add("Avondale");
            names.Add("Azalea Park");
            names.Add("Babb");
            names.Add("Bailey");
            names.Add("Baker City");
            names.Add("Baldwin Park");
            names.Add("Baldwinville");
            names.Add("Banks Springs");
            names.Add("Barberton");
            names.Add("Barnegat Light");
            names.Add("Bartonville");
            names.Add("Basalt");
            names.Add("Basin");
            names.Add("Batesburg");
            names.Add("Baton Rouge");
            names.Add("Beach Haven");
            names.Add("Belfonte");
            names.Add("Belle Fontaine");
            names.Add("Bendersville");
            names.Add("Bermuda Dunes");
            names.Add("Bern");
            names.Add("Bernie");
            names.Add("Beulah Valley");
            names.Add("Big Arm");
            names.Add("Big Pine Key");
            names.Add("Big Thicket Lake Estates");
            names.Add("Biloxi");
            names.Add("Bingham Lake");
            names.Add("Biscoe");
            names.Add("Black Oak");
            names.Add("Bolckow");
            names.Add("Bolt");
            names.Add("Bolton Landing");
            names.Add("Bonita");
            names.Add("Boon");
            names.Add("Bostonia");
            names.Add("Brandt");
            names.Add("Briarcliff");
            names.Add("Brielle");
            names.Add("Brokaw");
            names.Add("Brookville");
            names.Add("Brunswick");
            names.Add("Brushy Creek");
            names.Add("Bucks");
            names.Add("Bunker Hill");
            names.Add("Burchinal");
            names.Add("Bylas");
            names.Add("Cabazon");
            names.Add("Calamus");
            names.Add("Calverton");
            names.Add("Calvin");
            names.Add("Candelero Arriba");
            names.Add("Cape Carteret");
            names.Add("Carlos");
            names.Add("Carter");
            names.Add("Cary");
            names.Add("Casa de Oro");
            names.Add("Caspian");
            names.Add("Cassel");
            names.Add("Caswell Beach");
            names.Add("Cathedral");
            names.Add("Cedar Hills");
            names.Add("Centrahoma");
            names.Add("Centre Hall");
            names.Add("Chamblee");
            names.Add("Chancellor");
            names.Add("Charleroi");
            names.Add("Chenoa");
            names.Add("Cheriton");
            names.Add("Chesilhurst");
            names.Add("Chetopa");
            names.Add("Chicago Heights");
            names.Add("Childersburg");
            names.Add("Chinook");
            names.Add("Chittenango");
            names.Add("Clarkston");
            names.Add("Clarksville City");
            names.Add("Clearfield");
            names.Add("Clearwater");
            names.Add("Cleary");
            names.Add("Cloudcroft");
            names.Add("Coal Valley");
            names.Add("Colcord");
            names.Add("Colton");
            names.Add("Columbia City");
            names.Add("Conneaut Lake");
            names.Add("Cook");
            names.Add("Cooper City");
            names.Add("Coplay");
            names.Add("Corley");
            names.Add("Corydon");
            names.Add("Cosmos");
            names.Add("Cottage Grove");
            names.Add("Coulter");
            names.Add("Cove Creek");
            names.Add("Crescent Springs");
            names.Add("Crothersville");
            names.Add("Culver City");
            names.Add("Cynthiana");
            names.Add("Cyrus");
            names.Add("Daly City");
            names.Add("Daphne");
            names.Add("Darrouzett");
            names.Add("Del Rey");
            names.Add("Denver City");
            names.Add("Devens");
            names.Add("Dickson City");
            names.Add("Dimock");
            names.Add("Domino");
            names.Add("Double Spring");
            names.Add("Downieville");
            names.Add("Dranesville");
            names.Add("Du Quoin");
            names.Add("Duenweg");
            names.Add("Eagan");
            names.Add("Earlsboro");
            names.Add("East Hope");
            names.Add("East Islip");
            names.Add("East Liverpool");
            names.Add("East Norwich");
            names.Add("East Washington");
            names.Add("Ecru");
            names.Add("Edgar Springs");
            names.Add("Edgecliff Village");
            names.Add("Edgemont");
            names.Add("Edinburg");
            names.Add("Edna Bay");
            names.Add("El Portal");
            names.Add("Elim");
            names.Add("Elk Garden");
            names.Add("Emory");
            names.Add("Enoch");
            names.Add("Escatawpa");
            names.Add("Estancia");
            names.Add("Etowah");
            names.Add("Evaro");
            names.Add("Excelsior");
            names.Add("Eyota");
            names.Add("Ezel");
            names.Add("Fairbanks");
            names.Add("Fall City");
            names.Add("Falmouth Foreside");
            names.Add("Federalsburg");
            names.Add("Fenwood");
            names.Add("Fernley");
            names.Add("Ferry");
            names.Add("Fingal");
            names.Add("Fisk");
            names.Add("Flora Dale");
            names.Add("Flournoy");
            names.Add("Forest Acres");
            names.Add("Forest Hill Village");
            names.Add("Forest Junction");
            names.Add("Forman");
            names.Add("Fort Garland");
            names.Add("Fort Gibson");
            names.Add("Fort Knox");
            names.Add("Fort Ripley");
            names.Add("Fort Towson");
            names.Add("Foss");
            names.Add("Fountain Valley");
            names.Add("Fox Island");
            names.Add("Franklin Square");
            names.Add("Franks Field");
            names.Add("Froid");
            names.Add("Fruitvale");
            names.Add("Fuller Heights");
            names.Add("Gallaway");
            names.Add("Gambrills");
            names.Add("Game Creek");
            names.Add("Garden View");
            names.Add("Gaston");
            names.Add("Gholson");
            names.Add("Gibsonville");
            names.Add("Gila Crossing");
            names.Add("Gilboa");
            names.Add("Gilgo");
            names.Add("Gillespie");
            names.Add("Gisela");
            names.Add("Glendon");
            names.Add("Glenvar Heights");
            names.Add("Glenvar");
            names.Add("Goddard");
            names.Add("Goldendale");
            names.Add("Goldonna");
            names.Add("Gonvick");
            names.Add("Goodfield");
            names.Add("Gopher Flats");
            names.Add("Gorst");
            names.Add("Government Camp");
            names.Add("Grape Creek");
            names.Add("Grasston");
            names.Add("Grayville");
            names.Add("Great Neck Estates");
            names.Add("Great Neck Gardens");
            names.Add("Green Camp");
            names.Add("Green Ridge");
            names.Add("Green Valley Farms");
            names.Add("Greensboro Bend");
            names.Add("Greentown");
            names.Add("Greenwood Village");
            names.Add("Gruver");
            names.Add("Hackneyville");
            names.Add("Hale Center");
            names.Add("Haledon");
            names.Add("Hallandale Beach");
            names.Add("Ham Lake");
            names.Add("Hammon");
            names.Add("Handley");
            names.Add("Hardwood Acres");
            names.Add("Harlowton");
            names.Add("Helmetta");
            names.Add("Hereford");
            names.Add("Highland Lake");
            names.Add("Highmore");
            names.Add("Holiday");
            names.Add("Horse Pasture");
            names.Add("Horseshoe Beach");
            names.Add("Hubbell");
            names.Add("Hustonville");
            names.Add("Huxley");
            names.Add("Hytop");
            names.Add("Imperial Beach");
            names.Add("Ithaca");
            names.Add("Ivy");
            names.Add("Ivyland");
            names.Add("Jackson Junction");
            names.Add("Java");
            names.Add("Jayuya");
            names.Add("Jolley");
            names.Add("K. I. Sawyer");
            names.Add("Kaaawa");
            names.Add("Kalihiwai");
            names.Add("Kaneville");
            names.Add("Kapp Heights");
            names.Add("Kemp");
            names.Add("Kendall West");
            names.Add("Kendrick");
            names.Add("Kenova");
            names.Add("Kingdom City");
            names.Add("Kings Park West");
            names.Add("Kingstowne");
            names.Add("Kiron");
            names.Add("Klickitat");
            names.Add("Knob Noster");
            names.Add("Kohler");
            names.Add("Kremmling");
            names.Add("Kurten");
            names.Add("La Joya");
            names.Add("La Junta");
            names.Add("Lacey");
            names.Add("Lafferty");
            names.Add("Lake Dalecarlia");
            names.Add("Lake Latonka");
            names.Add("Lake Luzerne");
            names.Add("Lake Sumner");
            names.Add("Lake Tanglewood");
            names.Add("Lake Tansi");
            names.Add("Lake Tomahawk");
            names.Add("Lamboglia");
            names.Add("Las Nutrias");
            names.Add("Lathrop");
            names.Add("Laton");
            names.Add("Laupahoehoe");
            names.Add("Lavelle");
            names.Add("Lawrence Creek");
            names.Add("Leakesville");
            names.Add("Leland");
            names.Add("Lemmon Valley");
            names.Add("Lennon");
            names.Add("Lenoir City");
            names.Add("Lenora");
            names.Add("Lewisberry");
            names.Add("Lexington Park");
            names.Add("Lime Village");
            names.Add("Lincoln Heights");
            names.Add("Lineville");
            names.Add("Linneus");
            names.Add("Lisbon");
            names.Add("Little America");
            names.Add("Littlefork");
            names.Add("Loma Linda");
            names.Add("Long Prairie");
            names.Add("Lorain");
            names.Add("Los Ebanos");
            names.Add("Los Ybanez");
            names.Add("Lower Salem");
            names.Add("Lu Verne");
            names.Add("Madison");
            names.Add("Magnet Cove");
            names.Add("Malin");
            names.Add("Malta");
            names.Add("Manorville");
            names.Add("Manzano");
            names.Add("Marble");
            names.Add("March");
            names.Add("Mariaville Lake");
            names.Add("Martinsdale");
            names.Add("Maryhill Estates");
            names.Add("Mayfield Heights");
            names.Add("Maywood Park");
            names.Add("McCutchenville");
            names.Add("McDermott");
            names.Add("McElhattan");
            names.Add("McGraw");
            names.Add("Meadow View");
            names.Add("Melba");
            names.Add("Melody Hill");
            names.Add("Mesa del Caballo");
            names.Add("Metzger");
            names.Add("Micro");
            names.Add("Mikes");
            names.Add("Milan");
            names.Add("Milano");
            names.Add("Minnehaha");
            names.Add("Moca");
            names.Add("Mohave Valley");
            names.Add("Mont Alto");
            names.Add("Monte Alto");
            names.Add("Montegut");
            names.Add("Mooers");
            names.Add("Moran");
            names.Add("Morocco");
            names.Add("Morovis");
            names.Add("Mounds View");
            names.Add("Mount Clemens");
            names.Add("Mount Eagle");
            names.Add("Mount Pulaski");
            names.Add("Mucarabones");
            names.Add("Muenster");
            names.Add("Mullin");
            names.Add("Muniz");
            names.Add("Munjor");
            names.Add("Murillo");
            names.Add("Nampa");
            names.Add("Nances Creek");
            names.Add("Nappanee");
            names.Add("Narcissa");
            names.Add("Naschitti");
            names.Add("Natalbany");
            names.Add("National City");
            names.Add("Natural Bridge");
            names.Add("Nehalem");
            names.Add("Nenana");
            names.Add("Nespelem");
            names.Add("New Baden");
            names.Add("New Columbus");
            names.Add("New Freeport");
            names.Add("New Germany");
            names.Add("New Hamilton");
            names.Add("New London");
            names.Add("New Schaefferstown");
            names.Add("Newington Forest");
            names.Add("Nicasio");
            names.Add("Noblestown");
            names.Add("North Arlington");
            names.Add("North Beach Haven");
            names.Add("North Edwards");
            names.Add("North El Monte");
            names.Add("North Granby");
            names.Add("North Haven");
            names.Add("North Lilbourn");
            names.Add("North Prairie");
            names.Add("North Rock Springs");
            names.Add("North Wantagh");
            names.Add("Novice");
            names.Add("Nunn");
            names.Add("Oak Harbor");
            names.Add("Oak Island");
            names.Add("Oak Run");
            names.Add("Obert");
            names.Add("Ocean Ridge");
            names.Add("Ocheyedan");
            names.Add("Ohatchee");
            names.Add("Oologah");
            names.Add("Oradell");
            names.Add("Organ");
            names.Add("Osage City");
            names.Add("Otho");
            names.Add("Overland");
            names.Add("Painter");
            names.Add("Palisade");
            names.Add("Park City");
            names.Add("Parks");
            names.Add("Parryville");
            names.Add("Paulina");
            names.Add("Paxtang");
            names.Add("Pelzer");
            names.Add("Pennington");
            names.Add("Peridot");
            names.Add("Persia");
            names.Add("Petal");
            names.Add("Petronila");
            names.Add("Pierceton");
            names.Add("Pigeon Forge");
            names.Add("Pilot Rock");
            names.Add("Pine Lake");
            names.Add("Pinewood");
            names.Add("Pinion Pines");
            names.Add("Pocola");
            names.Add("Polkton");
            names.Add("Port Allen");
            names.Add("Port Gibson");
            names.Add("Port Salerno");
            names.Add("Port St. John");
            names.Add("Port Vue");
            names.Add("Preston Heights");
            names.Add("Proctorville");
            names.Add("Prosper");
            names.Add("Pueblo");
            names.Add("Queen City");
            names.Add("Radium");
            names.Add("Raeville");
            names.Add("Raisin City");
            names.Add("Ramona");
            names.Add("Ranier");
            names.Add("Rawlins");
            names.Add("Red Hill");
            names.Add("Red Lick");
            names.Add("Reeds");
            names.Add("Reeltown");
            names.Add("Reese");
            names.Add("Reinholds");
            names.Add("Rendville");
            names.Add("Reston");
            names.Add("Riceville");
            names.Add("Richey");
            names.Add("Richton Park");
            names.Add("Ridgewood");
            names.Add("Rillito");
            names.Add("Rio Rico");
            names.Add("Rock Island");
            names.Add("Roebuck");
            names.Add("Round Rock");
            names.Add("Ruhenstroth");
            names.Add("Russia");
            names.Add("Sabina");
            names.Add("Sands Point");
            names.Add("Sangaree");
            names.Add("Santa Clara Pueblo");
            names.Add("Saronville");
            names.Add("Sauk Village");
            names.Add("Sault Ste. Marie");
            names.Add("Schoenchen");
            names.Add("Scottsdale");
            names.Add("Second Mesa");
            names.Add("Sentinel");
            names.Add("Seven Mile");
            names.Add("Seven Valleys");
            names.Add("Shaker Heights");
            names.Add("Shakopee");
            names.Add("Shallowater");
            names.Add("Sheboygan");
            names.Add("Shelbyville");
            names.Add("Sheldon");
            names.Add("Shelton");
            names.Add("Sidon");
            names.Add("Silsbee");
            names.Add("Silverhill");
            names.Add("Sissonville");
            names.Add("Smyrna");
            names.Add("Somerset");
            names.Add("Sopchoppy");
            names.Add("South Barrington");
            names.Add("South Bend");
            names.Add("South Gull Lake");
            names.Add("Southeast Arcadia");
            names.Add("Speculator");
            names.Add("Spooner");
            names.Add("St. Francis");
            names.Add("St. Martins");
            names.Add("Startup");
            names.Add("Statenville");
            names.Add("Stonybrook");
            names.Add("Sugartown");
            names.Add("Sullivans Island");
            names.Add("Sundown");
            names.Add("Sunrise");
            names.Add("Supai");
            names.Add("Supreme");
            names.Add("Swanville");
            names.Add("Sycamore");
            names.Add("Table Grove");
            names.Add("Taylor Landing");
            names.Add("Tehama");
            names.Add("Tennessee");
            names.Add("The Pinery");
            names.Add("Three Creeks");
            names.Add("Tildenville");
            names.Add("Tillamook");
            names.Add("Timber Lakes");
            names.Add("Timberwood Park");
            names.Add("Time");
            names.Add("Tonganoxie");
            names.Add("Tony");
            names.Add("Top-of-the-World");
            names.Add("Tower Hills");
            names.Add("Tracyton");
            names.Add("Trinity Center");
            names.Add("Troutville");
            names.Add("Tucson Estates");
            names.Add("Tunica Resorts");
            names.Add("Turpin Hills");
            names.Add("Tuscarawas");
            names.Add("Tuskegee");
            names.Add("Twentynine Palms");
            names.Add("Twin Groves");
            names.Add("Union Deposit");
            names.Add("Van Voorhis");
            names.Add("Vandenberg");
            names.Add("Vansant");
            names.Add("Vassar");
            names.Add("Vero Beach");
            names.Add("Vesta");
            names.Add("Villa del Sol");
            names.Add("Virgil");
            names.Add("Voorheesville");
            names.Add("Wacousta");
            names.Add("Waiehu");
            names.Add("Waldron");
            names.Add("Walford");
            names.Add("Walshville");
            names.Add("Wanda");
            names.Add("Wapella");
            names.Add("Warson Woods");
            names.Add("Water Valley");
            names.Add("Watterson Park");
            names.Add("Wayne City");
            names.Add("Weatherby");
            names.Add("Weimar");
            names.Add("West Carrollton");
            names.Add("West College Corner");
            names.Add("West Falmouth");
            names.Add("West Freehold");
            names.Add("West Portsmouth");
            names.Add("West University Place");
            names.Add("Westborough");
            names.Add("Wheatcroft");
            names.Add("Whipholt");
            names.Add("White River Junction");
            names.Add("Whitmer");
            names.Add("Wiggins");
            names.Add("Williams");
            names.Add("Williford");
            names.Add("Windham");
            names.Add("Winneconne");
            names.Add("Winter");
            names.Add("Wittmann");
            names.Add("Wolfhurst");
            names.Add("Wood Ridge");
            names.Add("Woodbine");
            names.Add("Woodcreek");
            names.Add("Wray");
            names.Add("Yakima");
            names.Add("Yoe");
            names.Add("Youngwood");
            names.Add("Yucca");
            names.Add("Zephyr Cove");
            names.Add("Zion");
            names.Add("Zuehl");


            return names;

        }

        public List<string> ListofSchoolNameTypes()
        {
            List<string> names = new List<string>();

            names.Add("Elementary");
            names.Add("Middle School");
            names.Add("Junior High");
            names.Add("High School");
            names.Add("Academy");

            return names;
        }

        public List<string> ListofStreetTypes()
        {
            List<string> names = new List<string>();

            names.Add("Street");
            names.Add("Road");
            names.Add("Way");
            names.Add("Drive");
            names.Add("Circle");

            return names;
        }

        public List<string> ListofUnitTypes()
        {
            List<string> names = new List<string>();

            names.Add("Apt #");
            names.Add("Unit #");
            names.Add("Suite #");
            names.Add("PO Box ");

            return names;
        }

        public string GetK12SeaName(string stateName)
        {

            string seaName = stateName + " State Education Agency";

            return seaName;

        }

        public string GetK12LeaName(Random rnd, List<string> placeNames)
        {

            string leaName = GetRandomString(rnd, placeNames) + " School District";

            return leaName;

        }

        public string GetK12SchoolName(Random rnd, List<string> placeNames, List<string> schoolTypes)
        {

            string schoolName = GetRandomString(rnd, placeNames) + " " + GetRandomString(rnd, schoolTypes);

            return schoolName;

        }

        public string GetK12SchoolName(Random rnd, List<string> placeNames, string schoolType)
        {

            string schoolName = GetRandomString(rnd, placeNames) + " " + schoolType;

            return schoolName;

        }

        public string GetStreetName(Random rnd, List<string> placeNames, List<string> streetTypes)
        {
            string streetName = GetRandomString(rnd, placeNames) + " " + GetRandomString(rnd, streetTypes);

            return streetName;

        }

        public string GetCityName(Random rnd, List<string> placeNames)
        {
            string placeName = GetRandomString(rnd, placeNames);

            return placeName;

        }

        public string GetUnitType(Random rnd, List<string> unitTypes)
        {
            string unitType = GetRandomString(rnd, unitTypes);

            return unitType;

        }

        public TimeSpan GetRandomTimeSpan(Random rnd)
        {
            TimeSpan start = TimeSpan.FromHours(7);
            TimeSpan end = TimeSpan.FromHours(7);
            int maxMinutes = (int)((end - start).TotalMinutes);
            int minutes = rnd.Next(maxMinutes);
            return start.Add(TimeSpan.FromMinutes(minutes));
        }

        #endregion


    }

}