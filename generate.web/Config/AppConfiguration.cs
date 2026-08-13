using generate.infrastructure.Contexts;
using generate.core.Models.App;
using generate.core.Models.IDS;
using generate.core.Models.RDS;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Interfaces.Repositories.IDS;
using generate.core.Interfaces.Services;
using generate.testdata;
using generate.testdata.DataGenerators;
using generate.testdata.Interfaces;
using generate.testdata.Profiles;
using generate.infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using generate.infrastructure.Repositories.RDS;
using generate.infrastructure.Repositories.IDS;
using generate.infrastructure.Repositories.App;
using generate.testdata.Helpers;
using System.IO.Abstractions;
using generate.core.Interfaces.Helpers;
using generate.infrastructure.Helpers;
using RestSharp;
using generate.infrastructure.Utilities;
using generate.core.Interfaces.Repositories.Staging;
using generate.infrastructure.Repositories.Staging;
using generate.web.Controllers.Api.App;

namespace generate.web.Config
{
    public static class AppConfiguration
    {

        public static void ConfigureCoreServices(IServiceCollection services)
        {
            // Utilities
            services.AddScoped<IFileSystem, FileSystem>();
            services.AddScoped<IHangfireHelper, HangfireHelper>();
            services.AddScoped<RestClient, RestClient>();
            services.AddScoped<IZipFileHelper, ZipFileHelper>();

            // Test Data
            //////////////////////

            services.AddScoped<IIdsTestDataGenerator, IdsTestDataGenerator>();
            services.AddScoped<IStagingTestDataGenerator, StagingTestDataGenerator>();
            services.AddScoped<IRdsTestDataGenerator, RdsTestDataGenerator>();
            services.AddScoped<IOutputHelper, OutputHelper>();

            services.AddScoped<ITestDataHelper, TestDataHelper>();

            services.AddScoped<ITestDataInitializer, TestDataInitializer>();

            // Test Data Profiles
            services.AddScoped<IIdsTestDataProfile, IdsTestDataProfile>();
            services.AddScoped<IStagingTestDataProfile, StagingTestDataProfile>();
            services.AddScoped<IRdsTestDataProfile, RdsTestDataProfile>();


            // Repositories
            //////////////////////

            services.AddScoped<IStagingRepository, StagingRepository>();
            services.AddScoped<IIDSRepository, IDSRepository>();
            services.AddScoped<IRDSRepository, RDSRepository>();
            services.AddScoped<IAppRepository, AppRepository>();

            services.AddScoped<IFactStudentCountRepository, FactStudentCountRepository>();
            services.AddScoped<IFactStudentDisciplineRepository, FactStudentDisciplineRepository>();
            services.AddScoped<IFactStudentAssessmentRepository, FactStudentAssessmentRepository>();
            services.AddScoped<IFactStaffCountRepository, FactStaffCountRepository>();
			services.AddScoped<IFactOrganizationCountRepository, FactOrganizationCountRepository>();
			services.AddScoped<IFactOrganizationStatusCountRepository, FactOrganizationStatusCountRepository>();
            services.AddScoped<IFactCustomCountRepository, FactCustomCountRepository>();

            services.AddScoped<IFactReportRepository, FactReportRepository>();

            services.AddScoped<IDimensionRepository, DimensionRepository>();

            services.AddScoped<IReportDebugRepository, ReportDebugRepository>();
            // Services
            //////////////////////

            services.AddScoped<IDbUpdaterService, DbUpdaterService>();
            services.AddScoped<IAppUpdateService, AppUpdateService>();

            services.AddScoped<IDataMigrationService, DataMigrationService>();
            services.AddScoped<IDataMigrationHistoryService, DataMigrationHistoryService>();
            services.AddScoped<IGenerateReportService, GenerateReportService>();
            services.AddScoped<IGenerateReportTopicService, GenerateReportTopicService>();
            services.AddScoped<IFileSubmissionService, FileSubmissionService>();
            services.AddScoped<IDataPopulationSummaryService, DataPopulationSummaryService>();
            services.AddScoped<IEdFactsReportService, EdFactsReportService>();
            services.AddScoped<IEdfactsFileService, EdfactsFileService>();
            services.AddScoped<ISppAprReportService, SppAprReportService>();
            services.AddScoped<IRDSDataMigrationService, RDSDataMigrationService>();
            services.AddScoped<IStateDefinedReportService, StateDefinedReportService>();
            services.AddScoped<IFSMetadataUpdateService, MetadataUpdateService>();
            services.AddScoped<IAboutService, AboutService>();
            // CEDS Ontology + Staging catalog (CIID-9057): source the match corpus from the ontology
            // RDF filtered to CEDS elements present in the warehouse Staging schema.
            services.AddSingleton<CedsOntologyProvider>();
            services.AddSingleton<StagingCedsColumnProvider>();
            services.AddSingleton<ICedsStagingCatalogProvider, CedsStagingCatalogProvider>();

            // CEDS automapping (CIID-9032): the fine-tuned CEDS Copilot embedding model (ONNX) when
            // configured and present; otherwise the deterministic lexical matcher.
            services.AddSingleton<CedsEmbeddingModelProvider>();
            services.AddScoped<CedsAutoMapService>();
            services.AddScoped<ICedsAutoMapService>(serviceProvider =>
            {
                var modelProvider = serviceProvider.GetRequiredService<CedsEmbeddingModelProvider>();

                return modelProvider.IsAvailable
                    ? new CedsEmbeddingAutoMapService(modelProvider)
                    : (ICedsAutoMapService)serviceProvider.GetRequiredService<CedsAutoMapService>();
            });
            services.AddScoped<IEtlSourceMappingService, EtlSourceMappingService>();

            // AI ETL developer chatbot (CIID-9061): local Ollama model + looping ETL development
            services.AddScoped<IOllamaClient, OllamaClient>();
            services.AddScoped<IEtlChatService, EtlChatService>();
            // Background runner (singleton) drives the phase loop server-side so it keeps running
            // after the user leaves the page.
            services.AddSingleton<IEtlChatRunner, EtlChatRunner>();

            // General-purpose assistant chat (CIID-9061): free-form sessions not tied to an ETL map.
            services.AddScoped<IAssistantChatService, AssistantChatService>();
        }


    }

}
