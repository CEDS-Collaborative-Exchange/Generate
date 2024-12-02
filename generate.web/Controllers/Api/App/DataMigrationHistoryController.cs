using generate.infrastructure.Contexts;
using generate.core.Models.App;
using generate.core.Interfaces.Services;
using Microsoft.AspNetCore.Mvc;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Repositories.Staging;
using generate.infrastructure.Services;
using System.Collections.Generic;
using System.Linq;
using generate.core.Models.Staging;

namespace generate.web.Controllers.Api.App
{
    [Route("api/app/datamigrationhistory")]
    [ResponseCache(Duration = 0)]
    [ApiController]
    public class DataMigrationHistoryController: Controller
    {
        private IAppRepository _appRepository;
        private IStagingRepository _stagingRepository;
        private IDataMigrationHistoryService _dataMigrationHistoryService;
        

        public DataMigrationHistoryController(
            IAppRepository appRepository,
            IStagingRepository stagingRepository,
            IDataMigrationHistoryService dataMigrationHistoryService)
        {
            _appRepository = appRepository;
            _stagingRepository = stagingRepository;
            _dataMigrationHistoryService = dataMigrationHistoryService;
        }

        [HttpGet("")]
        public JsonResult Get()
        {
            var results = _appRepository.GetAll<DataMigrationHistory>();
            return Json(results);
        }

        [HttpGet("{dataMigrationTypeCode}")]
        public JsonResult Get(string dataMigrationTypeCode)
        {
            var results = _appRepository.GetMigrationHistory(dataMigrationTypeCode);
            
            return Json(results);
        }

        [HttpGet("validation")]
        public JsonResult GetStagingValidationResults()
        {
            var results = _stagingRepository.GetAll<StagingValidationResult>(0, 0).OrderByDescending(x => x.Id);
            return Json(results);

        }

    }
}
