using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ActivityRecognition
    {
        public int ActivityRecognitionId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public int RefActivityRecognitionTypeId { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefActivityRecognitionType RefActivityRecognitionType { get; set; }
    }
}
