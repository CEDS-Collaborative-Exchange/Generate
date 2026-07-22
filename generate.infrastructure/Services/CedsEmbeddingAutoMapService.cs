using System;
using System.Collections.Generic;
using System.Linq;
using generate.core.Dtos.App;
using generate.core.Interfaces.Services;
using generate.core.Models.App;

namespace generate.infrastructure.Services
{
    /// <summary>
    /// CEDS automapping engine backed by the fine-tuned CEDS Copilot sentence-embedding model
    /// (epic CIID-9029). Sentences are formatted "Name: Definition" exactly as the model was
    /// fine-tuned on, embedded via <see cref="CedsEmbeddingModelProvider"/>, and scored by cosine
    /// similarity - the same approach as the CEDS Copilot auto-mapper. Option set value matching is
    /// two-tier: exact code/description match first (confidence 1.0), then embedding similarity.
    /// </summary>
    public class CedsEmbeddingAutoMapService : ICedsAutoMapService
    {
        private readonly CedsEmbeddingModelProvider _model;

        public CedsEmbeddingAutoMapService(CedsEmbeddingModelProvider model)
        {
            _model = model;
        }

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

            var candidates = catalog
                .Where(c => c != null && !string.IsNullOrWhiteSpace(c.CedsElementName))
                .ToList();

            if (candidates.Count == 0)
            {
                return matches;
            }

            // "Name: Definition" mirrors the sentence format the model was fine-tuned on
            float[] queryEmbedding = _model.Embed(BuildSentence(sourceElementName, sourceElementDefinition));
            var candidateEmbeddings = _model.EmbedBatch(
                candidates.Select(c => BuildSentence(c.CedsElementName, c.CedsElementDefinition)).ToList());

            for (int i = 0; i < candidates.Count; i++)
            {
                decimal confidence = CedsEmbeddingModelProvider.CosineSimilarity(queryEmbedding, candidateEmbeddings[i]);

                if (confidence >= threshold)
                {
                    var candidate = candidates[i];

                    matches.Add(new CedsElementMatchDto
                    {
                        CedsElementGlobalId = candidate.CedsElementGlobalId,
                        CedsElementName = candidate.CedsElementName,
                        CedsElementDefinition = candidate.CedsElementDefinition,
                        CedsPath = candidate.CedsPath,
                        CedsDataModelId = candidate.CedsDataModelId,
                        HasOptionSet = candidate.HasOptionSet,
                        StagingTableColumns = candidate.StagingTableColumns,
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

            var candidates = optionSetValues
                .Where(v => v != null &&
                    (!string.IsNullOrWhiteSpace(v.CedsOptionSetCode) || !string.IsNullOrWhiteSpace(v.CedsOptionSetDescription)))
                .ToList();

            if (candidates.Count == 0)
            {
                return matches;
            }

            var semanticCandidates = new List<CedsOptionSetValueDto>();

            foreach (var optionSetValue in candidates)
            {
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
                }
                else
                {
                    semanticCandidates.Add(optionSetValue);
                }
            }

            // Tier 2: embedding similarity of the combined code + description strings
            if (semanticCandidates.Count > 0)
            {
                float[] queryEmbedding = _model.Embed(combinedSource);
                var candidateEmbeddings = _model.EmbedBatch(semanticCandidates
                    .Select(v => ((v.CedsOptionSetCode ?? "") + " " + (v.CedsOptionSetDescription ?? "")).Trim())
                    .ToList());

                for (int i = 0; i < semanticCandidates.Count; i++)
                {
                    decimal confidence = CedsEmbeddingModelProvider.CosineSimilarity(queryEmbedding, candidateEmbeddings[i]);

                    if (confidence >= threshold)
                    {
                        matches.Add(new CedsOptionSetMatchDto
                        {
                            CedsOptionSetCode = semanticCandidates[i].CedsOptionSetCode,
                            CedsOptionSetDescription = semanticCandidates[i].CedsOptionSetDescription,
                            Confidence = confidence,
                            MatchType = EtlMatchType.Semantic
                        });
                    }
                }
            }

            return matches
                .OrderByDescending(m => m.MatchType == EtlMatchType.ExactCode ? 1 : 0)
                .ThenByDescending(m => m.Confidence)
                .ThenBy(m => m.CedsOptionSetCode, StringComparer.OrdinalIgnoreCase)
                .Take(topN)
                .ToList();
        }

        private static string BuildSentence(string name, string definition)
        {
            // "Label - Definition" format (CIID-9057), applied consistently to source and catalog
            return string.IsNullOrWhiteSpace(definition)
                ? (name ?? "").Trim()
                : (name ?? "").Trim() + " - " + definition.Trim();
        }

        private static string Normalize(string text)
        {
            if (string.IsNullOrWhiteSpace(text))
            {
                return string.Empty;
            }

            return new string(text.ToLowerInvariant().Where(char.IsLetterOrDigit).ToArray());
        }
    }
}
