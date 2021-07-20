using System;
using System.Collections.Generic;
using System.IO;
class Solution {
    static void Main(String[] args) {
        /* Enter your code here. Read input from STDIN. Print output to STDOUT. Your class should be named Solution */
        String s = Console.ReadLine();
        
        bool reduced = false;
        
        do {
            reduced = false;
            
            for (int i = 0; i < s.Length - 1; ) {
                if (s[i] == s[i+1]) {
                    s = s.Substring(0, i) + s.Substring(i + 2);
                    reduced = true;
                }
                else
                    ++i;
            }
        } while (reduced);
        
        if (s.Length == 0)
            Console.Out.WriteLine("Empty String");
        else
            Console.Out.WriteLine(s);
    }
}