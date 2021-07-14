using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
class Solution {

    static void Main(String[] args) {
        int n = Convert.ToInt32(Console.ReadLine());
        string[] A_temp = Console.ReadLine().Split(' ');
        int[] A = Array.ConvertAll(A_temp,Int32.Parse);
        
        int min = int.MaxValue;
        for(int i=0;i<n-1;i++){
            for(int j=i+1;j<n;j++){
                if(A[i]==A[j]){
                    int d = j-i;
                    if(d<min)min=d;
                }
            }
        }
        if(min==int.MaxValue) Console.WriteLine(-1);
        else Console.WriteLine(min);
    }
}