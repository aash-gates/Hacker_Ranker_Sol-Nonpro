using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
class Solution
{

    static void Main(String[] args)
    {
        int q = Convert.ToInt32(Console.ReadLine());
        for (int a0 = 0; a0 < q; a0++)
        {
            char[] hr = new char[10] { 'h', 'a', 'c', 'k', 'e', 'r', 'r', 'a', 'n', 'k' };
            char[] sArray = Console.ReadLine().ToCharArray();
            bool status = true;
            for (int i = 0; i < hr.Length; i++)
            {
                char symbol = hr[i];
                int index = Array.FindIndex(sArray, s => s == symbol);
                if (index < 0)
                {
                    status = false;
                    break;
                }
                var newArr = new char[sArray.Length - index - 1];
                Array.Copy(sArray, index+1, newArr, 0, sArray.Length-index-1);
                sArray = newArr;
            }
            Console.WriteLine(status?"YES":"NO");
        }
    }
}