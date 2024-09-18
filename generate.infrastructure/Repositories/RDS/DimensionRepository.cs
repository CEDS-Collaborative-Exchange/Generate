using generate.core.Dtos.ODS;
using generate.core.Interfaces.Repositories.RDS;
using generate.infrastructure.Contexts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace generate.infrastructure.Repositories.RDS
{
    public class DimensionRepository : IDimensionRepository
    {
        private readonly AppDbContext _appContext;
        private readonly RDSDbContext _rdsContext;
        private readonly ILogger _logger;

        public DimensionRepository(
            AppDbContext appContext,
            RDSDbContext rdsContext,
             ILogger<DimensionRepository> logger
            )
        {
            _appContext = appContext;
            _rdsContext = rdsContext;
            _logger = logger;
        }

        public void GetChildCountDates(out int childCountMonth, out int childCountDay)
        {
            // Default values
            childCountMonth = 11;
            childCountDay = 1;

            // Get Custom Child Count Date (if available)

            this.GetCustomDateFromToggle("CHDCTDTE", childCountMonth, childCountDay, out childCountMonth, out childCountDay);

        }

        public void GetReferencePeriodDates(string factTypeCode, out int referencePeriodStartMonth, out int referencePeriodStartDay, out int referencePeriodEndMonth, out int referencePeriodEndDay)
        {
            // Default values
            referencePeriodStartMonth = 7;
            referencePeriodStartDay = 1;

            referencePeriodEndMonth = 6;
            referencePeriodEndDay = 30;


            if (factTypeCode == "cte")
            {
                // Get Custom Reference Period (if available)

                this.GetCustomDateFromToggle("CTEPERKPROGYRSTART", referencePeriodStartMonth, referencePeriodStartDay, out referencePeriodStartMonth, out referencePeriodStartDay);
                this.GetCustomDateFromToggle("CTEPERKPROGYREND", referencePeriodEndMonth, referencePeriodEndDay, out referencePeriodEndMonth, out referencePeriodEndDay);

            }
            else
            {
                // Get Custom Reference Period (if available)

                var customReferencePeriod = _appContext.ToggleResponses.FirstOrDefault(x => x.ToggleQuestion.EmapsQuestionAbbrv == "DEFEXREFPER");

                if (customReferencePeriod != null && customReferencePeriod.ResponseValue != null && customReferencePeriod.ResponseValue.ToLower() == "true")
                {

                    this.GetCustomDateFromToggle("DEFEXREFDTESTART", referencePeriodStartMonth, referencePeriodStartDay, out referencePeriodStartMonth, out referencePeriodStartDay);
                    this.GetCustomDateFromToggle("DEFEXREFDTEEND", referencePeriodEndMonth, referencePeriodEndDay, out referencePeriodEndMonth, out referencePeriodEndDay);

                }
            }
        }
        

        public void GetCustomDateFromToggle(string emapsQuestionAbbrv, int defaultMonth, int defaultDay, out int monthValue, out int dayValue)
        {
            monthValue = defaultMonth;
            dayValue = defaultDay;

            var toggleResponse = _appContext.ToggleResponses.FirstOrDefault(x => x.ToggleQuestion.EmapsQuestionAbbrv == emapsQuestionAbbrv);

            if (toggleResponse != null && toggleResponse.ResponseValue != null && toggleResponse.ResponseValue.Contains("/"))
            {
                var toggleResponseArray = toggleResponse.ResponseValue.Split("/");

                int.TryParse(toggleResponseArray[0], out monthValue);
                int.TryParse(toggleResponseArray[1], out dayValue);
            }

        }

        public IEnumerable<GradeLevelDto> GetGradeLevels(string gradeLevelTypeCode)
        {

            var returnObject = new List<GradeLevelDto>();

            try
            {
                returnObject = _rdsContext.Set<GradeLevelDto>().FromSqlRaw("App.Get_GradeLevels @gradeLevelType = {0}", gradeLevelTypeCode).ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;
            }
            return returnObject;
        }

        public IEnumerable<AssessmentTypeChildrenWithDisabilitiesDto> GetAssessmentTypeChildrenWithDisabilities(string subject, string grade)
        {

            var returnObject = new List<AssessmentTypeChildrenWithDisabilitiesDto>();

            try
            {
                returnObject = _rdsContext.Set<AssessmentTypeChildrenWithDisabilitiesDto>().FromSqlRaw("dbo.Get_AssessmentTypeChildrenWithDisabilities @subject = {0}, @grade = {1}", subject, grade).ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;
            }
            return returnObject;

        }
    }
}
