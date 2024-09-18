using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.RDS;

namespace generate.core.Helpers.ReferenceData
{
    public class DimStateDefinedCustomIndicatorHelper
    {
        public static List<DimStateDefinedCustomIndicator> GetData()
        {


            var data = new List<DimStateDefinedCustomIndicator>();

            //data.Add(new DimStateDefinedCustomIndicator()
            //{
            //    DimStateDefinedCustomIndicatorId = -1,
            //    StateDefinedCustomIndicatorId = -1,
            //    StateDefinedCustomIndicatorCode = "MISSING",
            //    StateDefinedCustomIndicatorDescription = "State Defined Custom Indicator not set "
            //});
            //data.Add(new DimStateDefinedCustomIndicator()
            //{
            //    DimStateDefinedCustomIndicatorId = 1,
            //    StateDefinedCustomIndicatorId = 1,
            //    StateDefinedCustomIndicatorCode = "IND01",
            //    StateDefinedCustomIndicatorDescription = "State Defined Custom Indicator IND01"
            //});
            //data.Add(new DimStateDefinedCustomIndicator()
            //{
            //    DimStateDefinedCustomIndicatorId = 2,
            //    StateDefinedCustomIndicatorId = 2,
            //    StateDefinedCustomIndicatorCode = "IND02",
            //    StateDefinedCustomIndicatorDescription = "State Defined Custom Indicator IND02"
            //});

            return data;

        }
    }
}
 