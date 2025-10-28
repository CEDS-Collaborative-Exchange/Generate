using generate.infrastructure.Contexts;
using generate.core.Models.App;
using generate.core.Interfaces.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using generate.core.ViewModels.App;
using System.Threading.Tasks;
using generate.core.Models.RDS;
using System.Linq;
using System.Collections.Generic;
using generate.core.Dtos.App;
using Microsoft.EntityFrameworkCore;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Repositories.RDS;
using RestSharp;
using Microsoft.Extensions.Options;
using generate.core.Config;
using System.Web.Services.Description;
using Microsoft.EntityFrameworkCore.Migrations;

namespace generate.web.Controllers.Api.App
{
    [Route("api/app/datamigrations")]
    [ResponseCache(Duration = 0)]
    [ApiController]
    public class DataMigrationController : Controller
    {
        private readonly IOptions<AppSettings> _appSettings;

        private readonly IAppRepository _appRepository;
        private readonly IDataMigrationService _dataMigrationService;
        private readonly IRDSRepository _rdsRepository;

        public DataMigrationController(
            IOptions<AppSettings> appSettings,
            IAppRepository appRepository,
            IRDSRepository rdsRepository,
            IDataMigrationService dataMigrationService
            )
        {
            _appSettings = appSettings;
            _appRepository = appRepository;
            _dataMigrationService = dataMigrationService;
            _rdsRepository = rdsRepository;
        }

        [HttpGet("")]
        public JsonResult Get()
        {
            var results = _appRepository.GetAll<DataMigration>();
            return Json(results);
        }



        public class CancelMigrationRequest
        {
            public string MigrationType { get; set; }
        }
        [HttpPut("CancelMigration")]
        public IActionResult CancelMigration([FromBody]CancelMigrationRequest cancelMigrationRequest)
        {
            try
            {

                var backgroundUrl = _appSettings.Value.BackgroundUrl;
                var client = new RestClient(backgroundUrl + "/api/DataMigration/");
                var request = new RestRequest("MigrateData/Cancel/" + cancelMigrationRequest.MigrationType, Method.Get);
                var response = client.Get(request);

                return new OkResult();
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"Exception in CancelMigration :{ex}");
                return BadRequest(ex);
            }

        }


        [HttpPut("migrateods")]
        public IActionResult MigrateODS([FromBody]ConfigurationDto postdata)
        {
            try
            {

                _rdsRepository.UpdateRangeSave(postdata.dimSchoolYearDataMigrationTypes);
                _appRepository.UpdateRangeSave(postdata.dataMigrationTasks);

                var backgroundUrl = _appSettings.Value.BackgroundUrl;
                var client = new RestClient(backgroundUrl + "/api/DataMigration/");
                var request = new RestRequest("MigrateData/ods", Method.Get);
                var response = client.Get(request);

                return new OkResult();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }

        }


        [HttpPut("migraterds")]
        public IActionResult MigrateRDS([FromBody]ConfigurationDto postdata)
        {
            
            try
            {
                _rdsRepository.UpdateRangeSave(postdata.dimSchoolYearDataMigrationTypes);
                _appRepository.UpdateRangeSave(postdata.dataMigrationTasks);
                //_rdsRepository.Save();
                //_appRepository.Save();

                var backgroundUrl = _appSettings.Value.BackgroundUrl;
                var client = new RestClient(backgroundUrl + "/api/DataMigration/");
                var request = new RestRequest("MigrateData/rds", Method.Get);
                var response = client.Get(request);

                return new OkResult();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }

        }

        [HttpPut("migratereport")]
        public IActionResult MigrateReport([FromBody]ReportMigrationConfigurationDto postdata)
        {

            try
            {
                DataMigration reportMigration = _appRepository.GetAll<DataMigration>()
                                                              .ToList()
                                                              .Find(t => t.DataMigrationTypeId == 3);
                reportMigration.UserName = postdata.userName;

                

                _rdsRepository.UpdateRange(postdata.dimSchoolYearDataMigrationTypes);
                _rdsRepository.Save();

                _appRepository.Update(reportMigration);
                _appRepository.UpdateRange(postdata.generateReportLists);
                _appRepository.Save();

                var backgroundUrl = _appSettings.Value.BackgroundUrl;
                var client = new RestClient(backgroundUrl + "/api/DataMigration/");
                var request = new RestRequest("MigrateData/report", Method.Get);
                var response = client.Get(request);

                return new OkResult();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }


        }

        [HttpGet("currentmigrationstatus")]
        public JsonResult CurrentMigrationStatus()
        {
            CurrentMigrationStatus status = _dataMigrationService.CurrentMigrationStatus();
            return Json(status);
        }


