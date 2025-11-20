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
using generate.core.Models.RDS;
using System.Dynamic;
using System.Data.SqlClient;
using System.Data;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Dtos.ODS;
using System.Text.RegularExpressions;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Repositories.IDS;

namespace generate.infrastructure.Services
{
    public class StateDefinedReportService : IStateDefinedReportService
    {

        private IIDSRepository _idsRepository;
        private IAppRepository _appRepository;

        private IFactStudentCountRepository _factStudentCountRepository;
        private IFactStudentDisciplineRepository _factStudentDisciplineRepository;
        private IFactStudentAssessmentRepository _factStudentAssessmentRepository;
        private IFactCustomCountRepository _customReportRepository;
        private string reportType = "statereport";

        public StateDefinedReportService(
            IIDSRepository idsRepository,
            IAppRepository appRepository,
            IFactStudentCountRepository factStudentCountRepository,
            IFactStudentDisciplineRepository factStudentDisciplineRepository,
            IFactStudentAssessmentRepository factStudentAssessmentRepository,
            IFactCustomCountRepository customReportRepository
            )
        {
            _factStudentCountRepository = factStudentCountRepository;
            _factStudentDisciplineRepository = factStudentDisciplineRepository;
            _factStudentAssessmentRepository = factStudentAssessmentRepository;
            _customReportRepository = customReportRepository;
            _idsRepository = idsRepository;
            _appRepository = appRepository;
        }

        public GenerateReportDataDto GetReportDto(string reportCode, string reportLevel, string reportYear, string categorySetCode, string reportLea = null, string reportSchool = null, string reportFilter = null, string reportSubFilter = null, string reportGrade = null, string organizationalIdList = null, int reportSort = 1, int skip = 0, int take = 50)
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
                reportDto.ReportTitle = report.ReportName;
            }

            // Data

            dynamic dataRows = new List<ExpandoObject>();


