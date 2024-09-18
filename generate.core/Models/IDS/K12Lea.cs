using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12lea
    {
        public K12lea()
        {
            K12leaPreKeligibility = new HashSet<K12leaPreKeligibility>();
            K12leaPreKeligibleAgesIdea = new HashSet<K12leaPreKeligibleAgesIdea>();
            K12leaTitleIiiprofessionalDevelopment = new HashSet<K12leaTitleIiiprofessionalDevelopment>();
            K12leaTitleIsupportService = new HashSet<K12leaTitleIsupportService>();            
        }

        public int K12LeaId { get; set; }
        public int OrganizationId { get; set; }
        public int? RefLeaTypeId { get; set; }
        public string SupervisoryUnionIdentificationNumber { get; set; }
        public int? RefLeaimprovementStatusId { get; set; }
        public int? RefPublicSchoolChoiceStatusId { get; set; }
        public bool? CharterSchoolIndicator { get; set; }
        public int? RefCharterLeaStatusId { get; set; }

        public virtual K12leaFederalReporting K12leaFederalReporting { get; set; }
        public virtual ICollection<K12leaPreKeligibility> K12leaPreKeligibility { get; set; }
        public virtual ICollection<K12leaPreKeligibleAgesIdea> K12leaPreKeligibleAgesIdea { get; set; }
        public virtual K12leaSafeDrugFree K12leaSafeDrugFree { get; set; }
        public virtual ICollection<K12leaTitleIiiprofessionalDevelopment> K12leaTitleIiiprofessionalDevelopment { get; set; }
        public virtual ICollection<K12leaTitleIsupportService> K12leaTitleIsupportService { get; set; }
        public virtual Organization Organization { get; set; }
        public virtual RefLeaType RefLeaType { get; set; }
        public virtual RefLeaImprovementStatus RefLeaimprovementStatus { get; set; }
        public virtual RefPublicSchoolChoiceStatus RefPublicSchoolChoiceStatus { get; set; }
        public virtual RefCharterLeaStatus RefCharterLeaStatus { get; set; }
    }
}
