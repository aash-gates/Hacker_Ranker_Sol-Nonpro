using System;
using System.Collections.Generic;
using System.IO;
class Solution {
    static void Main(String[] args) {
        int _a_size = Convert.ToInt32(Console.ReadLine());
        int[] _a = new int [_a_size];
        String move = Console.ReadLine();
        String[] move_split = move.Split(' ');
        for(int _a_i = 0; _a_i < _a.Length; _a_i++)
            _a[_a_i] = Convert.ToInt32(move_split[_a_i]);
        Array.Sort(_a);
        int minDiff = Int32.MaxValue;
        for(int _a_i = 1; _a_i < _a.Length; _a_i++)
            minDiff = Math.Min(_a[_a_i] - _a[_a_i-1], minDiff);
        for(int _a_i = 1; _a_i < _a.Length; _a_i++) {
            if (minDiff == _a[_a_i] - _a[_a_i-1]) {
                Console.Write(_a[_a_i-1]);
                Console.Write(' ');
                Console.Write(_a[_a_i]);
                Console.Write(' ');
            }
        }

    }
}