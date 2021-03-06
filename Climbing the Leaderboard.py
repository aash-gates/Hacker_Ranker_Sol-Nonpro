#!/bin/python

import sys

def compute_sums(A, B):
    i = 0
    y = A[i]
    s = 0

    result = {}
    for x in B:
        while x > y:
            result[y] = s
            i += 1
            if i >= len(A):
                return result
            
            y = A[i]
        s += 1
    for y in A[i:]:
        result[y] = s
    return result



n = int(input().strip())
A = list(map(int,input().strip().split(' ')))
m = int(input().strip())
B = list(map(int,input().strip().split(' ')))
A = list(set(A))
A.sort()

l = compute_sums(B,A)
for i in B:
    print(len(A)-l[i]+1)