using System;
using generate.core.Dtos.App;
using generate.core.Interfaces.Services;
using generate.core.Models.App;
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

        [HttpPost("maps")]
        public IActionResult CreateMap([FromBody] EtlMapSaveDto save)
        {
            if (save == null || string.IsNullOrWhiteSpace(save.MapName))
            {
                return BadRequest("A map name is required.");
            }

            if (string.IsNullOrWhiteSpace(save.ModifiedBy))
            {
                save.ModifiedBy = User?.Identity?.Name;
            }

            var result = _etlSourceMappingService.CreateMap(save);
            return Json(result);
        }

        [HttpPut("maps/{id}")]
        public IActionResult UpdateMap(int id, [FromBody] EtlMapSaveDto save)
        {
            if (save == null)
            {
                return BadRequest("No update was provided.");
            }

            if (string.IsNullOrWhiteSpace(save.ModifiedBy))
            {
                save.ModifiedBy = User?.Identity?.Name;
            }

            var result = _etlSourceMappingService.UpdateMap(id, save);

            if (result == null)
            {
                return NotFound();
            }

            return Json(result);
        }

        [HttpGet("facttypes")]
        public JsonResult GetFactTypes()
        {
            var results = _etlSourceMappingService.GetFactTypes();
            return Json(results);
        }

        [HttpGet("filespecnumbers")]
        public JsonResult GetFileSpecNumbers()
        {
            var results = _etlSourceMappingService.GetFileSpecNumbers();
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

        // ---- Source datasets registered to a map (a file spec may draw from several sources) ----

        [HttpGet("maps/{mapId}/sources")]
        public JsonResult GetMapSources(int mapId)
        {
            return Json(_etlSourceMappingService.GetMapSources(mapId));
        }

        [HttpPost("maps/{mapId}/sources")]
        public IActionResult SaveMapSource(int mapId, [FromBody] EtlMapSource source)
        {
            if (source == null || string.IsNullOrWhiteSpace(source.SourceObject))
            {
                return BadRequest("A source object (schema.table / view / query) is required.");
            }
            source.EtlMapId = mapId;
            if (string.IsNullOrWhiteSpace(source.CreatedBy)) { source.CreatedBy = User?.Identity?.Name; }
            source.ModifiedBy = User?.Identity?.Name;
            var saved = _etlSourceMappingService.SaveMapSource(source);
            return saved == null ? (IActionResult)NotFound() : Json(saved);
        }

        [HttpDelete("maps/sources/{sourceId}")]
        public IActionResult DeleteMapSource(int sourceId)
        {
            return _etlSourceMappingService.DeleteMapSource(sourceId) ? (IActionResult)Ok() : NotFound();
        }

        // ---- Structured joins between a map's source objects (how the sources relate) ----

        [HttpGet("maps/{mapId}/joins")]
        public JsonResult GetMapJoins(int mapId)
        {
            return Json(_etlSourceMappingService.GetMapJoins(mapId));
        }

        [HttpPost("maps/{mapId}/joins")]
        public IActionResult SaveMapJoin(int mapId, [FromBody] EtlMapJoin join)
        {
            if (join == null || string.IsNullOrWhiteSpace(join.LeftSourceObject) || string.IsNullOrWhiteSpace(join.RightSourceObject))
            {
                return BadRequest("A join needs a left and right source object.");
            }
            join.EtlMapId = mapId;
            if (string.IsNullOrWhiteSpace(join.CreatedBy)) { join.CreatedBy = User?.Identity?.Name; }
            join.ModifiedBy = User?.Identity?.Name;
            var saved = _etlSourceMappingService.SaveMapJoin(join);
            return saved == null ? (IActionResult)NotFound() : Json(saved);
        }

        [HttpDelete("maps/joins/{joinId}")]
        public IActionResult DeleteMapJoin(int joinId)
        {
            return _etlSourceMappingService.DeleteMapJoin(joinId) ? (IActionResult)Ok() : NotFound();
        }

        // ---- Free-text AI guidance (join description + map-level processing/filtering notes) ----

        [HttpPut("maps/{mapId}/guidance")]
        public IActionResult SaveMapGuidance(int mapId, [FromBody] EtlMapGuidanceDto guidance)
        {
            if (guidance == null)
            {
                return BadRequest("No guidance was provided.");
            }
            if (string.IsNullOrWhiteSpace(guidance.ModifiedBy)) { guidance.ModifiedBy = User?.Identity?.Name; }
            var result = _etlSourceMappingService.SaveMapGuidance(mapId, guidance);
            return result == null ? (IActionResult)NotFound() : Json(result);
        }

        // ---- Source objects + their columns (for the join-builder dropdowns) ----

        [HttpGet("maps/{mapId}/source-schema")]
        public JsonResult GetMapSourceSchema(int mapId)
        {
            return Json(_etlSourceMappingService.GetMapSourceSchema(mapId));
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

        [HttpGet("{id}/staging-candidates")]
        public JsonResult GetStagingCandidates(int id)
        {
            return Json(_etlSourceMappingService.GetStagingCandidates(id));
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
