using System;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class DataMigration
    {
        public int DataMigrationId { get; set; }
        public int DataMigrationTypeId { get; set; }
        public DataMigrationType DataMigrationType { get; set; }
        public int DataMigrationStatusId { get; set; }
        public int? LastDurationInSeconds { get; set; }
        public DateTime? LastTriggerDate { get; set; }
        public string UserName { get; set; }
        public string DataMigrationTaskList { get; set; }
        public DataMigrationStatus DataMigrationStatus { get; set; }
    }
}
