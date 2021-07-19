using System;
using System.Collections.Generic;
using System.IO;
class Solution {
    static void Main(String[] args) {
        /* Enter your code here. Read input from STDIN. Print output to STDOUT. Your class should be named Solution */
        var V = Convert.ToInt32(Console.ReadLine());
        var n = Convert.ToInt32(Console.ReadLine());
        var ar = Console.ReadLine();
        int _a_item;
        var ar_split = ar.Split(' ');
        var _a = new int [n];
        for(var _a_i = 0; _a_i < ar_split.Length; _a_i++) {
            _a_item = Convert.ToInt32(ar_split[_a_i]);
            _a[_a_i] = _a_item;
        }
        
        for(var i = 0; i < _a.Length; i++)
        {
            if(_a[i] == V)
            {
                Console.WriteLine(i);
                return;
            } 
        }
    }
}