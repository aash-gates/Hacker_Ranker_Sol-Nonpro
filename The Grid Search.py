using System;
using System.Collections.Generic;
using System.IO;
class Solution
{
    static void Main(String[] args)
    {
        /* Enter your code here. Read input from STDIN. Print output to STDOUT. Your class should be named Solution */
        int tests = Convert.ToInt32(Console.ReadLine());
        for (int t = 0; t < tests; t++)
        {
            List<string> grid = new List<string>();
            List<string> pattern = new List<string>();
            bool contains = false;
            string[] rc = Console.ReadLine().Split();
            int rows = Convert.ToInt32(rc[0]);
            int columns = Convert.ToInt32(rc[1]);
            for (int r = 0; r < rows; r++)
            {
                grid.Add(Console.ReadLine());
            }
            string[] prc = Console.ReadLine().Split();
            int prows = Convert.ToInt32(prc[0]);
            int pcolumns = Convert.ToInt32(prc[1]);
            for (int r = 0; r < prows; r++)
            {
                pattern.Add(Console.ReadLine());
            }
            for (int i = 0; i < grid.Count; i++)
            {
                if(grid[i].Contains(pattern[0]))
                {
                    for (int j = 1; j < pattern.Count; j++)
                    {
                        if(!grid[i+j].Contains(pattern[j]))
                        {
                            break;
                        }
                        if (j == pattern.Count - 1)
                        {
                            contains = true;
                        }
                    }
                }
            }
            if (contains)
                Console.Out.WriteLine("YES");
            else
                Console.Out.WriteLine("NO");
        }
    }
}