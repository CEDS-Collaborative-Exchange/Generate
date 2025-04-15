using generate.core.Models.Staging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.TestDataHelper
{
    public class StagingEnrollmentTestDataObject
    {

        #region Data

        // Global

        public List<K12PersonRace> K12PersonRaces { get; set; }
        public List<K12Enrollment> K12Enrollments { get; set; }
        public List<Assessment> Assessments { get; set; }
        public List<AccessibleEducationMaterialProvider> AccessibleEducationMaterialProviders { get; set; }

        #endregion
    }
}
