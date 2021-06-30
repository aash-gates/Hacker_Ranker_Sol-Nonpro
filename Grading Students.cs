# Hacker Rank Challenge 12

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
class Solution {

static void Main(String[] args) {
int n = Convert.ToInt32(Console.ReadLine());
for(int a0 = 0; a0 < n; a0++){
int grade = Convert.ToInt32(Console.ReadLine());
int final = 0;
int next = ((grade / 5) + 1) * 5;
if (next - grade >= 3 || grade < 38)
final = grade;
else
final = next;
Console.WriteLine(final);

}
}
}

# end of the Program