using System;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    /// <summary>
    /// A named ETL source mapping set (App.EtlMap): one uploaded data dictionary and its element /
    /// option set value mappings to CEDS, with creation and last-update audit.
    /// </summary>
    public class EtlMap
    {
        public int EtlMapId { get; set; }
        public string MapName { get; set; }
        public string UploadFileName { get; set; }
        public DateTime CreatedDate { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public string ModifiedBy { get; set; }

        public List<EtlSourceElementMapping> EtlSourceElementMappings { get; set; }
    }
}
