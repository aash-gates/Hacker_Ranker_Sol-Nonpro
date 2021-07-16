using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
class Solution {

    static void Main(String[] args) {
        int N = Convert.ToInt32(Console.ReadLine());
        string[] B_temp = Console.ReadLine().Split(' ');
        int[] B = Array.ConvertAll(B_temp,Int32.Parse);
        
        int loaves = 0;
        for (int i = 0; i < B.Length - 1; ++i) {
            if (B[i] % 2 == 1) {
                loaves += 2;
                B[i]++;
                B[i+1]++;
            }
        }
        
        if (B[B.Length - 1] % 2 == 1) {
            Console.Out.WriteLine("NO");
        } else {
            Console.Out.WriteLine(loaves);
        }
    }
}