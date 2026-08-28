using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Serilog.Events;
using Serilog;
using System.IO;
using System;
using generate.core.Config;
using Microsoft.Extensions.DependencyInjection;
using RestSharp;
using generate.infrastructure.Contexts;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Hosting;
using System.Text.Json;
using Microsoft.OpenApi.Models;
using generate.web.Security;
using generate.web.Security.Embeddable;
using generate.web.Config;
using generate.core.Interfaces.Services;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.SpaServices.AngularCli;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.MicrosoftAccount;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Identity.Web;
using Microsoft.AspNetCore.HttpOverrides;
using Microsoft.Extensions.Logging;


var builder = WebApplication.CreateBuilder(args);
string environment_string = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") + "_";

builder.Configuration
    .SetBasePath(Directory.GetCurrentDirectory() + "/Config/")
    .AddEnvironmentVariables(prefix: environment_string)
    .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
    .AddJsonFile($"appsettings.{Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT")}.json", optional: true, reloadOnChange: true);


AppConfiguration.ConfigureCoreServices(builder.Services);

builder.Logging.AddSerilog(new LoggerConfiguration()
    .MinimumLevel.Information()
    .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
    .Enrich.FromLogContext()
    .WriteTo.Console()
    .WriteTo.File("logs/log-.txt", rollingInterval: RollingInterval.Day)
    .CreateLogger());


builder.Services.AddControllersWithViews();
builder.Services.AddOptions();
builder.Services.Configure<AppSettings>(builder.Configuration.GetSection("AppSettings"));

// Add MVC
builder.Services.AddMvc()
    .AddMvcOptions(options => options.EnableEndpointRouting = false)
    .AddControllersAsServices()  //Injecting Controllers themselves thru DI   //For further info see: http://docs.autofac.org/en/latest/integration/aspnetcore.html#controllers-as-services
    .AddJsonOptions(opt => opt.JsonSerializerOptions.PropertyNamingPolicy = JsonNamingPolicy.CamelCase);

// Register the Swagger generator, defining one or more Swagger documents
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "generate", Version = "v1" });
});

// In production, the Angular files will be served from this directory
//app.UseStatic(configuration =>
//{
//    configuration.RootPath = "ClientApp/dist";
//});

//MER add switch to use Embedded usermanager/store if configured
if ("EMBEDDED".Equals(builder.Configuration.GetValue<string>("AppSettings:UserStoreType")))
{
    builder.Services.AddAuthorization();
    builder.Services.AddAuthentication().AddCookie();
    builder.Services.AddIdentity<ApplicationUser, ApplicationRole>()
    .AddUserStore<EmbeddedUserStore<ApplicationUser>>()
    .AddRoleStore<ApplicationRoleStore>()
    .AddUserManager<EmbeddedUserManager>();
}
else if ("OAUTH".Equals(builder.Configuration.GetValue<string>("AppSettings:UserStoreType")))
{
    if (builder.Environment.IsDevelopment())
    {
        // Reveals the real reason behind JWT validation failures (normally redacted as PII) for local debugging.
        Microsoft.IdentityModel.Logging.IdentityModelEventSource.ShowPII = true;
    }

    builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                    .AddMicrosoftIdentityWebApi(builder.Configuration.GetSection("AzureAd"));
    builder.Services.AddAuthorization();


    builder.Services.AddIdentity<ApplicationUser, ApplicationRole>()
    .AddUserStore<ApplicationUserStore<ApplicationUser>>()
    .AddRoleStore<ApplicationRoleStore>()
    .AddUserManager<ApplicationUserManager>();

    // AddIdentity<>() above overrides DefaultAuthenticateScheme/DefaultChallengeScheme back to
    // Identity.Application (cookies), even though AddAuthentication() was configured for JWT Bearer.
    // Re-assert JWT Bearer as the default so [Authorize] validates bearer tokens in OAuth mode.
    builder.Services.Configure<AuthenticationOptions>(options =>
    {
        options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    });
}
else // AD Auth
{
    builder.Services.AddAuthorization();
    builder.Services.AddAuthentication().AddCookie();
    builder.Services.AddIdentity<ApplicationUser, ApplicationRole>()
    .AddUserStore<ApplicationUserStore<ApplicationUser>>()
    .AddRoleStore<ApplicationRoleStore>()
    .AddUserManager<ApplicationUserManager>();
}


