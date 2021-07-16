using System;
using System.Linq;
public class Test
{
    public static void Main()
    {
        // your code goes here
        int n = int.Parse(Console.ReadLine());
        int[,] num = new int[n,n];
        for(int i = 0 ; i < n ; i++){
            string str = Console.ReadLine().Trim();
            for(int j = 0 ; j < n ; j++){
                int x = int.Parse(str[j].ToString());
                num[i,j] = x;
            }
        }
       string output = string.Empty;
        for(int i = 0 ; i < n ; i++){
            output = string.Empty;
            for(int j = 0 ; j < n ; j++){
                if(i == 0 || j == 0 || i == n - 1 || j == n-1)
                     output += num[i,j];
                 else {
                 	if(num[i-1,j] < num[i,j] && num[i+1,j] < num[i,j] && num[i,j+1] < num[i,j] && num[i,j-1] < num[i,j]){
                 		output += "X";
                 	}else{
                 		output += num[i,j];
                 	}
                 }
            }
            Console.WriteLine(output);