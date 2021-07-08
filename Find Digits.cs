using System;
using System.Collections.Generic;
using System.IO;
class Solution {
    static void Main(String[] args) {
        /* Enter your code here. Read input from STDIN. Print output to STDOUT. Your class should be named Solution */
        
        int T=Convert.ToInt32(Console.ReadLine());
        
        for (int i=0;i<T;i++){
            string broj=Console.ReadLine();
            
            int N=Convert.ToInt32(broj);
            
            int counter=0;
            
            for (int j=0;j<broj.Length;j++){
                int znamenka=Convert.ToInt32(broj.Substring(j,1));
                
                if (znamenka!=0 && N%znamenka==0){
                    counter++;
                }
            }
            
            Console.WriteLine(counter.ToString());
        }
    }
}