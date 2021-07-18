using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AlmostSorted
{
    class Program
    {
        static void Main(string[] args)
        {
            int n = int.Parse(Console.ReadLine());
            int[] arr = new int[n];

            string[] split = Console.ReadLine().Split(' ');
            for (int i = 0; i < n; i++)
            {
                arr[i] = int.Parse(split[i]);
            }

            int s = 1;
            while (s < n && arr[s] >= arr[s - 1])
            {
                s++;
            }

            if (s == n)
            {
                Console.WriteLine("yes");
                return;
            }

            int e = n - 2;
            while (e >= 0 && arr[e] <= arr[e + 1])
            {
                e--;
            }

            s--;
            e++;

            // Lets try swapping
            int temp = arr[s];
            arr[s] = arr[e];
            arr[e] = temp;

            if (s > 0 && arr[s] < arr[s - 1])
            {
                Console.WriteLine("no");
                return;
            }

            if (e < n - 1 && arr[e] > arr[e + 1])
            {
                Console.WriteLine("no");
                return;
            }

            // Is it assending from s to e?
            bool isAscending = true;
            for (int i = s + 1; i <= e; i++)
            {
                if (arr[i] < arr[i - 1])
                {
                    isAscending = false;
                    break;
                }
            }

            if (isAscending)
            {
                Console.WriteLine("yes");
                Console.WriteLine("swap {0} {1}", s+1, e+1);
                return;
            }

            // Lets try reverse
            temp = arr[s];
            arr[s] = arr[e];
            arr[e] = temp;

            isAscending = true;
            for (int i = e - 1; i >= s; i--)
            {
                if (arr[i] < arr[i + 1])
                {
                    isAscending = false;
                    break;
                }
            }

            if (isAscending)
            {
                Console.WriteLine("yes");
                Console.WriteLine("reverse {0} {1}", s + 1, e + 1);
                return;
            }

            Console.WriteLine("no");
        }
    }
}