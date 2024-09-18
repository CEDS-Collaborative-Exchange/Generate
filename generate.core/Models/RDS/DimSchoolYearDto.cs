using System;
using System.Collections.Generic;
using System.Text;

namespace generate.core.Models.RDS
{
    public partial class DimSchoolYearDto
    {
        public int DimSchoolYearId { get; set; }
        public string SchoolYear { get; set; }
        public DateTime SessionBeginDate { get; set; }
        public DateTime SessionEndDate { get; set; }
        public bool IsSelected { get; set; }
        public int DataMigrationTypeId { get; set; }
    }
}
