using System;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using generate.infrastructure.Contexts;
using generate.core.Models.App;
using generate.core.Models.RDS;
using Microsoft.EntityFrameworkCore;
using generate.core.Interfaces.Repositories.RDS;

namespace generate.infrastructure.Repositories.RDS 
{
    public class FactCustomCountRepository : RDSRepository, IFactCustomCountRepository
    {
        private readonly ILogger _logger;

        public FactCustomCountRepository(
            ILogger<FactCustomCountRepository> logger,
            RDSDbContext context
            )
            : base(context)
        {
            _logger = logger;
        }

        public IEnumerable<FactCustomCount> Get_ReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, bool includeZeroCounts = false, bool includeFriendlyCaptions = false, bool obscureMissingCategoryCounts = false)
        {
            // Convert bool parameters to bit values

            int zeroCounts = 0;
            int friendlyCaptions = 0;
            int missingCategoryCounts = 0;

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

            var returnObject = new List<FactCustomCount>();
            int? oldTimeout = null;

            try
            {
                oldTimeout = _context.Database.GetCommandTimeout();
                _context.Database.SetCommandTimeout(11000);
                returnObject = _context.Set<FactCustomCount>().FromSqlRaw("rds.Get_ReportData @reportCode = {0}, @reportLevel = {1}, @reportYear = {2}, @categorySetCode = {3}, @includeZeroCounts = {4}, @includeFriendlyCaptions = {5}, @obscureMissingCategoryCounts = {6}", reportCode, reportLevel, reportYear, categorySetCode, zeroCounts, friendlyCaptions, missingCategoryCounts).ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;
            }
            finally
            {
                _context.Database.SetCommandTimeout(oldTimeout);
            }

            return returnObject;

        }



