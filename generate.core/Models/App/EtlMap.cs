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

        /// <summary>Free-text, natural-language description of how the source tables are joined. Fed to the
        /// AI ETL Developer alongside the structured joins for cases too complex for the join grid.</summary>
        public string JoinInstructions { get; set; }

        /// <summary>Free-text, map-level guidance on filtering and any complex processing required to produce
        /// the correct dataset before it lands in Staging. Fed verbatim to the AI ETL Developer.</summary>
        public string ProcessingNotes { get; set; }

        public DateTime CreatedDate { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public string ModifiedBy { get; set; }

        public List<EtlSourceElementMapping> EtlSourceElementMappings { get; set; }
        public List<EtlMapFileSpec> EtlMapFileSpecs { get; set; }
    }
}
