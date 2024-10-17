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

        private int childCountDateMonth = 10;
        private int childCountDateDay = 1;

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

			ToggleResponse childCountDate = _appRepository.Find<ToggleResponse>(r => r.ToggleQuestion.EmapsQuestionAbbrv == "CHDCTDTE").FirstOrDefault();
            if (childCountDate != null)
            {
                if (childCountDate.ResponseValue.Contains("/"))
                {
                    string[] childCountDateArray = childCountDate.ResponseValue.Split('/');
                    if (childCountDateArray.Length == 2)
                    {
                        int.TryParse(childCountDateArray[0], out childCountDateMonth);
                        int.TryParse(childCountDateArray[1], out childCountDateDay);
                    }
                }

            }

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


            if (report == null)
            {
                reportDto.dataCount = -1;
                return reportDto;
            }
            else
            {
                if (report.ReportCode.ToLower() == "c059" && reportLevel == "sch")
                {                    
                    report.ReportName = "C059: Classroom Teacher FTE";
                }
                if (report.ReportCode.ToLower() == "c050" && reportYear == "2017-18")
                {
                    report.ReportName = "C050: Title III English Language Proficiency Results";
                }


                reportDto.ReportTitle = report.ReportName;                
            }

            bool includeZeroCounts = false;
            if (reportLevel == "sea")
            {
                includeZeroCounts = true;
            }

            // Data

            //List<String> organizations = null;
            dynamic dataRows = new List<ExpandoObject>();

            int skip = 0;

            if(page > 1) { skip = (page - 1) * pageSize;  }

            if (report.ReportCode == "c052")
            {
                bool isOnlineReport = false;

                var query = _factStudentCountRepository.Get_MembershipReportData(reportCode, reportLevel, reportYear, categorySetCode, includeZeroCounts, false, isOnlineReport);
                dataRows = query.Item1.ToList();
                reportDto.dataCount = query.Item1.Select(q => q.OrganizationIdentifierSea).Distinct().Count();
            }
            else if (report.FactTable.FactTableName == "FactK12StudentCounts")
            {
                bool isOnlineReport = false;
                if (reportCode == "c204" || reportCode == "c151" || reportCode == "c150")
                {
                    isOnlineReport = true;
                }
                var query = _factStudentCountRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode, includeZeroCounts, false, false, isOnlineReport);
                dataRows = query.ToList();
                reportDto.dataCount = query.Select(q => q.OrganizationIdentifierSea).Distinct().Count();
             }
            else if (report.FactTable.FactTableName == "FactK12StudentDisciplines")
            {
                var query = _factStudentDisciplineRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode, includeZeroCounts);
                dataRows = query.ToList();
                reportDto.dataCount = query.Select(q => q.OrganizationIdentifierSea).Distinct().Count();
            }
            else if (report.FactTable.FactTableName == "FactK12StudentAssessments")
            {
                var query = _factStudentAssessmentRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode, includeZeroCounts);
                dataRows = query.ToList();
                reportDto.dataCount = query.Select(q => q.OrganizationIdentifierSea).Distinct().Count();
            }
            else if (report.FactTable.FactTableName == "FactK12StaffCounts")
            {
                var query = _factStaffCountRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode, includeZeroCounts);
                dataRows = query.ToList();
                reportDto.dataCount = query.Select(q => q.OrganizationIdentifierSea).Distinct().Count();
            }
            else if (report.FactTable.FactTableName == "FactOrganizationCounts")
            {
                if(reportCode == "c039")
                {
                    var query = _factOrganizationCountRepository.Get_GradesOfferedReportData(reportCode, reportLevel, reportYear, categorySetCode, includeZeroCounts);
                    dataRows = query.ToList();
                    reportDto.dataCount = query.Select(q => q.OrganizationStateId).Distinct().Count();

                }
                else {
                    var query = _factOrganizationCountRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode, includeZeroCounts);
                    dataRows = query.ToList();
                    reportDto.dataCount = query.Select(q => q.OrganizationStateId).Distinct().Count();
                }
                
                
            }
			else if (report.FactTable.FactTableName == "FactOrganizationStatusCounts")
			{
                IEnumerable<ReportEDFactsOrganizationStatusCount> queryOrganizationStatusdto = _factOrganizationStatusCountRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode);
				reportDto.dataCount = queryOrganizationStatusdto.Select(q => q.OrganizationStateId).Distinct().Count();

                if (reportCode == "c199" || reportCode == "c201" || reportCode == "c200" || reportCode == "c202")
                {
                    Dictionary<string, string> columns = new Dictionary<string, string>();

                    if (reportCode == "c202")
                    {
                        if (categorySetCode == "CSA" || categorySetCode == "CSA1") { columns.Add("Race", "Race"); }
                        if (categorySetCode == "CSB" || categorySetCode == "CSB1") { columns.Add("Disability", "Disability"); }
                        if (categorySetCode == "CSC" || categorySetCode == "CSC1") { columns.Add("LepStatus", "English Learner Status"); }
                        if (categorySetCode == "CSD" || categorySetCode == "CSD1") { columns.Add("EcoDisStatus", "Economic Disadvantage Status"); }

                        columns.Add("STATEDEFINEDCUSTOMINDICATORCODE", "Indicator Type");
                    }
                    else
                    {
                        if (categorySetCode == "CSA") { columns.Add("Race", "Race"); }
                        if (categorySetCode == "CSB") { columns.Add("Disability", "Disability"); }
                        if (categorySetCode == "CSC") { columns.Add("LepStatus", "English Learner Status"); }
                        if (categorySetCode == "CSD") { columns.Add("EcoDisStatus", "Economic Disadvantage Status"); }
                    }

                    columns.Add("IndicatorStatus", "Indicator Status");
                    columns.Add("StatedefinedStatusCode", "State Defined Status");


                    reportDto.structure.rowHeader = "School Name";
                    reportDto.structure.columnHeaders = new List<string>();
                    foreach (var item in columns)
                    {
                        reportDto.structure.columnHeaders.Add(item.Value);
                    }


                    foreach (var queryItem in queryOrganizationStatusdto)
                    {
                        dynamic dataRow = new ExpandoObject();

                        dataRow.stateCode = queryItem.StateCode;
                        dataRow.stateName = queryItem.StateName;
                        dataRow.organizationStateId = queryItem.OrganizationNcesId;

                        //dataRow.rowId = queryItem.OrganizationId;
                        dataRow.rowKey = queryItem.OrganizationName;

                        if (reportCode == "c202")
                        {
                            dataRow.parentOrganizationStateId = queryItem.ParentOrganizationStateId;
                            //dataRow.parentOrganizationName = queryItem.ParentOrganizationName;

                            if (categorySetCode == "CSA" || categorySetCode == "CSA1") { dataRow.col_1 = queryItem.RACE; }
                            if (categorySetCode == "CSB" || categorySetCode == "CSB1") { dataRow.col_1 = queryItem.DISABILITY; }
                            if (categorySetCode == "CSC" || categorySetCode == "CSC1") { dataRow.col_1 = queryItem.LEPSTATUS; }
                            if (categorySetCode == "CSD" || categorySetCode == "CSD1") { dataRow.col_1 = queryItem.ECODISSTATUS; }

                            if (categorySetCode == "TOT" || categorySetCode == "TOT1")
                            {
                                dataRow.col_1 = queryItem.STATEDEFINEDCUSTOMINDICATORCODE;
                                dataRow.col_2 = queryItem.INDICATORSTATUS;
                                dataRow.col_3 = queryItem.STATEDEFINEDSTATUSCODE;
                            }
                            else
                            {
                                dataRow.col_2 = queryItem.STATEDEFINEDCUSTOMINDICATORCODE;
                                dataRow.col_3 = queryItem.INDICATORSTATUS;
                                dataRow.col_4 = queryItem.STATEDEFINEDSTATUSCODE;
                            }
                        }
                        else
                        {
                            if (categorySetCode == "CSA") { dataRow.col_1 = queryItem.RACE; }
                            if (categorySetCode == "CSB") { dataRow.col_1 = queryItem.DISABILITY; }
                            if (categorySetCode == "CSC") { dataRow.col_1 = queryItem.LEPSTATUS; }
                            if (categorySetCode == "CSD") { dataRow.col_1 = queryItem.ECODISSTATUS; }

                            if (categorySetCode == "TOT")
                            {
                                dataRow.col_1 = queryItem.STATEDEFINEDCUSTOMINDICATORCODE;
                                dataRow.col_2 = queryItem.INDICATORSTATUS;
                                dataRow.col_3 = queryItem.STATEDEFINEDSTATUSCODE;
                            }
                            else
                            {
                                dataRow.col_2 = queryItem.STATEDEFINEDCUSTOMINDICATORCODE;
                                dataRow.col_3 = queryItem.INDICATORSTATUS;
                                dataRow.col_4 = queryItem.STATEDEFINEDSTATUSCODE;
                            }
                        }

                        dataRows.Add(dataRow);

                    }

                    reportDto.data.AddRange(dataRows);

                }


            }


            
            reportDto.data = dataRows;          

            return reportDto;
        }


    }
}