        public IEnumerable<FactCustomCount> Get_FederalProgramReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, string reportFilter)
        {
            var returnObject = new List<FactCustomCount>();

            try
            {
                int? oldTimeout = _context.Database.GetCommandTimeout();
                _context.Database.SetCommandTimeout(11000);
                returnObject = _context.Set<FactCustomCount>().FromSqlRaw("rds.Get_StudentFederalProgramsReportData @reportCode = {0}, @reportLevel = {1}, @reportYear = {2}, @categorySetCode = {3}, @reportFilter = {4}", reportCode, reportLevel, reportYear, categorySetCode, reportFilter).ToList();
                _context.Database.SetCommandTimeout(oldTimeout);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;
                //var emptyReport = new List<FactStudentCountReportDto>();
                //return emptyReport;
            }
            return returnObject;

        }

        public IEnumerable<FactCustomCount> Get_DisciplinaryRemovalsReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode)
        {
            var returnObject = new List<FactCustomCount>();

            try
            {
                int? oldTimeout = _context.Database.GetCommandTimeout();
                _context.Database.SetCommandTimeout(11000);
                returnObject = _context.Set<FactCustomCount>().FromSqlRaw("rds.Get_StudentDisciplinaryRemovalsReportData @reportCode = {0}, @reportLevel = {1}, @reportYear = {2}, @categorySetCode = {3}", reportCode, reportLevel, reportYear, categorySetCode).ToList();
                _context.Database.SetCommandTimeout(oldTimeout);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;
                //var emptyReport = new List<FactStudentCountReportDto>();
                //return emptyReport;
            }
            return returnObject;

        }

        public IEnumerable<FactCustomCount> Get_AssessmentPerformanceReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, string reportFilter, string reportSubFilter, string reportGrade)
        {
            var returnObject = new List<FactCustomCount>();

            try
            {
                int? oldTimeout = _context.Database.GetCommandTimeout();
                _context.Database.SetCommandTimeout(11000);
                returnObject = _context.Set<FactCustomCount>().FromSqlRaw("rds.Get_StateAssessmentProficiencyReportData @reportCode = {0}, @reportLevel = {1}, @reportYear = {2}, @categorySetCode = {3}, @reportFilter = {4}, @reportSubFilter = {5}, @reportGrade = {6}", reportCode, reportLevel, reportYear, categorySetCode, reportFilter, reportSubFilter, reportGrade).ToList();
                _context.Database.SetCommandTimeout(oldTimeout);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;
                //var emptyReport = new List<FactStudentCountReportDto>();
                //return emptyReport;
            }
            return returnObject;

        }

        public IEnumerable<FactCustomCount> Get_EducationEnvironmentDisabilitiesReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode)
        {
            var returnObject = new List<FactCustomCount>();

            try
            {
                int? oldTimeout = _context.Database.GetCommandTimeout();
                _context.Database.SetCommandTimeout(11000);
                returnObject = _context.Set<FactCustomCount>().FromSqlRaw("rds.Get_StudentEducationEnvironmentDisabilitiesReportData @reportCode = {0}, @reportLevel = {1}, @reportYear = {2}, @categorySetCode = {3}", reportCode, reportLevel, reportYear, categorySetCode).ToList();
                _context.Database.SetCommandTimeout(oldTimeout);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;
                //var emptyReport = new List<FactStudentCountReportDto>();
                //return emptyReport;
            }
            return returnObject;

        }

        public IEnumerable<FactCustomCount> Get_YearToYearChildCountReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode)
        {
            var returnObject = new List<FactCustomCount>();

            try
            {
                int? oldTimeout = _context.Database.GetCommandTimeout();
                _context.Database.SetCommandTimeout(11000);
                returnObject = _context.Set<FactCustomCount>().FromSqlRaw("rds.Get_YearToYearStudentCountReportData @reportCode = {0}, @reportLevel = {1}, @reportYear = {2}, @categorySetCode = {3}", reportCode, reportLevel, reportYear, categorySetCode).ToList();
                _context.Database.SetCommandTimeout(oldTimeout);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;
            }
            return returnObject;

        }
        public IEnumerable<FactCustomCount> Get_YearToYearExitCountReportDataSCH(string reportCode, string reportLevel, string reportYear, string categorySetCode, string filter)
        {
            var returnObject = new List<FactCustomCount>();
            try
            {
                int? oldTimeout = _context.Database.GetCommandTimeout();
                _context.Database.SetCommandTimeout(11000);
                returnObject = _context.Set<FactCustomCount>().FromSqlRaw("rds.Get_YearToYearExitCountReportData_SchoolLevel @reportCode = {0}, @reportLevel = {1}, @reportYear = {2}, @categorySetCode = {3}", reportCode, reportLevel, reportYear, filter).ToList();
                _context.Database.SetCommandTimeout(oldTimeout);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;
            }
            return returnObject;

        }

        public IEnumerable<FactCustomCount> Get_YearToYearExitCountReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, string filter)
        {
            var returnObject = new List<FactCustomCount>();
            string catset = String.Empty;
            if (categorySetCode.ToLower() == "exitonly" && filter.ToLower() != "select")
            {
                catset = filter;
            }
            else
            {
                catset = categorySetCode;
            }
            try
            {
                int? oldTimeout = _context.Database.GetCommandTimeout();
                _context.Database.SetCommandTimeout(11000);
                returnObject = _context.Set<FactCustomCount>().FromSqlRaw("rds.Get_YearToYearExitCountReportData @reportCode = {0}, @reportLevel = {1}, @reportYear = {2}, @categorySetCode = {3}", reportCode, reportLevel, reportYear, catset).ToList();
                _context.Database.SetCommandTimeout(oldTimeout);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;
            }
            return returnObject;

        }

        public IEnumerable<FactCustomCount> Get_YearToYearRemovalCountReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, string filter)
        {
            var returnObject = new List<FactCustomCount>();
            string catset = String.Empty;
            if (categorySetCode.ToLower() == "removaltype" && filter.ToLower() != "select")
            {
                catset = String.Concat(categorySetCode, filter);
            }
            else
            {
                catset = categorySetCode;
            }
            try
            {
                int? oldTimeout = _context.Database.GetCommandTimeout();
                _context.Database.SetCommandTimeout(11000);
                returnObject = _context.Set<FactCustomCount>().FromSqlRaw("rds.Get_YearToYearRemovalCountReportData @reportCode = {0}, @reportLevel = {1}, @reportYear = {2}, @categorySetCode = {3}", reportCode, reportLevel, reportYear, catset).ToList();
                _context.Database.SetCommandTimeout(oldTimeout);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;
            }
            return returnObject;

        }


        public IEnumerable<FactCustomCount> Get_LEAStudentsSummary(string reportCode, string reportLevel, string reportYear, string categorySetCode, string reportFilter, string reportLea)
        {
            var returnObject = new List<FactCustomCount>();
            string categorySet = String.Empty;
            if (reportFilter == "select")
            {
                categorySet = categorySetCode;
            }
            else
            {
                categorySet = String.Concat(categorySetCode, reportFilter);
            }
            try
            {
                int? oldTimeout = _context.Database.GetCommandTimeout();
                _context.Database.SetCommandTimeout(11000);
                returnObject = _context.Set<FactCustomCount>().FromSqlRaw("rds.Get_StudentsSummary @reportCode = {0}, @reportLevel = {1}, @reportYear = {2}, @categorySetCode = {3}, @reportLea = {4}", reportCode, reportLevel, reportYear, categorySet, reportLea).ToList();
                _context.Database.SetCommandTimeout(oldTimeout);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;
            }
            return returnObject;

        }

        public IEnumerable<FactCustomCount> Get_YearToYearEnvironmentCountReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode)
        {
            var returnObject = new List<FactCustomCount>();

            try
            {
                int? oldTimeout = _context.Database.GetCommandTimeout();
                _context.Database.SetCommandTimeout(11000);
                returnObject = _context.Set<FactCustomCount>().FromSqlRaw("rds.Get_YearToYearEnvironmentCountReportData @reportCode = {0}, @reportLevel = {1}, @reportYear = {2}, @categorySetCode = {3}", reportCode, reportLevel, reportYear, categorySetCode).ToList();
                _context.Database.SetCommandTimeout(oldTimeout);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;
            }
            return returnObject;

        }

        public IEnumerable<FactCustomCount> Get_YearToYearProgressReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, string reportFilter, string reportSubFilter, string reportGrade, string reportLea, string reportSchool)
        {
            var returnObject = new List<FactCustomCount>();

            try
            {
                int? oldTimeout = _context.Database.GetCommandTimeout();
                _context.Database.SetCommandTimeout(11000);
                returnObject = _context.Set<FactCustomCount>().FromSqlRaw("rds.Get_YeartoYearProgressReportData @reportCode = {0}, @reportLevel = {1}, @reportYear = {2}, @categorySetCode = {3}, @reportFilter = {4}, @reportSubFilter = {5}, @reportGrade = {6}, @reportLea = {7}, @reportSchool = {8}", reportCode, reportLevel, reportYear, categorySetCode, reportFilter, reportSubFilter, reportGrade, reportLea, reportSchool).ToList();
                _context.Database.SetCommandTimeout(oldTimeout);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;
                //var emptyReport = new List<FactStudentCountReportDto>();
                //return emptyReport;
            }
            return returnObject;

        }

        public IEnumerable<FactCustomCount> Get_YearToYearAttendanceReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, string reportGrade, string reportLea, string reportSchool)
        {
            var returnObject = new List<FactCustomCount>();

            try
            {
                int? oldTimeout = _context.Database.GetCommandTimeout();
                _context.Database.SetCommandTimeout(11000);
                returnObject = _context.Set<FactCustomCount>().FromSqlRaw("rds.Get_YeartoYearAttendanceReportData @reportCode = {0}, @reportLevel = {1}, @reportYear = {2}, @categorySetCode = {3}, @reportGrade = {4}, @reportLea = {5}, @reportSchool = {6}", reportCode, reportLevel, reportYear, categorySetCode, reportGrade, reportLea, reportSchool).ToList();
                _context.Database.SetCommandTimeout(oldTimeout);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;
                //var emptyReport = new List<FactStudentCountReportDto>();
                //return emptyReport;
            }
            return returnObject;

        }
    }
}
