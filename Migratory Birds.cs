using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
class Solution {

static void Main(String[] args) {
int n = Convert.ToInt32(Console.ReadLine());
string[] types_temp = Console.ReadLine().Split(' ');
int[] types = new int[n];

for(int i = 0; i < n; i++){
types[i] = int.Parse(types_temp[i]);
}

List<int> counters = new List<int>() {0, 0, 0, 0, 0};

int max = 0, maxType = 0;

foreach(int type in types){
counters[type - 1]++;

if(counters[type - 1] > max){
max = counters[type - 1];
maxType = type - 1;
}
else if(counters[type - 1] == max){
if(maxType > type - 1){
maxType = type - 1;
}
}
}

Console.WriteLine((maxType + 1).ToString());
// your code goes here
}
}