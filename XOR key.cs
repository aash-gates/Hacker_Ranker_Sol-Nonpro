using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading;

namespace XorKey
{
    class Solution
    {
        static void Main(string[] args)
        {
            int caseCount = int.Parse(Console.ReadLine());
            var timer = new Stopwatch();
            timer.Start();
            for (int i = 0; i < caseCount; i++) {
                ProcessCase(false);
                GC.GetTotalMemory(true);
            }
            Debug("Done in {0}ms.", timer.ElapsedMilliseconds);
            Sleep();
        }

        private static void ProcessCase(bool performanceTest)
        {
            if (performanceTest) {
                var count = 100000;
                var queryCount = 50000;
                var rnd = new Random();
                var xorq = new Xorq(Enumerable.Range(1, count/5)
                    .SelectMany(x => Enumerable.Repeat(x, 5))
                    .Select(i => (short) (i & 0x7FFF))
                    .ToList());
                var timer = new Stopwatch();
                timer.Start();
                for (int i = 0; i < queryCount; i++) {
                    int l = rnd.Next(count);
                    int r = rnd.Next(count);
                    int x = xorq.Query(0, Math.Min(l, r), Math.Max(l, r));
                    if (x!=xorq.Data[Math.Max(l, r)])
                        throw new InvalidOperationException("Wrong result.");
                }
                Debug("  Done in {0}ms.", timer.ElapsedMilliseconds);
            }
            else {
                var nq = ReadSpaceDelimitedSequence().Select(int.Parse).ToArray();
                int queryCount = nq[1];
                var xorq = new Xorq(ReadSpaceDelimitedSequence().Select(short.Parse).ToList());
                for (int i = 0; i < queryCount; i++) {
                    var qs = ReadSpaceDelimitedSequence().Select(int.Parse).ToArray();
                    int a = qs[0];
                    int l = qs[1] - 1;
                    int r = qs[2] - 1;
                    Console.WriteLine(xorq.Query(a, l, r));
                }
            }
        }

        public class Xorq
        {
            private const int MinNodeSizeShift = 7;
            private const int MinNodeSize = 1 << MinNodeSizeShift;

            public class FastBitArray
            {
                const int Shift = 6;
                const int Mask = 63;
                readonly long[] bits;

                public bool this[int index]
                {
                    get
                    {
                        return (bits[index >> Shift] & (1L << (index & Mask)))!=0;
                    }
                    set
                    {
                        if (value)
                            bits[index >> Shift] |= (1L << (index & Mask));
                        else
                            bits[index >> Shift] &= ~(1L << (index & Mask));
                    }
                }

                public void Or(FastBitArray other)
                {
                    for (int i = 0; i < bits.Length; i++)
                        bits[i] |= other.bits[i];
                }

                public bool Equals(FastBitArray other)
                {
                    return ReferenceEquals(other.bits, bits);
                }

                public override bool Equals(object obj)
                {
                    if (ReferenceEquals(null, obj)) return false;
                    if (obj.GetType() != typeof (FastBitArray)) return false;
                    return Equals((FastBitArray) obj);
                }

                public override int GetHashCode()
                {
                    return (bits != null ? bits.GetHashCode() : 0);
                }

                public FastBitArray(int count)
                {
                    bits = new long[(count >> Shift) + 1];
                }
            }

            public class Tree
            {
                FastBitArray bits;

                public void Add(int value)
                {
                    int index = 0;
                    for (int mask = 0x4000, offsetSize = 1; mask != 0; mask >>= 1, offsetSize <<= 1, index += offsetSize) {
                        index += (value & mask)!=0 ? offsetSize : 0;
                        bits[index] = true;
                    }
                }

                public bool Contains(int value)
                {
                    int index = 0;
                    for (int mask = 0x4000, offsetSize = 1; mask != 0; mask >>= 1, offsetSize <<= 1, index += offsetSize) {
                        index += (value & mask)!=0 ? offsetSize : 0;
                        if (!bits[index])
                            return false;
                    }
                    return true;
                }

