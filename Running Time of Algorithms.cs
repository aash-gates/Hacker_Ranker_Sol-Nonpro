using System;
using System.Collections.Generic;
using System.IO;
class Solution
{
    static void Main(String[] args)
    {
        /* Enter your code here. Read input from STDIN. Print output to STDOUT. Your class should be named Solution */
        int _ar_size;
        _ar_size = Convert.ToInt32(Console.ReadLine());
        int[] _ar = new int[_ar_size];
        string input = Console.ReadLine();
        string[] inputs = input.Split(' ');

        for (int _ar_i = 0; _ar_i < _ar_size; _ar_i++)
        {
            _ar[_ar_i] = Convert.ToInt32(inputs[_ar_i]);
        }

        Console.WriteLine(InsertionSort(_ar));
    }
    public static int InsertionSort(int[] array)
    {
        int n = array.Length;
        int count = 0;
        for (int i = 1; i < n; i++)
        {
            for (int j = i - 1; j >= 0 && array[j] > array[j + 1]; j--)
            {
                swap(ref array[j], ref array[j + 1]);
                count++;
            }
        }

        return count;
    }

    private static void swap(ref int a, ref int b)
    {
        int temp = a;
        a = b;
        b = temp;
    }
}