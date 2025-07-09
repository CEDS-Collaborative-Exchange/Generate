using generate.infrastructure.Contexts;
using generate.core.Helpers;
using generate.core.Dtos.App;
using generate.core.Models;
using generate.core.Models.App;
using generate.core.Models.IDS;
using generate.core.Models.RDS;
using generate.core.Interfaces.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Repositories.RDS;

namespace generate.web.Controllers.Api.App
{
    [Route("api/app/generatereports")]
    [ApiController]
    public class GenerateReportController : Controller
    {
        private readonly IGenerateReportService _generateReportService;
        private readonly IRDSRepository _rdsRepository;
        private readonly IAppRepository _appRepository;

        public GenerateReportController(
            IGenerateReportService generateReportService,
            IRDSRepository rdsRepository,
            IAppRepository appRepository
            )
        {
            _generateReportService = generateReportService;
            _rdsRepository = rdsRepository;
            _appRepository = appRepository;
        }

        [HttpGet("{reportTypeCode}")]
        public JsonResult Get(string reportTypeCode)
        {
            List<GenerateReport> reportList = _generateReportService.GetReports(reportTypeCode);
            var results = _generateReportService.GetReportDtos(reportList);
            return Json(results);
        }

        [HttpGet("reports/{reportTypeCode}")]
        public JsonResult GetReportList(string reportTypeCode)
        {

            List<GenerateReport> reportList = new List<GenerateReport>();
            reportList.Add(new GenerateReport { GenerateReportId = -1, ReportShortName = "Select Report" });

            if (reportTypeCode == "edfactsreport") { reportList.AddRange(_generateReportService.GetReportList(reportTypeCode)); }
            else
            {
                foreach(GenerateReport report in _generateReportService.GetReportList(reportTypeCode))
                {
                    if(report.ReportShortName is null) { report.ReportShortName = report.ReportName; }
                    reportList.Add(report);
                }
            }
           
            return Json(reportList);
        }

        [HttpGet("reports/{reportTypeCode}/{reportCode}")]
        public JsonResult GetSubmissionReport(string reportTypeCode, string reportCode)
        {

            GenerateReport report = _generateReportService.GetReportList(reportTypeCode).Find(t => t.ReportCode == reportCode);
            return Json(report);
        }

        [HttpGet("{reportTypeCode}/{reportCode}")]
        public JsonResult Get(string reportTypeCode, string reportCode)
        {

            if (reportTypeCode == null || reportCode == null)
            {
                return null;
            }

            List<GenerateReport> reportList = new List<GenerateReport>();
            GenerateReport report = _generateReportService.GetReport(reportTypeCode, reportCode);
            reportList.Add(report);
            var result = _generateReportService.GetReportDtos(reportList);
            if (result != null)
            {
                return Json(result.FirstOrDefault());
            }
            else
            {
                return null;
            }

        }
        [HttpGet("report/{reportTypeCode}/{reportCode}")]
        public JsonResult GetReps(string reportTypeCode, string reportCode)
        {

            if (reportTypeCode == null || reportCode == null)
            {
                return null;
            }

            List<GenerateReport> reportList = new List<GenerateReport>();
            GenerateReport report = _generateReportService.GetReports(reportTypeCode).FirstOrDefault(s => s.ReportCode == reportCode);
            reportList.Add(report);
            var result = _generateReportService.GetReportDtos(reportList);
            return Json(result[0]);

        }

        [HttpGet("{reportTypeCode}/{reportCode}/{reportLevel}/{reportYear}/{categorySetCode}")]
        public ContentResult Get(string reportTypeCode, string reportCode, string reportLevel, string reportYear, string categorySetCode, [FromQuery] int sort = 1, [FromQuery] int skip = 0, [FromQuery] int take = 50)
        {

            if (reportTypeCode == null || reportCode == null || reportLevel == null || reportYear == null || categorySetCode == null)
            {
                return null;
            }

            GenerateReportDataDto reportDto = _generateReportService.GetReportDataDto(reportTypeCode, reportCode, reportLevel, reportYear, categorySetCode, null, null, null, null, null, null, sort, skip, take);
            return this.JsonWithoutEmptyProperties(reportDto);
        }

