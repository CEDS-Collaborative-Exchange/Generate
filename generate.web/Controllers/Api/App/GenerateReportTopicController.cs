using generate.infrastructure.Contexts;
using generate.core.Dtos.App;
using generate.core.Models;
using generate.core.Models.App;
using generate.core.Models.RDS;
using generate.core.Interfaces.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;

namespace generate.web.Controllers.Api.App
{
    [Route("api/app/generatereporttopics")]
    [ResponseCache(Duration = 0)]
    public class GenerateReportTopicController : Controller
    {
        private IGenerateReportTopicService _generateReportTopicService;
        private IGenerateReportService _generateReportService;

        public GenerateReportTopicController(
            IGenerateReportTopicService generateReportTopicService,
            IGenerateReportService generateReportService
           )
        {
            _generateReportTopicService = generateReportTopicService;
            _generateReportService = generateReportService;
        }

        [HttpGet("{userName}")]
        public JsonResult Get(string userName)
        {
            var results = _generateReportTopicService.GetReportTopics(userName);
            return Json(results);
        }

        [HttpGet("getReports/{topicId}")]
        public JsonResult GetReports(int topicId)
        {
            List<GenerateReport> reportList = _generateReportTopicService.GetReports(topicId);
            var results = _generateReportService.GetReportDtos(reportList);
            return Json(results);

        }

        [HttpPost("addtopic")]
        public IActionResult AddTopic([FromBody]GenerateReportTopicDto topic)
        {
            try
            {
               _generateReportTopicService.AddTopic(topic);
                return new OkResult();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPut("updatetopic")]
        public IActionResult UpdateTopic([FromBody]GenerateReportTopicDto topic)
        {
            try
            {
                _generateReportTopicService.UpdateTopic(topic);
                return new OkResult();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPut("updatereporttopics/{reportId}")]
        public IActionResult UpdateReportTopics(int reportId, [FromBody]int[] topicIds)
        {
            try
            {
                _generateReportTopicService.UpdateReportTopics(reportId, topicIds);
                return new OkResult();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpDelete("{id}")]
        public IActionResult RemoveTopic(int id)
        {
            try
            {
                _generateReportTopicService.RemoveTopic(id);
                return new OkResult();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
