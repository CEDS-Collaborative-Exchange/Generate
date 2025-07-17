using System;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using generate.core.Models.App;
using generate.core.Interfaces.Services;
using System.Linq.Expressions;
using generate.core.Models.IDS;
using System.Threading.Tasks;
using Microsoft.Extensions.PlatformAbstractions;
using generate.core.ViewModels.App;
using generate.core.Dtos.App;
using generate.infrastructure.Contexts;
using generate.core.Models.RDS;
using System.Dynamic;
using System.Data.SqlClient;
using System.Data;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Interfaces.Repositories.App;

namespace generate.infrastructure.Services
{
    public class EdFactsReportService : IEdFactsReportService
    {
        private readonly IAppRepository _appRepository;

        private IFactStudentCountRepository _factStudentCountRepository;
        private IFactStudentDisciplineRepository _factStudentDisciplineRepository;
        private IFactStudentAssessmentRepository _factStudentAssessmentRepository;
        private IFactStaffCountRepository _factStaffCountRepository;
        private IFactOrganizationCountRepository _factOrganizationCountRepository;
		private IFactOrganizationStatusCountRepository _factOrganizationStatusCountRepository;

		private string reportType = "edfactsreport";


        public EdFactsReportService(
            IAppRepository appRepository,
            IFactStudentCountRepository factStudentCountRepository,
            IFactStudentDisciplineRepository factStudentDisciplineRepository,
            IFactStudentAssessmentRepository factStudentAssessmentRepository,
            IFactStaffCountRepository factStaffCountRepository,
            IFactOrganizationCountRepository factOrganizationCountRepository,
			IFactOrganizationStatusCountRepository factOrganizationStatusCountRepository
			)
        {
            _appRepository = appRepository;
            _factStudentCountRepository = factStudentCountRepository;
            _factStudentDisciplineRepository = factStudentDisciplineRepository;
            _factStudentAssessmentRepository = factStudentAssessmentRepository;
            _factStaffCountRepository = factStaffCountRepository;
            _factOrganizationCountRepository = factOrganizationCountRepository;
			_factOrganizationStatusCountRepository = factOrganizationStatusCountRepository;

			
        }

