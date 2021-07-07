using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication7
{
    class Solution
    {
        static void Main(string[] args)
        {
            var n = Convert.ToInt32(Console.ReadLine());

            var result = 0;

            var currentNum = 5;

            for (int i = 0; i < n; i++)
            {
                currentNum = currentNum / 2;
                result += currentNum;
                currentNum *= 3;
            }

            Console.WriteLine(result);
        }
    }
}