                public int Query(int xor)
                {
                    int index = 0;
                    int max = 0;
                    for (int mask = 0x4000, offsetSize = 1; mask != 0; mask >>= 1, offsetSize <<= 1, index += offsetSize) {
                        if ((xor & mask)==0) {
                            if (bits[index + offsetSize]) {
                                index += offsetSize;
                                max |= mask;
                            }
                        }
                        else {
                            if (!bits[index]) {
                                index += offsetSize;
                                max |= mask;
                            }
                        }
                    }
                    return max;
                }

                public void OrWith(Tree tree)
                {
                    bits.Or(tree.bits);
                }

                public override string ToString()
                {
                    var sb = new StringBuilder();
                    sb.AppendFormat("[{0}]", string.Join(",", Enumerable.Range(0, 0x8000).Where(Contains)));
//                    BitArray _bits = bits;
//                    sb.AppendFormat(" (bits: {0})", string.Join(",", Enumerable.Range(0, 0x10000).Where(i => _bits[i])));
                    return sb.ToString();
                }

                public bool Equals(Tree other)
                {
                    return ReferenceEquals(other.bits, bits);
                }

                public override bool Equals(object obj)
                {
                    if (ReferenceEquals(null, obj)) return false;
                    if (obj.GetType() != typeof (Tree)) return false;
                    return Equals((Tree) obj);
                }

                public override int GetHashCode()
                {
                    return bits.GetHashCode();
                }

                public Tree()
                {
                    bits = new FastBitArray(0x10000);
                }
            }

            public int Count;
            public short[] Data;
            public List<Tree[]> Levels = new List<Tree[]>(); 

            public int Query(int xor, int left, int right)
            {
                if (left>right)
                    return xor;
                if (left==right)
                    return Data[left] ^ xor;

                int maxXor = -1;
                if (right-left <= MinNodeSizeShift) {
                    for (int i = left; i <= right; i++) {
                        int x = Data[i];
                        int xXor = x ^ xor;
                        if (xXor > maxXor)
                            maxXor = xXor;
                    }
                }
                else {
                    int prevLeftNodeIndex = -1;
                    int prevRightNodeIndex = -1;
                    for (int level = Levels.Count - 1; level >= 0; level--) {
                        int leftNodeIndex = GetBorderNodeIndex(left, MinNodeSizeShift + level, false);
                        int rightNodeIndex = GetBorderNodeIndex(right, MinNodeSizeShift + level, true);
                        var tl = GetLookupTree(leftNodeIndex, rightNodeIndex, prevLeftNodeIndex, level, false);
                        var tr = GetLookupTree(rightNodeIndex, leftNodeIndex, prevRightNodeIndex, level, true);
                        if (tl!=null) {
                            int x = tl.Query(xor);
                            int xXor = x ^ xor;
                            if (xXor > maxXor)
                                maxXor = xXor;
                        }
                        if (tr!=null && !ReferenceEquals(tr,tl)) {
                            int x = tr.Query(xor);
                            int xXor = x ^ xor;
                            if (xXor > maxXor)
                                maxXor = xXor;
                        }
                        prevLeftNodeIndex = leftNodeIndex;
                        prevRightNodeIndex = rightNodeIndex;
                    }
                    var leftBorderIndex = Math.Min(right, GetBorderIndex(left, MinNodeSizeShift, false) - 1);
                    for (int i = left; i <= leftBorderIndex; i++) {
                        int x = Data[i];
                        int xXor = x ^ xor;
                        if (xXor > maxXor)
                            maxXor = xXor;
                    }
                    var rightBorderIndex = Math.Max(left, GetBorderIndex(right, MinNodeSizeShift, true) + 1);
                    for (int i = rightBorderIndex; i <= right; i++) {
                        int x = Data[i];
                        int xXor = x ^ xor;
                        if (xXor > maxXor)
                            maxXor = xXor;
                    }
                }
                return maxXor;
            }

            private Tree GetLookupTree(int nodeIndex, int otherNodeIndex, int nextLevelNodeIndex, int level, bool isRight)
            {
                var trees = Levels[level];
                if (otherNodeIndex != nodeIndex && ((otherNodeIndex < nodeIndex) ^ isRight))
                    return null;
                if (nodeIndex == (nextLevelNodeIndex << 1) + (isRight ? 1 : 0))
                    return null;
                if (nodeIndex < 0 || nodeIndex >= trees.Length) 
                    return null;
                return trees[nodeIndex];
            }