            if (report.ReportCode == "studentfederalprogramsparticipation" || report.ReportCode == "studentmultifedprogsparticipation")
            {
                var query = _customReportRepository.Get_FederalProgramReportData(reportCode, reportLevel, reportYear, categorySetCode, reportFilter);
                var (rows, dataCount) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                dataRows = rows;
                reportDto.dataCount = dataCount;
            }
            else if (report.ReportCode == "disciplinaryremovals")
            {
                var query = _customReportRepository.Get_DisciplinaryRemovalsReportData(reportCode, reportLevel, reportYear, categorySetCode);
                var (rows, dataCount) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                dataRows = rows;
                reportDto.dataCount = dataCount;
            }
            else if (report.ReportCode == "stateassessmentsperformance")
            {
                var query = _customReportRepository.Get_AssessmentPerformanceReportData(reportCode, reportLevel, reportYear, categorySetCode, reportFilter, reportSubFilter, reportGrade);
                var (rows, dataCount) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                dataRows = rows;
                reportDto.dataCount = dataCount;

            }
            else if (report.ReportCode == "edenvironmentdisabilitiesage3-5" || report.ReportCode == "edenvironmentdisabilitiesage6-21")
            {
                var query = _customReportRepository.Get_EducationEnvironmentDisabilitiesReportData(reportCode, reportLevel, reportYear, categorySetCode);
                var (rows, dataCount) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                dataRows = rows;
                reportDto.dataCount = dataCount;
            }
            else if (report.ReportCode == "yeartoyearchildcount")
            {
                var query = _customReportRepository.Get_YearToYearChildCountReportData(reportCode, reportLevel, reportYear, categorySetCode);
                var (rows, dataCount) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                dataRows = rows;
                reportDto.dataCount = dataCount;
            }
            else if (report.ReportCode == "yeartoyearexitcount")
            {
                if (reportLevel.ToLower() == "sch" && reportFilter.ToLower() != "select")
                {
                    var query = _customReportRepository.Get_YearToYearExitCountReportDataSCH(reportCode, reportLevel, reportYear, categorySetCode, reportFilter);
                    var (rows, dataCount) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                    dataRows = rows;
                    reportDto.dataCount = dataCount;
                }
                else
                {
                    var query = _customReportRepository.Get_YearToYearExitCountReportData(reportCode, reportLevel, reportYear, categorySetCode, reportFilter);
                    var (rows, dataCount) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                    dataRows = rows;
                    reportDto.dataCount = dataCount;
                }
            }
            else if (report.ReportCode == "yeartoyearremovalcount")
            {
                var query = _customReportRepository.Get_YearToYearRemovalCountReportData(reportCode, reportLevel, reportYear, categorySetCode, reportFilter);
                var (rows, dataCount) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                dataRows = rows;
                reportDto.dataCount = dataCount;

            }
            else if (report.ReportCode == "studentssummary")
            {
                var query = _customReportRepository.Get_LEAStudentsSummary(reportCode, reportLevel, reportYear, categorySetCode, reportFilter, reportLea);
                var (rows, dataCount) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                dataRows = rows;
                reportDto.dataCount = dataCount;
            }
            else if (report.ReportCode == "yeartoyearprogress")
            {
                var query = _customReportRepository.Get_YearToYearProgressReportData(reportCode, reportLevel, reportYear, categorySetCode, reportFilter, reportSubFilter, reportGrade, reportLea, reportSchool);

                string subject = (reportFilter == "MATH") ? "Mathematics" : "Reading/Language Arts";
                if (categorySetCode == "All")
                {
                    reportDto.ReportTitle = "Year to Year Progress for All Students in " + subject;
                }
                else
                {
                    reportDto.ReportTitle = "Year to Year Progress in " + subject;
                }

                dataRows = query.ToList();
                reportDto.dataCount = query.Select(q => q.OrganizationStateId).Distinct().Count();
            }
            else if (report.ReportCode == "yeartoyearattendance")
            {
                var query = _customReportRepository.Get_YearToYearAttendanceReportData(reportCode, reportLevel, reportYear, categorySetCode, reportGrade, reportLea, reportSchool);

                dataRows = query.ToList();
                reportDto.dataCount = query.Select(q => q.OrganizationStateId).Distinct().Count();
            }
            else if (report.ReportCode == "yeartoyearenvironmentcount")
            {
                var query = _customReportRepository.Get_YearToYearEnvironmentCountReportData(reportCode, reportLevel, reportYear, categorySetCode);
                
                if (categorySetCode != "all")
                {
                    if (categorySetCode == "schoolage")
                    {
                        query = query.Where(t => t.CategorySetCode == "School Age (6-21)").ToList();
                    }
                    else if (categorySetCode == "earlychildhood")
                    {
                        query = query.Where(t => t.CategorySetCode == "Early Childhood (3-5)").ToList();
                    }

                }
                var (rows, dataCount) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                dataRows = rows;
                reportDto.dataCount = dataCount;
            }

            else if (report.FactTable.FactTableName == "FactK12StudentCounts")
            {
                var query = _factStudentCountRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode);
                if (reportLevel == "lea" && reportLea != null && reportLea != "all")
                {
                    query = query.Where(t => t.OrganizationIdentifierSea == reportLea).ToList();
                }
                if (reportLevel == "sch")
                {
                    if (reportLea != null && reportLea != "all")
                    {
                        query = query.Where(t => t.ParentOrganizationIdentifierSea == reportLea).ToList();
                    }
                    if (reportSchool != null && reportSchool != "all")
                    {
                        query = query.Where(t => t.OrganizationIdentifierSea == reportSchool).ToList();
                    }
                }

