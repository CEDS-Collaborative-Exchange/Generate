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
    public class DataMigrationController : ControllerBase
    {

        private readonly IMigrationService _migrationService;

        public DataMigrationController(ILogger<DataMigrationController> logger, IMigrationService migrationService)
        {
            _migrationService = migrationService ?? throw new ArgumentNullException(nameof(migrationService));
        }


        [HttpGet("MigrateData/{migrationType}")]
        public IActionResult MigrateData(string migrationType)
        {
            try
            {
                Console.WriteLine($"Inside MigrateData migrationType:{migrationType}");
                _migrationService.MigrateData(migrationType);

                return Ok();
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"Exception in MigrationData:{ex}");
                return BadRequest(ex);
            }
        }

        [HttpGet("MigrateData/Cancel/{migrationType}")]
        public IActionResult Cancel(string migrationType)
        {
            try
            {
                Console.WriteLine($"Inside Cancel migrationType:{migrationType}");

                _migrationService.CancelMigration(migrationType);

                return Ok();
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"Exception in Cancel:{ex}");
                return BadRequest(ex);
            }
        }


    }
}
