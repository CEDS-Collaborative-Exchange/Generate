using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefOperationalStatusHelper
    {

        public static List<RefOperationalStatus> GetData()
        {
            /*
            select 'data.Add(new RefOperationalStatus() { 
            RefOperationalStatusId = ' + convert(varchar(20), RefOperationalStatusId) + ',
            RefOperationalStatusTypeId = ' + convert(varchar(20), RefOperationalStatusTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefOperationalStatus
            */

            var data = new List<RefOperationalStatus>();

            data.Add(new RefOperationalStatus() { RefOperationalStatusId = 1, RefOperationalStatusTypeId = 1, Code = "Open", Description = "Open" });
            data.Add(new RefOperationalStatus() { RefOperationalStatusId = 2, RefOperationalStatusTypeId = 1, Code = "Closed", Description = "Closed" });
            data.Add(new RefOperationalStatus() { RefOperationalStatusId = 3, RefOperationalStatusTypeId = 1, Code = "New", Description = "New" });
            data.Add(new RefOperationalStatus() { RefOperationalStatusId = 4, RefOperationalStatusTypeId = 1, Code = "Added", Description = "Added" });
            data.Add(new RefOperationalStatus() { RefOperationalStatusId = 5, RefOperationalStatusTypeId = 1, Code = "ChangedBoundary", Description = "Changed boundary" });
            data.Add(new RefOperationalStatus() { RefOperationalStatusId = 6, RefOperationalStatusTypeId = 1, Code = "Inactive", Description = "Inactive" });
            data.Add(new RefOperationalStatus() { RefOperationalStatusId = 7, RefOperationalStatusTypeId = 1, Code = "FutureAgency", Description = "Future agency" });
            data.Add(new RefOperationalStatus() { RefOperationalStatusId = 8, RefOperationalStatusTypeId = 1, Code = "Reopened", Description = "Reopened" });
            data.Add(new RefOperationalStatus() { RefOperationalStatusId = 9, RefOperationalStatusTypeId = 2, Code = "Open", Description = "Open" });
            data.Add(new RefOperationalStatus() { RefOperationalStatusId = 10, RefOperationalStatusTypeId = 2, Code = "Closed", Description = "Closed" });
            data.Add(new RefOperationalStatus() { RefOperationalStatusId = 11, RefOperationalStatusTypeId = 2, Code = "New", Description = "New" });
            data.Add(new RefOperationalStatus() { RefOperationalStatusId = 12, RefOperationalStatusTypeId = 2, Code = "Added", Description = "Added" });
            data.Add(new RefOperationalStatus() { RefOperationalStatusId = 13, RefOperationalStatusTypeId = 2, Code = "ChangedAgency", Description = "Changed Agency" });
            data.Add(new RefOperationalStatus() { RefOperationalStatusId = 14, RefOperationalStatusTypeId = 2, Code = "Inactive", Description = "Inactive" });
            data.Add(new RefOperationalStatus() { RefOperationalStatusId = 15, RefOperationalStatusTypeId = 2, Code = "FutureSchool", Description = "Future school" });
            data.Add(new RefOperationalStatus() { RefOperationalStatusId = 16, RefOperationalStatusTypeId = 2, Code = "Reopened", Description = "Reopened" });
            data.Add(new RefOperationalStatus() { RefOperationalStatusId = 17, RefOperationalStatusTypeId = 3, Code = "Active", Description = "Active" });
            data.Add(new RefOperationalStatus() { RefOperationalStatusId = 18, RefOperationalStatusTypeId = 3, Code = "Inactive", Description = "Inactive" });
            return data;
        }
    }
}
