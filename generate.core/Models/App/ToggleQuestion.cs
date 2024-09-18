using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;

namespace generate.core.Models.App
{
    public class ToggleQuestion
    {
        public int ToggleQuestionId { get; set; }
        public int ToggleQuestionTypeId { get; set; }
        public int ToggleSectionId { get; set; }
        public string EmapsQuestionAbbrv { get; set; }
        public string QuestionText { get; set; }
        public int QuestionSequence { get; set; }
        public int? ParentToggleQuestionId { get; set; }
        public ToggleQuestionType ToggleQuestionType { get; set; }
        public ToggleSection ToggleSection { get; set; }

        [ForeignKey("ParentToggleQuestionId")]
        public virtual ToggleQuestion ParentToggleQuestion { get; set; }
    }
}
