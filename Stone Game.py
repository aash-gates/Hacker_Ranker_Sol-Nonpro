mod = 10**9 + 7

def maxbit(v):
    return v if v <= 1 else maxbit(v >> 1) << 1

def solve0(vals):
    m = maxbit(max(vals))
    if m == 0: return 1
    ans = [1, 0]
    t = 0
    p0 = p1 = 1
    for v in vals:
        if v & m:
            t ^= 1
            a0, a1 = ans
            ans[0] = (a0 * (v - m + 1) + a1 * m) % mod
            ans[1] = (a1 * (v - m + 1) + a0 * m) % mod
            p1 = p1 * (v - m + 1) % mod
        else:
            p0 = p0 * (v + 1) % mod
    ans[0] = (ans[0] - p1) % mod
    res = ans[t] * pow(m, mod-2, mod) * p0
    if t == 0:
        res += solve0([v & ~m for v in vals])
    return res % mod

def solve(vals):
    return (solve0(vals) - solve0([v-1 for v in vals])) % mod

n = eval(input())
vals = list(map(int, input().strip().split()))
print(solve(vals))