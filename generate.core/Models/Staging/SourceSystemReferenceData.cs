using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class SourceSystemReferenceData
    {
        public int SourceSystemReferenceDataId { get; set; }
        public short SchoolYear { get; set; }
        public string TableName { get; set; }
        public string TableFilter { get; set; }
        public string InputCode { get; set; }
        public string OutputCode { get; set; }
    }
}
