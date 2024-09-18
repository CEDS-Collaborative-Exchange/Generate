using System;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class DataMigrationHistory
    {
        public int DataMigrationHistoryId { get; set; }
        public int DataMigrationTypeId { get; set; }
        public DateTime DataMigrationHistoryDate { get; set; }
        public string DataMigrationHistoryMessage { get; set; }
        public DataMigrationType DataMigrationType { get; set; }
    }
}
