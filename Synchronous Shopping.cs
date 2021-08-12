using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;

class Solution {
    static void Main(String[] args) {
        Solve();
    }
    
        static int[] shops;
        static Dictionary<int, List<Road>> roads;
        static int?[,] shopPaths;
        static int N = 0; // # of shops
        static int M = 0; // # of roads
        static int K = 0; // # of fish types

        static int[] ReadLineOfInts(params char[] separator) {
            string readLine = Console.ReadLine();
            readLine = readLine.Replace("´╗┐", "");
            return readLine.Split(separator).Select(x => int.Parse(x)).ToArray();
        }

        public static void  Solve() {
            int[] startupParams = ReadLineOfInts(' ');
            N = startupParams[0]; // # of shops
            M = startupParams[1]; // # of roads
            K = startupParams[2]; // # of fish types

            int allFishTypesBinary = (int)Math.Pow(2, K) - 1;
            shopPaths = new int?[N + 1, allFishTypesBinary + 1];

            GetShops();
            GetRoads();

            //Stopwatch sw = Stopwatch.StartNew();
            PrepareShopPaths();
            //Console.WriteLine("PrepareShopPaths:{0}", sw.ElapsedMilliseconds / 1000.00);

            var yLimit = Enumerable.Range(0, shopPaths.GetUpperBound(1) + 1);
            var shopNFishTypesBinaryList = yLimit.Where(y => shopPaths[N, y].HasValue).Select(y => y).ToList();

            int minDuration = int.MaxValue;
            foreach (var path1FishTypesBinary in shopNFishTypesBinaryList) {
                int path1Duration = shopPaths[N, path1FishTypesBinary].Value;

                if (path1FishTypesBinary == allFishTypesBinary) {
                    if (minDuration > path1Duration) {
                        minDuration = path1Duration;
                    }
                    continue;
                }

                foreach (var path2FishTypesBinary in shopNFishTypesBinaryList) {
                    int path2Duration = shopPaths[N, path2FishTypesBinary].Value;

                    if (path2FishTypesBinary == allFishTypesBinary) {
                        if (minDuration > path2Duration) {
                            minDuration = path2Duration;
                        }
                        continue;
                    }

                    var mergedBinaryStrings = path1FishTypesBinary | path2FishTypesBinary;
                    if (mergedBinaryStrings != allFishTypesBinary) {
                        continue;
                    }
                    int maxDuration = Math.Max(path1Duration, path2Duration);
                    if (minDuration > maxDuration) {
                        minDuration = maxDuration;
                    }
                }
            }

            Console.WriteLine(minDuration);
        }

        static void PrepareShopPaths() {
            shopPaths[1, shops[1]] = 0;

            Queue<ShopPath> queue = new Queue<ShopPath>();
            ShopPath shopPath = new ShopPath() {
                ShopNumber = 1,
                FishTypesBinary = shops[1]
            };

            queue.Enqueue(shopPath);

            while (queue.Any()) {
                ShopPath path = queue.Dequeue();
                var roadList = roads[path.ShopNumber];
                var pathDuration = shopPaths[path.ShopNumber, path.FishTypesBinary].Value;

                foreach (var road in roadList) {
                    int newBinary = path.FishTypesBinary | shops[road.ToShopNumber];
                    int newDuration = pathDuration + road.Duration;

                    if (shopPaths[road.ToShopNumber, newBinary].GetValueOrDefault(int.MaxValue) > newDuration) {
                        shopPaths[road.ToShopNumber, newBinary] = newDuration;

                        shopPath = new ShopPath() {
                            ShopNumber = road.ToShopNumber,
                            FishTypesBinary = newBinary
                        };
                        queue.Enqueue(shopPath);
                    }
                }
            }
        }

        static void GetShops() {
            shops = new int[N + 1];
            for (int i = 1; i <= N; i++) {
                string[] tmpParams = Console.ReadLine().Split(' ');
                int[] fishTypes = Array.ConvertAll(tmpParams, Int32.Parse);
                shops[i] = PrepareFishTypesBinary(fishTypes);
            }
        }

        static void GetRoads() {
            roads = new Dictionary<int, List<Road>>();
            for (int i = 0; i < M; i++) {
                string[] tmpParams = Console.ReadLine().Split(' ');
                int fromShopNumber = Int32.Parse(tmpParams[0]);
                Road rd = new Road() {
                    ToShopNumber = Int32.Parse(tmpParams[1]),
                    Duration = Int32.Parse(tmpParams[2])
                };

                List<Road> rdList;
                if (!roads.TryGetValue(fromShopNumber, out rdList)) {
                    rdList = new List<Road>();
                    roads.Add(fromShopNumber, rdList);
                }
                rdList.Add(rd);

                // reverse                
                fromShopNumber = Int32.Parse(tmpParams[1]);
                rd = new Road() {
                    ToShopNumber = Int32.Parse(tmpParams[0]),
                    Duration = Int32.Parse(tmpParams[2])
                };

                if (!roads.TryGetValue(fromShopNumber, out rdList)) {
                    rdList = new List<Road>();
                    roads.Add(fromShopNumber, rdList);
                }
                rdList.Add(rd);
            }
        }

        static int PrepareFishTypesBinary(int[] fishTypes) {
            int fishTypesBinary = 0;
            for (int i = 1; i < fishTypes.Length; i++) {
                fishTypesBinary += (int)Math.Pow(2, fishTypes[i] - 1);
            }
            return fishTypesBinary;
        }

        struct Road {
            public int ToShopNumber { get; set; }
            public int Duration { get; set; }
            public new string ToString() {
                return string.Format("ToShopNumber-Duration:{0}-{1}", ToShopNumber, Duration);
            }
        }

        struct ShopPath {
            public int ShopNumber { get; set; }
            public int FishTypesBinary { get; set; }
        }
    
}