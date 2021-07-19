using System;
using System.Collections.Generic;
using System.IO;
class Solution {

/* Head ends here */

static void insertionSort(int[] ar) {
    int n = ar.Length;
            for (int i = 1; i < n; i++)
            {
                for (int j = i-1; j >=0 && ar[j]>(ar[j+1]); j--)
                {
                    swap(ref ar[j], ref ar[j + 1]);
                }
                PrintArray(ar);
            }

}
    
static void swap(ref int a, ref int b)
{
    int temp = a;
    a = b;
    b = temp;
}
    
static void PrintArray(int[] ar)
{
    int length = ar.Length;
    for (int i = 0; i < length; i++)
    {
        Console.Write(ar[i] + " ");
    }
    Console.WriteLine();
}


/* Tail starts here */
static void Main(String[] args) {
   
        int _ar_size;
        _ar_size = Convert.ToInt32(Console.ReadLine());
        int[] _ar = new int[_ar_size];
        string input = Console.ReadLine();
        string[] inputs = input.Split(' ');

        for (int _ar_i = 0; _ar_i < _ar_size; _ar_i++)
        {
            _ar[_ar_i] = Convert.ToInt32(inputs[_ar_i]);
        }

        insertionSort(_ar);
   
}
    }