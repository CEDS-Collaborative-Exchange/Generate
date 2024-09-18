using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Abstractions;
using System.Linq;
using System.Threading.Tasks;
using generate.core.Interfaces.Helpers;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Services;
using generate.infrastructure.Contexts;
using generate.infrastructure.Helpers;
using generate.infrastructure.Repositories.App;
using generate.infrastructure.Services;
using generate.infrastructure.Utilities;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using RestSharp;
using Serilog;

namespace generate.update
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddLogging(loggingBuilder => loggingBuilder.AddSerilog(dispose: true));
                       
            // Configure Context
            services = ConfigureContext(services);

            // Add Cors Policy
            services.AddCors(options =>
            {
                options.AddPolicy("CorsPolicy",
                    builder => builder.AllowAnyOrigin()
                    .AllowAnyMethod()
                    .AllowAnyHeader()
                    .WithExposedHeaders("X-Total-Count"));
            });

            services.AddMvc()
                    .AddMvcOptions(options => options.EnableEndpointRouting = false);

            // Repositories
            services.AddScoped<IAppRepository, AppRepository>();

            // Services            
            services.AddScoped<IAppUpdateService, AppUpdateService>();

            services.AddScoped<IHangfireHelper, HangfireHelper>();
            services.AddScoped<IFileSystem, FileSystem>();
            services.AddScoped<RestClient, RestClient>();
            services.AddScoped<IZipFileHelper, ZipFileHelper>();


        }


        /// <summary>
        /// Configure Context
        /// </summary>
        /// <param name="services"></param>
        /// <returns></returns>
        public virtual IServiceCollection ConfigureContext(IServiceCollection services)
        {

            services
               .AddDbContext<AppDbContext>(options =>
                    options.UseSqlServer(Configuration["Data:AppDbContextConnection"]))
               .AddDbContext<IDSDbContext>(options =>
                    options.UseSqlServer(Configuration["Data:ODSDbContextConnection"]))
               .AddDbContext<RDSDbContext>(options =>
                    options.UseSqlServer(Configuration["Data:RDSDbContextConnection"]));

            return services;

        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }


            app.UseCors("CorsPolicy");

            app.UseHttpsRedirection();

            app.UseFileServer(new FileServerOptions()
            {
                FileProvider = new PhysicalFileProvider(Path.Combine(env.ContentRootPath, @"Updates")),
                RequestPath = new PathString("/Updates")
            });

            app.UseMvc();
        }
    }
}
