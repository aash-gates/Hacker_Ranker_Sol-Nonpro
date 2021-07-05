import sys


s,n,m = input().strip().split(' ')
s,n,m = [int(s),int(n),int(m)]
keyboards = list(map(int,input().strip().split(' ')))
pendrives = list(map(int,input().strip().split(' ')))
sorted(keyboards)
sorted(pendrives)
max = -1
for i in keyboards:
    for j in pendrives:
        sum = i+j
        if sum<=s:
            if sum>max:
                max = sum
print(max)