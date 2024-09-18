using System;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.PlatformAbstractions;
using Newtonsoft.Json.Serialization;
using Microsoft.Extensions.Logging;
using Microsoft.EntityFrameworkCore;
using System.IO;
using generate.infrastructure.Contexts;
using generate.core.Config;
using generate.core.Interfaces.Services;
using Microsoft.Extensions.Options;
//using Microsoft.EntityFrameworkCore.Design.Internal;
using generate.web.Config;

namespace generate.test.Web
{
    public class TestServerStartup
    {
        public static IConfigurationRoot Configuration;

        public TestServerStartup(IHostEnvironment env)
        {

            DirectoryInfo di = new DirectoryInfo(Directory.GetCurrentDirectory());
            string appDir = di.Parent.Parent.Parent.FullName;

            var builder = new ConfigurationBuilder()
                .AddEnvironmentVariables();
            
            var config = builder.Build();

            string environment = "test";

            #if DEBUG
            environment = "development";
            #endif
                                   
            builder.SetBasePath(appDir + "/Config/");
            
            System.Console.WriteLine("generate.test / environment = " + environment);


            builder.AddJsonFile("appsettings.json", optional: true)
                .AddJsonFile($"appsettings.{environment.ToLower()}.json", optional: true);


            Configuration = builder.Build();

        }


        // This method gets called by the runtime. Use this method to add services to the container.
        // For more information on how to configure your application, visit http://go.microsoft.com/fwlink/?LinkID=398940
        public void ConfigureServices(IServiceCollection services)
        {

            services.AddOptions();
            services.Configure<AppSettings>(Configuration.GetSection("AppSettings"));
            services.Configure<DataSettings>(Configuration.GetSection("Data"));

            services
               .AddDbContext<AppDbContext>(options =>
                    options.UseSqlServer(Configuration["Data:AppDbContextConnection"]))
               .AddDbContext<IDSDbContext>(options =>
                    options.UseSqlServer(Configuration["Data:ODSDbContextConnection"]))
               .AddDbContext<RDSDbContext>(options =>
                    options.UseSqlServer(Configuration["Data:RDSDbContextConnection"]));


            AppConfiguration.ConfigureCoreServices(services);

        }

        public void Configure(IApplicationBuilder app,
            IServiceProvider serviceProvider,
            IHostEnvironment env,
            ILoggerFactory loggerFactory,
            IDbUpdaterService dbUpdaterService,
            IOptions<AppSettings> appSettings)
        {
            DirectoryInfo di = new DirectoryInfo(Directory.GetCurrentDirectory());
            string appDir = di.Parent.Parent.Parent.Parent.FullName;

            System.Console.WriteLine("Update Path = " + appDir + "\\generate.web");
            System.Console.WriteLine("Database = " + Configuration["AppSettings:DatabaseServer"]);

            dbUpdaterService.Update(false, appDir + "\\generate.web");

        }


    }
}
