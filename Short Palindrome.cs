using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
class Solution {
    static void Main(String[] args) {
        /* Enter your code here. Read input from STDIN. Print output to STDOUT. Your class should be named Solution */
        Console.WriteLine(CountTuples(Console.ReadLine()));
    }
        public static ulong CountTuples(string s)
        {
            const int englishCharCount = 26;
            var charCountRemain = new ulong[englishCharCount];
            var charCountPassed = new ulong[englishCharCount];
            var pairsCombinationsCount = new ulong[englishCharCount, englishCharCount];
            ulong result = 0;
            foreach (var c in s)
                charCountRemain[GetCharNumber(c)]++;

            foreach (var c in s)
            {
                var ci = GetCharNumber(c);
                charCountRemain[ci]--;
                for (var i = 0; i < englishCharCount; i++)
                {

                    result += (pairsCombinationsCount[i, ci] * charCountRemain[i]) % ((ulong)1E9 + 7);
                    pairsCombinationsCount[i, ci] += charCountPassed[i];
                }
                charCountPassed[ci] ++;
            }
            return result % ((ulong)1E9 + 7);
        }
    
        private static int GetCharNumber(char c)
        {
            return  c - 'a';
        }

}