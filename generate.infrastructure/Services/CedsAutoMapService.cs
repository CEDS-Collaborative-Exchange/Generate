using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using generate.core.Dtos.App;
using generate.core.Interfaces.Services;
using generate.core.Models.App;

namespace generate.infrastructure.Services
{
    /// <summary>
    /// Deterministic, offline CEDS automapping engine (CIID-9032, epic CIID-9029).
    /// Ports the CEDS Copilot auto-mapper's behavior (embedding cosine similarity, threshold, top-N,
    /// two-tier option set matching) to a lexical scoring model:
    ///   confidence = 0.45 * name token similarity + 0.25 * name trigram similarity + 0.30 * definition token similarity
    /// (name-only weights are used when either definition is missing). Exact normalized name matches
    /// are floored at 0.95, and exact name + definition matches score 1.0.
    /// </summary>
    public class CedsAutoMapService : ICedsAutoMapService
    {
        private static readonly HashSet<string> _stopWords = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
        {
            "a", "an", "and", "as", "at", "by", "for", "from", "in", "is", "of", "on", "or", "that",
            "the", "to", "which", "with"
        };

        public List<CedsElementMatchDto> MatchElement(
            string sourceElementName,
            string sourceElementDefinition,
            IEnumerable<CedsElementCatalogDto> catalog,
            int topN = 5,
            decimal threshold = 0.2m)
        {
            var matches = new List<CedsElementMatchDto>();

            if (string.IsNullOrWhiteSpace(sourceElementName) || catalog == null)
            {
                return matches;
            }

            string normalizedSourceName = Normalize(sourceElementName);
            var sourceNameTokens = Tokenize(sourceElementName);
            var sourceNameTrigrams = Trigrams(normalizedSourceName);
            var sourceDefinitionTokens = Tokenize(sourceElementDefinition);

            foreach (var cedsElement in catalog)
            {
                if (cedsElement == null || string.IsNullOrWhiteSpace(cedsElement.CedsElementName))
                {
                    continue;
                }

                decimal confidence = ScoreElement(
                    normalizedSourceName, sourceNameTokens, sourceNameTrigrams, sourceDefinitionTokens,
                    cedsElement.CedsElementName, cedsElement.CedsElementDefinition);

                if (confidence >= threshold)
                {
                    matches.Add(new CedsElementMatchDto
                    {
                        CedsElementGlobalId = cedsElement.CedsElementGlobalId,
                        CedsElementName = cedsElement.CedsElementName,
                        CedsElementDefinition = cedsElement.CedsElementDefinition,
                        CedsPath = cedsElement.CedsPath,
                        CedsDataModelId = cedsElement.CedsDataModelId,
                        HasOptionSet = cedsElement.HasOptionSet,
                        StagingTableColumns = cedsElement.StagingTableColumns,
                        Confidence = confidence
                    });
                }
            }

            return matches
                .OrderByDescending(m => m.Confidence)
                .ThenBy(m => m.CedsElementName, StringComparer.OrdinalIgnoreCase)
                .ThenBy(m => m.CedsElementGlobalId, StringComparer.OrdinalIgnoreCase)
                .Take(topN)
                .ToList();
        }

        public List<CedsOptionSetMatchDto> MatchOptionSetValue(
            string sourceOptionSetCode,
            string sourceOptionSetDescription,
            IEnumerable<CedsOptionSetValueDto> optionSetValues,
            int topN = 5,
            decimal threshold = 0.2m)
        {
            var matches = new List<CedsOptionSetMatchDto>();

            if (optionSetValues == null ||
                (string.IsNullOrWhiteSpace(sourceOptionSetCode) && string.IsNullOrWhiteSpace(sourceOptionSetDescription)))
            {
                return matches;
            }

            string normalizedSourceCode = Normalize(sourceOptionSetCode);
            string normalizedSourceDescription = Normalize(sourceOptionSetDescription);
            string combinedSource = ((sourceOptionSetCode ?? "") + " " + (sourceOptionSetDescription ?? "")).Trim();
            var sourceTokens = Tokenize(combinedSource);
            var sourceTrigrams = Trigrams(Normalize(combinedSource));

            foreach (var optionSetValue in optionSetValues)
            {
                if (optionSetValue == null ||
                    (string.IsNullOrWhiteSpace(optionSetValue.CedsOptionSetCode) && string.IsNullOrWhiteSpace(optionSetValue.CedsOptionSetDescription)))
                {
                    continue;
                }

                string normalizedCedsCode = Normalize(optionSetValue.CedsOptionSetCode);
                string normalizedCedsDescription = Normalize(optionSetValue.CedsOptionSetDescription);

                // Tier 1: case-insensitive exact code or description match
                bool exactMatch =
                    (normalizedSourceCode.Length > 0 && (normalizedSourceCode == normalizedCedsCode || normalizedSourceCode == normalizedCedsDescription)) ||
                    (normalizedSourceDescription.Length > 0 && (normalizedSourceDescription == normalizedCedsCode || normalizedSourceDescription == normalizedCedsDescription));

                if (exactMatch)
                {
                    matches.Add(new CedsOptionSetMatchDto
                    {
                        CedsOptionSetCode = optionSetValue.CedsOptionSetCode,
                        CedsOptionSetDescription = optionSetValue.CedsOptionSetDescription,
                        Confidence = 1.0m,
                        MatchType = EtlMatchType.ExactCode
                    });
                    continue;
                }

                // Tier 2: lexical similarity of the combined code + description strings
                string combinedCeds = ((optionSetValue.CedsOptionSetCode ?? "") + " " + (optionSetValue.CedsOptionSetDescription ?? "")).Trim();
                var cedsTokens = Tokenize(combinedCeds);
                var cedsTrigrams = Trigrams(Normalize(combinedCeds));

                decimal confidence = Round(
                    0.6m * DiceCoefficient(sourceTokens, cedsTokens) +
                    0.4m * DiceCoefficient(sourceTrigrams, cedsTrigrams));

                if (confidence >= threshold)
                {
                    matches.Add(new CedsOptionSetMatchDto
                    {
                        CedsOptionSetCode = optionSetValue.CedsOptionSetCode,
                        CedsOptionSetDescription = optionSetValue.CedsOptionSetDescription,
                        Confidence = confidence,
                        MatchType = EtlMatchType.Semantic
                    });
                }
            }

            return matches
                .OrderByDescending(m => m.MatchType == EtlMatchType.ExactCode ? 1 : 0)
                .ThenByDescending(m => m.Confidence)
                .ThenBy(m => m.CedsOptionSetCode, StringComparer.OrdinalIgnoreCase)
                .Take(topN)
                .ToList();
        }

