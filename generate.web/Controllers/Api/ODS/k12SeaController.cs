using generate.infrastructure.Contexts;
using generate.core.Interfaces.Repositories.IDS;
using generate.core.Models;
using generate.core.Models.IDS;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;

namespace generate.web.Controllers.Api.ODS
{
    [Route("api/ods/k12Sea")]
    public class k12SeaController : Controller
    {
        private IIDSRepository _idsRepository;

        public k12SeaController(IIDSRepository idsRepository)
        {
            _idsRepository = idsRepository;
        }

        [HttpGet("")]
        public JsonResult Get()
        {
            var results = _idsRepository.GetAll<K12sea>(0,1).FirstOrDefault();
            return Json(results);
        }


        [HttpGet("state")]
        public JsonResult GetState()
        {
            K12sea sea = _idsRepository.GetAll<K12sea>(0,1).FirstOrDefault();
            var state = _idsRepository.GetById<RefState>(Convert.ToInt32(sea.RefStateAnsicodeId));
            return Json(state);
        }
    }
}
