using generate.infrastructure.Services;
using Microsoft.Extensions.Configuration;
using Moq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.Json;
using Xunit;

namespace generate.test.Infrastructure.Services
{
    /// <summary>
    /// Environment-dependent tests for the fine-tuned CEDS Copilot embedding model (epic CIID-9029).
    /// They validate the .NET tokenizer against ids produced by the Python (HuggingFace) tokenizer
    /// and basic embedding behavior. When the exported ONNX model is not present on the machine the
    /// tests pass trivially (the model is an optional, configurable asset - not part of the repo).
    /// </summary>
    public class CedsEmbeddingModelProviderShould
    {
        private const string OnnxDirectory = @"C:\Repos\CEDS-Copilot\test\data\ceds-copilot-onnx";

        private static CedsEmbeddingModelProvider BuildProvider()
        {
            var configuration = new Mock<IConfiguration>();
            configuration.Setup(c => c["CedsAutoMap:OnnxModelPath"]).Returns(Path.Combine(OnnxDirectory, "model.onnx"));
            configuration.Setup(c => c["CedsAutoMap:VocabPath"]).Returns(Path.Combine(OnnxDirectory, "vocab.txt"));
            return new CedsEmbeddingModelProvider(configuration.Object);
        }

        private static bool ModelAvailable()
        {
            return File.Exists(Path.Combine(OnnxDirectory, "model.onnx")) &&
                   File.Exists(Path.Combine(OnnxDirectory, "vocab.txt"));
        }

        [Fact]
        public void TokenizeIdenticallyToThePythonTokenizer()
        {
            string fixturePath = Path.Combine(OnnxDirectory, "tokenizer_test.json");

            if (!ModelAvailable() || !File.Exists(fixturePath))
            {
                return; // model assets not installed on this machine
            }

            var fixture = JsonSerializer.Deserialize<TokenizerFixture>(
                File.ReadAllText(fixturePath),
                new JsonSerializerOptions { PropertyNameCaseInsensitive = true });

            var provider = BuildProvider();

            for (int i = 0; i < fixture.Sentences.Count; i++)
            {
                var expected = fixture.Input_Ids[i]
                    .Zip(fixture.Attention_Mask[i], (id, mask) => (id, mask))
                    .Where(pair => pair.mask == 1)
                    .Select(pair => pair.id)
                    .ToList();

                var actual = provider.TokenizeWithSpecials(fixture.Sentences[i]);

                Assert.True(expected.SequenceEqual(actual),
                    $"Token ids diverge from the Python tokenizer for: \"{fixture.Sentences[i]}\"\n" +
                    $"expected: {string.Join(",", expected)}\nactual:   {string.Join(",", actual)}");
            }
        }

        [Fact]
        public void EmbedWithNormalizedVectorsAndSensibleSimilarities()
        {
            if (!ModelAvailable())
            {
                return; // model assets not installed on this machine
            }

            var provider = BuildProvider();

            var gradeLevel = provider.Embed("Entry Grade Level: The grade level or primary instructional level at which a student enters and receives services in a school.");
            var gradeLevelAgain = provider.Embed("Entry Grade Level: The grade level or primary instructional level at which a student enters and receives services in a school.");
            var unrelated = provider.Embed("Bus Route Number: The number of the bus route the student rides to school.");

            // L2-normalized output
            double norm = Math.Sqrt(gradeLevel.Sum(v => (double)v * v));
            Assert.InRange(norm, 0.99, 1.01);

            // Identical sentences are identical (and cached)
            Assert.Equal(1.0m, CedsEmbeddingModelProvider.CosineSimilarity(gradeLevel, gradeLevelAgain));

            // An unrelated concept scores lower than self-similarity
            Assert.True(CedsEmbeddingModelProvider.CosineSimilarity(gradeLevel, unrelated) < 0.9m);
        }

        private class TokenizerFixture
        {
            public List<string> Sentences { get; set; }
            public List<List<int>> Input_Ids { get; set; }
            public List<List<int>> Attention_Mask { get; set; }
        }
    }
}
