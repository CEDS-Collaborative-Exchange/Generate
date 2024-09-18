using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class Facility
    {
        public int LocationId { get; set; }
        public string Identifier { get; set; }
        public string BuildingName { get; set; }
        public string SpaceDescription { get; set; }
        public int? RefSpaceUseTypeId { get; set; }
        public string BuildingSiteNumber { get; set; }
        public int? RefBuildingUseTypeId { get; set; }

        public virtual Location Location { get; set; }
        public virtual RefBuildingUseType RefBuildingUseType { get; set; }
        public virtual RefSpaceUseType RefSpaceUseType { get; set; }
    }
}