        [HttpGet("pages/{reportTypeCode}/{reportCode}/{reportLevel}/{reportYear}/{categorySetCode}")]
        public ContentResult GetPagedReport(string reportTypeCode, string reportCode, string reportLevel, string reportYear, string categorySetCode, [FromQuery] int sort = 1, [FromQuery] int skip = 0, [FromQuery] int take = 50, [FromQuery] int pageSize = 10, [FromQuery] int page = 1)
        {

            if (reportTypeCode == null || reportCode == null || reportLevel == null || reportYear == null || categorySetCode == null)
            {
                return null;
            }

            GenerateReportDataDto reportDto = _generateReportService.GetReportDataDto(reportTypeCode, reportCode, reportLevel, reportYear, categorySetCode, null, null, null, null, null, null, sort, skip, take, pageSize, page);
            return this.JsonWithoutEmptyProperties(reportDto);
        }

        [HttpGet("{reportTypeCode}/{reportCode}/{reportLevel}/{reportYear}/{categorySetCode}/{reportLea}/{reportSchool}/{reportFilter}/{reportSubFilter}/{reportGrade}/{organizationalIdList}")]
        public ContentResult Get(string reportTypeCode, string reportCode, string reportLevel, string reportYear, string categorySetCode, string reportLea, string reportSchool, string reportFilter, string reportSubFilter, string reportGrade, string organizationalIdList, [FromQuery]int sort = 1, [FromQuery]int skip = 0, [FromQuery]int take = 50)
        {

            if (reportTypeCode == null || reportCode == null || reportLevel == null || reportYear == null || categorySetCode == null)
            {
                return null;
            }

            GenerateReportDataDto reportDto = _generateReportService.GetReportDataDto(reportTypeCode, reportCode, reportLevel, reportYear, categorySetCode, reportLea, reportSchool, reportFilter, reportSubFilter, reportGrade, organizationalIdList, sort, skip, take);

            return this.JsonWithoutEmptyProperties(reportDto);
        }

        [HttpGet("categorysets/{reportTypeCode}/{reportCode}/{reportLevel}/{reportYear}")]
        public ContentResult Get(string reportTypeCode, string reportCode, string reportLevel, string reportYear)
        {

            if (reportTypeCode != "edfactsreport" || reportTypeCode != "sppaprreport")
            {
                return null;
            }

            if (reportTypeCode == null || reportCode == null || reportLevel == null || reportYear == null)
            {
                return null;
            }
            else
            {
                var results = _appRepository.Find<CategorySet>(c => c.GenerateReport.ReportCode == reportCode && c.OrganizationLevel.LevelCode == reportLevel && c.SubmissionYear == reportYear).OrderBy(c => c.CategorySetName).GroupBy(x => x.CategorySetName).Select(y => y.First()).Distinct();

                return this.JsonWithoutEmptyProperties(results);
            }
        }

        [HttpGet("debuginfo/{reportCode}/{reportLevel}/{reportYear}/{categorySetCode}/{selectedList}")]
        //   public ContentResult Get(string reportTypeCode, string reportCode, string reportLevel, string reportYear, string categorySetCode, string selectedList, [FromQuery] int sort = 1, [FromQuery] int skip = 0, [FromQuery] int take = 50)
        public ContentResult Get(string reportCode, string reportLevel, string reportYear, string categorySetCode, string selectedList)
        {

            if (reportCode == null || reportLevel == null || reportYear == null || categorySetCode == null)
            {
                return null;
            }

            List<ReportDebug> reportDebugs = _generateReportService.GetReportDebugData(reportCode, reportLevel, reportYear, categorySetCode, selectedList);

            return this.JsonWithoutEmptyProperties(reportDebugs);
        }

        [HttpGet("submissionyears/{reportCode}")]
        public JsonResult GetSubmissionYears(string reportCode)
        {
            List<int> returnResults = new List<int>();
            IEnumerable<DimSchoolYear> dimYears = _rdsRepository.GetAll<DimSchoolYear>();

            if (reportCode == "cohortgraduationrate")
            {
                var currentYear = dimYears.Select(d => d.SchoolYear).Max();

                for (int i = 1; i <= 6; i++)
                {
                    int submissionYear = Convert.ToInt32(currentYear) + 1 + i;
                    returnResults.Add(submissionYear);
                }

            }
            else
            {
                var years = dimYears.Select(d => d.SchoolYear).Distinct().OrderByDescending(d => d).ToList();

                for (int i = 0; i < years.Count; i++)
                {
                    int submissionYear = years[i];
                    returnResults.Add(submissionYear);
                }
            }

            return Json(returnResults);

        }

