using generate.shared.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace generate.test.Core.Utilities
{
    public class GenerateExtensionsShould
    {

        [Fact]
        public void AppendFixedWhenNotNullAndLengthSmall()
        {
            var oldString = new StringBuilder("test");

            var actual = GenerateExtensions.AppendFixed(oldString, 3, "x").ToString();
            var expected = "testx  ";

            Assert.Equal(expected, actual);
        }

        [Fact]
        public void AppendFixedWhenNotNullAndLengthLarge()
        {
            var oldString = new StringBuilder("test");

            var actual = GenerateExtensions.AppendFixed(oldString, 3, "1234").ToString();
            var expected = "test123";

            Assert.Equal(expected, actual);
        }

        [Fact]
        public void AppendFixedWhenNull()
        {
            var oldString = new StringBuilder("test");

            var actual = GenerateExtensions.AppendFixed(oldString, 3, null).ToString();
            var expected = "test   ";

            Assert.Equal(expected, actual);
        }

        [Fact]
        public void AppendFixedWhenPaddingEqualsZero()
        {
            var oldString = new StringBuilder("test");

            var actual = GenerateExtensions.AppendFixed(oldString, 3, "123").ToString();
            var expected = "test123  ";

            Assert.Equal(expected, actual);
        }

    }
}