            private int GetBorderNodeIndex(int i, int nodeSizeShift, bool isRight)
            {
                int ni = i >> nodeSizeShift;
                int i1 = ni << nodeSizeShift;
                if (!isRight && i1 != i)
                    ni++;
                if (isRight && (i1 + (1 << nodeSizeShift) - 1) != i)
                    ni--;
                return ni;
            }

            private int GetBorderIndex(int i, int nodeSizeShift, bool isRight)
            {
                int bi = GetBorderNodeIndex(i, nodeSizeShift, isRight) << nodeSizeShift;
                return isRight ? bi + (1 << nodeSizeShift) - 1 : bi;
            }

            public Xorq(List<short> data)
            {
                Count = 32;
                while (Count < data.Count)
                    Count <<= 1;
                var last = data[data.Count - 1];
                for (int i = data.Count; i<Count; i++)
                    data.Add(last);
                Data = data.ToArray();
//                Debug("Data: {0}", string.Join(",", Data));

                var timer = new Stopwatch();
                timer.Start();
                long ram = GC.GetTotalMemory(false);

                int nodeSizeShift = MinNodeSizeShift;
                int levelSize = Count >> nodeSizeShift;
                if (levelSize == 0)
                    levelSize = 1;
                for (int level = 0; levelSize != 0; level++, nodeSizeShift++, levelSize = Count >> nodeSizeShift) {
                    if (level==0) {
                        var trees = new Tree[levelSize];
                        var added = new BitArray[levelSize];
                        Levels.Add(trees);
                        for (int i = 0; i < Count; i++) {
                            int nodeIndex = i >> nodeSizeShift;
                            var tree = trees[nodeIndex];
                            if (tree==null) {
                                tree = new Tree();
                                trees[nodeIndex] = tree;
                            }
                            var bitArray = added[nodeIndex];
                            if (bitArray==null) {
                                bitArray = new BitArray(0x8000);
                                added[nodeIndex] = bitArray;
                            }
                            var x = Data[i];
                            if (!bitArray[x]) {
                                bitArray[x] = true;
                                tree.Add(x);
                            }
                        }
                    }
                    else {
                        var trees = new Tree[levelSize];
                        Levels.Add(trees);
                        var prevTrees = Levels[level - 1];
                        for (int nodeIndex = 0; nodeIndex < levelSize; nodeIndex++) {
                            var tree = new Tree();
                            trees[nodeIndex] = tree;
                            int prevLevelNodeIndex = nodeIndex << 1;
                            for (int i = 0; i<2; i++)
                                tree.OrWith(prevTrees[prevLevelNodeIndex + i]);
                        }
                    }
                }

                ram = GC.GetTotalMemory(false) - ram;
                Debug("Index is built in {0}ms, {1}MB.", timer.ElapsedMilliseconds, ram / 1024 / 1024);

//                for (int i = Math.Max(0, Levels.Count - 3); i < Levels.Count; i++) {
//                    Debug("Level {0}", i);
//                    var trees = Levels[i];
//                    for (int j = 0; j < trees.Length; j++) {
//                        Debug("  Tree {0}: {1}", j, trees[j]);
//                    }
//                }
            }
        }

        [Conditional("DEBUG")]
        private static void Debug(string format, params object[] args)
        {
            var color = Console.ForegroundColor;
            try {
                Console.ForegroundColor = ConsoleColor.Yellow;
                Console.WriteLine(format, args);
            }
            finally {
                Console.ForegroundColor = color;
            }
        }

        [Conditional("DEBUG")]
        private static void Sleep(bool waitForKeyPress = false)
        {
            if (waitForKeyPress)
                Console.ReadKey();
            else
                Thread.Sleep(1000000);
        }

        private static IEnumerable<string> ReadSpaceDelimitedSequence()
        {
            return Console.ReadLine().Split(' ').Where(s => !string.IsNullOrEmpty(s));
        }
    }
}