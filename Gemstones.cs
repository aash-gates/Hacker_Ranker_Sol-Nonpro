using System;
using System.Collections.Generic;
using System.IO;


class Solution
{
    

    static void doStuff(List<String> seed)
    {
        int counter = 0;
        String mainSeed = seed[0];

        List<String> gems = new List<string>();

        int _sampleLength = 1;

        while (_sampleLength <= mainSeed.Length)
        {
            int _sampleOffset = 0;
            while (_sampleOffset <= mainSeed.Length - _sampleLength)
            {
                String _sample = mainSeed.Substring(_sampleOffset, _sampleLength);

                if (!gems.Contains(_sample))
                    gems.Add(_sample);

                _sampleOffset++;
            }
            _sampleLength++;
        }

        foreach (string gem in gems)
        {
            if (hasGem(gem, seed))
                counter++;
        }

        Console.WriteLine(counter);
    }

    static bool hasGem(string gem, List<string> seed)
    {
        for (int index = 1; index < seed.Count; index++)
        {
            if (seed[index].IndexOf(gem) == -1)
                return false;
        }
        return true;
    }

    static void Main(String[] args)
    {
        List<String> _seeds = new List<String>();
        int _loops = Convert.ToInt32(Console.ReadLine());

        for (int index = 0; index < _loops; index++)
            _seeds.Add(Console.ReadLine());
        doStuff(_seeds);

        Console.ReadLine();
    }
}