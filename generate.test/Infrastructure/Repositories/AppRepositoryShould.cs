using generate.infrastructure.Contexts;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;
using Moq;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using generate.core.Config;
using generate.core.Models.App;
using generate.infrastructure.Repositories.App;
using generate.core.Examples.App;

namespace generate.test.Infrastructure.Repositories
{
    public class AppRepositoryShould
    {
        private readonly int id = 1;
        private GenerateReport expected;

        private AppDbContext GetContext()
        {

            var options = new DbContextOptionsBuilder<infrastructure.Contexts.AppDbContext>()
                              .UseInMemoryDatabase(Guid.NewGuid().ToString())
                              .Options;

            var logger = Mock.Of<ILogger<AppDbContext>>();

            var appSettings = Mock.Of<IOptions<AppSettings>>();

            var context = new AppDbContext(options, logger, appSettings);

            return context;
        }


        private AppDbContext GetContextWithData()
        {

            var context = this.GetContext();

            var repository = new AppRepository(context);
            this.expected = GenerateReportExample.GetExample(id);

            repository.Create(expected);
            repository.SaveAsync();

            return context;
        }


        /// <summary>
        /// Verify properties
        /// </summary>
        /// <param name="expected"></param>
        /// <param name="actual"></param>
        private void Verify(GenerateReport expected, GenerateReport actual)
        {
            Assert.NotNull(actual);

            Assert.Equal(expected.GenerateReportId, actual.GenerateReportId);

            Assert.Equal(expected.ReportName, actual.ReportName);
            Assert.Equal(expected.ReportCode, actual.ReportCode);
            Assert.Equal(expected.ReportShortName, actual.ReportShortName);
            Assert.Equal(expected.ReportSequence, actual.ReportSequence);

        }

        /// <summary>
        /// Verify IEnumerable
        /// </summary>
        /// <param name="expected"></param>
        /// <param name="actual"></param>
        private void ValidateIEnumerable(GenerateReport expected, IEnumerable<GenerateReport> actual)
        {

            Assert.NotNull(expected);
            Assert.NotNull(actual);
            Assert.NotEmpty(actual);

            var actualItem = actual.FirstOrDefault(i => i.GenerateReportId == expected.GenerateReportId);
            Verify(expected, actualItem);

        }


        [Fact]
        public void Create()
        {

            using (var context = GetContext())
            {
                var repository = new AppRepository(context);

                // Create
                this.expected = GenerateReportExample.GetExample(id);
                repository.Create(expected);
                repository.SaveAsync();

                // Get
                var actual = context.GenerateReports.FirstOrDefault();

                // Verify
                Verify(expected, actual);

            }
        }


        [Fact]
        public void GetAll()
        {

            using (var context = GetContextWithData())
            {

                var repository = new AppRepository(context);

                // Get
                var returnValue = repository.GetAll<GenerateReport>(0, 0);

                // Verify
                ValidateIEnumerable(expected, returnValue);

                // test skip
                var skip = 1;

                returnValue = repository.GetAll<GenerateReport>(skip, 1);

                Assert.Empty(returnValue);

            }
        }
               
        [Fact]
        public void Delete()
        {

            using (var context = GetContextWithData())
            {

                var repository = new AppRepository(context);

                // Get
                var existingList = repository.GetAll<GenerateReport>(0, 1);

                Assert.NotNull(existingList);
                Assert.NotEmpty(existingList);

                // Delete
                int id = existingList.FirstOrDefault().GenerateReportId;
                repository.Delete<GenerateReport>(id);
                repository.SaveAsync();

                // Get
                var returnValue = repository.GetAll<GenerateReport>(0, 1);

                // Verify
                Assert.Empty(returnValue);


            }
        }


        [Fact]
        public void Update()
        {

            using (var context = GetContextWithData())
            {

                var repository = new AppRepository(context);

                // Get
                var existingList = repository.GetAll<GenerateReport>(0, 1);

                Assert.NotNull(existingList);
                Assert.NotEmpty(existingList);

                // Update
                var existing = existingList.FirstOrDefault();
                Assert.NotNull(existing);

                var updated = GenerateReportExample.GetUpdatedExample(existing);
                repository.Update(updated);
                repository.SaveAsync();

                // Get
                var returnValue = repository.GetAll<GenerateReport>(0, 1);

                // Verify
                ValidateIEnumerable(updated, returnValue);

            }
        }




    }

}
