from itertools import groupby
n = int(input())
c = list(map(int, input().split()))

ans = 0
for val in [len(list(group)) for key, group in groupby(sorted(c))]:
    ans = ans + val/2
print(ans)