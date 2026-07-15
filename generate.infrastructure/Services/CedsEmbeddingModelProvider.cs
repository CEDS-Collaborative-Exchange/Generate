using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Microsoft.Extensions.Configuration;
using Microsoft.ML.OnnxRuntime;
using Microsoft.ML.OnnxRuntime.Tensors;
using Microsoft.ML.Tokenizers;

namespace generate.infrastructure.Services
{
    /// <summary>
    /// Hosts the fine-tuned CEDS Copilot sentence-embedding model (epic CIID-9029), exported to ONNX
    /// from C:\Repos\CEDS-Copilot\test\data\CEDS_Copilot_tuned_model.model (all-mpnet-base-v2 fine-tuned
    /// with ContrastiveLoss on labeled source-to-CEDS pairs). The ONNX graph includes mean pooling and
    /// L2 normalization, so cosine similarity between two embeddings is their dot product.
    ///
    /// Registered as a singleton: the inference session is created once and sentence embeddings are
    /// cached for the application lifetime (the CEDS catalog is stable). Configured by:
    ///   CedsAutoMap:OnnxModelPath - path to model.onnx
    ///   CedsAutoMap:VocabPath     - path to the model's WordPiece vocab.txt
    /// When either file is missing, IsAvailable is false and the lexical matcher is used instead.
    /// </summary>
    public class CedsEmbeddingModelProvider
    {
        private const int MaxSequenceLength = 384;
        private const int EncodeBatchSize = 32;

        private readonly string _modelPath;
        private readonly string _vocabPath;
        private readonly Lazy<InferenceSession> _session;
        private readonly Lazy<BertTokenizer> _tokenizer;
        private readonly ConcurrentDictionary<string, float[]> _embeddingCache =
            new ConcurrentDictionary<string, float[]>(StringComparer.Ordinal);

        public CedsEmbeddingModelProvider(IConfiguration configuration)
        {
            _modelPath = configuration["CedsAutoMap:OnnxModelPath"];
            _vocabPath = configuration["CedsAutoMap:VocabPath"];
            _session = new Lazy<InferenceSession>(() => new InferenceSession(_modelPath));
            _tokenizer = new Lazy<BertTokenizer>(CreateTokenizer);
        }

        public virtual bool IsAvailable =>
            !string.IsNullOrWhiteSpace(_modelPath) && File.Exists(_modelPath) &&
            !string.IsNullOrWhiteSpace(_vocabPath) && File.Exists(_vocabPath);

        private BertTokenizer CreateTokenizer()
        {
            // The fine-tuned model uses the MPNet tokenizer: BERT-style lowercased WordPiece with
            // RoBERTa-style special token names (<s>, </s>, <pad>, <mask>) but a BERT-style [UNK].
            var options = new BertOptions
            {
                UnknownToken = "[UNK]",
                ClassificationToken = "<s>",
                SeparatorToken = "</s>",
                PaddingToken = "<pad>",
                MaskingToken = "<mask>",
                LowerCaseBeforeTokenization = true
            };

            using var vocabStream = File.OpenRead(_vocabPath);
            return BertTokenizer.Create(vocabStream, options);
        }

        /// <summary>
        /// Embeds one sentence (cached).
        /// </summary>
        public virtual float[] Embed(string sentence)
        {
            return EmbedBatch(new[] { sentence })[0];
        }

        /// <summary>
        /// Embeds a batch of sentences, returning L2-normalized 768-dim vectors. Results are cached
        /// by sentence text for the application lifetime.
        /// </summary>
        public virtual IReadOnlyList<float[]> EmbedBatch(IReadOnlyList<string> sentences)
        {
            var results = new float[sentences.Count][];
            var missing = new List<(int Index, string Sentence)>();

            for (int i = 0; i < sentences.Count; i++)
            {
                string sentence = sentences[i] ?? string.Empty;

                if (_embeddingCache.TryGetValue(sentence, out var cached))
                {
                    results[i] = cached;
                }
                else
                {
                    missing.Add((i, sentence));
                }
            }

            for (int start = 0; start < missing.Count; start += EncodeBatchSize)
            {
                var batch = missing.Skip(start).Take(EncodeBatchSize).ToList();
                var embeddings = RunModel(batch.Select(b => b.Sentence).ToList());

                for (int i = 0; i < batch.Count; i++)
                {
                    results[batch[i].Index] = embeddings[i];
                    _embeddingCache.TryAdd(batch[i].Sentence, embeddings[i]);
                }
            }

            return results;
        }

