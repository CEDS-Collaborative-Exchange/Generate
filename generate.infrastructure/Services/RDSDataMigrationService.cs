using System;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using generate.core.Models.App;
using generate.core.Interfaces.Services;
using System.Linq.Expressions;
using generate.core.Models.IDS;
using System.Threading.Tasks;
using Microsoft.Extensions.PlatformAbstractions;
using generate.core.ViewModels.App;
using generate.infrastructure.Contexts;
using generate.core.Models.RDS;
using Microsoft.EntityFrameworkCore;
using System.Globalization;
using System.Dynamic;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Interfaces.Repositories.App;

namespace generate.infrastructure.Services
{
    public class RDSDataMigrationService : IRDSDataMigrationService
    {

        private IAppRepository _appRepository;

        private int childCountDateMonth = 11;
        private int childCountDateDay = 1;


        public RDSDataMigrationService(
            IAppRepository appRepository
            )
        {
            _appRepository = appRepository;

            ToggleResponse childCountDate = _appRepository.Find<ToggleResponse>(r => r.ToggleQuestion.EmapsQuestionAbbrv == "CHDCTDTE").FirstOrDefault();
            if (childCountDate != null)
            {
                if (childCountDate.ResponseValue.Contains("/"))
                {
                    string[] childCountDateArray = childCountDate.ResponseValue.Split('/');
                    if (childCountDateArray.Length == 2)
                    {
                        int.TryParse(childCountDateArray[0], out childCountDateMonth);
                        int.TryParse(childCountDateArray[1], out childCountDateDay);
                    }
                }

            }

        }
        

    }

}