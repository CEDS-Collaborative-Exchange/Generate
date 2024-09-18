using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
 

namespace generate.core.Models.App
{
    public class CedsConnection_CedsElement
    {

        public int CedsConnectionId { get; set; }
        public CedsConnection CedsConnection { get; set; }
        public int CedsElementId { get; set; }
        public CedsElement CedsElement { get; set; }
        public string CedsDesElement { get; set; }


    }
}
