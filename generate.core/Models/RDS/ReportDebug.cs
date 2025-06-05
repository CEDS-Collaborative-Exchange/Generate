using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace generate.core.Models.RDS
{
    public class ReportDebug
    {
        public Dictionary<string, object> Fields { get; set; } = new Dictionary<string, object>();
        public object this[string key]
        {
            get => Fields.ContainsKey(key) ? Fields[key] : null;
            set => Fields[key] = value;
        }
        public string ToJson()
        {
            return JsonSerializer.Serialize(Fields);
        }

    }
}
