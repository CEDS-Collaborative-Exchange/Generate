using generate.core.Dtos.App;
using generate.core.Interfaces.Repositories.App;
using generate.core.Models.App;
using generate.infrastructure.Services;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using Xunit;

namespace generate.test.Infrastructure.Services
{
    /// <summary>
    /// Tests for the ETL Checklist source mapping workflow (CIID-9033/CIID-9035, epic CIID-9029).
    /// </summary>
    public class EtlSourceMappingServiceShould
    {
        private readonly Mock<IAppRepository> _appRepository = new Mock<IAppRepository>();
        private readonly List<EtlMetadata> _metadata;
        private readonly List<EtlSourceElementMapping> _mappings = new List<EtlSourceElementMapping>();

        public EtlSourceMappingServiceShould()
        {
            _metadata = new List<EtlMetadata>
            {
                new EtlMetadata
                {
                    EtlMetadataId = 1,
                    EdFactsFileSpecNumber = "FS052",
                    CedsPath = "K12 -> K12 Student -> Enrollment",
                    CedsElementName = "Entry Grade Level",
                    CedsElementDefinition = "The grade level or primary instructional level at which a student enters and receives services in a school.",
                    CedsDataType = "Option Set",
                    CedsOptionSetCode = "08",
                    CedsOptionSetDescription = "Grade 8",
                    CedsElementGlobalId = "000100",
                    CedsElementDataModelId = "59749",
                    DestinationStagingTableName = "K12Enrollment",
                    DestinationStagingColumnName = "GradeLevel"
                },
                new EtlMetadata
                {
                    EtlMetadataId = 2,
                    EdFactsFileSpecNumber = "FS052",
                    CedsPath = "K12 -> K12 Student -> Enrollment",
                    CedsElementName = "Entry Grade Level",
                    CedsElementDefinition = "The grade level or primary instructional level at which a student enters and receives services in a school.",
                    CedsDataType = "Option Set",
                    CedsOptionSetCode = "09",
                    CedsOptionSetDescription = "Grade 9",
                    CedsElementGlobalId = "000100",
                    CedsElementDataModelId = "59749",
                    DestinationStagingTableName = "K12Enrollment",
                    DestinationStagingColumnName = "GradeLevel"
                },
                new EtlMetadata
                {
                    EtlMetadataId = 3,
                    CedsPath = "Assessments -> Assessment",
                    CedsElementName = "Assessment Family Short Name",
                    CedsElementDefinition = "The abbreviated title of the Assessment Family.",
                    CedsElementGlobalId = "000933",
                    CedsElementDataModelId = "59392"
                }
            };

            _appRepository
                .Setup(r => r.GetAllReadOnly<EtlMetadata>(It.IsAny<int>(), It.IsAny<int>()))
                .Returns(() => _metadata);

            _appRepository
                .Setup(r => r.FindReadOnly(It.IsAny<Expression<Func<EtlMetadata, bool>>>(), It.IsAny<int>(), It.IsAny<int>()))
                .Returns((Expression<Func<EtlMetadata, bool>> criteria, int skip, int take, Expression<Func<EtlMetadata, object>>[] eagerLoad) =>
                    _metadata.Where(criteria.Compile()));

            _appRepository
                .Setup(r => r.Create(It.IsAny<EtlSourceElementMapping>()))
                .Returns((EtlSourceElementMapping mapping) =>
                {
                    mapping.EtlSourceElementMappingId = _mappings.Count + 1;
                    _mappings.Add(mapping);
                    return mapping;
                });

            _appRepository
                .Setup(r => r.GetAllReadOnly(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<Expression<Func<EtlSourceElementMapping, object>>[]>()))
                .Returns(() => _mappings);

            _appRepository
                .Setup(r => r.Find(It.IsAny<Expression<Func<EtlSourceElementMapping, bool>>>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<Expression<Func<EtlSourceElementMapping, object>>[]>()))
                .Returns((Expression<Func<EtlSourceElementMapping, bool>> criteria, int skip, int take, Expression<Func<EtlSourceElementMapping, object>>[] eagerLoad) =>
                    _mappings.Where(criteria.Compile()));

            _appRepository
                .Setup(r => r.GetAll<EtlSourceElementMapping>(It.IsAny<int>(), It.IsAny<int>()))
                .Returns(() => _mappings);
        }

