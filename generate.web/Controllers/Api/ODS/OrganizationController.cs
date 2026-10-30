using generate.infrastructure.Contexts;
using generate.core.Models.IDS;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;
using generate.core.Dtos.ODS;
using generate.core.Interfaces.Repositories.IDS;
using generate.core.Interfaces.Repositories.RDS;
using Microsoft.AspNetCore.Authorization;

namespace generate.web.Controllers.Api.ODS
{
    [Route("api/ods/organizations")]
    [ApiController]
    [Authorize]
    public class OrganizationController : Controller
    {
        private IIDSRepository _idsRepository;
        private IFactOrganizationCountRepository _factOrganizationCountRepository;

        public OrganizationController(IIDSRepository idsRepository,IFactOrganizationCountRepository factOrganizationCountRepository)
        {
            _idsRepository = idsRepository;
            _factOrganizationCountRepository = factOrganizationCountRepository;
        }

        [HttpGet("")]
        public JsonResult Get()
        {
            var results = _idsRepository.GetAll<OrganizationDetail>();
            return Json(results);
        }

        [HttpGet("{organizationTypeCode}/{schoolYear}")]
        public JsonResult Get(string organizationTypeCode, string schoolYear)
        {
            return Json(_factOrganizationCountRepository.GetOrganizations(organizationTypeCode, schoolYear));
        }

    }
}

