using System;
using System.Collections.Generic;
using System.IO;
class Solution
{

    /* Head ends here */

    static void insertionSort(int[] ar)
    {
        if (ar == null)
            return;
        int length = ar.Length;
        int p = ar[length - 1];
        if (length == 1)
            PrintArray(ar);
        for (int i = length - 2; i >= 0; i--)
        {
            if (ar[i] > p)
            {
                ar[i + 1] = ar[i];
                if (i == 0)
                {
                    PrintArray(ar);
                    ar[i] = p;
                }
                PrintArray(ar);
            }
            else
            {
                ar[i + 1] = p;
                PrintArray(ar);
                return;
            }

        }
    }

    static void PrintArray(int[] ar)
    {
        int length = ar.Length;
        for (int i = 0; i < length; i++)
        {
            if (i == length - 1)
                Console.Write(ar[i]);
            else
                Console.Write(ar[i] + " ");
        }
        Console.WriteLine();
    }


    /* Tail starts here */
    static void Main(String[] args)
    {

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
        Console.ReadKey();
    }
}