builder.Services
   .AddDbContext<AppDbContext>(options =>
        options.UseSqlServer(builder.Configuration.GetValue<string>("Data:AppDbContextConnection")))
   .AddDbContext<IDSDbContext>(options =>
        options.UseSqlServer(builder.Configuration.GetValue<string>("Data:ODSDbContextConnection")))
   .AddDbContext<RDSDbContext>(options =>
        options.UseSqlServer(builder.Configuration.GetValue<string>("Data:RDSDbContextConnection")))
   .AddDbContext<StagingDbContext>(options =>
        options.UseSqlServer(builder.Configuration.GetValue<string>("Data:StagingDbContextConnection")));

var app = builder.Build();

if (app.Environment.IsDevelopment() && "OAUTH".Equals(builder.Configuration.GetValue<string>("AppSettings:UserStoreType")))
{
    // Decodes the incoming bearer token's claims directly, bypassing Microsoft.IdentityModel's PII
    // redaction, so the real audience/scope/issuer can be seen while diagnosing signature failures.
    app.Use(async (context, next) =>
    {
        var header = context.Request.Headers.Authorization.ToString();
        if (header.StartsWith("Bearer "))
        {
            var parts = header.Substring("Bearer ".Length).Split('.');
            if (parts.Length >= 2)
            {
                try
                {
                    string Pad(string s) => s.PadRight(s.Length + (4 - s.Length % 4) % 4, '=').Replace('-', '+').Replace('_', '/');
                    var header_ = System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(Pad(parts[0])));
                    var payload = System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(Pad(parts[1])));
                    app.Logger.LogInformation("OAuth diagnostic - token header: {Header}", header_);
                    app.Logger.LogInformation("OAuth diagnostic - token payload: {Payload}", payload);
                }
                catch (Exception ex)
                {
                    app.Logger.LogWarning(ex, "OAuth diagnostic - failed to decode token");
                }
            }
        }
        await next();
    });
}

app.UseAuthentication();
app.UseAuthorization();
//app.UseStaticFiles(new StaticFileOptions() { RequestPath = "/ClientApp/dist" });
app.UseStaticFiles();
app.UseMvc();
app.UseSpa(spa => {

    if (builder.Environment.IsDevelopment() && !builder.Environment.IsEnvironment("CI"))
    {
        spa.Options.SourcePath = "ClientApp";
        spa.Options.StartupTimeout = new TimeSpan(0, 6, 0);
        spa.UseAngularCliServer(npmScript: "start");
    }
});
app.UseForwardedHeaders(new ForwardedHeadersOptions { 
    ForwardedHeaders = ForwardedHeaders.XForwardedProto
});


if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();

    // Enable middleware to serve generated Swagger as a JSON endpoint.
    app.UseSwagger();

    //// Enable middleware to serve swagger-ui (HTML, JS, CSS etc.), specifying the Swagger JSON endpoint.
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "generate v1");
    });


}
else
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.MapControllerRoute(
    name: "default",
    pattern: "{controller}/{action=Index}/{id?}"
    );

//var scope = app.Services.CreateScope();
//var DbUpdaterService = scope.ServiceProvider.GetService<IDbUpdaterService>();
//DbUpdaterService.Update(false, Directory.GetCurrentDirectory());

try
{
    Log.Information("Starting web host");

    app.Run();

}
catch (Exception ex)
{
    Log.Fatal(ex, "Host terminated unexpectedly");
}
finally
{
    Log.CloseAndFlush();
}
