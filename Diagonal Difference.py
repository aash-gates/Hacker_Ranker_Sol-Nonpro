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






# end of the program
