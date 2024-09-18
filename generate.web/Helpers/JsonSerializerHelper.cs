using generate.core.Dtos.App;
using generate.core.Models.RDS;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json.Serialization;
using System;
using System.Reflection;
using System.Runtime.Remoting;

public static class ControllerExtensions
{
    public static ContentResult JsonWithoutEmptyProperties<T>(this ControllerBase controller, T obj)
    {
        var settings = new JsonSerializerSettings
        {
            ContractResolver = new ShouldSerializeContractResolver()
        };

        var json = JsonConvert.SerializeObject(obj, settings);
        json = json.Replace("isO6392LANGUAGECODE", "iso6392languagecode");

        return new ContentResult
        {
            Content = json,
            ContentType = "application/json",
        };
    }

    private class ShouldSerializeContractResolver : CamelCasePropertyNamesContractResolver
    {
        protected override JsonProperty CreateProperty(MemberInfo member, MemberSerialization memberSerialization)
        {
            var property = base.CreateProperty(member, memberSerialization);

            if (property.PropertyType == typeof(string))
            {
                property.ShouldSerialize = instance =>
                {
                    if (instance.GetType() != typeof(GenerateReportDataDto)
                        && instance.GetType() != typeof(GenerateReportStructureDto)
                        && instance.GetType() != typeof(CategorySetDto)
                        && instance.GetType() != typeof(CategorySetCategoryOptionDto)
                        && instance.GetType() != typeof(ReportEDFactsOrganizationCount))
                    {
                        var value = member is PropertyInfo ? ((PropertyInfo)member).GetValue(instance) : ((FieldInfo)member).GetValue(instance);
                        return value != null && !string.IsNullOrEmpty(value.ToString());
                    }
                    else
                    {
                        return true;
                    }
                };
            }

            return property;
        }
    }
}
