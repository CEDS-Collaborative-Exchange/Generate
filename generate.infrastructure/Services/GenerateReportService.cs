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
using generate.core.Interfaces.Repositories.App;

namespace generate.infrastructure.Services
{
    public class GenerateReportService : IGenerateReportService
    {
        private readonly IAppRepository _appRepository;

        private IDataPopulationSummaryService _dataPopulationSummaryService;
        private IEdFactsReportService _edFactsReportService;
        private ISppAprReportService _sppAprReportService;
        private IStateDefinedReportService _stateDefinedReportService;

        public GenerateReportService(
            IAppRepository appRepository,
            IDataPopulationSummaryService dataPopulationSummaryService,
            IEdFactsReportService edFactsReportService,
            ISppAprReportService sppAprReportService,
            IStateDefinedReportService stateDefinedReportService
            )
        {
            _appRepository = appRepository;
            _dataPopulationSummaryService = dataPopulationSummaryService;
            _edFactsReportService = edFactsReportService;
            _sppAprReportService = sppAprReportService;
            _stateDefinedReportService = stateDefinedReportService;
        }

        public List<GenerateReport> GetReports(string reportTypeCode)
        {
            IEnumerable<GenerateReport> reports;

            if (reportTypeCode == null)
            {
                reports = _appRepository.GetAll<GenerateReport>(0, 0);
            }
            else
            {
                reports = _appRepository.Find<GenerateReport>(r => r.GenerateReportType.ReportTypeCode == reportTypeCode && r.IsActive, 0, 0, r => r.GenerateReport_OrganizationLevels, s => s.GenerateReportControlType, t => t.GenerateReportFilterOptions, g => g.CedsConnection);
            }

            reports = reports.OrderBy(r => r.ReportSequence != null ? r.ReportSequence.ToString() : r.ReportShortName);

            return reports.ToList();
        }

        public List<GenerateReport> GetReportList(string reportTypeCode)
        {
            IEnumerable<GenerateReport> reports;

            if (reportTypeCode == null)
            {
                reports = _appRepository.GetAll<GenerateReport>(0, 0);
            }
            else
            {
                reports = _appRepository.Find<GenerateReport>(r => r.GenerateReportType.ReportTypeCode == reportTypeCode && r.IsActive, 0, 0);
            }

            reports = reports.OrderBy(r => r.ReportSequence != null ? r.ReportSequence.ToString() : r.ReportShortName);

            return reports.ToList();
        }

        public GenerateReport GetReport(string reportTypeCode, string reportCode)
        {
            IEnumerable<GenerateReport> reports = _appRepository.Find<GenerateReport>(r => 
                r.GenerateReportType.ReportTypeCode == reportTypeCode && r.IsActive && r.ReportCode == reportCode, 0, 0, r => r.GenerateReport_OrganizationLevels, s => s.GenerateReportControlType, t => t.GenerateReportFilterOptions, g => g.CedsConnection);

            if (reports != null)
            {
                return reports.FirstOrDefault();
            }
            else
            {
                return null;
            }
        }


