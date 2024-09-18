using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.RDS;

namespace generate.core.Helpers.ReferenceData
{
    public class DimRaceHelper
    {
        public static List<DimRace> GetData()
        {


            var data = new List<DimRace>();

            /*
            select 'data.Add(new DimRace() { 
            DimRaceId = ' + convert(varchar(20), DimRaceId) + ',
            DimFactTypeId = ' + convert(varchar(20), isnull(DimFactTypeId, -1)) + ',
            RaceId = ' + convert(varchar(20), isnull(RaceId, -1)) + ',
            RaceCode = "' + RaceCode + '"
			});'
            from rds.DimRaces
            */

            data.Add(new DimRace() { DimRaceId = -1, DimFactTypeId = -1, RaceId = -1, RaceCode = "MISSING" });
            data.Add(new DimRace() { DimRaceId = 1, DimFactTypeId = 1, RaceId = 1, RaceCode = "AmericanIndianorAlaskaNative" });
            data.Add(new DimRace() { DimRaceId = 2, DimFactTypeId = 1, RaceId = 2, RaceCode = "Asian" });
            data.Add(new DimRace() { DimRaceId = 3, DimFactTypeId = 1, RaceId = 3, RaceCode = "BlackorAfricanAmerican" });
            data.Add(new DimRace() { DimRaceId = 4, DimFactTypeId = 1, RaceId = 4, RaceCode = "NativeHawaiianorOtherPacificIslander" });
            data.Add(new DimRace() { DimRaceId = 5, DimFactTypeId = 1, RaceId = 5, RaceCode = "White" });
            data.Add(new DimRace() { DimRaceId = 6, DimFactTypeId = 1, RaceId = 6, RaceCode = "TwoorMoreRaces" });
            data.Add(new DimRace() { DimRaceId = 7, DimFactTypeId = 1, RaceId = 7, RaceCode = "HI" });
            data.Add(new DimRace() { DimRaceId = 8, DimFactTypeId = 2, RaceId = 8, RaceCode = "AM7" });
            data.Add(new DimRace() { DimRaceId = 9, DimFactTypeId = 2, RaceId = 9, RaceCode = "AS7" });
            data.Add(new DimRace() { DimRaceId = 10, DimFactTypeId = 2, RaceId = 10, RaceCode = "BL7" });
            data.Add(new DimRace() { DimRaceId = 11, DimFactTypeId = 2, RaceId = 11, RaceCode = "HI7" });
            data.Add(new DimRace() { DimRaceId = 12, DimFactTypeId = 2, RaceId = 12, RaceCode = "PI7" });
            data.Add(new DimRace() { DimRaceId = 13, DimFactTypeId = 2, RaceId = 13, RaceCode = "WH7" });
            data.Add(new DimRace() { DimRaceId = 14, DimFactTypeId = 2, RaceId = 14, RaceCode = "MU7" });
            data.Add(new DimRace() { DimRaceId = 15, DimFactTypeId = 3, RaceId = 15, RaceCode = "AM7" });
            data.Add(new DimRace() { DimRaceId = 16, DimFactTypeId = 3, RaceId = 16, RaceCode = "AS7" });
            data.Add(new DimRace() { DimRaceId = 17, DimFactTypeId = 3, RaceId = 17, RaceCode = "BL7" });
            data.Add(new DimRace() { DimRaceId = 18, DimFactTypeId = 3, RaceId = 18, RaceCode = "HI7" });
            data.Add(new DimRace() { DimRaceId = 19, DimFactTypeId = 3, RaceId = 19, RaceCode = "PI7" });
            data.Add(new DimRace() { DimRaceId = 20, DimFactTypeId = 3, RaceId = 20, RaceCode = "WH7" });
            data.Add(new DimRace() { DimRaceId = 21, DimFactTypeId = 3, RaceId = 21, RaceCode = "MU7" });
            data.Add(new DimRace() { DimRaceId = 22, DimFactTypeId = 4, RaceId = 22, RaceCode = "AM7" });
            data.Add(new DimRace() { DimRaceId = 23, DimFactTypeId = 4, RaceId = 23, RaceCode = "AS7" });
            data.Add(new DimRace() { DimRaceId = 24, DimFactTypeId = 4, RaceId = 24, RaceCode = "BL7" });
            data.Add(new DimRace() { DimRaceId = 25, DimFactTypeId = 4, RaceId = 25, RaceCode = "HI7" });
            data.Add(new DimRace() { DimRaceId = 26, DimFactTypeId = 4, RaceId = 26, RaceCode = "PI7" });
            data.Add(new DimRace() { DimRaceId = 27, DimFactTypeId = 4, RaceId = 27, RaceCode = "WH7" });
            data.Add(new DimRace() { DimRaceId = 28, DimFactTypeId = 4, RaceId = 28, RaceCode = "MU7" });

            return data;

        }
    }
}
 