        private EtlSourceMappingService BuildService()
        {
            return new EtlSourceMappingService(_appRepository.Object, new CedsAutoMapService());
        }

        private static EtlSourceMappingUploadDto BuildUpload()
        {
            return new EtlSourceMappingUploadDto
            {
                UploadFileName = "StateDataDictionary.xlsx",
                UploadedBy = "tester",
                Elements = new List<EtlSourceElementUploadDto>
                {
                    new EtlSourceElementUploadDto
                    {
                        SourceElementName = "Entry Grade Level",
                        SourceElementDefinition = "The grade level or primary instructional level at which a student enters and receives services in a school.",
                        SourceTableName = "StudentEnrollment",
                        SourceColumnName = "EntryGrade",
                        OptionSetValues = new List<EtlSourceOptionSetValueUploadDto>
                        {
                            new EtlSourceOptionSetValueUploadDto { SourceOptionSetCode = "08", SourceOptionSetDescription = "Eighth Grade" },
                            new EtlSourceOptionSetValueUploadDto { SourceOptionSetCode = "Z9", SourceOptionSetDescription = "Unknown Level Xyz" }
                        }
                    },
                    new EtlSourceElementUploadDto
                    {
                        SourceElementName = "Bus Route Number",
                        SourceElementDefinition = "The number of the bus route the student rides to school."
                    }
                }
            };
        }

        [Fact]
        public void PersistUploadedElementsAndApplySuggestions()
        {
            var service = BuildService();

            var results = service.UploadDataDictionary(BuildUpload());

            Assert.Equal(2, results.Count);
            _appRepository.Verify(r => r.Save(), Times.AtLeastOnce);

            var gradeLevel = results[0].Mapping;
            Assert.Equal(EtlMappingStatus.Suggested, gradeLevel.MappingStatus);
            Assert.Equal("000100", gradeLevel.CedsElementGlobalId);
            Assert.Equal(EtlMatchType.Suggested, gradeLevel.MatchType);
            Assert.NotNull(gradeLevel.MatchConfidence);
            Assert.Equal("StateDataDictionary.xlsx", gradeLevel.UploadFileName);
            Assert.Equal("tester", gradeLevel.CreatedBy);
            Assert.NotEmpty(results[0].Candidates);

            // Option value "08" exists in the CEDS option set -> exact code suggestion
            var exactOption = gradeLevel.EtlSourceOptionSetMappings.First(o => o.SourceOptionSetCode == "08");
            Assert.Equal(EtlMappingStatus.Suggested, exactOption.MappingStatus);
            Assert.Equal("08", exactOption.CedsOptionSetCode);
            Assert.Equal(EtlMatchType.ExactCode, exactOption.MatchType);
            Assert.Equal(1.0m, exactOption.MatchConfidence);
        }

        [Fact]
        public void LeaveUnrelatedElementsUnmapped()
        {
            var service = BuildService();

            var results = service.UploadDataDictionary(BuildUpload());

            var busRoute = results[1].Mapping;
            Assert.Equal(EtlMappingStatus.Unmapped, busRoute.MappingStatus);
            Assert.Null(busRoute.CedsElementGlobalId);
        }

        [Fact]
        public void ReturnEmptyResultForEmptyUpload()
        {
            var service = BuildService();

            Assert.Empty(service.UploadDataDictionary(null));
            Assert.Empty(service.UploadDataDictionary(new EtlSourceMappingUploadDto()));
        }

        [Fact]
        public void BuildDistinctCedsElementCatalogFromEtlMetadata()
        {
            var service = BuildService();

            var catalog = service.GetCedsElementCatalog();

            Assert.Equal(2, catalog.Count);

            var gradeLevel = catalog.First(c => c.CedsElementGlobalId == "000100");
            Assert.Equal("Entry Grade Level", gradeLevel.CedsElementName);
            Assert.True(gradeLevel.HasOptionSet);

            var assessment = catalog.First(c => c.CedsElementGlobalId == "000933");
            Assert.False(assessment.HasOptionSet);
        }

        [Fact]
        public void ReturnCedsOptionSetValuesForOneElement()
        {
            var service = BuildService();

            var optionSetValues = service.GetCedsOptionSetValues("000100");

            Assert.Equal(2, optionSetValues.Count);
            Assert.Contains(optionSetValues, v => v.CedsOptionSetCode == "08");
            Assert.Contains(optionSetValues, v => v.CedsOptionSetCode == "09");

            Assert.Empty(service.GetCedsOptionSetValues("000933"));
            Assert.Empty(service.GetCedsOptionSetValues(null));
        }

