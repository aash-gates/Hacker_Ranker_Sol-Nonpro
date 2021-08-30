using System;

namespace FloydCityOfBlindingLights
{
    class Program
    {
        static void Main(string[] args)
        {
            var line = Console.ReadLine().Split(' ');

            var N = Convert.ToInt32(line[0]);
            var M = Convert.ToInt32(line[1]);

            var graph = new int[N, N];

            for (var i = 0; i < N; i++)
            {
                for (var j = 0; j < N; j++)
                {
                    graph[i, j] = int.MaxValue;
                }
            }

            for (var i = 0; i < N; i++)
            {
                graph[i, i] = 0;
            }

            for (var i=0; i < M; i++)
            {
                line = Console.ReadLine().Split(' ');

                var x = Convert.ToInt32(line[0]);
                var y = Convert.ToInt32(line[1]);
                var r = Convert.ToInt32(line[2]);

                graph[x - 1, y - 1] = r;
            }

            for (var i = 0; i < N; i++)
            {
                for (var j = 0; j < N; j++)
                {
                    for (var k = 0; k < N; k++)
                    {
                        if (graph[j, k] > (long)graph[j, i] + graph[i, k])
                        {
                            graph[j, k] = graph[j, i] + graph[i, k];
                        }
                    }
                }
            }

            var Q = Convert.ToInt32(Console.ReadLine());

            for (var i=0; i < Q; i++)
            {
                line = Console.ReadLine().Split(' ');

                var a = Convert.ToInt32(line[0]);
                var b = Convert.ToInt32(line[1]);

                if (graph[a - 1, b - 1] == int.MaxValue)
                {
                    Console.WriteLine(-1);
                }
                else
                { 
                    Console.WriteLine(graph[a - 1, b -1]);
                }
            }

        }
    }
}
