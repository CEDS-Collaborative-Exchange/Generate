using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Serilog.Events;
using Serilog;
using System.IO;
using System;
using Microsoft.Extensions.Logging;
using generate.core.Config;
using Microsoft.Extensions.DependencyInjection;
using Hangfire;
using Hangfire.SqlServer;
using generate.core.Interfaces.Helpers;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Repositories.IDS;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Interfaces.Repositories.Staging;
using generate.core.Interfaces.Services;
using generate.infrastructure.Helpers;
using generate.infrastructure.Repositories.App;
using generate.infrastructure.Repositories.IDS;
using generate.infrastructure.Repositories.RDS;
using generate.infrastructure.Repositories.Staging;
using generate.infrastructure.Services;
using generate.infrastructure.Utilities;
using generate.testdata.DataGenerators;
using generate.testdata.Helpers;
using generate.testdata.Interfaces;
using generate.testdata.Profiles;
using generate.testdata;
using RestSharp;
using System.IO.Abstractions;
using generate.infrastructure.Contexts;
using Microsoft.EntityFrameworkCore;
using generate.background.Filters;
using Microsoft.Extensions.Hosting;
using System.Reflection;

var builder = WebApplication.CreateBuilder();
string environment_string = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") + "_";

builder.Configuration
    .SetBasePath(Directory.GetCurrentDirectory())
    .AddUserSecrets(Assembly.GetExecutingAssembly(), true)
    .AddEnvironmentVariables(prefix: environment_string)
    .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
    .AddJsonFile($"appsettings.{Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT")}.json", optional: true, reloadOnChange: true);
    

builder.Logging.AddSerilog(new LoggerConfiguration()
    .MinimumLevel.Information()
    .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
    .Enrich.FromLogContext()
    .WriteTo.Console()
    .WriteTo.File("logs/log-.txt", rollingInterval: RollingInterval.Day)
    .CreateLogger());

builder.Services.Configure<AppSettings>(builder.Configuration.GetSection("AppSettings"));
builder.Services.Configure<DataSettings>(builder.Configuration.GetSection("Data"));


builder.Services.AddMvc()
        .AddMvcOptions(options => options.EnableEndpointRouting = false);

builder.Services.AddHangfire(options =>
    options
        .UseSqlServerStorage(builder.Configuration.GetValue<string>("Data:HangfireConnection"))
);

GlobalConfiguration.Configuration.UseSqlServerStorage(builder.Configuration.GetValue<string>("Data:HangfireConnection"), new SqlServerStorageOptions { CommandTimeout = TimeSpan.FromHours(8) });

GlobalJobFilters.Filters.Add(new AutomaticRetryAttribute { Attempts = 0, OnAttemptsExceeded = AttemptsExceededAction.Delete });

// Add Cors Policy
builder.Services.AddCors(options =>
{
options.AddPolicy("CorsPolicy",
    builder => builder.AllowAnyOrigin()
    .AllowAnyMethod()
    .AllowAnyHeader()
    .WithExposedHeaders("X-Total-Count"));
});

// Test Data

builder.Services.AddScoped<ITestDataHelper, TestDataHelper>();

builder.Services.AddScoped<ITestDataInitializer, TestDataInitializer>();

// Test Data Generators
builder.Services.AddScoped<IStagingTestDataGenerator, StagingTestDataGenerator>();
builder.Services.AddScoped<IOutputHelper, OutputHelper>();
builder.Services.AddScoped<IStagingTestDataProfile, StagingTestDataProfile>();
builder.Services.AddScoped<IIdsTestDataGenerator, IdsTestDataGenerator>();

builder.Services.AddScoped<IIdsTestDataProfile, IdsTestDataProfile>();
builder.Services.AddScoped<IStagingTestDataProfile, StagingTestDataProfile>();

// Services            
builder.Services.AddScoped<IMigrationService, MigrationService>();
builder.Services.AddScoped<IAppUpdateService, AppUpdateService>();
builder.Services.AddScoped<IFSMetadataUpdateService, MetadataUpdateService>();
builder.Services.AddHangfireServer();

// Repositories
builder.Services.AddScoped<IAppRepository, AppRepository>();
builder.Services.AddScoped<IStagingRepository, StagingRepository>();
builder.Services.AddScoped<IIDSRepository, IDSRepository>();
builder.Services.AddScoped<IRDSRepository, RDSRepository>();
builder.Services.AddScoped<IFactReportRepository, FactReportRepository>();
builder.Services.AddScoped<ITestDataInitializer, TestDataInitializer>();
builder.Services.AddScoped<IDataMigrationHistoryService, DataMigrationHistoryService>();


// Utilities

builder.Services.AddScoped<IFileSystem, FileSystem>();
builder.Services.AddScoped<IHangfireHelper, HangfireHelper>();
builder.Services.AddScoped<RestClient, RestClient>();
builder.Services.AddScoped<IZipFileHelper, ZipFileHelper>();

builder.Services
    .AddDbContext<AppDbContext>(options =>
        options.UseSqlServer(builder.Configuration.GetValue<string>("Data:AppDbContextConnection")))
    .AddDbContext<IDSDbContext>(options =>
        options.UseSqlServer(builder.Configuration.GetValue<string>("Data:ODSDbContextConnection")))
    .AddDbContext<StagingDbContext>(options =>
        options.UseSqlServer(builder.Configuration.GetValue<string>("Data:StagingDbContextConnection")))
    .AddDbContext<RDSDbContext>(options =>
        options.UseSqlServer(builder.Configuration.GetValue<string>("Data:RDSDbContextConnection")));

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}
else
{
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}


app.UseCors("CorsPolicy");

app.UseMvc();


app.UseHangfireDashboard("", new DashboardOptions
{
    Authorization = new[] { new AuthorizationFilter() },
    AppPath = null
});

try
{
    Log.Information("Starting web host");

    await app.RunAsync();

}
catch (Exception ex)
{
    Log.Fatal(ex, "Host terminated unexpectedly");
}
finally
{
    Log.CloseAndFlush();
}


