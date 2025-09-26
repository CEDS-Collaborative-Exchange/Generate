namespace generate.overnighttest
{
    public class Program
    {
        protected Program()
        {

        }

        public static void Main(string[] args)
        {
            Worker worker = new(args);
            worker.Start();

        }
    }

}

