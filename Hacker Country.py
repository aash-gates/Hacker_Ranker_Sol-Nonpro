# Hacker Rank Challenge 10

import math
import os

def comp(a, b):
    return a[0] * b[1] - a[1] * b[0]

if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')
    n = int(input().strip())
    tolls = []
    d = [[0 for _ in range(n + 1)] for _ in range(n + 1)]
    for _ in range(n):
        tolls.append(list(map(int, input().rstrip().split())))
    for i in range(n):
        for j in range(n):
            mark = False
            for k in range(n):
                if k != j:
                    if mark:
                        d[i + 1][j] = min(d[i + 1][j] , d[i][k] + tolls[k][j])
                    else:
                        mark = True
                        d[i + 1][j]  = d[i][k] + tolls[k][j]
    ans = (0, 0)
    for i in range(n):
        now = (d[n][i] - d[0][i], n)
        for k in range(1, n):
            temp = (d[n][i] - d[k][i], n - k)
            if comp(temp, now) > 0:
                now = temp
        if i == 0 or comp(now, ans) < 0:
            ans = now
    g = math.gcd(ans[0], ans[1])
    result = str(ans[0] // g) + '/' + str(ans[1] // g)
    fptr.write(result + '\n')
    fptr.close()
    
