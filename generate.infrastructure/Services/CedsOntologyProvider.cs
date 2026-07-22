using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Xml.Linq;
using Microsoft.Extensions.Configuration;

namespace generate.infrastructure.Services
{
    /// <summary>One CEDS element from the ontology: a class (C######) or property (P######).</summary>
    public class CedsOntologyElement
    {
        public string Identifier { get; set; }   // e.g. C000021 / P000021
        public string GlobalId { get; set; }      // numeric part, e.g. 000021 (matches Staging CEDS_GlobalId)
        public bool IsClass { get; set; }
        public bool IsConceptScheme { get; set; }  // an option set class
        public string Label { get; set; }
        public string Definition { get; set; }
    }

    /// <summary>One CEDS option set value (owl:NamedIndividual) and the scheme it belongs to.</summary>
    public class CedsOntologyOptionValue
    {
        public string Identifier { get; set; }        // NI############
        public string Label { get; set; }
        public string Definition { get; set; }
        public string Notation { get; set; }           // the option set code
        public string SchemeGlobalId { get; set; }     // numeric GlobalId of the skos:inScheme class
    }

    /// <summary>
    /// Loads the CEDS Ontology RDF/XML (CIID-9057, epic CIID-9029) into in-memory lookups so the
    /// automapper can source CEDS elements ("Label - Definition") and option set values from the
    /// canonical ontology rather than the CSV/EtlMetadata. Registered as a singleton: the 20 MB file
    /// is parsed once on first use and the XML DOM is released, keeping only the extracted objects.
    ///
    /// Configured by CedsAutoMap:OntologyRdfPath; defaults to CedsOntology/CEDS-Ontology.rdf beside
    /// the application binaries. When the file is absent, IsAvailable is false.
    /// </summary>
    public class CedsOntologyProvider
    {
        private static readonly XNamespace Rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns#";
        private static readonly XNamespace Rdfs = "http://www.w3.org/2000/01/rdf-schema#";
        private static readonly XNamespace Skos = "http://www.w3.org/2004/02/skos/core#";
        private const string ConceptSchemeType = "http://www.w3.org/2004/02/skos/core#ConceptScheme";
        private const string TermsBase = "https://w3id.org/CEDStandards/terms/";

        private readonly string _rdfPath;
        private readonly Lazy<OntologyData> _data;

        public CedsOntologyProvider(IConfiguration configuration)
        {
            _rdfPath = configuration["CedsAutoMap:OntologyRdfPath"];

            if (string.IsNullOrWhiteSpace(_rdfPath))
            {
                _rdfPath = Path.Combine(AppContext.BaseDirectory, "CedsOntology", "CEDS-Ontology.rdf");
            }

            _data = new Lazy<OntologyData>(Load);
        }

        public virtual bool IsAvailable => !string.IsNullOrWhiteSpace(_rdfPath) && File.Exists(_rdfPath);

        /// <summary>CEDS elements (class and/or property variants) for one numeric GlobalId.</summary>
        public virtual IReadOnlyList<CedsOntologyElement> GetElements(string globalId)
        {
            if (string.IsNullOrWhiteSpace(globalId))
            {
                return Array.Empty<CedsOntologyElement>();
            }

            return _data.Value.ElementsByGlobalId.TryGetValue(globalId.Trim(), out var elements)
                ? elements
                : Array.Empty<CedsOntologyElement>();
        }

        /// <summary>
        /// The best ontology element for a Staging GlobalId: prefers the entity whose label matches
        /// the Staging CEDS_Element label, then a class (concept), then a property.
        /// </summary>
        public virtual CedsOntologyElement ResolveElement(string globalId, string preferredLabel)
        {
            var elements = GetElements(globalId);

            if (elements.Count == 0)
            {
                return null;
            }

            if (!string.IsNullOrWhiteSpace(preferredLabel))
            {
                var labelMatch = elements.FirstOrDefault(e =>
                    string.Equals(e.Label, preferredLabel.Trim(), StringComparison.OrdinalIgnoreCase));

                if (labelMatch != null)
                {
                    return labelMatch;
                }
            }

            return elements.FirstOrDefault(e => e.IsClass) ?? elements[0];
        }

        /// <summary>Option set values for a scheme (numeric GlobalId of the option set class).</summary>
        public virtual IReadOnlyList<CedsOntologyOptionValue> GetOptionValues(string schemeGlobalId)
        {
            if (string.IsNullOrWhiteSpace(schemeGlobalId))
            {
                return Array.Empty<CedsOntologyOptionValue>();
            }

            return _data.Value.OptionValuesByScheme.TryGetValue(schemeGlobalId.Trim(), out var values)
                ? values
                : Array.Empty<CedsOntologyOptionValue>();
        }

