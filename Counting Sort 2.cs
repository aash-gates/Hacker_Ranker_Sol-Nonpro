using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace counting
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.ReadLine();
            int[] res = new int[100];

            foreach (int i in Console.ReadLine().Trim().Split(' ').Select(int.Parse))
            {
                res[i]++;
            }
            for (int index = 0; index < res.Length; index++)
            {
                int r = res[index];
                for (int i = 0; i < r; i++)
                {
                    Console.Write("{0} ", index);
                }
            }
        }
    }
}