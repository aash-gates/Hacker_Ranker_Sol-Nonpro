
n = eval(input())
arr = list(map(int,input().split()))
c1 = len([x for x in arr if x>0])
c2 = len([x for x in arr if x<0])
c3 = len([x for x in arr if x==0])
print("%.7f" % (c1/n))
print("%.7f" % (c2/n))
print("%.7f" % (c3/n))