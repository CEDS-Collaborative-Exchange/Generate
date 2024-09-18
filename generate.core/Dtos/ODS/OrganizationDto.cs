using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using generate.core.Models.IDS;

namespace generate.core.Dtos.ODS
{
    public class OrganizationDto
    {
        public string OrganizationId { get; set; }
        public string Name { get; set; }
        public int? RefOrganizationTypeId { get; set; }
        public string ShortName { get; set; }
        public string ParentOrganizationId { get; set; }
        public string OrganizationStateIdentifier { get; set; }
    }
}
