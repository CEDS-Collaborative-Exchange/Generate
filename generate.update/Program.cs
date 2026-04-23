using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Serilog;
using Serilog.Events;

namespace generate.update
{
    public class Program
    {

        public static void Main(string[] args)
        {


            Log.Logger = new LoggerConfiguration()
                                                  .MinimumLevel.Warning()
                                                  .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
                                                  .Enrich.FromLogContext()
                                                  .WriteTo.Console()
                                                  .WriteTo.File("logs/log-.txt", rollingInterval: RollingInterval.Day)
                                                  .CreateLogger();

            try
            {
                Log.Information("Starting web host");

                BuildWebHost(args).Run();

            }
            catch (Exception ex)
            {
                Log.Fatal(ex, "Host terminated unexpectedly");
            }
            finally
            {
                Log.CloseAndFlush();
            }


        }

        /// <summary>
        /// BuildWebHost
        /// </summary>
        /// <param name="args"></param>
        /// <returns></returns>
        public static IHost BuildWebHost(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .UseSerilog()
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                })
                .Build();
    }
}
