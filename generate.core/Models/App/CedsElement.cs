using System;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class CedsElement
    {
        public int CedsElementId { get; set; }
        public int CedsTermId { get; set; }
        public string CedsElementName { get; set; }
        public string CedsElementDefinition { get; set; }
        public int? CedsElementVersion { get; set; }
        public List<ODSElement> ODSElements { get; set; }
        public List<CedsConnection_CedsElement> CedsConnection_CedsElements { get; set; }


    }
}
