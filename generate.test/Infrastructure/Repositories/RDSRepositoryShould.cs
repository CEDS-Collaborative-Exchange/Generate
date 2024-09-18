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
using generate.infrastructure.Repositories.RDS;
using generate.core.Models.RDS;
using generate.core.Examples.RDS;

namespace generate.test.Infrastructure.Repositories
{
    public class RDSRepositoryShould
    {
        private readonly int id = 1;
        private DimAge expected;

        private RDSDbContext GetContext()
        {

            var options = new DbContextOptionsBuilder<infrastructure.Contexts.RDSDbContext>()
                              .UseInMemoryDatabase(Guid.NewGuid().ToString())
                              .Options;

            var logger = Mock.Of<ILogger<RDSDbContext>>();

            var appSettings = Mock.Of<IOptions<AppSettings>>();

            var context = new RDSDbContext(options, logger, appSettings);

            return context;
        }


        private RDSDbContext GetContextWithData()
        {

            var context = this.GetContext();

            var repository = new RDSRepository(context);
            this.expected = DimAgeExample.GetExample(id);

            repository.Create(expected);
            repository.SaveAsync();

            return context;
        }


        /// <summary>
        /// Verify properties
        /// </summary>
        /// <param name="expected"></param>
        /// <param name="actual"></param>
        private void Verify(DimAge expected, DimAge actual)
        {
            Assert.NotNull(actual);

            Assert.Equal(expected.DimAgeId, actual.DimAgeId);

            Assert.Equal(expected.AgeCode, actual.AgeCode);
            Assert.Equal(expected.AgeDescription, actual.AgeDescription);
            Assert.Equal(expected.AgeValue, actual.AgeValue);

        }

        /// <summary>
        /// Verify IEnumerable
        /// </summary>
        /// <param name="expected"></param>
        /// <param name="actual"></param>
        private void ValidateIEnumerable(DimAge expected, IEnumerable<DimAge> actual)
        {

            Assert.NotNull(expected);
            Assert.NotNull(actual);
            Assert.NotEmpty(actual);

            var actualItem = actual.FirstOrDefault(i => i.DimAgeId == expected.DimAgeId);
            Verify(expected, actualItem);

        }


        [Fact]
        public void Create()
        {

            using (var context = GetContext())
            {
                var repository = new RDSRepository(context);

                // Create
                this.expected = DimAgeExample.GetExample(id);
                repository.Create(expected);
                repository.SaveAsync();

                // Get
                var actual = context.DimAges.FirstOrDefault();

                // Verify
                Verify(expected, actual);

            }
        }


        [Fact]
        public void GetAll()
        {

            using (var context = GetContextWithData())
            {

                var repository = new RDSRepository(context);

                // Get
                var returnValue = repository.GetAll<DimAge>(0, 0);

                // Verify
                ValidateIEnumerable(expected, returnValue);

                // test skip
                var skip = 1;

                returnValue = repository.GetAll<DimAge>(skip, 1);

                Assert.Empty(returnValue);

            }
        }
               
        [Fact]
        public void Delete()
        {

            using (var context = GetContextWithData())
            {

                var repository = new RDSRepository(context);

                // Get
                var existingList = repository.GetAll<DimAge>(0, 1);

                Assert.NotNull(existingList);
                Assert.NotEmpty(existingList);

                // Delete
                int id = existingList.FirstOrDefault().DimAgeId;
                repository.Delete<DimAge>(id);
                repository.SaveAsync();

                // Get
                var returnValue = repository.GetAll<DimAge>(0, 1);

                // Verify
                Assert.Empty(returnValue);


            }
        }


        [Fact]
        public void Update()
        {

            using (var context = GetContextWithData())
            {

                var repository = new RDSRepository(context);

                // Get
                var existingList = repository.GetAll<DimAge>(0, 1);

                Assert.NotNull(existingList);
                Assert.NotEmpty(existingList);

                // Update
                var existing = existingList.FirstOrDefault();
                Assert.NotNull(existing);

                var updated = DimAgeExample.GetUpdatedExample(existing);
                repository.Update(updated);
                repository.SaveAsync();

                // Get
                var returnValue = repository.GetAll<DimAge>(0, 1);

                // Verify
                ValidateIEnumerable(updated, returnValue);

            }
        }



    }

}
