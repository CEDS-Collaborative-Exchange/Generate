using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefStateHelper
    {

        public static List<RefState> GetData()
        {
            /*
            select 'data.Add(new RefState() { 
            RefStateId = ' + convert(varchar(20), RefStateId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefState
            */

            var data = new List<RefState>();

            data.Add(new RefState() { RefStateId = 1, Code = "AK", Description = "Alaska" });
            data.Add(new RefState() { RefStateId = 2, Code = "AL", Description = "Alabama" });
            data.Add(new RefState() { RefStateId = 3, Code = "AR", Description = "Arkansas" });
            data.Add(new RefState() { RefStateId = 4, Code = "AS", Description = "American Samoa" });
            data.Add(new RefState() { RefStateId = 5, Code = "AZ", Description = "Arizona" });
            data.Add(new RefState() { RefStateId = 6, Code = "CA", Description = "California" });
            data.Add(new RefState() { RefStateId = 7, Code = "CO", Description = "Colorado" });
            data.Add(new RefState() { RefStateId = 8, Code = "CT", Description = "Connecticut" });
            data.Add(new RefState() { RefStateId = 9, Code = "DC", Description = "District of Columbia" });
            data.Add(new RefState() { RefStateId = 10, Code = "DE", Description = "Delaware" });
            data.Add(new RefState() { RefStateId = 11, Code = "FL", Description = "Florida" });
            data.Add(new RefState() { RefStateId = 12, Code = "FM", Description = "Federated States of Micronesia" });
            data.Add(new RefState() { RefStateId = 13, Code = "GA", Description = "Georgia" });
            data.Add(new RefState() { RefStateId = 14, Code = "GU", Description = "Guam" });
            data.Add(new RefState() { RefStateId = 15, Code = "HI", Description = "Hawaii" });
            data.Add(new RefState() { RefStateId = 16, Code = "IA", Description = "Iowa" });
            data.Add(new RefState() { RefStateId = 17, Code = "ID", Description = "Idaho" });
            data.Add(new RefState() { RefStateId = 18, Code = "IL", Description = "Illinois" });
            data.Add(new RefState() { RefStateId = 19, Code = "IN", Description = "Indiana" });
            data.Add(new RefState() { RefStateId = 20, Code = "KS", Description = "Kansas" });
            data.Add(new RefState() { RefStateId = 21, Code = "KY", Description = "Kentucky" });
            data.Add(new RefState() { RefStateId = 22, Code = "LA", Description = "Louisiana" });
            data.Add(new RefState() { RefStateId = 23, Code = "MA", Description = "Massachusetts" });
            data.Add(new RefState() { RefStateId = 24, Code = "MD", Description = "Maryland" });
            data.Add(new RefState() { RefStateId = 25, Code = "ME", Description = "Maine" });
            data.Add(new RefState() { RefStateId = 26, Code = "MH", Description = "Marshall Islands" });
            data.Add(new RefState() { RefStateId = 27, Code = "MI", Description = "Michigan" });
            data.Add(new RefState() { RefStateId = 28, Code = "MN", Description = "Minnesota" });
            data.Add(new RefState() { RefStateId = 29, Code = "MO", Description = "Missouri" });
            data.Add(new RefState() { RefStateId = 30, Code = "MP", Description = "Northern Marianas" });
            data.Add(new RefState() { RefStateId = 31, Code = "MS", Description = "Mississippi" });
            data.Add(new RefState() { RefStateId = 32, Code = "MT", Description = "Montana" });
            data.Add(new RefState() { RefStateId = 33, Code = "NC", Description = "North Carolina" });
            data.Add(new RefState() { RefStateId = 34, Code = "ND", Description = "North Dakota" });
            data.Add(new RefState() { RefStateId = 35, Code = "NE", Description = "Nebraska" });
            data.Add(new RefState() { RefStateId = 36, Code = "NH", Description = "New Hampshire" });
            data.Add(new RefState() { RefStateId = 37, Code = "NJ", Description = "New Jersey" });
            data.Add(new RefState() { RefStateId = 38, Code = "NM", Description = "New Mexico" });
            data.Add(new RefState() { RefStateId = 39, Code = "NV", Description = "Nevada" });
            data.Add(new RefState() { RefStateId = 40, Code = "NY", Description = "New York" });
            data.Add(new RefState() { RefStateId = 41, Code = "OH", Description = "Ohio" });
            data.Add(new RefState() { RefStateId = 42, Code = "OK", Description = "Oklahoma" });
            data.Add(new RefState() { RefStateId = 43, Code = "OR", Description = "Oregon" });
            data.Add(new RefState() { RefStateId = 44, Code = "PA", Description = "Pennsylvania" });
            data.Add(new RefState() { RefStateId = 45, Code = "PR", Description = "Puerto Rico" });
            data.Add(new RefState() { RefStateId = 46, Code = "PW", Description = "Palau" });
            data.Add(new RefState() { RefStateId = 47, Code = "RI", Description = "Rhode Island" });
            data.Add(new RefState() { RefStateId = 48, Code = "SC", Description = "South Carolina" });
            data.Add(new RefState() { RefStateId = 49, Code = "SD", Description = "South Dakota" });
            data.Add(new RefState() { RefStateId = 50, Code = "TN", Description = "Tennessee" });
            data.Add(new RefState() { RefStateId = 51, Code = "TX", Description = "Texas" });
            data.Add(new RefState() { RefStateId = 52, Code = "UT", Description = "Utah" });
            data.Add(new RefState() { RefStateId = 53, Code = "VA", Description = "Virginia" });
            data.Add(new RefState() { RefStateId = 54, Code = "VI", Description = "Virgin Islands" });
            data.Add(new RefState() { RefStateId = 55, Code = "VT", Description = "Vermont" });
            data.Add(new RefState() { RefStateId = 56, Code = "WA", Description = "Washington" });
            data.Add(new RefState() { RefStateId = 57, Code = "WI", Description = "Wisconsin" });
            data.Add(new RefState() { RefStateId = 58, Code = "WV", Description = "West Virginia" });
            data.Add(new RefState() { RefStateId = 59, Code = "WY", Description = "Wyoming" });
            data.Add(new RefState() { RefStateId = 60, Code = "AA", Description = "Armed Forces America" });
            data.Add(new RefState() { RefStateId = 61, Code = "AE", Description = "Armed Forces Africa, Canada, Europe, and Mideast" });
            data.Add(new RefState() { RefStateId = 62, Code = "AP", Description = "Armed Forces Pacific" });

            return data;
        }
    }
}