        [Fact]
        public void AcceptElementMappingAndSetAudit()
        {
            var service = BuildService();
            service.UploadDataDictionary(BuildUpload());

            var updated = service.UpdateElementMapping(1, new EtlSourceElementMappingUpdateDto
            {
                MappingStatus = EtlMappingStatus.Accepted,
                CedsElementGlobalId = "000100",
                ModifiedBy = "reviewer"
            });

            Assert.Equal(EtlMappingStatus.Accepted, updated.MappingStatus);
            Assert.Equal("000100", updated.CedsElementGlobalId);
            Assert.Equal("reviewer", updated.ModifiedBy);
            Assert.NotNull(updated.ModifiedDate);
        }

        [Fact]
        public void OverrideElementMappingWithManualMatchTypeAndResuggestOptions()
        {
            var service = BuildService();
            service.UploadDataDictionary(BuildUpload());

            // Bus Route (id 2) was unmapped; manually map it to Entry Grade Level
            var updated = service.UpdateElementMapping(2, new EtlSourceElementMappingUpdateDto
            {
                MappingStatus = EtlMappingStatus.Accepted,
                CedsElementGlobalId = "000100",
                ModifiedBy = "reviewer"
            });

            Assert.Equal("000100", updated.CedsElementGlobalId);
            Assert.Equal("Entry Grade Level", updated.CedsElementName);
            Assert.Equal(EtlMatchType.Manual, updated.MatchType);
            Assert.Null(updated.MatchConfidence);
        }

        [Fact]
        public void ClearCedsFieldsWhenMarkedNotInCeds()
        {
            var service = BuildService();
            service.UploadDataDictionary(BuildUpload());

            var updated = service.UpdateElementMapping(1, new EtlSourceElementMappingUpdateDto
            {
                MappingStatus = EtlMappingStatus.NotInCeds,
                ModifiedBy = "reviewer"
            });

            Assert.Equal(EtlMappingStatus.NotInCeds, updated.MappingStatus);
            Assert.Null(updated.CedsElementGlobalId);
            Assert.Null(updated.CedsElementName);
            Assert.Null(updated.MatchConfidence);
        }

        [Fact]
        public void ThrowWhenOverridingToUnknownCedsElement()
        {
            var service = BuildService();
            service.UploadDataDictionary(BuildUpload());

            Assert.Throws<ArgumentException>(() => service.UpdateElementMapping(1, new EtlSourceElementMappingUpdateDto
            {
                MappingStatus = EtlMappingStatus.Accepted,
                CedsElementGlobalId = "999999"
            }));
        }

        [Fact]
        public void ReturnNullWhenUpdatingUnknownMapping()
        {
            var service = BuildService();

            Assert.Null(service.UpdateElementMapping(999, new EtlSourceElementMappingUpdateDto { MappingStatus = EtlMappingStatus.Accepted }));
            Assert.Null(service.UpdateElementMapping(1, null));
        }

        [Fact]
        public void DeleteAllMappings()
        {
            var service = BuildService();
            service.UploadDataDictionary(BuildUpload());

            service.DeleteAllMappings();

            _appRepository.Verify(r => r.DeleteRange(It.IsAny<IEnumerable<EtlSourceElementMapping>>()), Times.Once);
        }

        [Fact]
        public void ExportChecklistCsvWithDestinationMetadata()
        {
            var service = BuildService();
            service.UploadDataDictionary(BuildUpload());

            string csv = service.ExportChecklistCsv();
            var lines = csv.Split(new[] { "\r\n", "\n" }, StringSplitOptions.RemoveEmptyEntries);

            // Header + 2 option rows for Entry Grade Level + 1 row for Bus Route
            Assert.Equal(4, lines.Length);
            Assert.StartsWith("Source Common Name,", lines[0]);
            Assert.Contains("Destination Staging Table Name", lines[0]);

            // The exact-code option row joins the EtlMetadata destination columns for FS052
            Assert.Contains(lines, l => l.Contains("Entry Grade Level") && l.Contains("K12Enrollment") && l.Contains("FS052"));
        }
    }
}
