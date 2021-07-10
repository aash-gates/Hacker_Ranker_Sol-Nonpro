using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CutTheStick
{
    class Program
    {
        static void Main(string[] args)
        {
            int n = int.Parse(Console.ReadLine());
            string[] s = Console.ReadLine().Split(' ');

            int[] sticks = new int[n];
            for (int i = 0; i < n; i++)
                sticks[i] = int.Parse(s[i]);

            Array.Sort(sticks);
            int stick = n;
            int current = sticks[0];
            int count = 1;

            for (int i = 1; i < n; i++)
            {
                if (sticks[i] == current)
                    count++;
                else
                {
                    Console.WriteLine(stick);
                    stick -= count;
                    count = 1;
                    current = sticks[i];
                }
            }
            Console.WriteLine(stick);
        }
    }
}