                if (reportFilter != null && reportFilter != "AllStudents")
                {
                    if (reportFilter == "WDIS")
                    {
                        query = query.Where(t => t.IDEADISABILITYTYPE != "MISSING").ToList();
                    }
                    else if (reportFilter == "WODIS")
                    {
                        query = query.Where(t => t.IDEADISABILITYTYPE == "MISSING").ToList();
                    }

                }
                dataRows = query.ToList();
                reportDto.dataCount = query.Select(q => q.OrganizationIdentifierSea).Distinct().Count();
            }
            else if (report.FactTable.FactTableName == "FactK12StudentAssessments")
            {
                var query = _factStudentAssessmentRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode);
                if (reportLevel == "lea" && reportLea != null && reportLea != "all")
                {
                    query = query.Where(t => t.OrganizationIdentifierSea == reportLea).ToList();
                }
                if (reportLevel == "sch")
                {
                    if (reportLea != null && reportLea != "all")
                    {
                        query = query.Where(t => t.ParentOrganizationIdentifierSea == reportLea).ToList();
                    }
                    if (reportSchool != null && reportSchool != "all")
                    {
                        query = query.Where(t => t.OrganizationIdentifierSea == reportSchool).ToList();
                    }
                }
                dataRows = query.ToList();
                reportDto.dataCount = query.Select(q => q.OrganizationIdentifierSea).Distinct().Count();
            }
            else if (report.FactTable.FactTableName == "FactK12StudentDisciplines")
            {
                var query = _factStudentDisciplineRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode);

                if (reportLevel == "lea" && reportLea != null && reportLea != "all")
                {
                    query = query.Where(t => t.OrganizationName == reportLea).ToList();
                }
                if (reportLevel == "sch")
                {
                    if (reportLea != null && reportLea != "all")
                    {
                        query = query.Where(t => t.ParentOrganizationIdentifierSea == reportLea).ToList();
                    }
                    if (reportSchool != null && reportSchool != "all")
                    {
                        query = query.Where(t => t.OrganizationIdentifierSea == reportSchool).ToList();
                    }
                }

                dataRows = query.ToList();
                reportDto.dataCount = query.Select(q => q.OrganizationIdentifierSea).Distinct().Count();
            }
            else if (report.FactTable.FactTableName == "FactCustomCounts")
            {
                var query = _customReportRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode);
                var (rows, dataCount) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                dataRows = rows;
                reportDto.dataCount = dataCount;
            }

            reportDto.data = dataRows;

            return reportDto;
        }

        public (dynamic DataRows, int DistinctCount)
    FilterCustomReportData(
        IEnumerable<FactCustomCount> query,
        string reportLevel,
        string reportLea,
        string reportSchool,
        string organizationalIdList)
        {
            // Apply LEA-level filtering
            if (reportLevel == "lea" && !string.IsNullOrEmpty(reportLea) && reportLea != "all")
            {
                query = query.Where(t => t.OrganizationStateId == reportLea);
            }
            else if (reportLevel == "lea" && reportLea != null && reportLea == "all")
            {
                int[] organizationIds = organizationalIdList.Split(',').Select(h => Int32.Parse(h)).ToArray();
                List<string> od = new List<string>();
                foreach (var organizationId in organizationIds)
                {
                    if (organizationId != 0 && organizationId != -1)
                    {
                        OrganizationDetail OD = _idsRepository.Find<OrganizationDetail>(f => f.OrganizationDetailId == organizationId, 0, 1).FirstOrDefault();
                        if (OD != null)
                            od.Add(OD.Name);
                    }
                }
                query = query.Where(x => od.Contains(x.OrganizationName)).ToList();
            }

            // Apply School-level filtering
            if (reportLevel == "sch")
            {
                if (!string.IsNullOrEmpty(reportLea) && reportLea != "all")
                {
                    query = query.Where(t => t.ParentOrganizationStateId == reportLea);
                }

                if (!string.IsNullOrEmpty(reportSchool) && reportSchool != "all")
                {
                    query = query.Where(t => t.OrganizationStateId == reportSchool);
                }
            }

            var resultList = query.ToList();
            var distinctCount = resultList
                .Select(q => q.OrganizationStateId)
                .Distinct()
                .Count();

            return (resultList, distinctCount);
        }


        public string PadNumbers(string input)
        {
            return Regex.Replace(input, "[0-9]+", match => match.Value.PadLeft(10, '0'));
        }

    }
}
