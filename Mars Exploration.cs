using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
class Solution {

    static void Main(String[] args) {
       string s = Console.ReadLine().Trim();
        int changedLetters = 0;
        for (int i = 0; i < s.Length; i += 3) {
            if (s[i] != 'S') { changedLetters++; }
            if (s[i+1] != 'O') { changedLetters++; }
            if (s[i+2] != 'S') { changedLetters++; }
        }

        Console.WriteLine(changedLetters);
    }
}