        /// <summary>
        /// Token ids for one sentence, including the leading &lt;s&gt; and trailing &lt;/s&gt;
        /// (exposed for tokenizer parity tests against the Python tokenizer).
        /// </summary>
        public List<int> TokenizeWithSpecials(string sentence)
        {
            var tokenizer = _tokenizer.Value;

            // Parity fix: the HuggingFace tokenizer the model was trained with treats '_' as
            // punctuation (its own token), but Microsoft.ML.Tokenizers' pre-tokenizer keeps it
            // inside \w+ words. Isolate underscores so technical names like REC_INDICATOR_L
            // tokenize identically to training time.
            string normalized = (sentence ?? string.Empty).Replace("_", " _ ");

            var ids = tokenizer.EncodeToIds(normalized).ToList();

            // Tolerate tokenizer configurations that do or do not add the special tokens
            if (ids.Count == 0 || ids[0] != tokenizer.ClassificationTokenId)
            {
                ids.Insert(0, tokenizer.ClassificationTokenId);
            }
            if (ids[ids.Count - 1] != tokenizer.SeparatorTokenId)
            {
                ids.Add(tokenizer.SeparatorTokenId);
            }
            if (ids.Count > MaxSequenceLength)
            {
                ids = ids.Take(MaxSequenceLength - 1).ToList();
                ids.Add(tokenizer.SeparatorTokenId);
            }

            return ids;
        }

        private List<float[]> RunModel(IReadOnlyList<string> sentences)
        {
            int padId = _tokenizer.Value.PaddingTokenId;
            var sequences = sentences.Select(TokenizeWithSpecials).ToList();

            int batchSize = sequences.Count;
            int seqLength = Math.Max(1, sequences.Max(s => s.Count));

            var inputIds = new DenseTensor<long>(new[] { batchSize, seqLength });
            var attentionMask = new DenseTensor<long>(new[] { batchSize, seqLength });

            for (int row = 0; row < batchSize; row++)
            {
                var ids = sequences[row];

                for (int col = 0; col < seqLength; col++)
                {
                    if (col < ids.Count)
                    {
                        inputIds[row, col] = ids[col];
                        attentionMask[row, col] = 1;
                    }
                    else
                    {
                        inputIds[row, col] = padId;
                        attentionMask[row, col] = 0;
                    }
                }
            }

            var inputs = new List<NamedOnnxValue>
            {
                NamedOnnxValue.CreateFromTensor("input_ids", inputIds),
                NamedOnnxValue.CreateFromTensor("attention_mask", attentionMask)
            };

            using var output = _session.Value.Run(inputs);
            var embeddingTensor = output.First().AsTensor<float>();
            int dimensions = embeddingTensor.Dimensions[1];

            var embeddings = new List<float[]>(batchSize);

            for (int row = 0; row < batchSize; row++)
            {
                var vector = new float[dimensions];

                for (int d = 0; d < dimensions; d++)
                {
                    vector[d] = embeddingTensor[row, d];
                }

                embeddings.Add(vector);
            }

            return embeddings;
        }

        /// <summary>
        /// Cosine similarity of two embeddings from this provider (both are L2-normalized, so this
        /// is the dot product), clamped to [0, 1].
        /// </summary>
        public static decimal CosineSimilarity(float[] a, float[] b)
        {
            double dot = 0;

            for (int i = 0; i < a.Length; i++)
            {
                dot += (double)a[i] * b[i];
            }

            decimal similarity = Math.Round((decimal)dot, 4, MidpointRounding.AwayFromZero);
            return similarity < 0m ? 0m : (similarity > 1m ? 1m : similarity);
        }
    }
}
