using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class LearningStandardDocument
    {
        public LearningStandardDocument()
        {
            LearningStandardItem = new HashSet<LearningStandardItem>();
        }

        public int LearningStandardDocumentId { get; set; }
        public string Uri { get; set; }
        public string Title { get; set; }
        public string Subject { get; set; }
        public string Version { get; set; }
        public string Creator { get; set; }
        public string Jurisdiction { get; set; }
        public string Description { get; set; }
        public string Publisher { get; set; }
        public int? RefLearningStandardDocumentPublicationStatusId { get; set; }
        public DateTime ValidStartDate { get; set; }
        public DateTime ValidEndDate { get; set; }
        public int? RefLanguageId { get; set; }
        public string License { get; set; }
        public string Rights { get; set; }
        public string RightsHolder { get; set; }
        public DateTime? LearningStandardDocumentPublicationDate { get; set; }

        public virtual ICollection<LearningStandardItem> LearningStandardItem { get; set; }
        public virtual RefLanguage RefLanguage { get; set; }
        public virtual RefLearningStandardDocumentPublicationStatus RefLearningStandardDocumentPublicationStatus { get; set; }
    }
}
