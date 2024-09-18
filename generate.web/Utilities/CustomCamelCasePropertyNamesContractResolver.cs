using Newtonsoft.Json.Serialization;
using System.Collections.Generic;

namespace generate
{

    class CustomCamelCasePropertyNamesContractResolver : DefaultContractResolver
    {
        public CustomCamelCasePropertyNamesContractResolver()
        {
            this.NamingStrategy = new CustomNamingStrategy();
        }

        class CustomNamingStrategy : CamelCaseNamingStrategy
        {
            protected override string ResolvePropertyName(string propertyName)

            {
                var fields  = new List<string> { "TITLE1PROGRAMTYPE", "TITLE1INSTRUCTIONALSERVICES", "TITLE1SUPPORTSERVICES","TITLE1SCHOOLSTATUS","MOBILITYSTATUS12MO", "SECTION504PROGRAM" };

                if (fields.Contains(propertyName))
                {
                    return propertyName.ToLower();
                }               
                else return base.ResolvePropertyName(propertyName);
            }
        }
    }


}