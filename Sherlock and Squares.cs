using System;
using System.Collections.Generic;
using System.IO;
class Solution {
    static void Main(String[] args) {
        /* Enter your code here. Read input from STDIN. Print output to STDOUT. Your class should be named Solution */
      var testCases = int.Parse(Console.ReadLine());
      
      for(var i = 0; i < testCases; i++)
      {
        var input = Console.ReadLine().Split();
        var A = int.Parse(input[0]);
        var B = int.Parse(input[1]);
        var sqrA = Math.Ceiling(Math.Sqrt(A));
        var sqrB = Math.Floor(Math.Sqrt(B));
        var squares = 0;
        
        for(var j = sqrA; j <= sqrB; j++)
        {
          var square = j*j;
          
          if (square >= A && square <= B)
            squares++;
        }
        
        Console.WriteLine(squares);
      }
    }
}