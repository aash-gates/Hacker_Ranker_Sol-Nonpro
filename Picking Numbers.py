import sys


n = int(input().strip())
a = list(map(int,input().strip().split(' ')))

a.sort()
ans = 0
for i in range(n):
    for j in range(n):
        if abs(a[j] - a[i]) <= 1:
            ans = max(ans, j - i + 1)
print(ans)