import sys
di = {}
a = 'abcdefghijklmnopqrstuvwxyz'
for i in range(26):
    di[a[i]] = i+1
    
s = input().strip()
hi = {}
pr = '*'
co = 0
for i in s:
    if i==pr:
        co += di[i]
        hi[co] = 1
    else:
        pr = i
        co = di[i]
        hi[co] = 1
        
n = int(input().strip())
for a0 in range(n):
    x = int(input().strip())
    if x in hi:
        print('Yes')
    else:
        print('No')