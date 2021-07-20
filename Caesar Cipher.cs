using System;
using System.Collections.Generic;
using System.IO;
class Solution {
    static void Main(String[] args) {
        /* Enter your code here. Read input from STDIN. Print output to STDOUT. Your class should be named Solution */
        var length = int.Parse(Console.ReadLine());
        var s = Console.ReadLine();
        var k = int.Parse(Console.ReadLine());
        
        foreach (var c in s)
        {
            if (!((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')))
            {
                Console.Write(c);
            }
            else
            {
                var isLower = (c >= 'a' && c <= 'z');
                
                var c1 = c.ToString().ToLower()[0];
                
                c1 += (char)(k % 26);
                
                if (c1 > 'z')
                {
                    c1 -= (char)26;
                }
                
                if (!isLower)
                {
                    c1 = c1.ToString().ToUpper()[0];
                }
                
                Console.Write(c1);
            }
        }
        
        Console.WriteLine();
    }
}