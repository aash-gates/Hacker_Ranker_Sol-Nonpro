using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
class Solution
{

    static void Main(String[] args)
    {
        int Q = Convert.ToInt32(Console.ReadLine());
        for (int a0 = 0; a0 < Q; a0++)
        {
            int n = Convert.ToInt32(Console.ReadLine());
            string b = Console.ReadLine();
            bool happy = true;
            if (b.Contains('_'))
            {
                int[] counts = new int[26];
                foreach(char c in b)
                {
                    if (c != '_') counts[(int)(c - 'A')]++;
                }
                foreach(int c in counts)
                {
                    if (c == 1)
                    {
                        happy = false;
                        break;
                    }
                }
            }else
            {
                for(int i=0;i<n;i++)
                {
                    if (b[i] != '_')
                    {
                        bool friendleft = i > 0 && b[i - 1] == b[i];
                        bool friendright = i < n - 1 && b[i + 1] == b[i];
                        if (!friendleft && !friendright)
                        {
                            happy = false;
                            break;
                        }
                    }
                }
            }
            Console.WriteLine(happy ? "YES" : "NO");
        }
    }
}