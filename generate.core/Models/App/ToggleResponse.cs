using System;
using System.Collections;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class ToggleResponse
    {
        public int ToggleResponseId { get; set; }
        public int ToggleQuestionId { get; set; }
        public int? ToggleQuestionOptionId { get; set; }
        public string ResponseValue { get; set; }
        public ToggleQuestion ToggleQuestion { get; set; }
        public ToggleQuestionOption ToggleQuestionOption { get; set; }
        

    }

    public class ToggleResponseDto {
        public int ToggleResponseId { get; set; }
        public int ToggleQuestionId { get; set; }
        public int? ToggleQuestionOptionId { get; set; }
        public string ResponseValue { get; set; }

        public ToggleResponse MapToToggleResponse() {
            return new ToggleResponse {
                ToggleResponseId = this.ToggleResponseId,
                ToggleQuestionId = this.ToggleQuestionId,
                ToggleQuestionOptionId = this.ToggleQuestionOptionId,
                ResponseValue = this.ResponseValue
            };
        }
    }
}
