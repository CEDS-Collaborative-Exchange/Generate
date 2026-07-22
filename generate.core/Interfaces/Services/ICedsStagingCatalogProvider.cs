using System.Collections.Generic;
using generate.core.Dtos.App;

namespace generate.core.Interfaces.Services
{
    /// <summary>
    /// Supplies the CEDS automapping catalog built from the CEDS Ontology intersected with the
    /// warehouse Staging schema (CIID-9057, epic CIID-9029).
    /// </summary>
    public interface ICedsStagingCatalogProvider
    {
        /// <summary>True when both the ontology RDF and the Staging CEDS view are available.</summary>
        bool IsAvailable { get; }

        /// <summary>The Staging-filtered CEDS element catalog (the direct-match corpus).</summary>
        List<CedsElementCatalogDto> GetElementCatalog();

        /// <summary>
        /// Option-set-value fallback corpus: one entry per option set value of a Staging option set
        /// class. Name/Definition are the value's text; CedsElementGlobalId is the option set class.
        /// </summary>
        List<CedsElementCatalogDto> GetOptionValueFallbackCatalog();

        /// <summary>The catalog element for a CEDS GlobalId, or null if not in Staging.</summary>
        CedsElementCatalogDto GetElementByGlobalId(string globalId);

        /// <summary>CEDS option set values for one element, from the ontology.</summary>
        List<CedsOptionSetValueDto> GetOptionSetValues(string globalId);
    }
}
