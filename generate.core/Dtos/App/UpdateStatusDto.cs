using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Dtos.App
{
    public class UpdateStatusDto
    {
        // "OK", "IN_PROGRESS", or "FAILED - {message}" for each side of the update.
        public string WebStatus { get; set; }
        public string WebPhase { get; set; }
        public string BackgroundStatus { get; set; }
        public string BackgroundPhase { get; set; }
    }
}
