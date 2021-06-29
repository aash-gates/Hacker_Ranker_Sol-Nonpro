# Hacker Rank Challenge 5
import math
import os
import random
import re
import sys


def diagonalDifference(arr):
    diag1=0
    diag2=0
    
    for x in range(int(len(arr))):
        y=list(reversed(list(range(len(arr[x])))))
        diag1+=arr[x][x]
        diag2+=arr[x][y[x]]

    return abs(diag1-diag2)

if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    n = int(input().strip())

    arr = []

    for _ in range(n):
        arr.append(list(map(int, input().rstrip().split())))

    result = diagonalDifference(arr)

    fptr.write(str(result) + '\n')

    fptr.close()



# end of the program
