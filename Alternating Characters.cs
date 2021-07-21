using System;

namespace AlternatingCharacters
{
    class Program
    {
        static void Main(string[] args)
        {
            int t = int.Parse(Console.ReadLine());
            for (int i = 0; i < t; i++)
            {
                HandleTestCase();
            }
        }

        static void HandleTestCase()
        {
            string str = Console.ReadLine();
            int deletions = 0;
            char lastChar = 'C';
            for (int i = 0; i < str.Length; i++)
            {
                if (str[i] == lastChar)
                {
                    deletions++;
                }
                lastChar = str[i];
            }

            Console.WriteLine(deletions);
        }
    }
}