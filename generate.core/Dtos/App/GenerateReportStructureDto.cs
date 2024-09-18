using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Dtos.App
{
    public class GenerateReportStructureDto
    {
        public string rowHeader { get; set; }
        public List<string> columnHeaders { get; set; }
        public List<string> subColumnHeaders { get; set; }

    }
}
