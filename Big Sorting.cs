using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.Collections;
using System.ComponentModel;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.Serialization;
using System.Text.RegularExpressions;
using System.Text;
using System;

class Solution
{
    static void Main()
    {
        int n = int.Parse(Console.ReadLine());
        string[] a = new string[n];

        for (int i = 0; i < n; ++i) a[i] = Console.ReadLine();

        Array.Sort(a, (s1, s2) =>
        {
            int l = s1.Length - s2.Length;
            return (l != 0) ? l : string.Compare(s1, s2, StringComparison.OrdinalIgnoreCase);
        });

        for (int i = 0; i < n; ++i) Console.WriteLine(a[i]);
    }
}