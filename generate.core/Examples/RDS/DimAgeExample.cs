using generate.core.Models.RDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Examples.RDS
{
    public static class DimAgeExample
    {
        public static DimAge GetExample(int? id = null)
        {
            if (!id.HasValue)
            {
                id = 1;
            }

            DimAge example = new DimAge()
            {
                 DimAgeId = (int)id,
                 AgeCode = "AGE01",
                 AgeDescription = "Age 1",
                 AgeValue = 1
            };

            return example;
        }

        public static DimAge GetUpdatedExample(DimAge existing)
        {
            existing.AgeDescription = "Updated";

            return existing;
        }
    }
}
