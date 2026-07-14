using generate.core.Dtos.App;
using generate.core.Models.App;
using generate.infrastructure.Services;
using System.Collections.Generic;
using System.Linq;
using Xunit;

namespace generate.test.Infrastructure.Services
{
    /// <summary>
    /// Tests for the deterministic CEDS automapping engine (CIID-9032/CIID-9035, epic CIID-9029).
    /// </summary>
    public class CedsAutoMapServiceShould
    {
        private readonly CedsAutoMapService _service = new CedsAutoMapService();

        private static List<CedsElementCatalogDto> BuildElementCatalog()
        {
            return new List<CedsElementCatalogDto>
            {
                new CedsElementCatalogDto
                {
                    CedsElementGlobalId = "000100",
                    CedsElementName = "Entry Grade Level",
                    CedsElementDefinition = "The grade level or primary instructional level at which a student enters and receives services in a school or an educational institution during a given academic session.",
                    CedsPath = "K12 -> K12 Student -> Enrollment",
                    HasOptionSet = true
                },
                new CedsElementCatalogDto
                {
                    CedsElementGlobalId = "000144",
                    CedsElementName = "Hispanic or Latino Ethnicity",
                    CedsElementDefinition = "An indication that the person traces his or her origin or descent to Mexico, Puerto Rico, Cuba, Central and South America, and other Spanish cultures, regardless of race.",
                    CedsPath = "K12 -> K12 Student -> Demographic",
                    HasOptionSet = true
                },
                new CedsElementCatalogDto
                {
                    CedsElementGlobalId = "000933",
                    CedsElementName = "Assessment Family Short Name",
                    CedsElementDefinition = "The abbreviated title of the Assessment Family.",
                    CedsPath = "Assessments -> Assessment",
                    HasOptionSet = false
                }
            };
        }

        private static List<CedsOptionSetValueDto> BuildYesNoOptionSet()
        {
            return new List<CedsOptionSetValueDto>
            {
                new CedsOptionSetValueDto { CedsOptionSetCode = "Yes", CedsOptionSetDescription = "Yes" },
                new CedsOptionSetValueDto { CedsOptionSetCode = "No", CedsOptionSetDescription = "No" }
            };
        }

        private static List<CedsOptionSetValueDto> BuildGradeLevelOptionSet()
        {
            return new List<CedsOptionSetValueDto>
            {
                new CedsOptionSetValueDto { CedsOptionSetCode = "08", CedsOptionSetDescription = "Grade 8" },
                new CedsOptionSetValueDto { CedsOptionSetCode = "09", CedsOptionSetDescription = "Grade 9" },
                new CedsOptionSetValueDto { CedsOptionSetCode = "KG", CedsOptionSetDescription = "Kindergarten" }
            };
        }

        #region MatchElement

        [Fact]
        public void ScoreExactNameAndDefinitionMatchAsFullConfidence()
        {
            var catalog = BuildElementCatalog();

            var matches = _service.MatchElement(
                "Entry Grade Level",
                catalog[0].CedsElementDefinition,
                catalog);

            Assert.NotEmpty(matches);
            Assert.Equal("000100", matches[0].CedsElementGlobalId);
            Assert.Equal(1.0m, matches[0].Confidence);
        }

        [Fact]
        public void ScoreExactNameMatchAtOrAboveNinetyFivePercent()
        {
            var matches = _service.MatchElement(
                "Entry Grade Level",
                "The grade a student is in when they first enroll.",
                BuildElementCatalog());

            Assert.NotEmpty(matches);
            Assert.Equal("000100", matches[0].CedsElementGlobalId);
            Assert.True(matches[0].Confidence >= 0.95m);
        }

        [Fact]
        public void RankSimilarTechnicalNameAboveUnrelatedElements()
        {
            // A bespoke technical name should still match through camelCase splitting + trigrams
            var matches = _service.MatchElement(
                "EntryGradeLvl",
                "Grade level at which the student enters the school.",
                BuildElementCatalog());

            Assert.NotEmpty(matches);
            Assert.Equal("000100", matches[0].CedsElementGlobalId);
        }

        [Fact]
        public void ExcludeUnrelatedElementsBelowThreshold()
        {
            var matches = _service.MatchElement(
                "Bus Route Number",
                "The number of the bus route the student rides.",
                BuildElementCatalog(),
                topN: 5,
                threshold: 0.5m);

            Assert.Empty(matches);
        }

        [Fact]
        public void ReturnEmptyForMissingSourceName()
        {
            Assert.Empty(_service.MatchElement(null, "definition", BuildElementCatalog()));
            Assert.Empty(_service.MatchElement("  ", "definition", BuildElementCatalog()));
        }

