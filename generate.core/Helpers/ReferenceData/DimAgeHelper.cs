using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.RDS;

namespace generate.core.Helpers.ReferenceData
{
    public class DimAgeHelper
    {
        public static List<DimAge> GetData()
        {


            var data = new List<DimAge>();

            /*
            select 'data.Add(new DimAge() { 
            DimAgeId = ' + convert(varchar(20), DimAgeId) + ',
            AgeId = ' + convert(varchar(20), AgeId) + ',
            AgeCode = "' + AgeCode + '",
            AgeValue = ' + convert(varchar(20), AgeValue) + '
            });'
            from rds.DimAges

            */

            //data.Add(new DimAge() { DimAgeId = -1, AgeId = -1, AgeCode = "MISSING", AgeValue = -1 });
            //data.Add(new DimAge() { DimAgeId = 1, AgeId = 0, AgeCode = "0", AgeValue = 0 });
            //data.Add(new DimAge() { DimAgeId = 2, AgeId = 1, AgeCode = "1", AgeValue = 1 });
            //data.Add(new DimAge() { DimAgeId = 3, AgeId = 2, AgeCode = "2", AgeValue = 2 });
            //data.Add(new DimAge() { DimAgeId = 4, AgeId = 3, AgeCode = "3", AgeValue = 3 });
            //data.Add(new DimAge() { DimAgeId = 5, AgeId = 4, AgeCode = "4", AgeValue = 4 });
            //data.Add(new DimAge() { DimAgeId = 6, AgeId = 5, AgeCode = "5", AgeValue = 5 });
            //data.Add(new DimAge() { DimAgeId = 7, AgeId = 6, AgeCode = "6", AgeValue = 6 });
            //data.Add(new DimAge() { DimAgeId = 8, AgeId = 7, AgeCode = "7", AgeValue = 7 });
            //data.Add(new DimAge() { DimAgeId = 9, AgeId = 8, AgeCode = "8", AgeValue = 8 });
            //data.Add(new DimAge() { DimAgeId = 10, AgeId = 9, AgeCode = "9", AgeValue = 9 });
            //data.Add(new DimAge() { DimAgeId = 11, AgeId = 10, AgeCode = "10", AgeValue = 10 });
            //data.Add(new DimAge() { DimAgeId = 12, AgeId = 11, AgeCode = "11", AgeValue = 11 });
            //data.Add(new DimAge() { DimAgeId = 13, AgeId = 12, AgeCode = "12", AgeValue = 12 });
            //data.Add(new DimAge() { DimAgeId = 14, AgeId = 13, AgeCode = "13", AgeValue = 13 });
            //data.Add(new DimAge() { DimAgeId = 15, AgeId = 14, AgeCode = "14", AgeValue = 14 });
            //data.Add(new DimAge() { DimAgeId = 16, AgeId = 15, AgeCode = "15", AgeValue = 15 });
            //data.Add(new DimAge() { DimAgeId = 17, AgeId = 16, AgeCode = "16", AgeValue = 16 });
            //data.Add(new DimAge() { DimAgeId = 18, AgeId = 17, AgeCode = "17", AgeValue = 17 });
            //data.Add(new DimAge() { DimAgeId = 19, AgeId = 18, AgeCode = "18", AgeValue = 18 });
            //data.Add(new DimAge() { DimAgeId = 20, AgeId = 19, AgeCode = "19", AgeValue = 19 });
            //data.Add(new DimAge() { DimAgeId = 21, AgeId = 20, AgeCode = "20", AgeValue = 20 });
            //data.Add(new DimAge() { DimAgeId = 22, AgeId = 21, AgeCode = "21", AgeValue = 21 });
            //data.Add(new DimAge() { DimAgeId = 23, AgeId = 22, AgeCode = "22", AgeValue = 22 });
            //data.Add(new DimAge() { DimAgeId = 24, AgeId = 23, AgeCode = "23", AgeValue = 23 });
            //data.Add(new DimAge() { DimAgeId = 25, AgeId = 24, AgeCode = "24", AgeValue = 24 });
            //data.Add(new DimAge() { DimAgeId = 26, AgeId = 25, AgeCode = "25", AgeValue = 25 });
            //data.Add(new DimAge() { DimAgeId = 27, AgeId = 26, AgeCode = "26", AgeValue = 26 });
            //data.Add(new DimAge() { DimAgeId = 28, AgeId = 27, AgeCode = "27", AgeValue = 27 });
            //data.Add(new DimAge() { DimAgeId = 29, AgeId = 28, AgeCode = "28", AgeValue = 28 });
            //data.Add(new DimAge() { DimAgeId = 30, AgeId = 29, AgeCode = "29", AgeValue = 29 });
            //data.Add(new DimAge() { DimAgeId = 31, AgeId = 30, AgeCode = "30", AgeValue = 30 });
            //data.Add(new DimAge() { DimAgeId = 32, AgeId = 31, AgeCode = "31", AgeValue = 31 });
            //data.Add(new DimAge() { DimAgeId = 33, AgeId = 32, AgeCode = "32", AgeValue = 32 });
            //data.Add(new DimAge() { DimAgeId = 34, AgeId = 33, AgeCode = "33", AgeValue = 33 });
            //data.Add(new DimAge() { DimAgeId = 35, AgeId = 34, AgeCode = "34", AgeValue = 34 });
            //data.Add(new DimAge() { DimAgeId = 36, AgeId = 35, AgeCode = "35", AgeValue = 35 });
            //data.Add(new DimAge() { DimAgeId = 37, AgeId = 36, AgeCode = "36", AgeValue = 36 });
            //data.Add(new DimAge() { DimAgeId = 38, AgeId = 37, AgeCode = "37", AgeValue = 37 });
            //data.Add(new DimAge() { DimAgeId = 39, AgeId = 38, AgeCode = "38", AgeValue = 38 });
            //data.Add(new DimAge() { DimAgeId = 40, AgeId = 39, AgeCode = "39", AgeValue = 39 });
            //data.Add(new DimAge() { DimAgeId = 41, AgeId = 40, AgeCode = "40", AgeValue = 40 });
            //data.Add(new DimAge() { DimAgeId = 42, AgeId = 41, AgeCode = "41", AgeValue = 41 });
            //data.Add(new DimAge() { DimAgeId = 43, AgeId = 42, AgeCode = "42", AgeValue = 42 });
            //data.Add(new DimAge() { DimAgeId = 44, AgeId = 43, AgeCode = "43", AgeValue = 43 });
            //data.Add(new DimAge() { DimAgeId = 45, AgeId = 44, AgeCode = "44", AgeValue = 44 });
            //data.Add(new DimAge() { DimAgeId = 46, AgeId = 45, AgeCode = "45", AgeValue = 45 });
            //data.Add(new DimAge() { DimAgeId = 47, AgeId = 46, AgeCode = "46", AgeValue = 46 });
            //data.Add(new DimAge() { DimAgeId = 48, AgeId = 47, AgeCode = "47", AgeValue = 47 });
            //data.Add(new DimAge() { DimAgeId = 49, AgeId = 48, AgeCode = "48", AgeValue = 48 });
            //data.Add(new DimAge() { DimAgeId = 50, AgeId = 49, AgeCode = "49", AgeValue = 49 });
            //data.Add(new DimAge() { DimAgeId = 51, AgeId = 50, AgeCode = "50", AgeValue = 50 });
            //data.Add(new DimAge() { DimAgeId = 52, AgeId = 51, AgeCode = "51", AgeValue = 51 });
            //data.Add(new DimAge() { DimAgeId = 53, AgeId = 52, AgeCode = "52", AgeValue = 52 });
            //data.Add(new DimAge() { DimAgeId = 54, AgeId = 53, AgeCode = "53", AgeValue = 53 });
            //data.Add(new DimAge() { DimAgeId = 55, AgeId = 54, AgeCode = "54", AgeValue = 54 });
            //data.Add(new DimAge() { DimAgeId = 56, AgeId = 55, AgeCode = "55", AgeValue = 55 });
            //data.Add(new DimAge() { DimAgeId = 57, AgeId = 56, AgeCode = "56", AgeValue = 56 });
            //data.Add(new DimAge() { DimAgeId = 58, AgeId = 57, AgeCode = "57", AgeValue = 57 });
            //data.Add(new DimAge() { DimAgeId = 59, AgeId = 58, AgeCode = "58", AgeValue = 58 });
            //data.Add(new DimAge() { DimAgeId = 60, AgeId = 59, AgeCode = "59", AgeValue = 59 });
            //data.Add(new DimAge() { DimAgeId = 61, AgeId = 60, AgeCode = "60", AgeValue = 60 });
            //data.Add(new DimAge() { DimAgeId = 62, AgeId = 61, AgeCode = "61", AgeValue = 61 });
            //data.Add(new DimAge() { DimAgeId = 63, AgeId = 62, AgeCode = "62", AgeValue = 62 });
            //data.Add(new DimAge() { DimAgeId = 64, AgeId = 63, AgeCode = "63", AgeValue = 63 });
            //data.Add(new DimAge() { DimAgeId = 65, AgeId = 64, AgeCode = "64", AgeValue = 64 });
            //data.Add(new DimAge() { DimAgeId = 66, AgeId = 65, AgeCode = "65", AgeValue = 65 });
            //data.Add(new DimAge() { DimAgeId = 67, AgeId = 66, AgeCode = "66", AgeValue = 66 });
            //data.Add(new DimAge() { DimAgeId = 68, AgeId = 67, AgeCode = "67", AgeValue = 67 });
            //data.Add(new DimAge() { DimAgeId = 69, AgeId = 68, AgeCode = "68", AgeValue = 68 });
            //data.Add(new DimAge() { DimAgeId = 70, AgeId = 69, AgeCode = "69", AgeValue = 69 });
            //data.Add(new DimAge() { DimAgeId = 71, AgeId = 70, AgeCode = "70", AgeValue = 70 });
            //data.Add(new DimAge() { DimAgeId = 72, AgeId = 71, AgeCode = "71", AgeValue = 71 });
            //data.Add(new DimAge() { DimAgeId = 73, AgeId = 72, AgeCode = "72", AgeValue = 72 });
            //data.Add(new DimAge() { DimAgeId = 74, AgeId = 73, AgeCode = "73", AgeValue = 73 });
            //data.Add(new DimAge() { DimAgeId = 75, AgeId = 74, AgeCode = "74", AgeValue = 74 });
            //data.Add(new DimAge() { DimAgeId = 76, AgeId = 75, AgeCode = "75", AgeValue = 75 });
            //data.Add(new DimAge() { DimAgeId = 77, AgeId = 76, AgeCode = "76", AgeValue = 76 });
            //data.Add(new DimAge() { DimAgeId = 78, AgeId = 77, AgeCode = "77", AgeValue = 77 });
            //data.Add(new DimAge() { DimAgeId = 79, AgeId = 78, AgeCode = "78", AgeValue = 78 });
            //data.Add(new DimAge() { DimAgeId = 80, AgeId = 79, AgeCode = "79", AgeValue = 79 });
            //data.Add(new DimAge() { DimAgeId = 81, AgeId = 80, AgeCode = "80", AgeValue = 80 });
            //data.Add(new DimAge() { DimAgeId = 82, AgeId = 81, AgeCode = "81", AgeValue = 81 });
            //data.Add(new DimAge() { DimAgeId = 83, AgeId = 82, AgeCode = "82", AgeValue = 82 });
            //data.Add(new DimAge() { DimAgeId = 84, AgeId = 83, AgeCode = "83", AgeValue = 83 });
            //data.Add(new DimAge() { DimAgeId = 85, AgeId = 84, AgeCode = "84", AgeValue = 84 });
            //data.Add(new DimAge() { DimAgeId = 86, AgeId = 85, AgeCode = "85", AgeValue = 85 });
            //data.Add(new DimAge() { DimAgeId = 87, AgeId = 86, AgeCode = "86", AgeValue = 86 });
            //data.Add(new DimAge() { DimAgeId = 88, AgeId = 87, AgeCode = "87", AgeValue = 87 });
            //data.Add(new DimAge() { DimAgeId = 89, AgeId = 88, AgeCode = "88", AgeValue = 88 });
            //data.Add(new DimAge() { DimAgeId = 90, AgeId = 89, AgeCode = "89", AgeValue = 89 });
            //data.Add(new DimAge() { DimAgeId = 91, AgeId = 90, AgeCode = "90", AgeValue = 90 });
            //data.Add(new DimAge() { DimAgeId = 92, AgeId = 91, AgeCode = "91", AgeValue = 91 });
            //data.Add(new DimAge() { DimAgeId = 93, AgeId = 92, AgeCode = "92", AgeValue = 92 });
            //data.Add(new DimAge() { DimAgeId = 94, AgeId = 93, AgeCode = "93", AgeValue = 93 });
            //data.Add(new DimAge() { DimAgeId = 95, AgeId = 94, AgeCode = "94", AgeValue = 94 });
            //data.Add(new DimAge() { DimAgeId = 96, AgeId = 95, AgeCode = "95", AgeValue = 95 });
            //data.Add(new DimAge() { DimAgeId = 97, AgeId = 96, AgeCode = "96", AgeValue = 96 });
            //data.Add(new DimAge() { DimAgeId = 98, AgeId = 97, AgeCode = "97", AgeValue = 97 });
            //data.Add(new DimAge() { DimAgeId = 99, AgeId = 98, AgeCode = "98", AgeValue = 98 });
            //data.Add(new DimAge() { DimAgeId = 100, AgeId = 99, AgeCode = "99", AgeValue = 99 });
            //data.Add(new DimAge() { DimAgeId = 101, AgeId = 100, AgeCode = "100", AgeValue = 100 });
            //data.Add(new DimAge() { DimAgeId = 102, AgeId = 101, AgeCode = "101", AgeValue = 101 });
            //data.Add(new DimAge() { DimAgeId = 103, AgeId = 102, AgeCode = "102", AgeValue = 102 });
            //data.Add(new DimAge() { DimAgeId = 104, AgeId = 103, AgeCode = "103", AgeValue = 103 });
            //data.Add(new DimAge() { DimAgeId = 105, AgeId = 104, AgeCode = "104", AgeValue = 104 });
            //data.Add(new DimAge() { DimAgeId = 106, AgeId = 105, AgeCode = "105", AgeValue = 105 });
            //data.Add(new DimAge() { DimAgeId = 107, AgeId = 106, AgeCode = "106", AgeValue = 106 });
            //data.Add(new DimAge() { DimAgeId = 108, AgeId = 107, AgeCode = "107", AgeValue = 107 });
            //data.Add(new DimAge() { DimAgeId = 109, AgeId = 108, AgeCode = "108", AgeValue = 108 });
            //data.Add(new DimAge() { DimAgeId = 110, AgeId = 109, AgeCode = "109", AgeValue = 109 });
            //data.Add(new DimAge() { DimAgeId = 111, AgeId = 110, AgeCode = "110", AgeValue = 110 });
            //data.Add(new DimAge() { DimAgeId = 112, AgeId = 111, AgeCode = "111", AgeValue = 111 });
            //data.Add(new DimAge() { DimAgeId = 113, AgeId = 112, AgeCode = "112", AgeValue = 112 });
            //data.Add(new DimAge() { DimAgeId = 114, AgeId = 113, AgeCode = "113", AgeValue = 113 });
            //data.Add(new DimAge() { DimAgeId = 115, AgeId = 114, AgeCode = "114", AgeValue = 114 });
            //data.Add(new DimAge() { DimAgeId = 116, AgeId = 115, AgeCode = "115", AgeValue = 115 });
            //data.Add(new DimAge() { DimAgeId = 117, AgeId = 116, AgeCode = "116", AgeValue = 116 });
            //data.Add(new DimAge() { DimAgeId = 118, AgeId = 117, AgeCode = "117", AgeValue = 117 });
            //data.Add(new DimAge() { DimAgeId = 119, AgeId = 118, AgeCode = "118", AgeValue = 118 });
            //data.Add(new DimAge() { DimAgeId = 120, AgeId = 119, AgeCode = "119", AgeValue = 119 });
            //data.Add(new DimAge() { DimAgeId = 121, AgeId = 120, AgeCode = "120", AgeValue = 120 });
            //data.Add(new DimAge() { DimAgeId = 122, AgeId = 121, AgeCode = "121", AgeValue = 121 });
            //data.Add(new DimAge() { DimAgeId = 123, AgeId = 122, AgeCode = "122", AgeValue = 122 });
            //data.Add(new DimAge() { DimAgeId = 124, AgeId = 123, AgeCode = "123", AgeValue = 123 });
            //data.Add(new DimAge() { DimAgeId = 125, AgeId = 124, AgeCode = "124", AgeValue = 124 });
            //data.Add(new DimAge() { DimAgeId = 126, AgeId = 125, AgeCode = "125", AgeValue = 125 });
            //data.Add(new DimAge() { DimAgeId = 127, AgeId = 126, AgeCode = "126", AgeValue = 126 });
            //data.Add(new DimAge() { DimAgeId = 128, AgeId = 127, AgeCode = "127", AgeValue = 127 });
            //data.Add(new DimAge() { DimAgeId = 129, AgeId = 128, AgeCode = "128", AgeValue = 128 });
            //data.Add(new DimAge() { DimAgeId = 130, AgeId = 129, AgeCode = "129", AgeValue = 129 });
            //data.Add(new DimAge() { DimAgeId = 131, AgeId = 130, AgeCode = "130", AgeValue = 130 });


            return data;

        }
    }
}
 