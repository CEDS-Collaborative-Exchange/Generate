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
    public class DynamicClassObjectShould
    {

        [Fact]
        public void AddProperty()
        {
            var expando = new ExpandoObject();

            DynamicClassObject.AddProperty("test", "value", expando);

            var actual = ((dynamic)expando).test;

            Assert.Equal("value", actual);
        }

        [Fact]
        public void GetProperty()
        {
            var expando = new ExpandoObject();

            DynamicClassObject.AddProperty("test", "value", expando);

            var actual = DynamicClassObject.GetProperty("test", expando);

            Assert.Equal("value", actual);
        }

    }
}
