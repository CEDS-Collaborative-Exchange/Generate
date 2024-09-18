using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.test.Core.Utilities
{
    public class TestIndexedObject
    {
        private readonly string[] strings = { "abc", "def", "ghi", "jkl" };
        public string this[int Index]
        {
            get
            {
                return strings[Index];
            }
            set
            {
                strings[Index] = value;
            }
        }
    }

}
