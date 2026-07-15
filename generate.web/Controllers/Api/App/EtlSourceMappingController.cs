using System;
using generate.core.Dtos.App;
using generate.core.Interfaces.Services;
using Microsoft.AspNetCore.Mvc;

namespace generate.web.Controllers.Api.App
{
    /// <summary>
    /// ETL Checklist source mapping API (CIID-9033, epic CIID-9029): upload a state's bespoke data
    /// dictionary, automap it to CEDS, review/override the mappings, and export the checklist.
    /// </summary>
    [Route("api/app/etlsourcemappings")]
    [ApiController]
    public class EtlSourceMappingController : Controller
    {
        private readonly IEtlSourceMappingService _etlSourceMappingService;

        public EtlSourceMappingController(IEtlSourceMappingService etlSourceMappingService)
        {
            _etlSourceMappingService = etlSourceMappingService;
        }

        [HttpGet("")]
        public JsonResult Get([FromQuery] int? mapId = null)
        {
            var results = _etlSourceMappingService.GetAllMappings(mapId);
            return Json(results);
        }

        [HttpGet("maps")]
        public JsonResult GetMaps()
        {
            var results = _etlSourceMappingService.GetMaps();
            return Json(results);
        }

        [HttpDelete("maps/{id}")]
        public IActionResult DeleteMap(int id)
        {
            if (!_etlSourceMappingService.DeleteMap(id))
            {
                return NotFound();
            }

            return Ok();
        }

        [HttpPost("upload")]
        public IActionResult Upload([FromBody] EtlSourceMappingUploadDto upload)
        {
            if (upload == null || upload.Elements == null || upload.Elements.Count == 0)
            {
                return BadRequest("No data dictionary elements were provided.");
            }

            if (string.IsNullOrWhiteSpace(upload.UploadedBy))
            {
                upload.UploadedBy = User?.Identity?.Name;
            }

            var results = _etlSourceMappingService.UploadDataDictionary(upload);
            return Json(results);
        }

        [HttpGet("cedselements")]
        public JsonResult GetCedsElements()
        {
            var results = _etlSourceMappingService.GetCedsElementCatalog();
            return Json(results);
        }

        [HttpGet("cedselements/{globalId}/optionsets")]
        public JsonResult GetCedsOptionSets(string globalId)
        {
            var results = _etlSourceMappingService.GetCedsOptionSetValues(globalId);
            return Json(results);
        }

        [HttpGet("{id}/candidates")]
        public JsonResult GetCandidates(int id)
        {
            var results = _etlSourceMappingService.GetElementCandidates(id);
            return Json(results);
        }

        [HttpPut("{id}")]
        public IActionResult UpdateElementMapping(int id, [FromBody] EtlSourceElementMappingUpdateDto update)
        {
            if (update == null)
            {
                return BadRequest("No update was provided.");
            }

            if (string.IsNullOrWhiteSpace(update.ModifiedBy))
            {
                update.ModifiedBy = User?.Identity?.Name;
            }

            try
            {
                var result = _etlSourceMappingService.UpdateElementMapping(id, update);

                if (result == null)
                {
                    return NotFound();
                }

                return Json(result);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPut("optionsets/{id}")]
        public IActionResult UpdateOptionSetMapping(int id, [FromBody] EtlSourceOptionSetMappingUpdateDto update)
        {
            if (update == null)
            {
                return BadRequest("No update was provided.");
            }

            if (string.IsNullOrWhiteSpace(update.ModifiedBy))
            {
                update.ModifiedBy = User?.Identity?.Name;
            }

            var result = _etlSourceMappingService.UpdateOptionSetMapping(id, update);

            if (result == null)
            {
                return NotFound();
            }

            return Json(result);
        }

        [HttpDelete("")]
        public IActionResult DeleteAll()
        {
            _etlSourceMappingService.DeleteAllMappings();
            return Ok();
        }

        [HttpGet("export")]
        public IActionResult Export([FromQuery] int? mapId = null)
        {
            string csv = _etlSourceMappingService.ExportChecklistCsv(mapId);
            string fileName = "EtlChecklist_" + DateTime.UtcNow.ToString("yyyyMMdd_HHmmss") + ".csv";
            return File(System.Text.Encoding.UTF8.GetBytes(csv), "text/csv", fileName);
        }
    }
}
