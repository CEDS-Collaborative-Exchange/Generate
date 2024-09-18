using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.RDS;

namespace generate.core.Helpers.ReferenceData
{
    public class DimDateHelper
    {
        public static List<DimDate> GetData()
        {


            var data = new List<DimDate>();

            data.Add(new DimDate() { DimDateId = -1 });

            /*
            select 'data.Add(new DimDate() { 
            DimDateId = ' + convert(varchar(20), DimDateId) + ',
            DateValue = new DateTime(' + convert(varchar(20), [Year]) + ', ' + convert(varchar(20), [Month]) + ', ' + convert(varchar(20), [Day]) + '),
            SubmissionYear = "' + SubmissionYear + '",
            Year = ' + convert(varchar(20), [Year]) + '
            });'
            from rds.DimDates
            where DimDateId <> -1
            */

            data.Add(new DimDate() { DimDateId = 4, DateValue = new DateTime(2016, 11, 1), SubmissionYear = "2016-17", Year = 2016 });
            data.Add(new DimDate() { DimDateId = 5, DateValue = new DateTime(2015, 11, 1), SubmissionYear = "2015-16", Year = 2015 });
            data.Add(new DimDate() { DimDateId = 6, DateValue = new DateTime(2014, 11, 1), SubmissionYear = "2014-15", Year = 2014 });
            data.Add(new DimDate() { DimDateId = 7, DateValue = new DateTime(2013, 11, 1), SubmissionYear = "2013-14", Year = 2013 });
            data.Add(new DimDate() { DimDateId = 8, DateValue = new DateTime(2017, 11, 1), SubmissionYear = "2017-18", Year = 2017 });
            data.Add(new DimDate() { DimDateId = 9, DateValue = new DateTime(2018, 11, 1), SubmissionYear = "2018-19", Year = 2018 });

            return data;

        }
    }
}
 