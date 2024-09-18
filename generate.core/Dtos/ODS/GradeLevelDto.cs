using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using generate.core.Models.IDS;

namespace generate.core.Dtos.ODS
{
    public class GradeLevelDto
    {
        public int RefGradeLevelId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public string RefGradeLeveltypeId { get; set; }
    }
}
