using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using generate.core.Dtos.App;
using generate.core.Interfaces.Services;
using Microsoft.Extensions.Hosting;
using Microsoft.AspNetCore.Mvc;

namespace generate.update.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UpdateController : ControllerBase
    {
        private readonly IHostEnvironment _hostingEnvironment;
        private readonly IAppUpdateService _updateService;

        public UpdateController(
            IHostEnvironment hostingEnvironment,
            IAppUpdateService updateService
            )
        {
            _updateService = updateService;
            _hostingEnvironment = hostingEnvironment;
        }


        [HttpGet]
        public ActionResult<IEnumerable<UpdatePackageDto>> GetAll()
        {
            string contentRootPath = _hostingEnvironment.ContentRootPath;
            return _updateService.GetPendingUpdates(contentRootPath);
        }

        [HttpGet("{currentVersion}")]
        public ActionResult<IEnumerable<UpdatePackageDto>> GetByVersion(string currentVersion)
        {
            if (currentVersion.Contains("."))
            {
                var versionArray = currentVersion.Split(".");

                if (versionArray.Length == 2)
                {
                    int currentMajorVersion = 0;
                    int currentMinorVersion = 0;

                    int.TryParse(versionArray[0], out currentMajorVersion);
                    int.TryParse(versionArray[1], out currentMinorVersion);

                    string contentRootPath = _hostingEnvironment.ContentRootPath;

                    return _updateService.GetPendingUpdates(contentRootPath, currentMajorVersion, currentMinorVersion);
                }
            }

            return BadRequest();
        }

    }
}
