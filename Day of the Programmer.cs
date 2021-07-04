using System;
using System.Collections.Generic;
using System.Linq;
class Solution {
static void Main(String[] args) {
var tmp = Console.ReadLine().Split(' ');
int n = int.Parse(tmp[0]);
int k = int.Parse(tmp[1]);

int[] A = Array.ConvertAll(Console.ReadLine().Split(' '), int.Parse);

int total = (A.Sum() - A[k]) / 2;
int c = int.Parse(Console.ReadLine());
if (c == total) {
Console.WriteLine("Bon Appetit");
} else {
Console.WriteLine(c - total );
}
}
}