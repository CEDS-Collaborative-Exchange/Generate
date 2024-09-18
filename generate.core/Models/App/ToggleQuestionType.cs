using System;
using System.Collections;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class ToggleQuestionType
    {
        public int ToggleQuestionTypeId { get; set; }
        public string ToggleQuestionTypeCode { get; set; }
        public string ToggleQuestionTypeName { get; set; }
        public bool IsMultiOption { get; set; }
    }
}
