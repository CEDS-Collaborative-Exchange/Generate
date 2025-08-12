using System;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using generate.infrastructure.Contexts;
using generate.core.Models.App;
using generate.core.Models.RDS;
using Microsoft.EntityFrameworkCore;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Dtos.ODS;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;
using System.Data;
using generate.core.Dtos.RDS;

namespace generate.infrastructure.Repositories.RDS 
{
    public class FactStudentCountRepository : IFactStudentCountRepository
    {
        private readonly ILogger _logger;
        private readonly RDSDbContext _rdsDbContext;

        public FactStudentCountRepository(
            ILogger<FactStudentCountRepository> logger,
            RDSDbContext rdsDbContext
            )
        {
            _logger = logger;
            _rdsDbContext = rdsDbContext;
        }

        public void Migrate_StudentCounts(string factTypeCode)
        {

            int? oldTimeOut = _rdsDbContext.Database.GetCommandTimeout();
            _rdsDbContext.Database.SetCommandTimeout(11000);
            _rdsDbContext.Database.ExecuteSqlRaw("rds.Migrate_StudentCounts @factTypeCode = {0}, @runAsTest = 0", factTypeCode);
            _rdsDbContext.Database.SetCommandTimeout(oldTimeOut);

        }
        
        public  IEnumerable<ReportEDFactsK12StudentCount> Get_ReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, bool includeZeroCounts = false, bool includeFriendlyCaptions = false, bool obscureMissingCategoryCounts = false, bool isOnlineReport = false)
        {
            // Convert bool parameters to bit values

            int zeroCounts = 0;
            int friendlyCaptions = 0;
            int missingCategoryCounts = 0;
            int onlineReport = 0;

            if (includeZeroCounts)
            {
                zeroCounts = 1;
            }
            if (includeFriendlyCaptions)
            {
                friendlyCaptions = 1;
            }
            if (obscureMissingCategoryCounts)
            {
                missingCategoryCounts = 1;
            }
            if (isOnlineReport)
            {
                onlineReport = 1;
            }

            var returnObject = new List<ReportEDFactsK12StudentCount>();

            try
            {
                int? oldTimeout = _rdsDbContext.Database.GetCommandTimeout();
                _rdsDbContext.Database.SetCommandTimeout(11000);
                returnObject = _rdsDbContext.Set<ReportEDFactsK12StudentCount>().FromSqlRaw("rds.Get_ReportData @reportCode = {0}, @reportLevel = {1}, @reportYear = {2}, @categorySetCode = {3}, @includeZeroCounts = {4}, @includeFriendlyCaptions = {5}, @obscureMissingCategoryCounts = {6}, @isOnlineReport={7}", reportCode, reportLevel, reportYear, categorySetCode, zeroCounts, friendlyCaptions, missingCategoryCounts, onlineReport).ToList();
                _rdsDbContext.Database.SetCommandTimeout(oldTimeout);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;  
            }
            return returnObject;

        }



