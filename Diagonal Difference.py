n = input()
arr=[]
for _ in range(n):
temp = map(int,raw_input().split())

arr.append(temp)
s1,s2 = 0,0
for i in range(n):
 s1 += arr[i][i]
 s2 += arr[-i-1][i]
print abs(s1-s2)