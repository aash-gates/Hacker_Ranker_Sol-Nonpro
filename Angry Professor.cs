using System;
using System.Collections.Generic;
using System.IO;
class Solution {
    static void Main(String[] args) {
        /* Enter your code here. Read input from STDIN. Print output to STDOUT. Your class should be named Solution */
        
        int count = int.Parse(Console.ReadLine());

        for (int i = 0; i < count; i++)
        {
            string[] nk = Console.ReadLine().Trim().Split(' ');

            int numstudents = int.Parse(nk[0]);
            int minnumber = int.Parse(nk[1]);

            string[] students = Console.ReadLine().Trim().Split(' ');
            System.Diagnostics.Debug.Assert(students.Length == numstudents);

            int earlystudents = 0;
            foreach (string item in students)
            {
                int time = int.Parse(item);

                if (time <= 0)
                    earlystudents++;
            }

            if (earlystudents >= minnumber)
                Console.WriteLine("NO");
            else
                Console.WriteLine("YES");
        }
    }
}