        public List<GenerateReportDto> GetReportDtos(List<GenerateReport> reports)
        {
            IEnumerable<OrganizationLevel> organizationLevels = _appRepository.GetAll<OrganizationLevel>(0, 0);

            List<GenerateReportDto> results = new List<GenerateReportDto>();
            List<CategorySet> categorySets = new List<CategorySet>();

            List<int> generateReportIds = new List<int>();
            if (reports != null && reports.Count > 0)
            {
                generateReportIds = reports.Select(r => r.GenerateReportId).ToList();

                foreach (var reportId in generateReportIds)
                {
                    var catsets = _appRepository.Find<CategorySet>(r => r.GenerateReportId == reportId, 0, 0, c => c.OrganizationLevel, c => c.GenerateReport).ToList();
                    categorySets.AddRange(catsets); 
                }

                foreach (var report in reports)
                {
                    List<OrganizationLevel> reportOrganizationLevels = organizationLevels.Where(l => report.GenerateReport_OrganizationLevels.Any(r => r.OrganizationLevelId == l.OrganizationLevelId)).ToList();
                    List<OrganizationLevelDto> reportLevelDtos = new List<OrganizationLevelDto>();

                    bool seaLevel = false;
                    bool leaLevel = false;
                    bool schLevel = false;
                    string connectionLink = string.Empty;

                    if (report.CedsConnection != null)
                    {
                        connectionLink = "https://ceds.ed.gov/connectReport.aspx?uid=" + report.CedsConnection.CedsUseCaseId.ToString();
                    }

                    foreach (var item in reportOrganizationLevels)
                    {
                        OrganizationLevelDto levelDto = new OrganizationLevelDto();
                        levelDto.OrganizationLevelId = item.OrganizationLevelId;
                        levelDto.LevelCode = item.LevelCode;
                        levelDto.LevelName = item.LevelName;
                        reportLevelDtos.Add(levelDto);
                        if (item.LevelCode == "sea")
                        {
                            seaLevel = true;
                        }
                        else if (item.LevelCode == "lea")
                        {
                            leaLevel = true;
                        }
                        else if (item.LevelCode == "sch")
                        {
                            schLevel = true;
                        }
                    }

                    List<CategorySetDto> reportCategorySetDtos = new List<CategorySetDto>();
                    reportCategorySetDtos = GetCategorySets(report);

                   
                    List<GenerateReportFilterOptionDto> reportFilterOptionDtos = new List<GenerateReportFilterOptionDto>();
                    if (report.GenerateReportFilterOptions != null)
                    {
                        foreach (var item in report.GenerateReportFilterOptions)
                        {
                            GenerateReportFilterOptionDto filterOptiondto = new GenerateReportFilterOptionDto();
                            filterOptiondto.GenerateReportFilterOptionId = item.GenerateReportFilterOptionId;
                            filterOptiondto.FilterCode = item.FilterCode;
                            filterOptiondto.FilterName = item.FilterName;
                            filterOptiondto.FilterSequence = item.FilterSequence;
                            filterOptiondto.IsDefaultOption = item.IsDefaultOption;
                            filterOptiondto.IsSubFilter = item.IsSubFilter;
                            reportFilterOptionDtos.Add(filterOptiondto);
                        }
                    }

                    GenerateReportDto dto = new GenerateReportDto()
                    {
                        GenerateReportId = report.GenerateReportId,
                        GenerateReportTypeId = report.GenerateReportTypeId,
                        GenerateReportControlTypeId = report.GenerateReportControlTypeId,
                        ReportControlType = report.GenerateReportControlType,
                        ReportCode = report.ReportCode,
                        ReportName = report.ReportName,
                        ReportShortName = report.ReportShortName != null ? report.ReportShortName : report.ReportName,
                        ReportTypeAbbreviation = report.ReportTypeAbbreviation != null ? report.ReportTypeAbbreviation : "",
                        CategorySetControlCaption = report.CategorySetControlCaption != null ? report.CategorySetControlCaption : "",
                        ShowCategorySetControl = report.ShowCategorySetControl,
                        CedsConnectionId = report.CedsConnectionId,
                        ReportSequence = report.ReportSequence,
                        OrganizationLevels = reportLevelDtos,
                        CategorySets = reportCategorySetDtos,
                        ReportFilterOptions = reportFilterOptionDtos,
                        SeaLevel = seaLevel,
                        LeaLevel = leaLevel,
                        SchLevel = schLevel,
                        FilterControlLabel = report.FilterControlLabel,
                        SubFilterControlLabel = report.SubFilterControlLabel,
                        ShowFilterControl = report.ShowFilterControl,
                        ShowSubFilterControl = report.ShowSubFilterControl,
                        ShowGraph = report.ShowGraph,
                        ShowData = report.ShowData,
                        isActive = false,
                        ConnectionLink = connectionLink
                    };

                    results.Add(dto);
                }

            }

            return results;
        }


