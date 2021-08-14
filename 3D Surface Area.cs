using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
class Solution {

     static int surfaceArea(int[][] A)
        {
            int area = 0;
            // Complete this function
            for (int i = 0; i < A.Length; i++)
            {
                for (int j = 0; j < A[i].Length; j++)
                {
                    area += A[i][j] * 4 + 2;
                    if(i>0)
                    {
                        area -= Math.Min(A[i - 1][j], A[i][j]) * 2;
                    }
                    if (j > 0)
                    {
                        area -= Math.Min(A[i][j - 1], A[i][j]) * 2;
                    }
                }
            }
            return area;
        }

    static void Main(String[] args) {
        string[] tokens_H = Console.ReadLine().Split(' ');
        int H = Convert.ToInt32(tokens_H[0]);
        int W = Convert.ToInt32(tokens_H[1]);
        int[][] A = new int[H][];
        for(int A_i = 0; A_i < H; A_i++){
           string[] A_temp = Console.ReadLine().Split(' ');
           A[A_i] = Array.ConvertAll(A_temp,Int32.Parse);
        }
        int result = surfaceArea(A);
        Console.WriteLine(result);
    }
}