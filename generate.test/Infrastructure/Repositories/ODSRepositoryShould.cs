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
using generate.infrastructure.Repositories.IDS;
using generate.core.Models.IDS;
using generate.core.Examples.ODS;

namespace generate.test.Infrastructure.Repositories
{
    public class idsRepositoryShould
    {
        private readonly int id = 1;
        private OrganizationDetail expected;

        private IDSDbContext GetContext()
        {

            var options = new DbContextOptionsBuilder<infrastructure.Contexts.IDSDbContext>()
                              .UseInMemoryDatabase(Guid.NewGuid().ToString())
                              .Options;

            var logger = Mock.Of<ILogger<IDSDbContext>>();

            var appSettings = Mock.Of<IOptions<AppSettings>>();

            var context = new IDSDbContext(options, logger, appSettings);

            return context;
        }


        private IDSDbContext GetContextWithData()
        {

            var context = this.GetContext();

            var repository = new IDSRepository(context);
            this.expected = OrganizationDetailExample.GetExample(id);

            repository.Create(expected);
            repository.SaveAsync();

            return context;
        }


        /// <summary>
        /// Verify properties
        /// </summary>
        /// <param name="expected"></param>
        /// <param name="actual"></param>
        private void Verify(OrganizationDetail expected, OrganizationDetail actual)
        {
            Assert.NotNull(actual);

            Assert.Equal(expected.OrganizationDetailId, actual.OrganizationDetailId);

            Assert.Equal(expected.Name, actual.Name);
            Assert.Equal(expected.ShortName, actual.ShortName);

        }

        /// <summary>
        /// Verify IEnumerable
        /// </summary>
        /// <param name="expected"></param>
        /// <param name="actual"></param>
        private void ValidateIEnumerable(OrganizationDetail expected, IEnumerable<OrganizationDetail> actual)
        {

            Assert.NotNull(expected);
            Assert.NotNull(actual);
            Assert.NotEmpty(actual);

            var actualItem = actual.FirstOrDefault(i => i.OrganizationDetailId == expected.OrganizationDetailId);
            Verify(expected, actualItem);

        }


        [Fact]
        public void Create()
        {

            using (var context = GetContext())
            {
                var repository = new IDSRepository(context);

                // Create
                this.expected = OrganizationDetailExample.GetExample(id);
                repository.Create(expected);
                repository.SaveAsync();

                // Get
                var actual = context.OrganizationDetail.FirstOrDefault();

                // Verify
                Verify(expected, actual);

            }
        }


        [Fact]
        public void GetAll()
        {

            using (var context = GetContextWithData())
            {

                var repository = new IDSRepository(context);

                // Get
                var returnValue = repository.GetAll<OrganizationDetail>(0, 0);

                // Verify
                ValidateIEnumerable(expected, returnValue);

                // test skip
                var skip = 1;

                returnValue = repository.GetAll<OrganizationDetail>(skip, 1);

                Assert.Empty(returnValue);

            }
        }
               
        [Fact]
        public void Delete()
        {

            using (var context = GetContextWithData())
            {

                var repository = new IDSRepository(context);

                // Get
                var existingList = repository.GetAll<OrganizationDetail>(0, 1);

                Assert.NotNull(existingList);
                Assert.NotEmpty(existingList);

                // Delete
                int id = existingList.FirstOrDefault().OrganizationDetailId;
                repository.Delete<OrganizationDetail>(id);
                repository.SaveAsync();

                // Get
                var returnValue = repository.GetAll<OrganizationDetail>(0, 1);

                // Verify
                Assert.Empty(returnValue);


            }
        }


        [Fact]
        public void Update()
        {

            using (var context = GetContextWithData())
            {

                var repository = new IDSRepository(context);

                // Get
                var existingList = repository.GetAll<OrganizationDetail>(0, 1);

                Assert.NotNull(existingList);
                Assert.NotEmpty(existingList);

                // Update
                var existing = existingList.FirstOrDefault();
                Assert.NotNull(existing);

                var updated = OrganizationDetailExample.GetUpdatedExample(existing);
                repository.Update(updated);
                repository.SaveAsync();

                // Get
                var returnValue = repository.GetAll<OrganizationDetail>(0, 1);

                // Verify
                ValidateIEnumerable(updated, returnValue);

            }
        }



    }

}
