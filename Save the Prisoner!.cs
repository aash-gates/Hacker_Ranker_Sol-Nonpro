using System;
using System.Collections.Generic;
using System.IO;
class Solution
{
    static void Main(String[] args)
    {
        var T = Convert.ToInt32(Console.ReadLine());

        for (int i = 0; i < T; i++)
        {
            var str = Console.ReadLine().Split(' ');

            var N = Convert.ToInt32(str[0]);
            var M = Convert.ToInt32(str[1]);
            var S = Convert.ToInt32(str[2]);

            var r = (M + S - 1) % N;

            if (r == 0)
                r = N;
            Console.WriteLine(r);
        }
    }
}