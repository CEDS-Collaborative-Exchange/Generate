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
            protected override string ResolvePropertyName(string name)

            {
                var fields  = new List<string> { "TITLE1PROGRAMTYPE", "TITLE1INSTRUCTIONALSERVICES", "TITLE1SUPPORTSERVICES","TITLE1SCHOOLSTATUS","MOBILITYSTATUS12MO", "SECTION504PROGRAM" };

                if (fields.Contains(name))
                {
                    return name.ToLower();
                }               
                else return base.ResolvePropertyName(name);
            }
        }
    }


}