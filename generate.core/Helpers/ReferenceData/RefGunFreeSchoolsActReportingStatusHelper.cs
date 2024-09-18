using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefGunFreeSchoolsActReportingStatusHelper
    {

        public static List<RefGunFreeSchoolsActReportingStatus> GetData()
        {
            /*
            select 'data.Add(new RefGunFreeSchoolsActReportingStatus() { 
            RefGunFreeSchoolsActStatusReportingId = ' + convert(varchar(20), RefGunFreeSchoolsActStatusReportingId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefGunFreeSchoolsActReportingStatus
            */

            var data = new List<RefGunFreeSchoolsActReportingStatus>();

            data.Add(new RefGunFreeSchoolsActReportingStatus() { RefGunFreeSchoolsActStatusReportingId = 1, Code = "YesReportingOffenses", Description = "Yes, with reporting of one or more students for an offense" });
            data.Add(new RefGunFreeSchoolsActReportingStatus() { RefGunFreeSchoolsActStatusReportingId = 2, Code = "YesNoReportedOffenses", Description = "Yes, with no reported offenses" });
            data.Add(new RefGunFreeSchoolsActReportingStatus() { RefGunFreeSchoolsActStatusReportingId = 3, Code = "No", Description = "No" });
            data.Add(new RefGunFreeSchoolsActReportingStatus() { RefGunFreeSchoolsActStatusReportingId = 4, Code = "NA", Description = "Not applicable" });

            return data;
        }
    }
}