        private decimal ScoreElement(
            string normalizedSourceName,
            HashSet<string> sourceNameTokens,
            HashSet<string> sourceNameTrigrams,
            HashSet<string> sourceDefinitionTokens,
            string cedsName,
            string cedsDefinition)
        {
            string normalizedCedsName = Normalize(cedsName);

            var cedsNameTokens = Tokenize(cedsName);
            var cedsNameTrigrams = Trigrams(normalizedCedsName);
            var cedsDefinitionTokens = Tokenize(cedsDefinition);

            decimal nameTokenScore = DiceCoefficient(sourceNameTokens, cedsNameTokens);
            decimal nameTrigramScore = DiceCoefficient(sourceNameTrigrams, cedsNameTrigrams);

            decimal confidence;
            if (sourceDefinitionTokens.Count == 0 || cedsDefinitionTokens.Count == 0)
            {
                confidence = 0.6m * nameTokenScore + 0.4m * nameTrigramScore;
            }
            else
            {
                decimal definitionScore = DiceCoefficient(sourceDefinitionTokens, cedsDefinitionTokens);
                confidence = 0.45m * nameTokenScore + 0.25m * nameTrigramScore + 0.30m * definitionScore;
            }

            if (normalizedSourceName.Length > 0 && normalizedSourceName == normalizedCedsName)
            {
                decimal definitionScoreForExact = DiceCoefficient(sourceDefinitionTokens, cedsDefinitionTokens);
                confidence = definitionScoreForExact >= 0.999m ? 1.0m : Math.Max(confidence, 0.95m);
            }

            return Round(confidence);
        }

        /// <summary>
        /// Dice coefficient over string sets (tokens or trigrams): 2 * |intersection| / (|a| + |b|).
        /// </summary>
        private static decimal DiceCoefficient(HashSet<string> a, HashSet<string> b)
        {
            if (a == null || b == null || a.Count == 0 || b.Count == 0)
            {
                return 0m;
            }

            int intersection = a.Count(t => b.Contains(t));
            return (2.0m * intersection) / (a.Count + b.Count);
        }

        /// <summary>
        /// Lowercases, splits camelCase boundaries, strips punctuation, and removes stop words.
        /// </summary>
        private static HashSet<string> Tokenize(string text)
        {
            var tokens = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

            if (string.IsNullOrWhiteSpace(text))
            {
                return tokens;
            }

            foreach (string rawToken in SplitCamelCase(text)
                .Split(new[] { ' ', '\t', '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries))
            {
                string token = new string(rawToken.Where(char.IsLetterOrDigit).ToArray()).ToLowerInvariant();

                if (token.Length > 0 && !_stopWords.Contains(token))
                {
                    tokens.Add(token);
                }
            }

            return tokens;
        }

        /// <summary>
        /// Lowercased alphanumeric-only form of the text (camelCase boundaries become spaces first,
        /// then all whitespace is removed) used for exact comparison and trigram extraction.
        /// </summary>
        private static string Normalize(string text)
        {
            if (string.IsNullOrWhiteSpace(text))
            {
                return string.Empty;
            }

            return new string(SplitCamelCase(text)
                .ToLowerInvariant()
                .Where(char.IsLetterOrDigit)
                .ToArray());
        }

        private static HashSet<string> Trigrams(string normalizedText)
        {
            var trigrams = new HashSet<string>(StringComparer.Ordinal);

            if (string.IsNullOrEmpty(normalizedText))
            {
                return trigrams;
            }

            if (normalizedText.Length <= 3)
            {
                trigrams.Add(normalizedText);
                return trigrams;
            }

            for (int i = 0; i <= normalizedText.Length - 3; i++)
            {
                trigrams.Add(normalizedText.Substring(i, 3));
            }

            return trigrams;
        }

        /// <summary>
        /// Inserts spaces at lowercase-to-uppercase and letter-to-digit boundaries so technical names
        /// like "StuGradeLvl" or "GradeLevel1" tokenize into words.
        /// </summary>
        private static string SplitCamelCase(string text)
        {
            var builder = new StringBuilder(text.Length + 8);

            for (int i = 0; i < text.Length; i++)
            {
                char current = text[i];

                if (i > 0)
                {
                    char previous = text[i - 1];

                    bool boundary =
                        (char.IsLower(previous) && char.IsUpper(current)) ||
                        (char.IsLetter(previous) && char.IsDigit(current)) ||
                        (char.IsDigit(previous) && char.IsLetter(current));

                    if (boundary)
                    {
                        builder.Append(' ');
                    }
                }

                builder.Append(current);
            }

            return builder.ToString();
        }

        private static decimal Round(decimal value)
        {
            decimal rounded = Math.Round(value, 4, MidpointRounding.AwayFromZero);
            return rounded > 1.0m ? 1.0m : (rounded < 0m ? 0m : rounded);
        }
    }
}
