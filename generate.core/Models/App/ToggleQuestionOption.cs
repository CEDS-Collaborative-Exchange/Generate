using System;
using System.Collections;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class ToggleQuestionOption
    {
        public int ToggleQuestionOptionId { get; set; }
        public int ToggleQuestionId { get; set; }
        public string OptionText { get; set; }
        public int OptionSequence { get; set; }
        public ToggleQuestion ToggleQuestion { get; set; }

    }
}
