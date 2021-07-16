using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
class Solution {

    static void Main(String[] args) {
        string[] tokens_n = Console.ReadLine().Split(' ');
        int n = Convert.ToInt32(tokens_n[0]);
        int m = Convert.ToInt32(tokens_n[1]);
        string[] c_temp = Console.ReadLine().Split(' ');
        int[] c = Array.ConvertAll(c_temp,Int32.Parse);
        
        Array.Sort(c);
        
        int max_distance = 0;
           
        for(int i = 0; i < n; i++){
            int left_d = n-1;
            int right_d = n-1;
            if(i > 0){
                for(int j = 0; j < m; j++){
                    if(c[j] > i)
                        break;
                    left_d = i - c[j];
                }
            }
                
            if(i < n){
                for(int j = m-1; j >= 0; j--){
                    if(c[j] < i)
                        break;
                    right_d = c[j] - i;
                }
            }
            
            max_distance = Math.Max(max_distance, Math.Min(left_d,right_d));
        }
        
        Console.WriteLine(max_distance);
    }
}