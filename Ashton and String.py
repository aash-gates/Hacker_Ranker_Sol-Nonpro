# Hacker Rank Challenge 16 Hard

def foo(text, k):
    stack = [("",list(range(len(text))))]
    while stack != []:
        prefix,ii = stack.pop()
        if k<len(prefix):
            return prefix[k]
        k -= len(prefix)
        cs = sorted([(text[i],i+1) for i in ii if i<len(text)], reverse=True)
        i = 0
        while i<len(cs):
            c = cs[i][0]
            ii2 = [cs[i][1]]
            j = i+1
            while j<len(cs) and cs[j][0]==c:
                ii2.append(cs[j][1])
                j+=1
            stack.append((prefix+c, ii2))
            i=j
    return None

T = int(input().strip())
for i in range(T):
    text = input().strip()
    k = int(input().strip())
    print(foo(text,k-1))
    

                    