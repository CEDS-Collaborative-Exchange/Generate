using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class OrganizationProgramType
    {
        public int Id { get; set; }
        public string OrganizationIdentifier { get; set; }
        public string OrganizationType { get; set; }
        public string ProgramType { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public string SchoolYear { get; set; }
        public string DataCollectionName { get; set; }
        //public int? DataCollectionId { get; set; }
        //public int? OrganizationId { get; set; }
        //public int? ProgramOrganizationId { get; set; }
        //public int? ProgramTypeId { get; set; }
        //public int? OrganizationProgramTypeId { get; set; }
    }
}
