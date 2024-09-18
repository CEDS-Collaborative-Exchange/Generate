using System;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class CedsConnection
    {
        public int CedsConnectionId { get; set; }
        public int CedsUseCaseId { get; set; }
        public string CedsConnectionName { get; set; }
        public string CedsConnectionDescription { get; set; }
        public string CedsConnectionSource { get; set; }
        public List<CedsConnection_CedsElement> CedsConnection_CedsElements { get; set; }

    }
}
