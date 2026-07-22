using System;
using System.Collections.Generic;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace generate.infrastructure.Services
{
    /// <summary>One CEDS-annotated column in the warehouse Staging schema.</summary>
    public class StagingCedsColumn
    {
        public string SchemaName { get; set; }
        public string TableName { get; set; }
        public string ColumnName { get; set; }
        public string CedsGlobalId { get; set; }   // CEDS identifier minus the C/P prefix
        public string CedsElement { get; set; }
    }

    /// <summary>
    /// Reads the CEDS extended properties on Staging-schema columns via App.vwEtlStagingCedsColumns
    /// (CIID-9057, epic CIID-9029). Used to (a) restrict the CEDS element catalog to elements that can
    /// be loaded into the warehouse and (b) show each element's Staging table + column(s).
    ///
    /// Registered as a singleton and cached for the application lifetime: warehouse schema metadata is
    /// static within a deployment. Uses the App database connection string from configuration.
    /// </summary>
    public class StagingCedsColumnProvider
    {
        private readonly string _connectionString;
        private readonly Lazy<List<StagingCedsColumn>> _columns;

        public StagingCedsColumnProvider(IConfiguration configuration)
        {
            _connectionString = configuration["Data:AppDbContextConnection"];
            _columns = new Lazy<List<StagingCedsColumn>>(Load);
        }

        public virtual bool IsAvailable => !string.IsNullOrWhiteSpace(_connectionString);

        public virtual IReadOnlyList<StagingCedsColumn> GetColumns()
        {
            return _columns.Value;
        }

        private List<StagingCedsColumn> Load()
        {
            var columns = new List<StagingCedsColumn>();

            if (!IsAvailable)
            {
                return columns;
            }

            using var connection = new SqlConnection(_connectionString);
            connection.Open();

            using var command = connection.CreateCommand();
            command.CommandText =
                "SELECT SchemaName, TableName, ColumnName, CedsGlobalId, CedsElement " +
                "FROM App.vwEtlStagingCedsColumns";

            using var reader = command.ExecuteReader();

            while (reader.Read())
            {
                columns.Add(new StagingCedsColumn
                {
                    SchemaName = reader.IsDBNull(0) ? null : reader.GetString(0),
                    TableName = reader.IsDBNull(1) ? null : reader.GetString(1),
                    ColumnName = reader.IsDBNull(2) ? null : reader.GetString(2),
                    CedsGlobalId = reader.IsDBNull(3) ? null : reader.GetString(3),
                    CedsElement = reader.IsDBNull(4) ? null : reader.GetString(4)
                });
            }

            return columns;
        }
    }
}
