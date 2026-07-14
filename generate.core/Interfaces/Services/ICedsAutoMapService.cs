using System.Collections.Generic;
using generate.core.Dtos.App;

namespace generate.core.Interfaces.Services
{
    /// <summary>
    /// Deterministic CEDS automapping engine (inspired by the CEDS Copilot auto-mapper).
    /// Matches a source data dictionary element (name + definition) against the CEDS element catalog
    /// and a source option set value against a CEDS element's option set values.
    /// Pure/in-memory: callers supply the catalog, so the engine is unit-testable and offline.
    /// </summary>
    public interface ICedsAutoMapService
    {
        /// <summary>
        /// Scores a source element against the CEDS element catalog and returns the top candidates
        /// (confidence descending) whose confidence is at or above <paramref name="threshold"/>.
        /// </summary>
        List<CedsElementMatchDto> MatchElement(
            string sourceElementName,
            string sourceElementDefinition,
            IEnumerable<CedsElementCatalogDto> catalog,
            int topN = 5,
            decimal threshold = 0.2m);

        /// <summary>
        /// Scores a source option set value against a CEDS element's option set values using two tiers:
        /// Tier 1 - case-insensitive exact code/description match (confidence 1.0, MatchType ExactCode);
        /// Tier 2 - lexical similarity (MatchType Semantic). Exact matches sort first.
        /// </summary>
        List<CedsOptionSetMatchDto> MatchOptionSetValue(
            string sourceOptionSetCode,
            string sourceOptionSetDescription,
            IEnumerable<CedsOptionSetValueDto> optionSetValues,
            int topN = 5,
            decimal threshold = 0.2m);
    }
}
