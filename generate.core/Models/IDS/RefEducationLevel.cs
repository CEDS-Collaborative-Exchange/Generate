using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefEducationLevel
    {
        public RefEducationLevel()
        {
            LearningResourceEducationLevel = new HashSet<LearningResourceEducationLevel>();
            LearningStandardItemEducationLevel = new HashSet<LearningStandardItemEducationLevel>();
            PersonDetail = new HashSet<PersonDetail>();
            PersonFamily = new HashSet<PersonFamily>();
            PsStudentDemographicRefMaternalEducationLevel = new HashSet<PsStudentDemographic>();
            PsStudentDemographicRefPaternalEducationLevel = new HashSet<PsStudentDemographic>();
        }

        public int RefEducationLevelId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public int? RefEducationLevelTypeId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<LearningResourceEducationLevel> LearningResourceEducationLevel { get; set; }
        public virtual ICollection<LearningStandardItemEducationLevel> LearningStandardItemEducationLevel { get; set; }
        public virtual ICollection<PersonDetail> PersonDetail { get; set; }
        public virtual ICollection<PersonFamily> PersonFamily { get; set; }
        public virtual ICollection<PsStudentDemographic> PsStudentDemographicRefMaternalEducationLevel { get; set; }
        public virtual ICollection<PsStudentDemographic> PsStudentDemographicRefPaternalEducationLevel { get; set; }
        public virtual RefEducationLevelType RefEducationLevelType { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
