# Hacker Rank Challenge 13

import sys


s,t = input().strip().split(' ')
s,t = [int(s),int(t)]
a,b = input().strip().split(' ')
a,b = [int(a),int(b)]
m,n = input().strip().split(' ')
m,n = [int(m),int(n)]
apple = list(map(int,input().strip().split(' ')))
orange = list(map(int,input().strip().split(' ')))
acount=0
for i in apple:
    if s<=a+i<=t:
        acount+=1
ocount=0
for i in orange:
    if s<=b+i<=t:
        ocount+=1
print(acount)
print(ocount)

#end of the program