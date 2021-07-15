using System;
using System.Collections.Generic;
using System.IO;
class Solution {
 static string[] numbers = {"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", 
    "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen", "twenty",
    "twenty one", "twenty two", "twenty three", "twenty four", "twenty five", "twenty six", "twenty seven", "twenty eight", "twenty nine"};
        static void Main(String[] args)
        {
            int h = Int32.Parse(Console.ReadLine());
            int m = Int32.Parse(Console.ReadLine());

            if (m == 0)
                Console.WriteLine(numbers[h] + " o' clock");
            else if (m < 30)
            {
                if(m == 1)
                    Console.WriteLine(numbers[m] + " minute past " + numbers[h]);
                else if(m == 15)
                    Console.WriteLine("quarter" + " past " + numbers[h]);      
                else
                    Console.WriteLine(numbers[m] + " minutes past " + numbers[h]);
            }
            else if (m == 30)
            {
                Console.WriteLine("half past " + numbers[h]);
            }
            else if (m < 45)
            {
                if (h + 1 > 12)
                    h -= 12;
                Console.WriteLine(numbers[60 - m] + " minutes to " + numbers[h + 1]);
            }
            else if (m == 45)
            {
                if (h + 1 > 12)
                    h -= 12;
                Console.WriteLine("quarter to " + numbers[h + 1]);
            }
            else if (m < 60)
            {
                if (h + 1 > 12)
                    h -= 12;
                if (60 - m == 1)
                    Console.WriteLine(numbers[60 - m] + " minute to " + numbers[h + 1]);
                else
                    Console.WriteLine(numbers[60 - m] + " minutes to " + numbers[h + 1]);
            }
        }
}