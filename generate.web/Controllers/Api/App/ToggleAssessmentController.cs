using generate.infrastructure.Contexts;
using generate.core.Interfaces.Repositories.App;
using generate.core.Models;
using generate.core.Models.App;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;


namespace generate.web.Controllers.Api.App
{
    [Route("api/app/toggleassessments")]
    [ResponseCache(Duration = 0)]
    [ApiController]
    public class ToggleAssessmentController : Controller
    {
        private IAppRepository _toggleAssessmentRepository;

        public ToggleAssessmentController(IAppRepository toggleAssessmentRepository)
        {
            _toggleAssessmentRepository = toggleAssessmentRepository;
        }

        // GET: api/values
        [HttpGet("")]
        public JsonResult Get()
        {
            IEnumerable<ToggleAssessment> results = _toggleAssessmentRepository.GetAll<ToggleAssessment>(0, 0);
            return Json(results);
        }

        // GET api/values/5
        [HttpGet("{id}")]
        public JsonResult Get(int id)
        {
            ToggleAssessment result = _toggleAssessmentRepository.GetById<ToggleAssessment>(id);
            return Json(result);
        }

        // POST api/values
        [HttpPost]
        public void Post([FromBody]ToggleAssessment newAssessment)
        {
            _toggleAssessmentRepository.Create<ToggleAssessment>(newAssessment);
            _toggleAssessmentRepository.Save();
        }

        [HttpPut]
        public void Put([FromBody]ToggleAssessment existingAssessment)
        {
            _toggleAssessmentRepository.Update(existingAssessment);
            _toggleAssessmentRepository.Save();
        }

        // DELETE api/values/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
            _toggleAssessmentRepository.Delete<ToggleAssessment>(id);
            _toggleAssessmentRepository.Save();
        }
    }
}
