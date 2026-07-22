using generate.infrastructure.Services;
using Microsoft.Extensions.Configuration;
using Moq;
using System;
using System.IO;
using System.Linq;
using Xunit;

namespace generate.test.Infrastructure.Services
{
    /// <summary>
    /// Tests for the CEDS Ontology RDF loader (CIID-9057). They run against the ontology shipped in
    /// generate.web/CedsOntology; when that file is not present the tests pass trivially.
    /// </summary>
    public class CedsOntologyProviderShould
    {
        private static readonly string RdfPath =
            Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "..", "generate.web", "CedsOntology", "CEDS-Ontology.rdf"));

        private static CedsOntologyProvider BuildProvider()
        {
            var configuration = new Mock<IConfiguration>();
            configuration.Setup(c => c["CedsAutoMap:OntologyRdfPath"]).Returns(RdfPath);
            return new CedsOntologyProvider(configuration.Object);
        }

        private static bool Available() => File.Exists(RdfPath);

        [Fact]
        public void LoadClassAndPropertyVariantsForAGlobalId()
        {
            if (!Available())
            {
                return;
            }

            var provider = BuildProvider();
            var elements = provider.GetElements("000021");

            // Both the class (concept) and the "Has..." property share GlobalId 000021
            Assert.Contains(elements, e => e.IsClass && e.Label == "Assessment Academic Subject");
            Assert.Contains(elements, e => !e.IsClass && e.Label.StartsWith("Has "));
        }

        [Fact]
        public void ResolveElementByStagingLabelPreferringTheConcept()
        {
            if (!Available())
            {
                return;
            }

            var provider = BuildProvider();
            var resolved = provider.ResolveElement("000021", "Assessment Academic Subject");

            Assert.NotNull(resolved);
            Assert.Equal("Assessment Academic Subject", resolved.Label);
            Assert.True(resolved.IsClass);
            Assert.False(string.IsNullOrWhiteSpace(resolved.Definition));
        }

        [Fact]
        public void ExposeOptionSetValuesForAConceptScheme()
        {
            if (!Available())
            {
                return;
            }

            var provider = BuildProvider();

            Assert.True(provider.HasOptionSet("000021"));

            var values = provider.GetOptionValues("000021");
            Assert.NotEmpty(values);
            Assert.All(values, v => Assert.False(string.IsNullOrWhiteSpace(v.Label)));
            Assert.All(values, v => Assert.Equal("000021", v.SchemeGlobalId));
        }

        [Fact]
        public void ReturnEmptyForUnknownGlobalId()
        {
            if (!Available())
            {
                return;
            }

            var provider = BuildProvider();
            Assert.Empty(provider.GetElements("999999"));
            Assert.Empty(provider.GetOptionValues("999999"));
            Assert.False(provider.HasOptionSet("999999"));
        }
    }
}