        public GenerateReportDataDto GetReportDataDto(string reportType, string reportCode, string reportLevel, string reportYear, string categorySetCode, string reportLea = null, string reportSchool = null, string reportFilter = null, string reportSubFilter = null, string reportGrade = null, string organizationalIdList = null, int reportSort = 1, int skip = 0, int take = 50, int pageSize = 10, int page = 1)
        {
            if (categorySetCode == "null")
            {
                categorySetCode = null;
            }

            if (reportLea == "null")
            {
                reportLea = null;
            }

            if (reportSchool == "null")
            {
                reportSchool = null;
            }

            GenerateReportDataDto reportDto = new GenerateReportDataDto();

            GenerateReport report = _appRepository.Find<GenerateReport>(r => r.GenerateReportType.ReportTypeCode == reportType
               && r.ReportCode == reportCode, 0, 1, c => c.GenerateReport_OrganizationLevels)
               .FirstOrDefault();

            IEnumerable<OrganizationLevel> organizationLevels = _appRepository.GetAll<OrganizationLevel>(0, 0);

            List<OrganizationLevel> reportOrganizationLevels = organizationLevels.Where(l => report.GenerateReport_OrganizationLevels.Any(r => r.OrganizationLevelId == l.OrganizationLevelId)).ToList();

            if (!reportOrganizationLevels.Any(l => l.LevelCode == reportLevel))
            {
                reportLevel = reportOrganizationLevels[0].LevelCode;

            }

            if (report == null)
            {
                return null;
            }

            GenerateReportControlType reportControlType = new GenerateReportControlType();
            reportControlType = _appRepository.GetById<GenerateReportControlType>(report.GenerateReportControlTypeId);


            if (reportType == "datapopulation")
            {
                reportDto = _dataPopulationSummaryService.GetReportDto(reportCode, reportLevel, reportYear, categorySetCode, reportSort, skip, take);

                if(reportCode == "studentswdtitle1")
                {
                   IEnumerable<CategorySet> categorySets = _appRepository.Find<CategorySet>(c => c.GenerateReport.ReportCode == reportCode && c.CategorySetCode == categorySetCode
                       && c.SubmissionYear == reportYear && c.OrganizationLevel.LevelCode == reportLevel, 0, 0, c => c.OrganizationLevel);


                    List<CategorySetDto> reportCategorySetDtos = new List<CategorySetDto>();
                    foreach (var item in categorySets)
                    {
                        CategorySetDto categorySetDto = new CategorySetDto();
                        categorySetDto.CategorySetId = item.CategorySetId;
                        categorySetDto.OrganizationLevelCode = item.OrganizationLevel.LevelCode;
                        categorySetDto.SubmissionYear = item.SubmissionYear;
                        categorySetDto.CategorySetCode = item.CategorySetCode;
                        categorySetDto.CategorySetName = item.CategorySetName;
                        categorySetDto.ViewDefinition = item.ViewDefinition;
                        categorySetDto.IncludeOnFilter = item.IncludeOnFilter;
                        categorySetDto.ExcludeOnFilter = item.ExcludeOnFilter;

                        List<string> categories = new List<string>();
                        List<CategorySetCategoryOptionDto> categoryOptions = new List<CategorySetCategoryOptionDto>();

                        List<CategorySet_Category> cats = _appRepository.Find<CategorySet_Category>(c => c.CategorySetId == item.CategorySetId, 0, 0, c => c.Category).ToList();
                        foreach (var cat in cats)
                        {
                            categories.Add(cat.Category.CategoryName);

                            List<CategoryOption> options = _appRepository.Find<CategoryOption>(o => o.CategoryId == cat.CategoryId && o.CategorySetId == cat.CategorySetId, 0, 0).ToList();

                            foreach (var option in options)
                            {
                                categoryOptions.Add(new CategorySetCategoryOptionDto
                                {
                                    CategoryName = cat.Category.CategoryName,
                                    CategoryOptionCode = option.CategoryOptionCode,
                                    CategoryOptionName = option.CategoryOptionName
                                });
                            }
                        }

                        categorySetDto.Categories = categories;
                        categorySetDto.CategoryOptions = categoryOptions;


                        reportCategorySetDtos.Add(categorySetDto);
                    }

                    reportDto.CategorySets = reportCategorySetDtos;
                }
            }
            else if (reportType == "edfactsreport")
            {
                reportDto = _edFactsReportService.GetReportDto(reportCode, reportLevel, reportYear, categorySetCode, reportSort, pageSize, page);

                IEnumerable<CategorySet> categorySets = _appRepository.Find<CategorySet>(c => c.GenerateReport.ReportCode == reportCode && c.CategorySetCode == categorySetCode 
                        && c.SubmissionYear == reportYear && c.OrganizationLevel.LevelCode == reportLevel , 0, 0, c => c.OrganizationLevel, c => c.GenerateReport, c => c.TableType);

                if (reportCode == "150") { categorySets = categorySets.Where(c => c.TableType.TableTypeAbbrv == "GRADRT4YRADJ"); }
                else if (reportCode == "151") { categorySets = categorySets.Where(c =>  c.TableType.TableTypeAbbrv == "GRADCOHORT4YR"); }

                List<string> categories = new List<string>();
                List<CategorySetCategoryOptionDto> categoryOptions = new List<CategorySetCategoryOptionDto>();

                foreach (var item in categorySets)
                {
                    List<CategorySet_Category> cats = _appRepository.Find<CategorySet_Category>(c => c.CategorySetId == item.CategorySetId, 0, 0, c => c.Category).ToList();
                    foreach (var cat in cats)
                    {
                        if(!categories.Contains(cat.Category.CategoryName))
                            categories.Add(cat.Category.CategoryName);

                        List<CategoryOption> options = _appRepository.Find<CategoryOption>(o => o.CategoryId == cat.CategoryId && o.CategorySetId == cat.CategorySetId, 0, 0).ToList();

                        foreach (var option in options)
                        {
                            if (categoryOptions.Where(t => t.CategoryOptionCode == option.CategoryOptionCode).Count() == 0)
                            {
                                categoryOptions.Add(new CategorySetCategoryOptionDto
                                {
                                    CategoryName = cat.Category.CategoryName,
                                    CategoryOptionCode = option.CategoryOptionCode,
                                    CategoryOptionName = option.CategoryOptionName
                                });
                            }
                        }
                    }

                }


                List<CategorySetDto> reportCategorySetDtos = new List<CategorySetDto>();

                foreach (var item in categorySets)
                {
                    CategorySetDto categorySetDto = new CategorySetDto();
                    categorySetDto.CategorySetId = item.CategorySetId;
                    categorySetDto.OrganizationLevelCode = item.OrganizationLevel.LevelCode;
                    categorySetDto.SubmissionYear = item.SubmissionYear;
                    categorySetDto.CategorySetCode = item.CategorySetCode;
                    categorySetDto.CategorySetName = item.CategorySetName;
                    categorySetDto.ViewDefinition = item.ViewDefinition;
                    categorySetDto.IncludeOnFilter = item.IncludeOnFilter;
                    categorySetDto.ExcludeOnFilter = item.ExcludeOnFilter;

                    categorySetDto.Categories = categories;
                    categorySetDto.CategoryOptions = categoryOptions;
                    reportCategorySetDtos.Add(categorySetDto);
                }

                reportDto.CategorySets = reportCategorySetDtos;

            }
            else if ( reportType == "sppaprreport")
            {

                reportDto = _sppAprReportService.GetReportDto(reportCode, reportLevel, reportYear, categorySetCode, reportSort, skip, take);

                IEnumerable<CategorySet> categorySets = _appRepository.Find<CategorySet>(c => c.GenerateReport.ReportCode == reportCode && c.CategorySetCode == categorySetCode
                       && c.SubmissionYear == reportYear && c.OrganizationLevel.LevelCode == reportLevel, 0, 0, c => c.OrganizationLevel, c => c.GenerateReport);

                List<CategorySetDto> reportCategorySetDtos = new List<CategorySetDto>();
                foreach (var item in categorySets)
                {
                    CategorySetDto categorySetDto = new CategorySetDto();
                    categorySetDto.CategorySetId = item.CategorySetId;
                    categorySetDto.OrganizationLevelCode = item.OrganizationLevel.LevelCode;
                    categorySetDto.SubmissionYear = item.SubmissionYear;
                    categorySetDto.CategorySetCode = item.CategorySetCode;
                    categorySetDto.CategorySetName = item.CategorySetName;
                    categorySetDto.ViewDefinition = item.ViewDefinition;
                    categorySetDto.IncludeOnFilter = item.IncludeOnFilter;
                    categorySetDto.ExcludeOnFilter = item.ExcludeOnFilter;

                    List<string> categories = new List<string>();
                    List<CategorySetCategoryOptionDto> categoryOptions = new List<CategorySetCategoryOptionDto>();

                    List<CategorySet_Category> cats = _appRepository.Find<CategorySet_Category>(c => c.CategorySetId == item.CategorySetId, 0, 0, c => c.Category).ToList();
                    foreach (var cat in cats)
                    {
                        categories.Add(cat.Category.CategoryName);

                        List<CategoryOption> options = _appRepository.Find<CategoryOption>(o => o.CategoryId == cat.CategoryId && o.CategorySetId == cat.CategorySetId, 0, 0).ToList();

                        foreach (var option in options)
                        {
                            categoryOptions.Add(new CategorySetCategoryOptionDto
                            {
                                CategoryName = cat.Category.CategoryName,
                                CategoryOptionCode = option.CategoryOptionCode,
                                CategoryOptionName = option.CategoryOptionName
                            });
                        }
                    }

                    categorySetDto.Categories = categories;
                    categorySetDto.CategoryOptions = categoryOptions;


                    reportCategorySetDtos.Add(categorySetDto);
                }


                reportDto.CategorySets = reportCategorySetDtos;

            }
            else if (reportType == "statereport")
            {

                reportDto = _stateDefinedReportService.GetReportDto(reportCode, reportLevel, reportYear, categorySetCode, reportLea, reportSchool, reportFilter, reportSubFilter, reportGrade, organizationalIdList, reportSort, skip, take);

                IEnumerable<CategorySet> categorySets = _appRepository.Find<CategorySet>(c => c.GenerateReport.ReportCode == reportCode && c.CategorySetCode == categorySetCode
                       && c.SubmissionYear == reportYear && c.OrganizationLevel.LevelCode == reportLevel, 0, 0, c => c.OrganizationLevel, c => c.GenerateReport);

                List<CategorySetDto> reportCategorySetDtos = new List<CategorySetDto>();
                foreach (var item in categorySets)
                {
                    CategorySetDto categorySetDto = new CategorySetDto();
                    categorySetDto.CategorySetId = item.CategorySetId;
                    categorySetDto.OrganizationLevelCode = item.OrganizationLevel.LevelCode;
                    categorySetDto.SubmissionYear = item.SubmissionYear;
                    categorySetDto.CategorySetCode = item.CategorySetCode;
                    categorySetDto.CategorySetName = item.CategorySetName;
                    categorySetDto.ViewDefinition = item.ViewDefinition;
                    categorySetDto.IncludeOnFilter = item.IncludeOnFilter;
                    categorySetDto.ExcludeOnFilter = item.ExcludeOnFilter;

                    List<string> categories = new List<string>();
                    List<CategorySetCategoryOptionDto> categoryOptions = new List<CategorySetCategoryOptionDto>();

                    List<CategorySet_Category> cats = _appRepository.Find<CategorySet_Category>(c => c.CategorySetId == item.CategorySetId, 0, 0, c => c.Category).ToList();
                    foreach (var cat in cats)
                    {
                        if(cat.Category.CategoryName== "English Learner Status (Both)")
                        {
                            cat.Category.CategoryName = "English Learner Status";
                        }
                        categories.Add(cat.Category.CategoryName);

                        List<CategoryOption> options = _appRepository.Find<CategoryOption>(o => o.CategoryId == cat.CategoryId && o.CategorySetId == cat.CategorySetId, 0, 0).ToList();

                        foreach (var option in options)
                        {
                            categoryOptions.Add(new CategorySetCategoryOptionDto
                            {
                                CategoryName = cat.Category.CategoryName,
                                CategoryOptionCode = option.CategoryOptionCode,
                                CategoryOptionName = option.CategoryOptionName
                            });
                        }
                    }

                    categorySetDto.Categories = categories;
                    categorySetDto.CategoryOptions = categoryOptions;


                    reportCategorySetDtos.Add(categorySetDto);
                }


                reportDto.CategorySets = reportCategorySetDtos;

            }
            reportDto.ReportControlTypeName = reportControlType.ControlTypeName;
            reportDto.ReportYear = reportYear;
            return reportDto;
        }
        
