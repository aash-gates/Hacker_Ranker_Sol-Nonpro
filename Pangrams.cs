using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace hackerrank_101_hack_Aug14
{
    class Program
    {
        static void Main(string[] args)
        {
            string sentence = Console.ReadLine();
            int []A = new int[26];
            for (int i = 0; i < 26; ++i)
                A[i] = 0;
            sentence = sentence.ToLower();
            for(int i = 0; i < sentence.Length; ++i)
            {
                if(sentence[i] != ' ')
                {
                    A[sentence[i] - 'a'] = 1;
                }
            }
            int j = 0;
            for (j = 0; j < 26; ++j)
                if (A[j] == 0)
                    break;
            if (j == 26)
                Console.WriteLine("pangram");
            else
                Console.WriteLine("not pangram");
        }
    }
}