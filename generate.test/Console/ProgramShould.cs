using generate.console;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace generate.test.Console
{
    public class ProgramShould
    {
        [Fact]
        public void GetHelpText()
        {
            var result = Program.GetHelpText();

            Assert.NotNull(result);
        }

        [Fact]
        public void RunTask_Invalid()
        {
            List<string> args = new List<string>();
            args.Add("invalid");

            Program.RunTask(args, "development");

            // No need to assert conditions -- we are just making sure that no exception occurs

        }

        [Fact]
        public void RunTask_Help()
        {
            List<string> args = new List<string>();
            args.Add("help");

            Program.RunTask(args, "development");

            // No need to assert conditions -- we are just making sure that no exception occurs

        }

    }
}