        public List<CategorySetDto> GetCategorySets(GenerateReport report)
        {
            List<CategorySet> reportCategorySets = _appRepository.Find<CategorySet>(c => c.GenerateReport.ReportCode == report.ReportCode, 0, 0, c => c.OrganizationLevel, c => c.GenerateReport, c => c.TableType).ToList();

            if (report.ReportCode == "150") { reportCategorySets = reportCategorySets.Where(c => report.GenerateReport_OrganizationLevels.Any(r => r.OrganizationLevelId == c.OrganizationLevelId) && c.TableType.TableTypeAbbrv == "GRADRT4YRADJ").ToList(); }
            else if (report.ReportCode == "151") { reportCategorySets = reportCategorySets.Where(c => report.GenerateReport_OrganizationLevels.Any(r => r.OrganizationLevelId == c.OrganizationLevelId) && c.TableType.TableTypeAbbrv == "GRADCOHORT4YR").ToList(); }
            else { reportCategorySets = reportCategorySets.Where(c => report.GenerateReport_OrganizationLevels.Any(r => r.OrganizationLevelId == c.OrganizationLevelId)).ToList(); }


            List<CategorySetDto> reportCategorySetDtos = new List<CategorySetDto>();
            foreach (var item in reportCategorySets)
            {
                if (!reportCategorySetDtos.Any(a => a.CategorySetName == item.CategorySetName && a.SubmissionYear == item.SubmissionYear && a.OrganizationLevelCode == item.OrganizationLevel.LevelCode))
                {
                    CategorySetDto categorySetDto = new CategorySetDto();
                    categorySetDto.CategorySetId = item.CategorySetId;
                    categorySetDto.OrganizationLevelCode = item.OrganizationLevel.LevelCode;
                    categorySetDto.SubmissionYear = item.SubmissionYear;
                    categorySetDto.CategorySetCode = item.CategorySetCode;
                    categorySetDto.CategorySetName = item.CategorySetName;
                    categorySetDto.ViewDefinition = item.ViewDefinition;
                    categorySetDto.IncludeOnFilter = item.IncludeOnFilter;
                    categorySetDto.ExcludeOnFilter = item.ExcludeOnFilter;

                    List<string> categories = new List<string>();
                    List<CategorySetCategoryOptionDto> categoryOptions = new List<CategorySetCategoryOptionDto>();

                    List<CategorySet_Category> cats = _appRepository.Find<CategorySet_Category>(c => c.CategorySetId == item.CategorySetId, 0, 0, c => c.Category).ToList();
                    foreach (var cat in cats)
                    {
                        categories.Add(cat.Category.CategoryName);

                        List<CategoryOption> options = _appRepository.Find<CategoryOption>(o => o.CategoryId == cat.CategoryId && o.CategorySetId == cat.CategorySetId, 0, 0).ToList();

                        foreach (var option in options)
                        {
                            categoryOptions.Add(new CategorySetCategoryOptionDto
                            {
                                CategoryName = cat.Category.CategoryName,
                                CategoryOptionCode = option.CategoryOptionCode,
                                CategoryOptionName = option.CategoryOptionName
                            });
                        }
                    }

                    categorySetDto.Categories = categories;
                    categorySetDto.CategoryOptions = categoryOptions;

                    reportCategorySetDtos.Add(categorySetDto);
                }



            }

            return reportCategorySetDtos;
        }
    }
}
