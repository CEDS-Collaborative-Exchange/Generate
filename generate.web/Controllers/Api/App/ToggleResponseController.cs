using generate.infrastructure.Contexts;
using generate.core.Models;
using generate.core.Models.App;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using Newtonsoft.Json;
using System;
using Microsoft.EntityFrameworkCore;
using generate.core.Interfaces.Repositories.App;

namespace generate.web.Controllers.Api.App
{
    public class ToggleResponses {
        public ToggleResponse[] Data { get; set; }
    }
    [Route("api/app/toggleresponses")]
    [ResponseCache(Duration = 0)]
    [ApiController]
    public class ToggleResponseController : Controller
    {
        private IAppRepository _toggleResponseRepository;

        public ToggleResponseController(IAppRepository toggleResponseRepository)
        {
            _toggleResponseRepository = toggleResponseRepository;
        }

        [HttpGet("")]
        public JsonResult Get()
        {
            IEnumerable<ToggleResponse> results = _toggleResponseRepository.GetAll<ToggleResponse>(0, 0);
            
            return Json(results);
        }

        [HttpPost("saveresponses")]
        public IActionResult SaveResponses([FromBody]object[] newResponses) {
            try {
                if (newResponses == null)
                    return new OkResult();
                var responses = DeserializeObjectArrayToToggleResponses(newResponses);
                _toggleResponseRepository.CreateRange<ToggleResponse>(responses);
                _toggleResponseRepository.Save();
                return new OkResult();
            }
            catch (Exception ex) {
                return BadRequest(ex);
            }
        }

        

        [HttpPut("updateresponses")]
        public IActionResult UpdateResponses([FromBody]object[] updatedResponses)
        {
            try
            {
                if(updatedResponses== null)
                    return new OkResult();
                var responses = DeserializeObjectArrayToToggleResponses(updatedResponses);
                _toggleResponseRepository.UpdateRange<ToggleResponse>(responses);
                _toggleResponseRepository.Save();
                return new OkResult();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpDelete("deleteresponses")]
        public IActionResult DeleteResponses([FromBody]object[] deleteResponses)
        {
            try
            {
                if(deleteResponses == null)
                    return new OkResult();
                var responses = DeserializeObjectArrayToToggleResponses(deleteResponses);
                _toggleResponseRepository.DeleteRange<ToggleResponse>(responses);
                _toggleResponseRepository.Save();
                return new OkResult();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
        
        protected IEnumerable<ToggleResponse> DeserializeObjectArrayToToggleResponses(object[] responses) {
            // HACK: responses from the controller methods were coming up as null when using the usual typed ToggleResponse[] pattern - so off to manual
            // DTO was necessary to avoid circular reference exceptions (ToggleQuestion, ToggleQuestionOption) from deserialization
            List<ToggleResponse> retval = new List<ToggleResponse>();
            foreach (var item in responses) {
                var dto = JsonConvert.DeserializeObject<ToggleResponseDto>(item.ToString());
                retval.Add(dto.MapToToggleResponse());
            }

            return retval;
        }
    }
}