        [HttpGet("years/{migrationType}")]
        public JsonResult MigrationYear(string migrationType)
        {

            List<string> dimSchoolYears = _appRepository.GetAll<CategorySet>(0, 0).Select(s => s.SubmissionYear).OrderByDescending(t => Convert.ToInt16(t)).Distinct().ToList();
            var datamigrationType = _appRepository.Find<DataMigrationType>(s => s.DataMigrationTypeCode == migrationType).FirstOrDefault();
            List<DimSchoolYearDto> yearDto = new List<DimSchoolYearDto>();

            foreach (var schoolYear in dimSchoolYears)
            {
                DimSchoolYear dimYear = _rdsRepository.Find<DimSchoolYear>(s => s.SchoolYear == Convert.ToInt16(schoolYear), 0, 0).FirstOrDefault();

                if (dimYear != null)
                {
                    DimSchoolYearDto dt = new DimSchoolYearDto();
                    dt.DimSchoolYearId = dimYear.DimSchoolYearId;
                    dt.SchoolYear = dimYear.SchoolYear.ToString();
                    dt.SessionBeginDate = dimYear.SessionBeginDate;
                    dt.SessionEndDate = dimYear.SessionEndDate;

                    var dm = _rdsRepository.Find<DimSchoolYearDataMigrationType>(s => s.DimSchoolYearId == dimYear.DimSchoolYearId && s.DataMigrationTypeId == datamigrationType.DataMigrationTypeId).FirstOrDefault();
                    if (dm == null || dm.IsSelected == false)
                        dt.IsSelected = false;
                    else
                        dt.IsSelected = true;
                    if (dm != null)
                    {
                        dt.DataMigrationTypeId = dm.DataMigrationTypeId;
                    }
                    yearDto.Add(dt);
                }

            }
            return Json(yearDto);
        }

        [HttpGet("tasklist/{reportType}")]
        public JsonResult MigrationTaskLists(string reportType)
        {
            List<DataMigrationTask> dataMigrationTasks = new List<DataMigrationTask>();
            IEnumerable<DataMigrationType> migrationList = _appRepository.GetAll<DataMigrationType>(0, 0);
            if (migrationList != null)
            {
                DataMigrationType dataMigrationType = _appRepository.GetAll<DataMigrationType>(0, 0).Where(s => s.DataMigrationTypeCode == reportType).FirstOrDefault();
                if (dataMigrationType != null)
                {
                     dataMigrationTasks = _appRepository.Find<DataMigrationTask>(a => a.DataMigrationTypeId == dataMigrationType.DataMigrationTypeId, 0, 0).ToList();
                }
            }
            return Json(dataMigrationTasks);
        }

        [HttpGet("reportLists")]
        public JsonResult GetReportListsLists()
        {
            List<GenerateReport> reportLists = new List<GenerateReport>();
            reportLists = _appRepository.GetReports(0, 0).ToList();
            return Json(reportLists);
        }
        [HttpGet("reportTypes")]
        public JsonResult GetReportTypes()
        {
            List<GenerateReportType> reportTypes = _appRepository.GetAll<GenerateReportType>().ToList();
            return Json(reportTypes);
        }

        [HttpGet("factTypes")]
        public JsonResult GetFactTypes()
        {
            List<DimFactType> factTypes = _rdsRepository.GetAll<DimFactType>()
                                                        .Where(t => t.DimFactTypeId > 0)
                                                        .OrderBy(t => t.FactTypeCode)
                                                        .ToList();
            return Json(factTypes);
        }

        [HttpGet("lastRunFactType")]
        public JsonResult GetLastRunFactType()
        {
            DimFactType factType = null;
            IEnumerable<DataMigrationType> migrationList = _appRepository.GetAll<DataMigrationType>(0, 0);
            if (migrationList != null)
            {
                DataMigrationType migrationType = migrationList.Where(s => s.DataMigrationTypeCode == "report").FirstOrDefault();
                if (migrationType != null)
                {
                    string taskList = _appRepository.Find<DataMigration>(a => a.DataMigrationTypeId == migrationType.DataMigrationTypeId, 0, 0).ToList()[0].DataMigrationTaskList;
                    if (taskList != null && taskList.Length > 0)
                    {
                        int taskId = Convert.ToInt32(taskList.Split(",")[0]);
                        DataMigrationTask task = _appRepository.GetById<DataMigrationTask>(taskId);
                        factType = _rdsRepository.GetById<DimFactType>(task.FactTypeId);

                    }
                }
            }

            return Json(factType);
        }

        [HttpGet("checkIfDirectoryDataExists/{schoolYearId}")]
        public JsonResult CheckIfDirectoryDataExists(int schoolYearId)
        {
            bool dataExists = _rdsRepository.CheckIfDirectoryDataExists(schoolYearId);
            return Json(dataExists);
        }


    }

}
