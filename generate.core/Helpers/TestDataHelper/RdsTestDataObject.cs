using generate.core.Models.RDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.TestDataHelper
{
    public class RdsTestDataObject
    {
        public string TestDatatype { get; set; }
        public string TestDataSection { get; set; }
        public string TestDataSectionDescription { get; set; }

        public int SeedValue { get; set; }

        public int QuantityOfSchools { get; set; }

        public List<DimSea> DimSeas { get; set; }
        public List<DimLea> DimLeas { get; set; }
        public List<DimK12School> DimSchools { get; set; }
        public List<DimK12Student> DimStudents { get; set; }
        public List<DimK12Staff> DimPersonnel { get; set; }
        public List<DimCharterSchoolAuthorizer> DimCharterSchoolAuthorizers { get; set; }
        public List<FactK12StudentCount> FactStudentCounts { get; set; }
        public List<FactK12StudentDiscipline> FactStudentDisciplines { get; set; }

        public List<FactK12StudentAssessment> FactStudentAssessments { get; set; }
        public List<FactK12StaffCount> FactPersonnelCounts { get; set; }
        public List<FactOrganizationCount> FactOrganizationCounts { get; set; }
        public List<FactOrganizationStatusCount> FactOrganizationStatusCounts { get; set; }
        public List<FactCustomCount> FactCustomCounts { get; set; }

    }
}
