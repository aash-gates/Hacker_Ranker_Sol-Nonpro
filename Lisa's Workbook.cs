using System;
using System.Collections.Generic;
using System.IO;
class Solution {
    static void Main(String[] args) {
        string[] line = Console.ReadLine().Split(' ');
        int N = Int32.Parse(line[0]);
        int K = Int32.Parse(line[1]);
        line = Console.ReadLine().Split(' ');
        int page = 1;
        int cnt = 0;
        for(int i=0; i<N; i++) {
            int Ps= Int32.Parse(line[i]);
            for(int j=1; j<=Ps; j+=K) {
                if(page >= j && page <= Math.Min(Ps,j+K-1)) {
                    cnt++;
                }
                page++;
            }
        }
        Console.WriteLine(cnt);
    }
}