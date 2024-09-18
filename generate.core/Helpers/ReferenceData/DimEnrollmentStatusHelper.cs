using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.RDS;

namespace generate.core.Helpers.ReferenceData
{
    public class DimEnrollmentStatusHelper
    {
        public static List<DimK12EnrollmentStatus> GetData()
        {


            var data = new List<DimK12EnrollmentStatus>();

            /*
            select 'data.Add(new DimEnrollmentStatus() { 
            DimEnrollmentStatusId = ' + convert(varchar(20), DimEnrollmentStatusId) + ',
            ExitOrWithdrawalId = ' + convert(varchar(20), ExitOrWithdrawalId) + ',
            ExitOrWithdrawalEdFactsCode = "' + ExitOrWithdrawalEdFactsCode + '"
			});'
            from rds.DimEnrollmentStatuses

            */

            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 1,
            //    ExitOrWithdrawalId = 1,
            //    ExitOrWithdrawalEdFactsCode = "01907"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 2,
            //    ExitOrWithdrawalId = 2,
            //    ExitOrWithdrawalEdFactsCode = "01908"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 3,
            //    ExitOrWithdrawalId = 3,
            //    ExitOrWithdrawalEdFactsCode = "01909"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 4,
            //    ExitOrWithdrawalId = 4,
            //    ExitOrWithdrawalEdFactsCode = "01910"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 5,
            //    ExitOrWithdrawalId = 5,
            //    ExitOrWithdrawalEdFactsCode = "01911"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 6,
            //    ExitOrWithdrawalId = 6,
            //    ExitOrWithdrawalEdFactsCode = "01912"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 7,
            //    ExitOrWithdrawalId = 7,
            //    ExitOrWithdrawalEdFactsCode = "01913"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 8,
            //    ExitOrWithdrawalId = 8,
            //    ExitOrWithdrawalEdFactsCode = "01914"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 9,
            //    ExitOrWithdrawalId = 9,
            //    ExitOrWithdrawalEdFactsCode = "01915"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 10,
            //    ExitOrWithdrawalId = 10,
            //    ExitOrWithdrawalEdFactsCode = "01916"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 11,
            //    ExitOrWithdrawalId = 11,
            //    ExitOrWithdrawalEdFactsCode = "01917"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 12,
            //    ExitOrWithdrawalId = 12,
            //    ExitOrWithdrawalEdFactsCode = "01918"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 13,
            //    ExitOrWithdrawalId = 13,
            //    ExitOrWithdrawalEdFactsCode = "01919"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 14,
            //    ExitOrWithdrawalId = 14,
            //    ExitOrWithdrawalEdFactsCode = "01921"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 15,
            //    ExitOrWithdrawalId = 15,
            //    ExitOrWithdrawalEdFactsCode = "01922"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 16,
            //    ExitOrWithdrawalId = 16,
            //    ExitOrWithdrawalEdFactsCode = "01923"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 17,
            //    ExitOrWithdrawalId = 17,
            //    ExitOrWithdrawalEdFactsCode = "01924"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 18,
            //    ExitOrWithdrawalId = 18,
            //    ExitOrWithdrawalEdFactsCode = "01925"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 19,
            //    ExitOrWithdrawalId = 19,
            //    ExitOrWithdrawalEdFactsCode = "01926"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 20,
            //    ExitOrWithdrawalId = 20,
            //    ExitOrWithdrawalEdFactsCode = "01927"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 21,
            //    ExitOrWithdrawalId = 21,
            //    ExitOrWithdrawalEdFactsCode = "01928"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 22,
            //    ExitOrWithdrawalId = 22,
            //    ExitOrWithdrawalEdFactsCode = "01930"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 23,
            //    ExitOrWithdrawalId = 23,
            //    ExitOrWithdrawalEdFactsCode = "01931"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 24,
            //    ExitOrWithdrawalId = 24,
            //    ExitOrWithdrawalEdFactsCode = "03499"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 25,
            //    ExitOrWithdrawalId = 25,
            //    ExitOrWithdrawalEdFactsCode = "03502"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 26,
            //    ExitOrWithdrawalId = 26,
            //    ExitOrWithdrawalEdFactsCode = "03503"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 27,
            //    ExitOrWithdrawalId = 27,
            //    ExitOrWithdrawalEdFactsCode = "03504"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 28,
            //    ExitOrWithdrawalId = 28,
            //    ExitOrWithdrawalEdFactsCode = "03505"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 29,
            //    ExitOrWithdrawalId = 29,
            //    ExitOrWithdrawalEdFactsCode = "03508"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 30,
            //    ExitOrWithdrawalId = 30,
            //    ExitOrWithdrawalEdFactsCode = "03509"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 31,
            //    ExitOrWithdrawalId = 31,
            //    ExitOrWithdrawalEdFactsCode = "09999"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 32,
            //    ExitOrWithdrawalId = 32,
            //    ExitOrWithdrawalEdFactsCode = "73060"
            //});
            //data.Add(new DimK12EnrollmentStatus()
            //{
            //    DimEnrollmentStatusId = 33,
            //    ExitOrWithdrawalId = 33,
            //    ExitOrWithdrawalEdFactsCode = "73061"
            //});

            return data;

        }
    }
}
