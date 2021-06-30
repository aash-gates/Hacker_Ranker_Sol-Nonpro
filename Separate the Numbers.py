q = int(input())
for __ in range(q):
    s = input().strip()
    if s[0] == '0':
        print("NO")
        continue
    found = False
    for pref in range(1,len(s)+1):
        t = ""
        curnum = int(s[:pref])
        added = 0
        while len(t) < len(s):
            t += str(curnum)
            curnum += 1
            added += 1
        if added > 1 and t == s:
            print("YES", s[:pref])
            found = True
            break
    if not found:
        print("NO")
