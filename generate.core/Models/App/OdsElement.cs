using System;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class ODSElement
    {
        public int ODSElementId { get; set; }
        public int CedsElementId { get; set; }
        public CedsElement CedsElement { get;set;}
        public int CedsNdsElementId { get; set; } 
        public string ODSElementTable { get; set; }
        public string ODSElementColumn { get; set; }

    }
}
