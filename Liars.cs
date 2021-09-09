
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
    }

    void calc()
    {
        cin = new Scanner();
        int N = cin.nextInt();
        int M = cin.nextInt();
        int[] start = new int[M];
        int[] goal = new int[M];
        int[] need = new int[M];
        for (int i = 0; i < M; i++)
        {
            start[i] = cin.nextInt() - 1;
            goal[i] = cin.nextInt() - 1;
            need[i] = cin.nextInt();
        }
        List<C> cl = new List<C>();
        C first = new C(new int[M]);
        Dictionary<long, int> min = new Dictionary<long, int>();
        Dictionary<long, int> max = new Dictionary<long, int>();
        min[first.gethash()] = max[first.gethash()] = 0;
        cl.Add(first);
        List<int> l = new List<int>();
        for (int i = 0; i < N; i++)
        {
            List<int> rem = new List<int>();
            for (int j = 0; j < M; j++)
            {
                if (start[j] == i) l.Add(j);
                if (goal[j] == i) rem.Add(j);
            }
            Dictionary<long, int> nmin = new Dictionary<long, int>();
            Dictionary<long, int> nmax = new Dictionary<long, int>();
            List<C> ncl = new List<C>();
            foreach (var now in cl)
            {
                int[] nums = (int[])now.nums.Clone();
                int mi = min[now.gethash()];
                int ma = max[now.gethash()];

                for (int k = 0; k < 2; k++)
                {
                    bool ok = true;
                    if (k == 1)
                    {
                        foreach (var item in l)
                        {
                            nums[item] += 1;
                        }
                    }
                    foreach (var item in rem)
                    {
                        if (nums[item] != need[item])
