
using System;
using System.Collections.Generic;

class Scanner
{
    string[] s;
    int i;

    char[] cs = new char[] { ' ' };

    public Scanner()
    {
        s = new string[0];
        i = 0;
    }

    public string next()
    {
        if (i < s.Length) return s[i++];
        s = Console.ReadLine().Split(cs, StringSplitOptions.RemoveEmptyEntries);
        i = 0;
        return s[i++];
    }

    public int nextInt()
    {
        return int.Parse(next());
    }

    public long nextLong()
    {
        return long.Parse(next());
    }

}

class Solution
{
    Scanner cin;

    public static void Main()
    {
        new Solution().calc();
    }

    class C
    {
        public long hash;
        public bool flag;
        public int[] nums;

        public C(int[] _nums)
        {
            flag = false;
            nums = (int[])_nums.Clone();
        }

        public long gethash()
        {
            if (flag) return hash;
            hash = 0; flag = true;
            foreach (var item in nums)
            {
                hash = hash * (long)12361717111 + item * (long)738173493019;
            }
            return hash;
        }
