using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RepeatedString
{
    class Program
    {
        static void Main(String[] args)
        {
            string s = Console.ReadLine();
            long n = Convert.ToInt64(Console.ReadLine());

            var inSingle = s.Count(x => x == 'a');

            var full = n / s.Length;

            var rest = n % s.Length;

            var inRest = s.Substring(0, (int)rest).Count(x => x == 'a');

            var result = (inSingle * full) + inRest;

            Console.WriteLine(result);

        }
    }
}