using System;
using System.Collections.Generic;
using System.IO;
class Solution {
    static void Main(String[] args) {
        /* Enter your code here. Read input from STDIN. Print output to STDOUT. Your class should be named Solution */
        
        int T=Convert.ToInt32(Console.ReadLine());
        
        for (int i=0;i<T;i++){
            int N=Convert.ToInt32(Console.ReadLine());
            
            int rez=1;
            bool pomnozi=true;
            
            while(N>0){
                if (pomnozi){
                    rez*=2;
                }
                else{
                    rez++;
                }
                
                pomnozi=!pomnozi;
                N--;
            }
            
            Console.WriteLine(rez.ToString());
        }
    }
}