        public GenerateReportDataDto GetReportDto(string reportCode, string reportLevel, string reportYear, string categorySetCode, int reportSort = 1, int pageSize = 10, int page = 1)
        {

            // Declare empty dto
            GenerateReportDataDto reportDto = new GenerateReportDataDto();
            reportDto.structure = new GenerateReportStructureDto();
            reportDto.data = new List<ExpandoObject>();

            GenerateReport report = _appRepository.Find<GenerateReport>(r => r.GenerateReportType.ReportTypeCode == reportType
                && r.ReportCode == reportCode
                && r.GenerateReport_OrganizationLevels.Count(l => l.OrganizationLevel.LevelCode == reportLevel) == 1, 0, 1, r => r.CategorySets, r => r.FactTable)
                .FirstOrDefault();



            if (report.ReportCode.ToLower() == "059" && reportLevel == "sch")
            {
                report.ReportName = "059: Classroom Teacher FTE";
            }
            if (report.ReportCode.ToLower() == "050" && reportYear == "2017-18")
            {
                report.ReportName = "050: Title III English Language Proficiency Results";
            }


            reportDto.ReportTitle = report.ReportName;                
            
            bool includeZeroCounts = false;
            //if (reportLevel == "sea")
            //{
            //    includeZeroCounts = true;
            //}

            // Data

            
            dynamic dataRows = new List<ExpandoObject>();

            int skip = 0;

            if(page > 1) { skip = (page - 1) * pageSize;  }

            if (report.ReportCode == "052")
            {
                bool isOnlineReport = false;

                var query = _factStudentCountRepository.Get_MembershipReportData(reportCode, reportLevel, reportYear, categorySetCode, false, isOnlineReport);
                dataRows = query.Item1.ToList();
                reportDto.dataCount = query.Item1.Select(q => q.OrganizationIdentifierSea).Distinct().Count();
            }
            else if (report.FactTable.FactTableName == "FactK12StudentCounts")
            {
                bool isOnlineReport = false;
                if (reportCode == "204" || reportCode == "151" || reportCode == "150")
                {
                    isOnlineReport = true;
                }
                var query = _factStudentCountRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode, false, false, isOnlineReport);
                dataRows = query.ToList();
                reportDto.dataCount = query.Select(q => q.OrganizationIdentifierSea).Distinct().Count();
             }
            else if (report.FactTable.FactTableName == "FactK12StudentDisciplines")
            {
                var query = _factStudentDisciplineRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode);
                dataRows = query.ToList();
                reportDto.dataCount = query.Select(q => q.OrganizationIdentifierSea).Distinct().Count();
            }
            else if (report.FactTable.FactTableName == "FactK12StudentAssessments")
            {
                var query = _factStudentAssessmentRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode);
                dataRows = query.ToList();
                reportDto.dataCount = query.Select(q => q.OrganizationIdentifierSea).Distinct().Count();
            }
            else if (report.FactTable.FactTableName == "FactK12StaffCounts")
            {
                var query = _factStaffCountRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode);
                dataRows = query.ToList();
                reportDto.dataCount = query.Select(q => q.OrganizationIdentifierSea).Distinct().Count();
            }
            else if (report.FactTable.FactTableName == "FactOrganizationCounts")
            {
                if(reportCode == "039")
                {
                    var query = _factOrganizationCountRepository.Get_GradesOfferedReportData(reportCode, reportLevel, reportYear, categorySetCode);
                    dataRows = query.ToList();
                    reportDto.dataCount = query.Select(q => q.OrganizationStateId).Distinct().Count();

                }
                else if (reportCode == "130")
                {
                    var query = _factOrganizationCountRepository.Get_PersistentlyDangerousReportData(reportCode, reportLevel, reportYear, categorySetCode);
                    dataRows = query.ToList();
                    reportDto.dataCount = query.Select(q => q.OrganizationStateId).Distinct().Count();
                }
                else {
                    var query = _factOrganizationCountRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode);
                    dataRows = query.ToList();
                    reportDto.dataCount = query.Select(q => q.OrganizationStateId).Distinct().Count();
                }
                
                
            }
            reportDto.data = dataRows;

            if (report.FactTable.FactTableName == "FactOrganizationStatusCounts")
			{
                reportDto = GetOrganizationStatusReportData(reportCode, reportLevel, reportYear, categorySetCode);
            }
                        
            return reportDto;
        }

        public GenerateReportDataDto GetOrganizationStatusReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode)
        {
            GenerateReportDataDto reportDto = new GenerateReportDataDto();
            reportDto.structure = new GenerateReportStructureDto();
            reportDto.data = new List<ExpandoObject>();

            dynamic dataRows = new List<ExpandoObject>();
            IEnumerable<ReportEDFactsOrganizationStatusCount> queryOrganizationStatusdto = null;

            queryOrganizationStatusdto = _factOrganizationStatusCountRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode);
            reportDto.dataCount = queryOrganizationStatusdto.Select(q => q.OrganizationStateId).Distinct().Count();

            if (reportCode == "199" || reportCode == "201" || reportCode == "200" || reportCode == "202")
            {
                reportDto = GetUpdatedOrganizationStatusReportData(reportCode, categorySetCode, reportDto, queryOrganizationStatusdto);
            }

            return reportDto;
        }

        public GenerateReportDataDto GetUpdatedOrganizationStatusReportData(
                                string reportCode,
                                string categorySetCode,
                                GenerateReportDataDto reportDto,
                                IEnumerable<ReportEDFactsOrganizationStatusCount> queryData)
        {
            var categoryColumnMap = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                { "CSA", "Race" }, { "CSA1", "Race" },
                { "CSB", "Disability" }, { "CSB1", "Disability" },
                { "CSC", "English Learner Status" }, { "CSC1", "English Learner Status" },
                { "CSD", "Economic Disadvantage Status" }, { "CSD1", "Economic Disadvantage Status" }
            };

            // Build column headers
            var columns = new Dictionary<string, string>
            {
                { "IndicatorStatus", "Indicator Status" },
                { "StatedefinedStatusCode", "State Defined Status" }
            };

            if (categoryColumnMap.TryGetValue(categorySetCode, out var categoryColumn))
                columns.Add("Category", categoryColumn);

            if (reportCode == "202")
                columns.Add("STATEDEFINEDCUSTOMINDICATORCODE", "Indicator Type");

            // Set report structure
            reportDto.structure.rowHeader = "School Name";
            reportDto.structure.columnHeaders = columns.Values.ToList();

            if (queryData != null)
            {
                foreach (var item in queryData)
                {
                    dynamic row = new ExpandoObject();
                    row.stateCode = item.StateCode;
                    row.stateName = item.StateName;
                    row.organizationStateId = item.OrganizationNcesId;
                    row.rowKey = item.OrganizationName;
                    row.parentOrganizationStateId = item.ParentOrganizationStateId;

                    // Category column
                    if (columns.ContainsKey("Category"))
                    {
                        row.col_1 = categorySetCode switch
                        {
                            "CSA" or "CSA1" => item.RACE,
                            "CSB" or "CSB1" => item.DISABILITY,
                            "CSC" or "CSC1" => item.LEPSTATUS,
                            "CSD" or "CSD1" => item.ECODISSTATUS,
                            _ => null
                        };
                    }

                    // Indicator columns (layout varies by categorySetCode)
                    if (categorySetCode is "TOT" or "TOT1")
                    {
                        row.col_1 = item.STATEDEFINEDCUSTOMINDICATORCODE;
                        row.col_2 = item.INDICATORSTATUS;
                        row.col_3 = item.STATEDEFINEDSTATUSCODE;
                    }
                    else
                    {
                        row.col_2 = item.STATEDEFINEDCUSTOMINDICATORCODE;
                        row.col_3 = item.INDICATORSTATUS;
                        row.col_4 = item.STATEDEFINEDSTATUSCODE;
                    }

                    reportDto.data.Add(row);
                }
            }

            return reportDto;

        }

    }
}
