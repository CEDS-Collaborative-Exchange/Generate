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

    public class DynamicConversionShould
    {

        [Fact]
        public void ToConcrete()
        {
            var expected = new TestObject()
            {
                Id = 1
            };

            var expando = new ExpandoObject();
            DynamicClassObject.AddProperty("Id", 1, expando);
            DynamicClassObject.AddProperty("Test", 2, expando);

            TestObject actual = (TestObject)DynamicConversion.ToConcrete<TestObject>(expando);

            Assert.IsType<TestObject>(actual);
            Assert.Equal(expected.Id, actual.Id);
        }

        [Fact]
        public void ToExpando()
        {
            var expected = new ExpandoObject();
            DynamicClassObject.AddProperty("Id", 1, expected);

            var actualObject = new TestObject()
            {
                Id = 1
            };

            ExpandoObject actual = DynamicConversion.ToExpando(actualObject);

            Assert.IsType<ExpandoObject>(actual);

            var expectedProperty = DynamicClassObject.GetProperty("Id", expected);
            var actualProperty = DynamicClassObject.GetProperty("Id", actual);
            
            Assert.Equal(expectedProperty, actualProperty);
        }

    }
}
