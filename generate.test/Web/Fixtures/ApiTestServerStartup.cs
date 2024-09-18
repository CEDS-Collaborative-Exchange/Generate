using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Extensions.Hosting;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication;
using System.Security.Claims;
using Microsoft.Extensions.Options;
using System.Text.Encodings.Web;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using generate.infrastructure.Contexts;
using generate.web;
using Microsoft.AspNetCore.Hosting;

namespace generate.test.Web.Fixtures
{
    public class ApiTestServerStartup
    {
        public ApiTestServerStartup(IHostEnvironment env) 
        {

        }

        /// <summary>
        /// Configure Context
        /// </summary>
        /// <param name="services"></param>
        /// <returns></returns>
        public IServiceCollection ConfigureContext(IServiceCollection services)
        {

            services.AddEntityFrameworkInMemoryDatabase();

            services
                    .AddDbContext<AppDbContext>(
            (serviceProvider, options) =>
            {
                options
                    .UseInternalServiceProvider(serviceProvider)
                    .UseInMemoryDatabase("generate.web");
            },
                ServiceLifetime.Scoped  //Showing explicitly that the DbContext is shared across the HTTP request scope (graph of objects started in the HTTP request)
            );


            return services;
        }

        /// <summary>
        /// Configure Authorization
        /// </summary>
        /// <param name="services"></param>
        /// <returns></returns>
        public IServiceCollection ConfigureAuthorization(IServiceCollection services)
        {
            return services;
        }

    }


}
