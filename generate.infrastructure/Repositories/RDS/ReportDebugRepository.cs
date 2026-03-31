using Azure.Core.Serialization;
using generate.core.Dtos.RDS;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Models.RDS;
using generate.infrastructure.Contexts;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.infrastructure.Repositories.RDS
{
    public class ReportDebugRepository : RDSRepository, IReportDebugRepository
    {
        private readonly ILogger _logger;

        public ReportDebugRepository(
            ILogger<FactStaffCountRepository> logger,
            RDSDbContext rdsDbContext
            )
            : base(rdsDbContext)
        {
            _logger = logger;
        }

        public IEnumerable<ReportDebug> Get_ReportDebugData(string reportCode, string reportLevel, string reportYear, string categorySetCode, string parameters, int sort, int skip, int take, int pageSize, int page)
        {
            int totalRecordCount = 0;

            var returnObject = new List<ReportDebug>();

            try
            {
                string connectionString = GetConnectionString();
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    using (SqlCommand command = new SqlCommand("rds.Get_ReportDebugData", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.CommandTimeout = 11000;

                        command.Parameters.AddWithValue("@reportCode", reportCode);
                        command.Parameters.AddWithValue("@reportLevel", reportLevel);
                        command.Parameters.AddWithValue("@reportYear", reportYear);
                        command.Parameters.AddWithValue("@categorySetCode", categorySetCode != null ? categorySetCode : DBNull.Value);
                        command.Parameters.AddWithValue("@parameters", parameters);
                        //command.Parameters.AddWithValue("@startRecord", startRecord);
                        //command.Parameters.AddWithValue("@numberOfRecords", numberOfRecords);

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            if (reader.HasRows)
                            {
                                int fileRecordNUmber = 0;
                                // Read the data
                                while (reader.Read())
                                {
                                    ++fileRecordNUmber;

                                    var dto = new ReportDebug();
                                    for (int i = 0; i < reader.FieldCount; i++)
                                    {
                                        dto.Fields[reader.GetName(i)] = reader.GetValue(i);
                                    }
                                    returnObject.Add(dto);
                                }
                            }

                            if (reader.NextResult())
                            {
                                if (reader.Read())
                                {
                                    totalRecordCount = reader.GetInt32(0);
                                }
                            }

                        }
                    }
                }

            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;
            }
            return returnObject;

        }
    }
}