        [Fact]
        public void ReturnEmptyForNullCatalog()
        {
            Assert.Empty(_service.MatchElement("Entry Grade Level", "definition", null));
        }

        [Fact]
        public void HandleNullDefinitionsWithNameOnlyScoring()
        {
            var matches = _service.MatchElement("Entry Grade Level", null, BuildElementCatalog());

            Assert.NotEmpty(matches);
            Assert.Equal("000100", matches[0].CedsElementGlobalId);
            Assert.True(matches[0].Confidence >= 0.95m);
        }

        [Fact]
        public void LimitResultsToTopN()
        {
            var matches = _service.MatchElement(
                "Grade Level Assessment Name",
                "A generic phrase overlapping several catalog entries.",
                BuildElementCatalog(),
                topN: 1,
                threshold: 0.01m);

            Assert.Single(matches);
        }

        [Fact]
        public void OrderResultsByConfidenceDescendingDeterministically()
        {
            var matches1 = _service.MatchElement("Grade Level", "Grade level of the student.", BuildElementCatalog(), 5, 0.01m);
            var matches2 = _service.MatchElement("Grade Level", "Grade level of the student.", BuildElementCatalog(), 5, 0.01m);

            Assert.Equal(matches1.Select(m => m.CedsElementGlobalId), matches2.Select(m => m.CedsElementGlobalId));

            for (int i = 1; i < matches1.Count; i++)
            {
                Assert.True(matches1[i - 1].Confidence >= matches1[i].Confidence);
            }
        }

        #endregion

        #region MatchOptionSetValue

        [Fact]
        public void ReturnExactCodeMatchWithFullConfidence()
        {
            var matches = _service.MatchOptionSetValue("Yes", null, BuildYesNoOptionSet());

            Assert.NotEmpty(matches);
            Assert.Equal("Yes", matches[0].CedsOptionSetCode);
            Assert.Equal(1.0m, matches[0].Confidence);
            Assert.Equal(EtlMatchType.ExactCode, matches[0].MatchType);
        }

        [Fact]
        public void MatchExactCodeCaseInsensitively()
        {
            var matches = _service.MatchOptionSetValue("YES", null, BuildYesNoOptionSet());

            Assert.NotEmpty(matches);
            Assert.Equal("Yes", matches[0].CedsOptionSetCode);
            Assert.Equal(EtlMatchType.ExactCode, matches[0].MatchType);
        }

        [Fact]
        public void MatchSourceDescriptionAgainstCedsDescriptionAsExact()
        {
            var matches = _service.MatchOptionSetValue("K", "Kindergarten", BuildGradeLevelOptionSet());

            Assert.NotEmpty(matches);
            Assert.Equal("KG", matches[0].CedsOptionSetCode);
            Assert.Equal(EtlMatchType.ExactCode, matches[0].MatchType);
            Assert.Equal(1.0m, matches[0].Confidence);
        }

        [Fact]
        public void ReturnSemanticMatchesForSimilarDescriptions()
        {
            var matches = _service.MatchOptionSetValue("8", "Eighth Grade 8", BuildGradeLevelOptionSet(), 5, 0.1m);

            Assert.NotEmpty(matches);
            Assert.Equal("08", matches[0].CedsOptionSetCode);
            Assert.Equal(EtlMatchType.Semantic, matches[0].MatchType);
            Assert.True(matches[0].Confidence < 1.0m);
        }

        [Fact]
        public void SortExactMatchesBeforeSemanticMatches()
        {
            var optionSet = new List<CedsOptionSetValueDto>
            {
                new CedsOptionSetValueDto { CedsOptionSetCode = "GradeEight", CedsOptionSetDescription = "Grade Eight Level" },
                new CedsOptionSetValueDto { CedsOptionSetCode = "G8", CedsOptionSetDescription = "G8" }
            };

            var matches = _service.MatchOptionSetValue("G8", "Grade Eight Level Something", optionSet, 5, 0.05m);

            Assert.True(matches.Count >= 1);
            Assert.Equal(EtlMatchType.ExactCode, matches[0].MatchType);
            Assert.Equal("G8", matches[0].CedsOptionSetCode);
        }

        [Fact]
        public void ReturnEmptyWhenSourceValueIsMissing()
        {
            Assert.Empty(_service.MatchOptionSetValue(null, null, BuildYesNoOptionSet()));
            Assert.Empty(_service.MatchOptionSetValue("", "  ", BuildYesNoOptionSet()));
        }

        [Fact]
        public void ReturnEmptyWhenOptionSetIsNullOrEmpty()
        {
            Assert.Empty(_service.MatchOptionSetValue("Yes", "Yes", null));
            Assert.Empty(_service.MatchOptionSetValue("Yes", "Yes", new List<CedsOptionSetValueDto>()));
        }

        #endregion
    }
}
