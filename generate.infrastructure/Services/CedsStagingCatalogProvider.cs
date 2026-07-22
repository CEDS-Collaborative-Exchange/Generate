using System;
using System.Collections.Generic;
using System.Linq;
using generate.core.Dtos.App;
using generate.core.Interfaces.Services;

namespace generate.infrastructure.Services
{
    /// <summary>
    /// Builds the CEDS automapping catalog (CIID-9057, epic CIID-9029) by intersecting the CEDS
    /// Ontology with the warehouse Staging schema: only CEDS elements referenced by Staging columns
    /// are mappable (so every mapping is loadable into the warehouse), each carrying its ontology
    /// "Label - Definition" and the Staging table + column(s) it lands in.
    ///
    /// Also exposes the option-set-value fallback corpus: the option set values (named individuals)
    /// of the option set classes that appear in Staging, used when an element has no confident direct
    /// match. Singleton; derived data is cached for the application lifetime.
    /// </summary>
    public class CedsStagingCatalogProvider : ICedsStagingCatalogProvider
    {
        private readonly CedsOntologyProvider _ontology;
        private readonly StagingCedsColumnProvider _staging;
        private readonly Lazy<CatalogData> _data;

        public CedsStagingCatalogProvider(CedsOntologyProvider ontology, StagingCedsColumnProvider staging)
        {
            _ontology = ontology;
            _staging = staging;
            _data = new Lazy<CatalogData>(Build);
        }

        public virtual bool IsAvailable => _ontology.IsAvailable && _staging.IsAvailable;

        /// <summary>The Staging-filtered CEDS element catalog (the direct-match corpus).</summary>
        public virtual List<CedsElementCatalogDto> GetElementCatalog()
        {
            return _data.Value.ElementCatalog;
        }

        /// <summary>
        /// Fallback corpus: one entry per option set value of a Staging option set class. Name and
        /// Definition are the value's text (what we match against); CedsElementGlobalId is the option
        /// set class (what a matched source element maps to).
        /// </summary>
        public virtual List<CedsElementCatalogDto> GetOptionValueFallbackCatalog()
        {
            return _data.Value.FallbackCatalog;
        }

        public virtual CedsElementCatalogDto GetElementByGlobalId(string globalId)
        {
            if (string.IsNullOrWhiteSpace(globalId))
            {
                return null;
            }

            return _data.Value.ByGlobalId.TryGetValue(globalId.Trim(), out var element) ? element : null;
        }

        /// <summary>CEDS option set values for one element, from the ontology.</summary>
        public virtual List<CedsOptionSetValueDto> GetOptionSetValues(string globalId)
        {
            return _ontology.GetOptionValues(globalId)
                .Select(v => new CedsOptionSetValueDto
                {
                    CedsOptionSetCode = v.Notation,
                    CedsOptionSetDescription = v.Label
                })
                .GroupBy(v => (v.CedsOptionSetCode ?? "") + "|" + (v.CedsOptionSetDescription ?? ""))
                .Select(g => g.First())
                .OrderBy(v => v.CedsOptionSetCode, StringComparer.OrdinalIgnoreCase)
                .ToList();
        }

        private CatalogData Build()
        {
            var elementCatalog = new List<CedsElementCatalogDto>();
            var byGlobalId = new Dictionary<string, CedsElementCatalogDto>(StringComparer.OrdinalIgnoreCase);
            var fallbackCatalog = new List<CedsElementCatalogDto>();

            if (!IsAvailable)
            {
                return new CatalogData(elementCatalog, fallbackCatalog, byGlobalId);
            }

            // Group Staging columns by CEDS GlobalId: one CEDS element maps to many Staging columns.
            var stagingGroups = _staging.GetColumns()
                .Where(c => !string.IsNullOrWhiteSpace(c.CedsGlobalId))
                .GroupBy(c => c.CedsGlobalId.Trim(), StringComparer.OrdinalIgnoreCase);

            foreach (var group in stagingGroups)
            {
                string globalId = group.Key;
                string stagingLabel = group.Select(c => c.CedsElement).FirstOrDefault(l => !string.IsNullOrWhiteSpace(l));

                var ontologyElement = _ontology.ResolveElement(globalId, stagingLabel);

                var tableColumns = group
                    .Where(c => !string.IsNullOrWhiteSpace(c.TableName))
                    .Select(c => c.TableName + (string.IsNullOrWhiteSpace(c.ColumnName) ? "" : "." + c.ColumnName))
                    .Distinct(StringComparer.OrdinalIgnoreCase)
                    .OrderBy(tc => tc, StringComparer.OrdinalIgnoreCase)
                    .ToList();

                var catalogEntry = new CedsElementCatalogDto
                {
                    CedsElementGlobalId = globalId,
                    CedsElementName = ontologyElement?.Label ?? stagingLabel,
                    CedsElementDefinition = ontologyElement?.Definition,
                    HasOptionSet = _ontology.HasOptionSet(globalId) || (ontologyElement?.IsConceptScheme ?? false),
                    StagingTableColumns = tableColumns
                };

                if (string.IsNullOrWhiteSpace(catalogEntry.CedsElementName))
                {
                    continue;
                }

                elementCatalog.Add(catalogEntry);
                byGlobalId[globalId] = catalogEntry;
            }

            // Fallback corpus: option set values of the option set classes present in Staging
            foreach (var element in elementCatalog.Where(e => e.HasOptionSet))
            {
                foreach (var value in _ontology.GetOptionValues(element.CedsElementGlobalId))
                {
                    fallbackCatalog.Add(new CedsElementCatalogDto
                    {
                        CedsElementGlobalId = element.CedsElementGlobalId,
                        CedsElementName = value.Label,
                        CedsElementDefinition = value.Definition,
                        HasOptionSet = true,
                        StagingTableColumns = element.StagingTableColumns
                    });
                }
            }

            return new CatalogData(elementCatalog, fallbackCatalog, byGlobalId);
        }

        private sealed class CatalogData
        {
            public CatalogData(
                List<CedsElementCatalogDto> elementCatalog,
                List<CedsElementCatalogDto> fallbackCatalog,
                Dictionary<string, CedsElementCatalogDto> byGlobalId)
            {
                ElementCatalog = elementCatalog;
                FallbackCatalog = fallbackCatalog;
                ByGlobalId = byGlobalId;
            }

            public List<CedsElementCatalogDto> ElementCatalog { get; }
            public List<CedsElementCatalogDto> FallbackCatalog { get; }
            public Dictionary<string, CedsElementCatalogDto> ByGlobalId { get; }
        }
    }
}
