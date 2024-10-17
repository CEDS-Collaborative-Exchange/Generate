using Microsoft.AspNetCore.Mvc;
using generate.infrastructure.Contexts;
using generate.core.Models.App;
using generate.core.Interfaces.Services;
using System;
using generate.core.ViewModels.App;
using System.Threading.Tasks;
using generate.core.Models.RDS;
using System.Linq;
using System.Collections.Generic;
using generate.core.Dtos.App;
using Microsoft.EntityFrameworkCore;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Repositories.RDS;
using RestSharp;
using Microsoft.Extensions.Options;
using generate.core.Config;
using System.Threading;
using System.Configuration;
using Microsoft.Extensions.Configuration;
using System.Net;

namespace generate.web.Controllers.Api.App
{
    [Route("api/app/fsmetadata")]
    [ResponseCache(Duration = 0)]
    public class FSMetadataCallController : Controller
    {

        private readonly IOptions<AppSettings> _appSettings;
        private readonly IAppRepository _appRepository;
        private readonly IFSMetadataUpdateService _FSMetadataUpdate;
        private readonly IRDSRepository _rdsRepository;
        private readonly bool _useWSforFSMetaUpd;
        private readonly string _fsWSURL;
        private readonly string _fsMetaFileLoc;
        private readonly string _fsMetaESSDetailFileName;
        private readonly string _fsMetaCHRDetailFileName;
        private readonly string _fsMetaESSLayoutFileName;        
        private readonly string _fsMetaCHRLayoutFileName;
        private readonly string _bkfsMetaFileLoc;
        private readonly bool _reloadFromBackUp;
        private readonly string _backgroundUrl;
        public FSMetadataCallController
        (
            IOptions <AppSettings> appSettings,
            IAppRepository appRepository,
            IRDSRepository rdsRepository,
            IFSMetadataUpdateService fsMetadataUpdate,
            IConfiguration configuration
        )
        {

            _appSettings = appSettings;
            _appRepository = appRepository;
            _FSMetadataUpdate = fsMetadataUpdate;
            _rdsRepository = rdsRepository;

            _useWSforFSMetaUpd = configuration.GetSection("appSettings").GetValue<bool>("useWSforFSMetaUpd");
            _fsWSURL = configuration.GetSection("appSettings").GetValue<string>("fsWSURL");   
            _fsMetaFileLoc = configuration.GetSection("appSettings").GetValue<string>("fsMetaFileLoc");
            _fsMetaESSDetailFileName = configuration.GetSection("appSettings").GetValue<string>("fsMetaESSDetailFileName");
            _fsMetaCHRDetailFileName = configuration.GetSection("appSettings").GetValue<string>("fsMetaCHRDetailFileName");
            _fsMetaESSLayoutFileName = configuration.GetSection("appSettings").GetValue<string>("fsMetaESSLayoutFileName");
            _fsMetaCHRLayoutFileName = configuration.GetSection("appSettings").GetValue<string>("fsMetaCHRLayoutFileName");
            _bkfsMetaFileLoc = configuration.GetSection("appSettings").GetValue<string>("bkfsMetaFileLoc");
            _reloadFromBackUp = configuration.GetSection("appSettings").GetValue<bool>("reloadFromBackUp");
            _backgroundUrl = configuration.GetSection("appSettings").GetValue<string>("BackgroundUrl");
        }

        [HttpGet("fsservc")]
        public async Task<IActionResult> callfsMetaServ()
        {

            this._FSMetadataUpdate.useWSforFSMetaUpd = _useWSforFSMetaUpd;
            this._FSMetadataUpdate.fsWSURL = _fsWSURL;
            this._FSMetadataUpdate.fsMetaFileLoc = _fsMetaFileLoc;
            this._FSMetadataUpdate.fsMetaESSDetailFileName = _fsMetaESSDetailFileName;
            this._FSMetadataUpdate.fsMetaCHRDetailFileName = _fsMetaCHRDetailFileName;
            this._FSMetadataUpdate.fsMetaESSLayoutFileName = _fsMetaESSLayoutFileName;
            this._FSMetadataUpdate.fsMetaCHRLayoutFileName = _fsMetaCHRLayoutFileName;
            this._FSMetadataUpdate.bkfsMetaFileLoc = _bkfsMetaFileLoc;
            this._FSMetadataUpdate.reloadFromBackUp = _reloadFromBackUp;

            await Task.FromResult(this._FSMetadataUpdate.callInitFSmetaServc());

            return Ok();
            
        }

        [HttpGet("getMetadataStatus")]
        public JsonResult getMetadataStatus()
        {
           List<GenerateConfiguration> metadataConfig = _appRepository.GetAll<GenerateConfiguration>(0, 0).Where(t => t.GenerateConfigurationCategory == "Metadata").ToList();
           return Json(metadataConfig);
        }

    }
}
