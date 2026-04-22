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

            reportDto.ReportTitle = report.ReportName;

            if (report.ReportCode == "yeartoyearprogress")
            {
                string subject = reportFilter == "MATH" ? "Mathematics" : "Reading/Language Arts";
                reportDto.ReportTitle = categorySetCode == "All"
                    ? "Year to Year Progress for All Students in " + subject
                    : "Year to Year Progress in " + subject;
            }

            var (dataRows, dataCount) = FetchReportData(report, reportCode, reportLevel, reportYear, categorySetCode, reportFilter, reportSubFilter, reportGrade, reportLea, reportSchool, organizationalIdList);
            reportDto.data = dataRows;
            reportDto.dataCount = dataCount;

            return reportDto;
        }

        private (dynamic DataRows, int DataCount) FetchReportData(GenerateReport report, string reportCode, string reportLevel, string reportYear, string categorySetCode, string reportFilter, string reportSubFilter, string reportGrade, string reportLea, string reportSchool, string organizationalIdList)
        {
            switch (report.ReportCode)
            {
                case "studentfederalprogramsparticipation":
                case "studentmultifedprogsparticipation":
                {
                    var query = _customReportRepository.Get_FederalProgramReportData(reportCode, reportLevel, reportYear, categorySetCode, reportFilter);
                    var (rows, count) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                    return (rows, count);
                }
                case "disciplinaryremovals":
                {
                    var query = _customReportRepository.Get_DisciplinaryRemovalsReportData(reportCode, reportLevel, reportYear, categorySetCode);
                    var (rows, count) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                    return (rows, count);
                }
                case "stateassessmentsperformance":
                {
                    var query = _customReportRepository.Get_AssessmentPerformanceReportData(reportCode, reportLevel, reportYear, categorySetCode, reportFilter, reportSubFilter, reportGrade);
                    var (rows, count) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                    return (rows, count);
                }
                case "edenvironmentdisabilitiesage3-5":
                case "edenvironmentdisabilitiesage6-21":
                {
                    var query = _customReportRepository.Get_EducationEnvironmentDisabilitiesReportData(reportCode, reportLevel, reportYear, categorySetCode);
                    var (rows, count) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                    return (rows, count);
                }
                case "yeartoyearchildcount":
                {
                    var query = _customReportRepository.Get_YearToYearChildCountReportData(reportCode, reportLevel, reportYear, categorySetCode);
                    var (rows, count) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                    return (rows, count);
                }
                case "yeartoyearexitcount":
                    return FetchYearToYearExitCountData(reportCode, reportLevel, reportYear, categorySetCode, reportFilter, reportLea, reportSchool, organizationalIdList);
                case "yeartoyearremovalcount":
                {
                    var query = _customReportRepository.Get_YearToYearRemovalCountReportData(reportCode, reportLevel, reportYear, categorySetCode, reportFilter);
                    var (rows, count) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                    return (rows, count);
                }
                case "studentssummary":
                {
                    var query = _customReportRepository.Get_LEAStudentsSummary(reportCode, reportLevel, reportYear, categorySetCode, reportFilter, reportLea);
                    var (rows, count) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                    return (rows, count);
                }
                case "yeartoyearprogress":
                {
                    var query = _customReportRepository.Get_YearToYearProgressReportData(reportCode, reportLevel, reportYear, categorySetCode, reportFilter, reportSubFilter, reportGrade, reportLea, reportSchool);
                    return (query.ToList(), query.Select(q => q.OrganizationStateId).Distinct().Count());
                }
                case "yeartoyearattendance":
                {
                    var query = _customReportRepository.Get_YearToYearAttendanceReportData(reportCode, reportLevel, reportYear, categorySetCode, reportGrade, reportLea, reportSchool);
                    return (query.ToList(), query.Select(q => q.OrganizationStateId).Distinct().Count());
                }
                case "yeartoyearenvironmentcount":
                    return FetchYearToYearEnvironmentCountData(reportCode, reportLevel, reportYear, categorySetCode, reportLea, reportSchool, organizationalIdList);
                default:
                    return FetchFactTableReportData(report, reportCode, reportLevel, reportYear, categorySetCode, reportFilter, reportLea, reportSchool, organizationalIdList);
            }
        }

        private (dynamic DataRows, int DataCount) FetchYearToYearExitCountData(string reportCode, string reportLevel, string reportYear, string categorySetCode, string reportFilter, string reportLea, string reportSchool, string organizationalIdList)
        {
            if (reportLevel.ToLower() == "sch" && reportFilter.ToLower() != "select")
            {
                var query = _customReportRepository.Get_YearToYearExitCountReportDataSCH(reportCode, reportLevel, reportYear, categorySetCode, reportFilter);
                var (rows, count) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                return (rows, count);
            }
            else
            {
                var query = _customReportRepository.Get_YearToYearExitCountReportData(reportCode, reportLevel, reportYear, categorySetCode, reportFilter);
                var (rows, count) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                return (rows, count);
            }
        }

        private (dynamic DataRows, int DataCount) FetchYearToYearEnvironmentCountData(string reportCode, string reportLevel, string reportYear, string categorySetCode, string reportLea, string reportSchool, string organizationalIdList)
        {
            var query = _customReportRepository.Get_YearToYearEnvironmentCountReportData(reportCode, reportLevel, reportYear, categorySetCode);

            if (categorySetCode == "schoolage")
            {
                query = query.Where(t => t.CategorySetCode == "School Age (6-21)").ToList();
            }
            else if (categorySetCode == "earlychildhood")
            {
                query = query.Where(t => t.CategorySetCode == "Early Childhood (3-5)").ToList();
            }

            var (rows, count) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
            return (rows, count);
        }

        private (dynamic DataRows, int DataCount) FetchFactTableReportData(GenerateReport report, string reportCode, string reportLevel, string reportYear, string categorySetCode, string reportFilter, string reportLea, string reportSchool, string organizationalIdList)
        {
            switch (report.FactTable.FactTableName)
            {
                case "FactK12StudentCounts":
                {
                    var query = _factStudentCountRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode);
                    var (rows, count) = FilterStudentCountReportData(query, reportLevel, reportLea, reportSchool, reportFilter, organizationalIdList);
                    return (rows, count);
                }
                case "FactK12StudentAssessments":
                {
                    var query = _factStudentAssessmentRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode);
                    var (rows, count) = FilterStudentAssessmentReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                    return (rows, count);
                }
                case "FactK12StudentDisciplines":
                {
                    var query = _factStudentDisciplineRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode);
                    var (rows, count) = FilterStudentDisciplineReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                    return (rows, count);
                }
                case "FactCustomCounts":
                {
                    var query = _customReportRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode);
                    var (rows, count) = FilterCustomReportData(query, reportLevel, reportLea, reportSchool, organizationalIdList);
                    return (rows, count);
                }
                default:
                    return (new List<ExpandoObject>(), 0);
            }
        }

        private List<string> ResolveOrganizationNames(string organizationalIdList)
        {
            var organizationIds = organizationalIdList.Split(',').Select(h => int.Parse(h));
            var names = new List<string>();
            foreach (var organizationId in organizationIds)
            {
                if (organizationId == 0 || organizationId == -1) continue;
                var od = _idsRepository.Find<OrganizationDetail>(f => f.OrganizationDetailId == organizationId, 0, 1).FirstOrDefault();
                if (od != null)
                    names.Add(od.Name);
            }
            return names;
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
            else if (reportLevel == "lea" && reportLea == "all")
            {
                var names = ResolveOrganizationNames(organizationalIdList);
                query = query.Where(x => names.Contains(x.OrganizationName)).ToList();
            }

            // Apply School-level filtering
            if (reportLevel == "sch")
            {
                if (!string.IsNullOrEmpty(reportLea) && reportLea != "all")
                    query = query.Where(t => t.ParentOrganizationStateId == reportLea);

                if (!string.IsNullOrEmpty(reportSchool) && reportSchool != "all")
                    query = query.Where(t => t.OrganizationStateId == reportSchool);
            }

            var resultList = query.ToList();
            var distinctCount = resultList
                .Select(q => q.OrganizationStateId)
                .Distinct()
                .Count();

            return (resultList, distinctCount);
        }

        public (dynamic DataRows, int DistinctCount)
    FilterStudentCountReportData(
    IEnumerable<ReportEDFactsK12StudentCount> query,
    string reportLevel,
    string reportLea,
    string reportSchool,
    string reportFilter,
    string organizationalIdList)
        {
            // Apply LEA-level filtering
            if (reportLevel == "lea" && !string.IsNullOrEmpty(reportLea) && reportLea != "all")
            {
                query = query.Where(t => t.OrganizationIdentifierSea == reportLea);
            }
            else if (reportLevel == "lea" && reportLea == "all")
            {
                var names = ResolveOrganizationNames(organizationalIdList);
                query = query.Where(x => names.Contains(x.OrganizationName)).ToList();
            }

            // Apply School-level filtering
            if (reportLevel == "sch")
            {
                if (!string.IsNullOrEmpty(reportLea) && reportLea != "all")
                    query = query.Where(t => t.ParentOrganizationIdentifierSea == reportLea);

                if (!string.IsNullOrEmpty(reportSchool) && reportSchool != "all")
                    query = query.Where(t => t.OrganizationIdentifierSea == reportSchool);
            }

            query = ApplyDisabilityFilter(query, reportFilter);

            var resultList = query.ToList();
            var distinctCount = resultList
                .Select(q => q.OrganizationIdentifierSea)
                .Distinct()
                .Count();

            return (resultList, distinctCount);
        }

        private IEnumerable<ReportEDFactsK12StudentCount> ApplyDisabilityFilter(IEnumerable<ReportEDFactsK12StudentCount> query, string reportFilter)
        {
            if (reportFilter == "WDIS")
                return query.Where(t => t.IDEADISABILITYTYPE != "MISSING").ToList();
            if (reportFilter == "WODIS")
                return query.Where(t => t.IDEADISABILITYTYPE == "MISSING").ToList();
            return query;
        }

        public (dynamic DataRows, int DistinctCount)
    FilterStudentAssessmentReportData(
    IEnumerable<ReportEDFactsK12StudentAssessment> query,
    string reportLevel,
    string reportLea,
    string reportSchool,
    string organizationalIdList)
        {
            // Apply LEA-level filtering
            if (reportLevel == "lea" && !string.IsNullOrEmpty(reportLea) && reportLea != "all")
            {
                query = query.Where(t => t.OrganizationIdentifierSea == reportLea);
            }
            else if (reportLevel == "lea" && reportLea == "all")
            {
                var names = ResolveOrganizationNames(organizationalIdList);
                query = query.Where(x => names.Contains(x.OrganizationName)).ToList();
            }

            // Apply School-level filtering
            if (reportLevel == "sch")
            {
                if (!string.IsNullOrEmpty(reportLea) && reportLea != "all")
                    query = query.Where(t => t.ParentOrganizationIdentifierSea == reportLea);

                if (!string.IsNullOrEmpty(reportSchool) && reportSchool != "all")
                    query = query.Where(t => t.OrganizationIdentifierSea == reportSchool);
            }

            var resultList = query.ToList();
            var distinctCount = resultList
                .Select(q => q.OrganizationIdentifierSea)
                .Distinct()
                .Count();

            return (resultList, distinctCount);
        }

        public (dynamic DataRows, int DistinctCount)
    FilterStudentDisciplineReportData(
    IEnumerable<ReportEDFactsK12StudentDiscipline> query,
    string reportLevel,
    string reportLea,
    string reportSchool,
    string organizationalIdList)
        {
            // Apply LEA-level filtering
            if (reportLevel == "lea" && !string.IsNullOrEmpty(reportLea) && reportLea != "all")
            {
                query = query.Where(t => t.OrganizationIdentifierSea == reportLea);
            }
            else if (reportLevel == "lea" && reportLea == "all")
            {
                var names = ResolveOrganizationNames(organizationalIdList);
                query = query.Where(x => names.Contains(x.OrganizationName)).ToList();
            }

            // Apply School-level filtering
            if (reportLevel == "sch")
            {
                if (!string.IsNullOrEmpty(reportLea) && reportLea != "all")
                    query = query.Where(t => t.ParentOrganizationIdentifierSea == reportLea);

                if (!string.IsNullOrEmpty(reportSchool) && reportSchool != "all")
                    query = query.Where(t => t.OrganizationIdentifierSea == reportSchool);
            }

            var resultList = query.ToList();
            var distinctCount = resultList
                .Select(q => q.OrganizationIdentifierSea)
                .Distinct()
                .Count();

            return (resultList, distinctCount);
        }

        public string PadNumbers(string input)
        {
            return Regex.Replace(input, "[0-9]+", match => match.Value.PadLeft(10, '0'), RegexOptions.None, TimeSpan.FromSeconds(1));
        }

    }
}
