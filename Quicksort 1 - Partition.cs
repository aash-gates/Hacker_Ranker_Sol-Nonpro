using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

class Solution 
{
    static void Partition(int[] array)
    {
        int p = array[0];
        List<int> right = array.Where(x => x < p).ToList();
        List<int> left = array.Where(x => x > p).ToList();
        
        right.Add(p);
        right.AddRange(left);
    
        Console.WriteLine(String.Concat(right.Select(x => x.ToString() + " ")));
    }
    
    static void Main(String[] args)
    {   
        Console.ReadLine();
    
        Partition(Console.ReadLine().Trim().Split(' ').Select(x => Int32.Parse(x)).ToArray());
    }  
}