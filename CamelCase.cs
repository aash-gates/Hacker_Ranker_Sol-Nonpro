using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
class Solution {

    static void Main(String[] args) {

        string line = Console.ReadLine();

        int ans = 0;
        foreach (var c in line) {
            if (c < 'a') ans++;
        }

        Console.WriteLine(ans+1);
    }
}