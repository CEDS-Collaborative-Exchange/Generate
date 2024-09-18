using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Dtos.ODS;

namespace generate.core.Interfaces.Repositories.RDS
{
    public interface IDimensionRepository
    {
        void GetChildCountDates(out int childCountMonth, out int childCountDay);
        void GetReferencePeriodDates(string factTypeCode, out int referencePeriodStartMonth, out int referencePeriodStartDay, out int referencePeriodEndMonth, out int referencePeriodEndDay);
        void GetCustomDateFromToggle(string emapsQuestionAbbrv, int defaultMonth, int defaultDay, out int monthValue, out int dayValue);
        IEnumerable<GradeLevelDto> GetGradeLevels(string gradeLevelTypeCode);
        IEnumerable<AssessmentTypeChildrenWithDisabilitiesDto> GetAssessmentTypeChildrenWithDisabilities(string subject, string grade);
    }
}
