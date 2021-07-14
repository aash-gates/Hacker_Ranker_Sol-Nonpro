using System;
using System.Collections.Generic;
using System.IO;
class Solution {
    static void Main(String[] args)
        {
            int p = Int32.Parse(Console.ReadLine());
            int q = Int32.Parse(Console.ReadLine());
            bool Found = false;
            for(int i = p; i <= q; i ++)
            {
                if(kaprekar(i))
                    Found = true;
            }
            if (!Found)
                Console.WriteLine("INVALID RANGE");
        }
        static bool kaprekar(Int64 n)
        {
            if (n == 1)
            {
                Console.Write("1 ");
                return true;
            }
            Int64 res = n * n;
            string temp = res.ToString();
            if (temp.Length >= 2)
            {
                Int64 n1 = Int64.Parse(temp.Substring(0, temp.Length / 2));
                Int64 n2 = Int64.Parse(temp.Substring(temp.Length / 2));
                if (n1 + n2 == n && n1 != 0 && n2 != 0)
                {
                    Console.Write(n + " ");
                    return true;
                }
            }
            return false;
        }
}