using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.infrastructure.Helpers
{
    public static class SqlDataReaderExtensions
    {
        public static string SafeGetString(this SqlDataReader reader, string columnName)
        {
            int index = reader.GetOrdinal(columnName);
            return reader.IsDBNull(index) ? string.Empty : reader.GetString(index);
        }
    }

}
