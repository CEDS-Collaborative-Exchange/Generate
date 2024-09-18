using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Text;



namespace generate.shared.Utilities
{
    public static class GenerateExtensions
    {
        public static StringBuilder AppendFixed(this StringBuilder sb, int length, string value)
        {
            if (String.IsNullOrWhiteSpace(value))
                return sb.Append(String.Empty.PadLeft(length));

            if (value.Length <= length)
            {
                int padding = length - value.Length;
                if (padding == 0)
                    padding = 2;
                sb.Append(value);
                sb.Append(String.Empty.PadLeft(padding));
                return sb;
            }
            else
                return sb.Append(value.Substring(0, length));
        }
    }
}
