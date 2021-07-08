using System;
using System.Collections.Generic;
using System.IO;
class Solution {
    static void Main(String[] args) {
        /* Enter your code here. Read input from STDIN. Print output to STDOUT. Your class should be named Solution */
        
        string[] input=Console.ReadLine().Split(' ');
        
        int N=Convert.ToInt32(input[0]);
        int K=Convert.ToInt32(input[1]);
        int Q=Convert.ToInt32(input[2]);
        
        input=Console.ReadLine().Split(' ');
        
        int[] polje=new int[N];
        
        for (int i=0;i<N;i++){
            polje[i]=Convert.ToInt32(input[i]);        
        }
        
        for (int i=0;i<Q;i++){
            int x=Convert.ToInt32(Console.ReadLine());
            
            int poz=x-K;
            
            while (poz<0){
                poz+=N;                
            }
            
            Console.WriteLine(polje[poz]);
        }
    }
}