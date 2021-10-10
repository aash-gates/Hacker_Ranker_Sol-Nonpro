
import sys
for linenum, testnum in enumerate(sys.stdin):
    if linenum == 1:
        for num in testnum.split():
            ans += int(num)
print(ans)

#end of the program