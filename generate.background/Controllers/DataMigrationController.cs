using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using generate.core.Interfaces.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace generate.background.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DataMigrationController : Controller
    {

        private readonly ILogger<DataMigrationController> _logger;
        private readonly IMigrationService _migrationService;

        public DataMigrationController(ILogger<DataMigrationController> logger, IMigrationService migrationService)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _migrationService = migrationService ?? throw new ArgumentNullException(nameof(migrationService));
        }


        [HttpGet("MigrateData/{migrationType}")]
        public IActionResult MigrateData(string migrationType)
        {
            try
            {
                _migrationService.MigrateData(migrationType);

                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpGet("MigrateData/Cancel/{migrationType}")]
        public IActionResult Cancel(string migrationType)
        {
            try
            {
                _migrationService.CancelMigration(migrationType);

                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }


    }
}
