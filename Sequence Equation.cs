using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Solution {
class Solution {
    static void Main(string[] args) {
         var n = int.Parse(Console.ReadLine());
            string[] p_temp = Console.ReadLine().Split(' ');
            int[] p = Array.ConvertAll(p_temp, Int32.Parse);

            
            for (int i = 0; i < n; i++)
            {
                var x = i + 1;
                for (int j = 0; j < n; j++)
                {
                    if (x == p[p[j] - 1])
                    {
                        Console.WriteLine(j + 1);
                    }
                }
            }
    }
}
}