# Hacker Rank Challenge 15 hard 

import sys
n,m = list(map(int,sys.stdin.readline().split()))

p = 1000000007

def pow_mod(x, y, z):
    number = 1
    while y:
        if y & 1:
            number = number * x % z
        y >>= 1
        x = x * x % z
    return number

S = pow_mod(2,m,p)-1 % p
A1 = 0
A2 = 0
A3 = S
W = S

z1 = pow_mod(2,m,p)
x = z1-1
for i in range(2,n+1):
    x -= 1
    A3 = (i * (S-W) * x)%p
    S = (S*x)%p
    W = (S-A1)
    A1 = (W - A3)
    #A2 = (S-W)
print(W%p)

