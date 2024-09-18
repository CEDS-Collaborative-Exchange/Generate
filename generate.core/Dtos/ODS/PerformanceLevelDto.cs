using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Dtos.ODS
{
    public class PerformanceLevelDto
    {
        public string Identifier { get; set; }
        public string Label { get; set; }
        public string LowerCutScore { get; set; }
        public string UpperCutScore { get; set; }
        public string DescriptiveFeedback { get; set; }
        public string ScoreMetric { get; set; }
    }
}
