using System;
using System.Collections;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class OrganizationLevel
    {
        public int OrganizationLevelId { get; set; }

        public string LevelName { get; set; }

        public string LevelCode { get; set; }

        public List<GenerateReport_OrganizationLevel> GenerateReport_OrganizationLevels { get; set; }

    }
}
