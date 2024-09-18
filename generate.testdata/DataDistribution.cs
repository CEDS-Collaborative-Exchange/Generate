using System;

namespace generate.testdata
{

    public class DataDistribution<T>
    {
        public T Option { get; set; }
        public int ExpectedDistribution { get; set; }
        public int ActualDistribution { get; set; }

    }

}