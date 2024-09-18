using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Dynamic;
using System.ComponentModel;

namespace generate.shared.Utilities
{
    public static class DynamicClassObject
    {
        public static void AddProperty(string name, object value, dynamic Instance)
        {
            ((IDictionary<string, object>)Instance).Add(name, value);
        }

        public static string GetProperty(string name, dynamic Instance)
        {
            if (((IDictionary<string, object>)Instance).ContainsKey(name))
                return ((IDictionary<string, object>)Instance)[name].ToString();
            else
                return null;
        }

    }
}
