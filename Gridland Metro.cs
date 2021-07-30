using System;
using System.Collections.Generic;
using System.IO;
struct Interval
    {
        public int Start { get; }
        public int End { get; }

        public int Size => End - Start + 1;

        public Interval(int c1, int c2)
        {
            Start = Math.Min(c1, c2);
            End = Math.Max(c1, c2);
        }

        public bool Intersect(Interval interval)
        {
            return (interval.Start <= Start && Start <= interval.End) ||
                   (Start <= interval.Start && interval.Start <= End);
        }
    }
class Solution {
    static void Main(String[] args) {
        int[] nmk = Array.ConvertAll(Console.ReadLine().Split(' '), int.Parse);
            int n = nmk[0];
            int m = nmk[1];
            int k = nmk[2];
            long result = n;
            result *= m;
            Dictionary<int, List<Interval>> d = new Dictionary<int, List<Interval>>();
            for (int i = 0; i < k; i++)
            {
                int[] rc12 = Array.ConvertAll(Console.ReadLine().Split(' '), int.Parse);
                List<Interval> l;
                int row = rc12[0];

                if (d.TryGetValue(row, out l))
                {
                    l.Add(new Interval(rc12[1], rc12[2]));
                }
                else
                {
                    l = new List<Interval>();
                    l.Add(new Interval(rc12[1], rc12[2]));
                    d.Add(row, l);
                }
            }

            foreach (var l in d.Values)
            {
                result -= Occupied(l);
            }

            Console.WriteLine(result);
    }
    static int Occupied(List<Interval> l)
        {
            LinkedList<Interval> resultl = new LinkedList<Interval>();
            resultl.AddFirst(l[0]);

            for (int i = 1; i < l.Count; i++)
            {
                var current = l[i];
                LinkedList<Interval> prev = resultl;
                resultl = new LinkedList<Interval>();
                foreach (var interval in prev)
                {
                    if (current.Intersect(interval))
                    {
                        current = new Interval(Math.Min(current.Start, interval.Start),
                            Math.Max(current.End, interval.End));
                    }
                    else
                    {
                        if (current.Start < interval.Start)
                        {
                            resultl.AddLast(current);
                            current = interval;
                        }
                        else
                        {
                            resultl.AddLast(interval);
                        }
                    }
                }
                resultl.AddLast(current);
            }

            int result = 0;

            foreach (var interval in resultl)
            {
                result += interval.Size;
            }

            return result;
        }
}