using System;
using System.Collections.Generic;
namespace Solution
{
    class Solution
    {
        static void Main(string[] args)
        {
            var line1 = System.Console.ReadLine().Trim().Split();
            var N = Int32.Parse(line1[0]);
            var T = Int32.Parse(line1[1]);
            line1 = System.Console.ReadLine().Trim().Split();

            int[] w = new int[N];
            for (var i = 0; i < N; i++)
            {
                w[i] = int.Parse(line1[i]);
            }
            for (int i = 0; i < T; i++)
            {
                line1 = System.Console.ReadLine().Trim().Split();
                var a = int.Parse(line1[0]);
                var b = int.Parse(line1[1]);
                int min = int.MaxValue;
                for (int k = a; k <= b; k++)
                {
                    if (w[k] < min)
                    {
                        min = w[k];
                    }
                }
                System.Console.WriteLine(min);
            }
        }
    }
}