        public (IEnumerable<MembershipReportDto>,int)  Get_MembershipReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, bool includeZeroCounts = false, bool includeFriendlyCaptions = false, bool obscureMissingCategoryCounts = false, bool isOnlineReport = false, int startRecord = 1, int numberOfRecords = 1000000)
        {
            // Convert bool parameters to bit values

            int zeroCounts = 0;
            int friendlyCaptions = 0;
            int missingCategoryCounts = 0;
            int onlineReport = 0;

            if (includeZeroCounts)
            {
                zeroCounts = 1;
            }
            if (includeFriendlyCaptions)
            {
                friendlyCaptions = 1;
            }
            if (obscureMissingCategoryCounts)
            {
                missingCategoryCounts = 1;
            }
            if (isOnlineReport)
            {
                onlineReport = 1;
            }

            int totalRecordCount = 0;

            var returnObject = new List<MembershipReportDto>();

            try
            {
                //int? oldTimeout = _rdsDbContext.Database.GetCommandTimeout();
                //_rdsDbContext.Database.SetCommandTimeout(11000);
                //returnObject = _rdsDbContext.Set<ReportEDFactsK12StudentCount>().FromSqlRaw("rds.Get_MembershipReportData @reportCode = {0}, @reportLevel = {1}, @reportYear = {2}, @categorySetCode = {3}, @includeZeroCounts = {4}, @includeFriendlyCaptions = {5}, @obscureMissingCategoryCounts = {6}, @isOnlineReport={7}, @startRecord={8}, @numberOfRecords={9}", reportCode, reportLevel, reportYear, categorySetCode, zeroCounts, friendlyCaptions, missingCategoryCounts, onlineReport, startRecord, numberOfRecords).ToList();
                //_rdsDbContext.Database.SetCommandTimeout(oldTimeout);

                string connectionString = _rdsDbContext.Database.GetDbConnection().ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    // Open the connection
                    connection.Open();

                    // Create a SqlCommand object for the stored procedure
                    using (SqlCommand command = new SqlCommand("rds.Get_MembershipReportData", connection))
                    {
                        // Specify that it's a stored procedure
                        command.CommandType = CommandType.StoredProcedure;
                        command.CommandTimeout = 11000;

                        command.Parameters.AddWithValue("@reportCode", reportCode);
                        command.Parameters.AddWithValue("@reportLevel", reportLevel);
                        command.Parameters.AddWithValue("@reportYear", reportYear);
                        command.Parameters.AddWithValue("@categorySetCode", categorySetCode != null ? categorySetCode : DBNull.Value);
                        command.Parameters.AddWithValue("@includeZeroCounts", zeroCounts);
                        command.Parameters.AddWithValue("@includeFriendlyCaptions", friendlyCaptions);
                        command.Parameters.AddWithValue("@obscureMissingCategoryCounts", missingCategoryCounts);
                        command.Parameters.AddWithValue("@isOnlineReport", onlineReport);
                        command.Parameters.AddWithValue("@startRecord", startRecord);
                        command.Parameters.AddWithValue("@numberOfRecords", numberOfRecords);

                        // Execute the stored procedure and obtain a data reader
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            // Check if the reader has rows
                            if (reader.HasRows)
                            {
                                int fileRecordNumber = 0;
                                // Read the data
                                while (reader.Read())
                                {
                                    ++fileRecordNumber;

                                    MembershipReportDto membershipReport = new MembershipReportDto();

                                    membershipReport.StateANSICode = reader.GetString(reader.GetOrdinal("StateANSICode"));
                                    membershipReport.StateAbbreviationCode = reader.GetString(reader.GetOrdinal("StateAbbreviationCode"));
                                    membershipReport.OrganizationIdentifierSea = reader.IsDBNull(reader.GetOrdinal("OrganizationIdentifierSea")) ? "" : reader.GetString(reader.GetOrdinal("OrganizationIdentifierSea"));
                                    membershipReport.ParentOrganizationIdentifierSea = reader.IsDBNull(reader.GetOrdinal("ParentOrganizationIdentifierSea")) ? "" : reader.GetString(reader.GetOrdinal("ParentOrganizationIdentifierSea"));
                                    membershipReport.OrganizationName = reader.GetString(reader.GetOrdinal("OrganizationName"));
                                    membershipReport.GRADELEVEL = reader.IsDBNull(reader.GetOrdinal("GRADELEVEL")) ? "" : reader.GetString(reader.GetOrdinal("GRADELEVEL"));
                                    membershipReport.RACE = reader.IsDBNull(reader.GetOrdinal("RACE")) ? "" : reader.GetString(reader.GetOrdinal("RACE"));
                                    membershipReport.SEX = reader.IsDBNull(reader.GetOrdinal("SEX")) ? "" : reader.GetString(reader.GetOrdinal("SEX"));
                                    membershipReport.TotalIndicator = reader.GetString(reader.GetOrdinal("TotalIndicator"));
                                    membershipReport.StudentCount = reader.GetInt32(reader.GetOrdinal("StudentCount"));

                                    returnObject.Add(membershipReport);
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
            return (returnObject, totalRecordCount);

        }

        public void Migrate_FactStudentCounts(string reportYear, string factTypeCode)
        {
            int take = 10;
            int skip = 0;

            // Remove existing data

            IQueryable<FactK12StudentCount> existingData = _rdsDbContext.FactStudentCounts
                .Where(
                    x => x.DimFactType.FactTypeCode == factTypeCode &&
                    x.DimCountDate.SubmissionYear == reportYear
                )
                .OrderBy(x => x.K12StudentId)
                .Take(take)
                .Skip(skip);

            _rdsDbContext.RemoveRange(existingData);
            _rdsDbContext.SaveChanges();

            // TODO - get from DimensionRepository
            var childCountDate = new DateTime(2018, 11, 1);

            var results =
                from dimStudent in _rdsDbContext.DimStudents.OrderBy(x => x.DimK12StudentId).Take(take).Skip(skip)
               

                join dimDate in _rdsDbContext.DimDates on reportYear equals dimDate.SubmissionYear
                //join dimAge in _rdsDbContext.DimAges on this.GetDifferenceInYears((DateTime)dimStudent.BirthDate, childCountDate) equals dimAge.AgeValue

                //join personDetail in _odsDbContext.PersonDetail on dimStudent.StudentPersonId equals personDetail.PersonId
                //join refSex in _odsDbContext.RefSex on personDetail.RefSex.RefSexId equals refSex.RefSexId into refSexJoin from refSexResult in refSexJoin.DefaultIfEmpty()

                select new FactK12StudentCount()
                {
                    FactK12StudentCountId = 0,

                    AgeId = -1,  
                    AttendanceId = -1,
                    CohortStatusId = -1,
                    CountDateId = dimDate.DimDateId,
                    K12DemographicId = -1,
                    FactTypeId = -1,
                    GradeLevelId = -1,
                    IdeaStatusId = -1,
                    LeaId = -1,
                    LanguageId = -1,
                    MigrantId = -1,
                    NorDProgramStatusId = -1,
                    ProgramStatusId = -1,
                    K12SchoolId = -1,
                    K12StudentId = dimStudent.DimK12StudentId,
                    StudentStatusId = -1,
                    TitleIStatusId = -1,
                    TitleIIIStatusId = -1,

                    StudentCount = 1
                };

            // Save data

            if (results.Any())
            {
                _rdsDbContext.AddRange(results);
                _rdsDbContext.SaveChanges();
            }

        }

       

    }
}
