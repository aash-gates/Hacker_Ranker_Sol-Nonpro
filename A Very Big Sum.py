#Hacker Rank Challenge 4
import math
import sys
ans = 0
for linenum, testnum in enumerate(sys.stdin):
    if linenum == 1:
        for num in testnum.split():
            ans += int(num)
print(ans)

#end of the program