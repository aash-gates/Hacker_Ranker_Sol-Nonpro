#based on python 2

for t in xrange(input()):
    s = raw_input().strip()
    res = 0
    for i in xrange(len(s)/2):
        res += abs(ord(s[i]) - ord(s[-i-1]))
    print res
    
#end of the program