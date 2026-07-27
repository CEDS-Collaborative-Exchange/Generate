using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace generate.core.Models.App
{
    /// <summary>
    /// An AI ETL developer chat session for a map (App.EtlChatSession, CIID-9061). The bot iteratively
    /// builds SQL that loads a specified source into the map's mapped Staging tables and self-tests it.
    /// </summary>
    public class EtlChatSession
    {
        public int EtlChatSessionId { get; set; }
        public int EtlMapId { get; set; }
        public string SessionName { get; set; }
        public string SourceConnection { get; set; }
        public string SourceObject { get; set; }
        public string Status { get; set; }
        public int MaxLoops { get; set; }
        public int CurrentLoop { get; set; }
        public string LastEtlSql { get; set; }
        public string LastTestSql { get; set; }
        public string GeneratedProcedureName { get; set; }
        public DateTime CreatedDate { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public string ModifiedBy { get; set; }

        public List<EtlChatMessage> EtlChatMessages { get; set; }

        [JsonIgnore]
        public EtlMap EtlMap { get; set; }
    }
}
