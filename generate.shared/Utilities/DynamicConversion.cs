using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Dynamic;
using System.Reflection;

namespace generate.shared.Utilities
{
    public static class DynamicConversion
    {
        public static object ToConcrete<T>(ExpandoObject dynObject)
        {
            object instance = Activator.CreateInstance<T>();
            var dict = dynObject as IDictionary<string, object>;
            PropertyInfo[] targetProperties = instance.GetType().GetProperties();

            foreach (PropertyInfo property in targetProperties)
            {
                object propVal;
                if (dict.TryGetValue(property.Name, out propVal))
                {
                    property.SetValue(instance, propVal, null);
                }
            }

            return instance;
        }

        public static ExpandoObject ToExpando(object staticObject)
        {
            System.Dynamic.ExpandoObject expando = new ExpandoObject();
            var dict = expando as IDictionary<string, object>;
            PropertyInfo[] properties = staticObject.GetType().GetProperties();

            foreach (PropertyInfo property in properties)
            {
                dict[property.Name] = property.GetValue(staticObject, null);
            }

            return expando;
        }
    }
}
