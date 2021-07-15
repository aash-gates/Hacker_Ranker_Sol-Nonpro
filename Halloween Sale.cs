using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
class Solution {

    static int howManyGames(int p, int d, int m, int s) {
        int res=0;
        int x=p;
        while(s>=0)
        {
            s-=x;
            x-=d;
            if(x<m)
                x=m;
            res++;
        }
        return res-1;
    }

    static void Main(String[] args) {
        string[] tokens_p = Console.ReadLine().Split(' ');
        int p = Convert.ToInt32(tokens_p[0]);
        int d = Convert.ToInt32(tokens_p[1]);
        int m = Convert.ToInt32(tokens_p[2]);
        int s = Convert.ToInt32(tokens_p[3]);
        int answer = howManyGames(p, d, m, s);
        Console.WriteLine(answer);
    }
}