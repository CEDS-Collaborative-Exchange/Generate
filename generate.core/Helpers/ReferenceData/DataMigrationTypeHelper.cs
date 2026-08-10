using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.App;

namespace generate.core.Helpers.ReferenceData
{
    public static class DataMigrationTypeHelper
    {
        public static List<DataMigrationType> GetData()
        {
            /*
            
            select 'data.Add(new DataMigrationType() { 
            DataMigrationTypeId = ' + convert(varchar(20), DataMigrationTypeId) + ',
            DataMigrationTypeName = "' + DataMigrationTypeName + '",
            DataMigrationTypeCode = "' + DataMigrationTypeCode + '"
            });'
            from App.DataMigrationTypes

            */


            var data = new List<DataMigrationType>();

            data.Add(new DataMigrationType() { DataMigrationTypeId = 1, DataMigrationTypeName = "Operational Data Store", DataMigrationTypeCode = "ods" });
            data.Add(new DataMigrationType() { DataMigrationTypeId = 2, DataMigrationTypeName = "Reporting Data Store", DataMigrationTypeCode = "rds" });
            data.Add(new DataMigrationType() { DataMigrationTypeId = 3, DataMigrationTypeName = "Report Warehouse", DataMigrationTypeCode = "report" });


            return data;

        }
    }
}
 