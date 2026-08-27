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

namespace generate.web.Controllers.Api.App
{
    [Route("api/app/generatereports")]
    [ApiController]
    public class GenerateReportController : Controller
    {
        private readonly IGenerateReportService _generateReportService;

        public GenerateReportController(
            IGenerateReportService generateReportService
            )
        {
            _generateReportService = generateReportService;
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

        [HttpGet("report/{reportTypeCode}/{reportCode}/{reportYear}")]
        public JsonResult GetReportByYear(string reportTypeCode, string reportCode, string reportYear)
        {

            if (reportTypeCode == null || reportCode == null || reportYear == null)
            {
                return null;
            }

            //List<GenerateReport> reportList = new List<GenerateReport>();
            GenerateReport report = _generateReportService.GetReports(reportTypeCode).FirstOrDefault(s => s.ReportCode == reportCode);
            //reportList.Add(report);
            var result = _generateReportService.GetReportDto(report, reportYear);
            return Json(result);

        }

        [HttpGet("{reportTypeCode}/{reportCode}/{reportLevel}/{reportYear}/{categorySetCode}")]
        public ContentResult Get(string reportTypeCode, string reportCode, string reportLevel, string reportYear, string categorySetCode, [FromQuery] int sort = 1, [FromQuery] int skip = 0, [FromQuery] int take = 50)
        {

            if (reportTypeCode == null || reportCode == null || reportLevel == null || reportYear == null || categorySetCode == null)
            {
                return null;
            }

            GenerateReportDataDto reportDto = _generateReportService.GetReportDataDto(reportTypeCode, reportCode, reportLevel, reportYear, categorySetCode,"", null, null, null, null, null, null, sort, skip, take);
            return this.JsonWithoutEmptyProperties(reportDto);
        }

        [HttpGet("pages/{reportTypeCode}/{reportCode}/{reportLevel}/{reportYear}/{categorySetCode}/{tableTypeAbbrv}")]
        public ContentResult GetPagedReport(string reportTypeCode, string reportCode, string reportLevel, string reportYear, string categorySetCode, string tableTypeAbbrv, [FromQuery] int sort = 1, [FromQuery] int skip = 0, [FromQuery] int take = 50, [FromQuery] int pageSize = 10, [FromQuery] int page = 1)
        {

            if (reportTypeCode == null || reportCode == null || reportLevel == null || reportYear == null || categorySetCode == null)
            {
                return null;
            }

            GenerateReportDataDto reportDto = _generateReportService.GetReportDataDto(reportTypeCode, reportCode, reportLevel, reportYear, categorySetCode, tableTypeAbbrv, null, null, null, null, null, null, sort, skip, take, pageSize, page);
            return this.JsonWithoutEmptyProperties(reportDto);
        }

        [HttpGet("{reportTypeCode}/{reportCode}/{reportLevel}/{reportYear}/{categorySetCode}/{reportLea}/{reportSchool}/{reportFilter}/{reportSubFilter}/{reportGrade}/{organizationalIdList}")]
        public ContentResult Get(string reportTypeCode, string reportCode, string reportLevel, string reportYear, string categorySetCode, string reportLea, string reportSchool, string reportFilter, string reportSubFilter, string reportGrade, string organizationalIdList, [FromQuery]int sort = 1, [FromQuery]int skip = 0, [FromQuery]int take = 50)
        {

            if (reportTypeCode == null || reportCode == null || reportLevel == null || reportYear == null || categorySetCode == null)
            {
                return null;
            }

            GenerateReportDataDto reportDto = _generateReportService.GetReportDataDto(reportTypeCode, reportCode, reportLevel, reportYear, categorySetCode, "", reportLea, reportSchool, reportFilter, reportSubFilter, reportGrade, organizationalIdList, sort, skip, take);

            return this.JsonWithoutEmptyProperties(reportDto);
        }

        [HttpGet("categorysets/{reportTypeCode}/{reportCode}/{reportLevel}/{reportYear}")]
        public ContentResult Get(string reportTypeCode, string reportCode, string reportLevel, string reportYear)
        {

            if (reportTypeCode != "edfactsreport" && reportTypeCode != "sppaprreport")
            {
                return null;
            }

            if (reportTypeCode == null || reportCode == null || reportLevel == null || reportYear == null)
            {
                return null;
            }
            else
            {
                var results = _generateReportService.GetDistinctCategorySets(reportCode, reportLevel, reportYear);

                return this.JsonWithoutEmptyProperties(results);
            }
        }

        [HttpGet("debuginfo/{reportCode}/{reportLevel}/{reportYear}/{categorySetCode}/{selectedList}")]
        //   public ContentResult Get(string reportTypeCode, string reportCode, string reportLevel, string reportYear, string categorySetCode, string selectedList, [FromQuery] int sort = 1, [FromQuery] int skip = 0, [FromQuery] int take = 50)
        public ContentResult GetDebugData(string reportCode, string reportLevel, string reportYear, string categorySetCode, string selectedList)
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
            return Json(_generateReportService.GetSubmissionYears(reportCode));
        }

        [HttpGet("option/{reportYear}/{reportLevel}/{reportCode}/{reportCategorySetCode}")]
        public JsonResult GetOptions(string reportYear, string reportLevel, string reportCode, string reportCategorySetCode)
        {
            return Json(_generateReportService.GetYearCategoryOptions(reportYear, reportLevel));
        }

        [HttpGet("submissionyears/{reportCode}/{reportType}")]
        public JsonResult GetSubmissionYearss(string reportCode, string reportType)
        {
            return Json(_generateReportService.GetSubmissionYearsWithSelectionPrompt(reportCode, reportType));
        }

        [HttpGet("organizationlevels")]
        public JsonResult GetOrganizationLevels()
        {
            return Json(_generateReportService.GetOrganizationLevels());
        }

        [HttpGet("organizationLevelsByReportCodeYear/{reportTypeCode}/{reportCode}/{reportYear}/{categorySetCode}")]
        public JsonResult GetOrganizationLevelsByReportCodeYear(string reportTypeCode, string reportCode, string reportYear, string categorySetCode)
        {
            if (reportTypeCode == null || reportCode == null || reportYear == null)
            {
                return null;
            }
            else
            {
                return Json(_generateReportService.GetOrganizationLevelsByReportCodeYear(reportCode, reportYear, categorySetCode));
            }
        }
        [HttpGet("getCatSet/{filterCode}")]
        public JsonResult GetCatSetNameByCode(string filterCode)
        {
            var filterOption = _generateReportService.GetFilterOptionByCode(filterCode);

            return Json(filterOption == null ? null : new { filterOption.FilterCode, filterOption.FilterName });
        }

        [HttpGet("getcat/{filterCode}")]
        public JsonResult GetCats(string filterCode)
        {
            var categorySet = _generateReportService.GetCategorySetByCode(filterCode);

            return Json(categorySet == null ? null : new { categorySet.CategorySetCode, categorySet.CategorySetName });
        }
    }

}
