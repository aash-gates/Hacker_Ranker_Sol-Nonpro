a, b, k = list(map(int, input().split()))
ans = 0
for i in range(a, b+1):
    ans = ans + abs(not (i - int(str(i)[::-1]))%k)
print(ans)