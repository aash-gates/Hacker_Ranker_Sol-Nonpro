using System;
using System.Collections.Generic;
using System.Linq;
class Solution {
static void Main(String[] args) {
Console.ReadLine();
var A = Array.ConvertAll(Console.ReadLine().Split(' '), int.Parse).ToList();
var B = Array.ConvertAll(Console.ReadLine().Split(' '), int.Parse).ToList();

int c = 0;

for (int i = 1; i < 10000; i++) {
if (A.Any(x => i % x != 0)) continue;
if (B.Any(x => x % i != 0)) continue;
c++;
}
Console.WriteLine(c);
}
}