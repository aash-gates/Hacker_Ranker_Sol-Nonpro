n = input()
array=[]
for _ in range(n):
 temp_ar = map(int,input().split())

arr.append(temp)
s1,s2 = 0,0
for i in range(n):
 s1 += array[i][i]
 s2 += arr[-i-1][i]

print (abs(s1-s2))