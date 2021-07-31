using System;
using System.Collections.Generic;
using System.IO;
class Solution {
/* Head ends here */
static int pairs(int[] a, int k) {

    return 0;
    }
/* Tail starts here */
static void Main(String[] args) {
        /* Enter your code here. Read input from STDIN. Print output to STDOUT. Your class should be named Solution 
         */
        string NandKStr = Console.ReadLine();
        string[] initValue = NandKStr.Split(' ');
        int N = Convert.ToInt32(initValue[0]);
        int K = Convert.ToInt32(initValue[1]);
        string[] numberStrs = Console.ReadLine().Split(' ');
        List<int> numbers = new List<int>();
        foreach (string numberStr in numberStrs)
        {
            try
            {
                numbers.Add(Convert.ToInt32(numberStr));
            }
            catch (Exception)
            {
            }
        }
        numbers.Sort();
        int i = 0;
        int j = 0;
        int result = 0;
        while (i < numbers.Count)
        {
            int dist = numbers[i] - numbers[j];
            if (dist == K)
            {
                result++;
                i++;
            }
            if (dist < K)
            {
                i++;
            }
            else
            {
                j++;
            }
        }
        Console.WriteLine(result);
        
    }
}