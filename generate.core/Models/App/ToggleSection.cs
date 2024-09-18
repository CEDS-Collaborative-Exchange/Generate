using System;
using System.Collections;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class ToggleSection
    {
        public int ToggleSectionId { get; set; }
        public int ToggleSectionTypeId { get; set; }
        public string EmapsSurveySectionAbbrv { get; set; }
        public string EmapsParentSurveySectionAbbrv { get; set; }
        public string SectionName { get; set; }
        public string SectionTitle { get; set; }
        public int SectionSequence { get; set; }
        public ToggleSectionType ToggleSectionType { get; set; }
    }
}
