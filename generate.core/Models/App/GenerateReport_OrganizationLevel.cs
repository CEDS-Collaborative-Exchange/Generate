using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
 

namespace generate.core.Models.App
{
    public class GenerateReport_OrganizationLevel
    {

        public int GenerateReportId { get; set; }
        public GenerateReport GenerateReport { get; set; }
        public int OrganizationLevelId { get; set; }
        public OrganizationLevel OrganizationLevel { get; set; }
                
    }
}
