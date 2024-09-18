using generate.core.Models.RDS;
using System;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class DataMigrationTask
    {
        public int DataMigrationTaskId { get; set; }
        public int DataMigrationTypeId { get; set; }
        public string TaskName { get; set; }
        public string StoredProcedureName { get; set; }
        public string Description { get; set; }
        public int TaskSequence { get; set; }
        public int FactTypeId { get; set; }
        public bool IsActive { get; set; }
        public bool RunBeforeGenerateMigration { get; set; }
        public bool RunAfterGenerateMigration { get; set; }
        public bool? IsSelected { get; set; }
        public DataMigrationType DataMigrationType { get; set; }

    }
}