        public virtual bool HasOptionSet(string schemeGlobalId)
        {
            return !string.IsNullOrWhiteSpace(schemeGlobalId) &&
                   _data.Value.OptionValuesByScheme.ContainsKey(schemeGlobalId.Trim());
        }

        private OntologyData Load()
        {
            var elementsByGlobalId = new Dictionary<string, List<CedsOntologyElement>>(StringComparer.OrdinalIgnoreCase);
            var optionValuesByScheme = new Dictionary<string, List<CedsOntologyOptionValue>>(StringComparer.OrdinalIgnoreCase);

            if (!IsAvailable)
            {
                return new OntologyData(elementsByGlobalId, optionValuesByScheme);
            }

            var doc = XDocument.Load(_rdfPath);

            foreach (var entity in doc.Root.Elements())
            {
                string about = (string)entity.Attribute(Rdf + "about");

                if (about == null || !about.StartsWith(TermsBase, StringComparison.Ordinal))
                {
                    continue;
                }

                string token = about.Substring(TermsBase.Length);

                if (token.Length < 2)
                {
                    continue;
                }

                string label = (string)entity.Element(Rdfs + "label") ?? (string)entity.Element(Skos + "prefLabel");
                string definition = (string)entity.Element(Skos + "definition") ?? (string)entity.Element(Rdfs + "comment");

                if (token[0] == 'N' && token[1] == 'I')
                {
                    string schemeResource = (string)entity.Element(Skos + "inScheme")?.Attribute(Rdf + "resource");
                    string schemeGlobalId = ToGlobalId(schemeResource);

                    if (schemeGlobalId == null || string.IsNullOrWhiteSpace(label))
                    {
                        continue;
                    }

                    if (!optionValuesByScheme.TryGetValue(schemeGlobalId, out var values))
                    {
                        values = new List<CedsOntologyOptionValue>();
                        optionValuesByScheme[schemeGlobalId] = values;
                    }

                    values.Add(new CedsOntologyOptionValue
                    {
                        Identifier = token,
                        Label = label,
                        Definition = definition,
                        Notation = (string)entity.Element(Skos + "notation"),
                        SchemeGlobalId = schemeGlobalId
                    });
                }
                else if ((token[0] == 'C' || token[0] == 'P') && char.IsDigit(token[1]))
                {
                    string globalId = token.Substring(1);

                    if (string.IsNullOrWhiteSpace(label))
                    {
                        continue;
                    }

                    bool isConceptScheme = entity.Elements(Rdf + "type")
                        .Any(t => (string)t.Attribute(Rdf + "resource") == ConceptSchemeType);

                    if (!elementsByGlobalId.TryGetValue(globalId, out var elements))
                    {
                        elements = new List<CedsOntologyElement>();
                        elementsByGlobalId[globalId] = elements;
                    }

                    elements.Add(new CedsOntologyElement
                    {
                        Identifier = token,
                        GlobalId = globalId,
                        IsClass = token[0] == 'C',
                        IsConceptScheme = isConceptScheme,
                        Label = label,
                        Definition = definition
                    });
                }
            }

            return new OntologyData(elementsByGlobalId, optionValuesByScheme);
        }

        /// <summary>Extracts the numeric GlobalId from a ".../C000361" style resource URI.</summary>
        private static string ToGlobalId(string resource)
        {
            if (string.IsNullOrWhiteSpace(resource) || !resource.StartsWith(TermsBase, StringComparison.Ordinal))
            {
                return null;
            }

            string token = resource.Substring(TermsBase.Length);

            return token.Length >= 2 && (token[0] == 'C' || token[0] == 'P') && char.IsDigit(token[1])
                ? token.Substring(1)
                : null;
        }

        private sealed class OntologyData
        {
            public OntologyData(
                Dictionary<string, List<CedsOntologyElement>> elementsByGlobalId,
                Dictionary<string, List<CedsOntologyOptionValue>> optionValuesByScheme)
            {
                ElementsByGlobalId = elementsByGlobalId;
                OptionValuesByScheme = optionValuesByScheme;
            }

            public Dictionary<string, List<CedsOntologyElement>> ElementsByGlobalId { get; }
            public Dictionary<string, List<CedsOntologyOptionValue>> OptionValuesByScheme { get; }
        }
    }
}
