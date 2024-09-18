using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.TestHost;
using System;
using System.IO;
using System.Linq;
using System.Security.Claims;
using System.Net.Http;
using System.Collections.Generic;
using generate.infrastructure.Contexts;
using generate.web.Infrastructure.Helpers;
using Microsoft.Extensions.DependencyInjection;

namespace generate.test.Web.Fixtures
{

    public class ApiTestServerFixture : IDisposable
    {
        public TestServer TestServer { get; private set; }
        public AppDbContext AppDbContext { get; private set; }

        public ApiTestServerFixture()
        {

            // Setup test server
            var contentRoot = Directory.GetCurrentDirectory();
            contentRoot = Directory.GetParent(contentRoot).ToString();
            contentRoot = Directory.GetParent(contentRoot).ToString();
            contentRoot = Directory.GetParent(contentRoot).ToString();
            contentRoot = Directory.GetParent(contentRoot).ToString();
            contentRoot = contentRoot + "\\generate.web\\";

            var webHostBuilder = new WebHostBuilder();

            webHostBuilder.UseEnvironment("CI");

            webHostBuilder.UseContentRoot(contentRoot);

            webHostBuilder.UseStartup<ApiTestServerStartup>();

            this.TestServer = new TestServer(webHostBuilder);

            var appDbContext = this.TestServer.Host.Services.GetService(typeof(AppDbContext)) as AppDbContext;
            var odsDbContext = this.TestServer.Host.Services.GetService(typeof(IDSDbContext)) as IDSDbContext;

            this.AppDbContext = appDbContext;

            ReferenceDataHelper.SetupReferenceData(appDbContext, odsDbContext);
            
            TestDataHelper.SetupTestDataForInMemoryStore(appDbContext, odsDbContext);

            //var educationOrganizationService = this.TestServer.Host.Services.GetService(typeof(IEducationOrganizationService)) as EducationOrganizationService;
            //var ApiAuthorizationService = this.TestServer.Host.Services.GetService(typeof(IApiAuthorizationService)) as ApiAuthorizationService;

        }


        public void Dispose()
        {
            this.TestServer.Dispose();
        }

    }
}

