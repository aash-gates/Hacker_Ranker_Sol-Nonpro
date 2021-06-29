# Hacker Rank Challenge 5

n = input()
array=[]
for _ in range(n):
 temp_ar = map(int,input().split())

array.append(temp_ar)
s1,s2 = 0,0
for i in range(n):
 s1 += array[i][i]
 s2 += array[-i-1][i]

print (abs(s1-s2))

# end of the program