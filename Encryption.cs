using System;

namespace contest
{
    class Program
    {
        static void Main(string[] args)
        {
            string line = Console.ReadLine();
            int length = line.Length;
            int row = (int) Math.Sqrt(length);
            int col = length/row;
            if (row * col < length) col++;

            while(col-row>1)
            {
                col--;
                row++;
            }

            string output = "";
            for(int i =0; i < col; i++)
            {
                for (int j = 0; j < row; j++)
                {
                    if (j * col + i < length)
                    output += line[j*col + i];
                }
                output += " ";
            }

            Console.WriteLine(output);
        }
    }
}