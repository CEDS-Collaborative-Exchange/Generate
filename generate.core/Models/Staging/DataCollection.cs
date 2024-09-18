using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class DataCollection
    {
        public int Id { get; set; }
        public int? SourceSystemDataCollectionIdentifier { get; set; }
        public string SourceSystemName { get; set; }
        public string DataCollectionName { get; set; }
        public string DataCollectionDescription { get; set; }
        public DateTime? DataCollectionOpenDate { get; set; }
        public DateTime? DataCollectionCloseDate { get; set; }
        public string DataCollectionAcademicSchoolYear { get; set; }
        public string DataCollectionSchoolYear { get; set; }
    }
}
