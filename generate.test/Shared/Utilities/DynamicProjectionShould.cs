using generate.shared.Utilities;
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace generate.test.Core.Utilities
{

    public class DynamicProjectionShould
    {

        [Fact]
        public void Projection()
        {
            var testObject = new TestObject()
            {
                Id = 1
            };

            List<string> properties = new List<string>();
            properties.Add("Id");
            properties.Add("field");
            properties.Add("Test");

            var actual = DynamicProjection.Projection(testObject, properties);
            
            var actualProperty = DynamicClassObject.GetProperty("Id", actual);
            var expectedProperty = testObject.Id.ToString();

            Assert.Equal(expectedProperty, actualProperty);
        }


        [Fact]
        public void ProjectionIndexedObject()
        {
            var testObject = new TestIndexedObject();

            List<string> properties = new List<string>();
            properties.Add("strings");

            var actual = DynamicProjection.Projection(testObject, properties);

            var actualProperty = DynamicClassObject.GetProperty("strings", actual);

            Assert.Null(actualProperty);
        }





    }
}
