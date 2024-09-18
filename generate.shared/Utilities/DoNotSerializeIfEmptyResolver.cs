using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace generate.shared.Utilities
{
    public class DoNotSerializeIfEmptyResolver : DefaultContractResolver
    {
        public static readonly DoNotSerializeIfEmptyResolver Instance = new DoNotSerializeIfEmptyResolver();

        protected override JsonProperty CreateProperty(MemberInfo member, MemberSerialization memberSerialization)
        {
            JsonProperty property = base.CreateProperty(member, memberSerialization);

            if (property.PropertyType.ToString().Contains("System.Collections"))
            {
                property.ShouldSerialize =
                    instance => (instance?.GetType().GetProperty(property.PropertyName).GetValue(instance) as IEnumerable<object>)?.Count() > 0;
            }

            return property;
        }
    }
}
