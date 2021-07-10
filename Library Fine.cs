using System;
using System.Collections.Generic;
using System.IO;
using System.Globalization;

class Solution {
    static void Main(String[] args) {
        /* Enter your code here. Read input from STDIN. Print output to STDOUT. Your class should be named Solution */
        var actual = DateTime.ParseExact(
            Console.ReadLine().Replace(' ', '/'), "d/M/yyyy", CultureInfo.InvariantCulture);
        var expected = DateTime.ParseExact(
            Console.ReadLine().Replace(' ', '/'), "d/M/yyyy", CultureInfo.InvariantCulture);
        
        int fine;
        
        if (actual <= expected)
        {
            Console.WriteLine(0);
        }
        else if (actual.Year != expected.Year)
        {
            Console.WriteLine(10000);
        }
        else if (actual.Month != expected.Month)
        {
            Console.WriteLine((actual.Month - expected.Month) * 500);
        }
        else if (actual.Day != expected.Day)
        {
            Console.WriteLine((actual.Day - expected.Day) * 15);
        }
    }
}