        [HttpGet("option/{reportYear}/{reportLevel}/{reportCode}/{reportCategorySetCode}")]
        public JsonResult GetOptions(string reportYear, string reportLevel, string reportCode, string reportCategorySetCode)
        {
            var a = _appRepository.GetAll<CategoryOption>(0, 0, x => x.Category, y => y.CategorySet, f => f.CategorySet.OrganizationLevel).Where(x => x.Category.CategoryCode == "YEAR"
               && x.CategorySet.SubmissionYear == reportYear && x.CategorySet.OrganizationLevel.LevelCode == reportLevel).OrderBy(x => x.CategorySet.SubmissionYear).Select(x => x.CategoryOptionName).Distinct().ToList();

            return Json(a);
        }

        [HttpGet("submissionyears/{reportCode}/{reportType}")]
        public JsonResult GetSubmissionYearss(string reportCode, string reportType)
        {
            List<string> returnResults = new List<string>();
            returnResults.Add("Select School Year");
            IEnumerable<DimSchoolYear> dimYears = _rdsRepository.GetAll<DimSchoolYear>();

            if (reportCode == "cohortgraduationrate")
            {
                var currentYear = dimYears.Select(d => d.SchoolYear).Max();

                for (int i = 1; i <= 6; i++)
                {
                    int submissionYear = Convert.ToInt32(currentYear) + 1 + i;
                    if (_appRepository.Count<CategorySet>(c => c.GenerateReport.ReportCode == reportCode && c.SubmissionYear == submissionYear.ToString()) > 0)
                    {
                        returnResults.Add(submissionYear.ToString());
                    }
                }

            }
            else
            {
                List<string> years = dimYears.Select(d => d.SchoolYear.ToString()).Distinct().OrderByDescending(d => d).ToList();
                for (int i = 0; i < years.Count; i++)
                {
                    string submissionYear = years[i];
                    if (_appRepository.Count<CategorySet>(c => c.GenerateReport.ReportCode == reportCode && c.SubmissionYear == submissionYear) > 0)
                    {
                        returnResults.Add(submissionYear);
                    }
                }
            }

            return Json(returnResults);

        }

        [HttpGet("organizationlevels")]
        public JsonResult GetOrganizationLevels()
        {
            List<OrganizationLevelDto> levels = new List<OrganizationLevelDto>();
            foreach (OrganizationLevel t in _appRepository.GetAll<OrganizationLevel>(0, 0).ToList())
            {
                levels.Add(new OrganizationLevelDto { OrganizationLevelId = t.OrganizationLevelId, LevelCode = t.LevelCode, LevelName = t.LevelName });
            }
            return Json(levels);

        }

        [HttpGet("organizationLevelsByReportCodeYear/{reportTypeCode}/{reportCode}/{reportYear}/{categorySetCode}")]
        public JsonResult GetOrganizationLevelsByReportCodeYear(string reportTypeCode, string reportCode, string reportYear, string categorySetCode)
        {
            List<OrganizationLevelDto> levels = new List<OrganizationLevelDto>();

            if (reportTypeCode == null || reportCode == null || reportYear == null)
            {
                return null;
            }
            else
            {
                var results = _appRepository.Find<CategorySet>(c => c.GenerateReport.ReportCode == reportCode && c.SubmissionYear == reportYear && c.CategorySetCode == categorySetCode).Select(c => c.OrganizationLevelId).Distinct().ToList();

                foreach (int id in results)
                {
                    OrganizationLevel orgLevel = _appRepository.GetById<OrganizationLevel>(id);
                    levels.Add(new OrganizationLevelDto { OrganizationLevelId = orgLevel.OrganizationLevelId, LevelCode = orgLevel.LevelCode, LevelName = orgLevel.LevelName });
                }

                return Json(levels);
            }
        }
        [HttpGet("getCatSet/{filterCode}")]
        public JsonResult GetCatSetNameByCode(string filterCode)
        {
            var i = _appRepository.Find<GenerateReportFilterOption>(s => s.FilterCode == filterCode).Select(s => new { s.FilterCode, s.FilterName }).FirstOrDefault();


            return Json(i);
        }

        [HttpGet("getcat/{filterCode}")]
        public JsonResult GetCats(string filterCode)
        {
            var i = _appRepository.Find<CategorySet>(s => s.CategorySetCode == filterCode).Select(s => new { s.CategorySetCode , s.CategorySetName }).FirstOrDefault();


            return Json(i);
        }
    }

}
