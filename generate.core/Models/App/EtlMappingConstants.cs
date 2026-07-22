namespace generate.core.Models.App
{
    /// <summary>
    /// Mapping status values for App.EtlSourceElementMapping / App.EtlSourceOptionSetMapping rows.
    /// </summary>
    public static class EtlMappingStatus
    {
        public const string Unmapped = "Unmapped";
        public const string Suggested = "Suggested";
        public const string Accepted = "Accepted";
        public const string Rejected = "Rejected";
        public const string NotInCeds = "NotInCeds";
    }

    /// <summary>
    /// Match type values describing how a CEDS mapping was determined.
    /// </summary>
    public static class EtlMatchType
    {
        public const string Suggested = "Suggested";
        public const string ExactCode = "ExactCode";
        public const string Semantic = "Semantic";
        public const string Manual = "Manual";
        /// <summary>Element mapped to an option set class because an option set value matched.</summary>
        public const string OptionSetValue = "OptionSetValue";
    }
}
