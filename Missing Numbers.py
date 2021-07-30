
def diff(A, B):
    i = 0
    L = {}

    for i in range(len(A)):
        if B[i] not in L:
            L[B[i]] = 1
        else:
            L[B[i]] += 1
            
        if A[i] not in L:
            L[A[i]] = -1
        else:
            L[A[i]] -= 1
    
    for i in range(len(A), len(B)):
        if B[i] not in L:
            L[B[i]] = 1
        else:
            L[B[i]] += 1

    #print(L)
    for x in L.keys():
        if L[x]:
            print(x, end = ' ')
        
if __name__ == '__main__':
    str = input()
    A = [int(x) for x in input().split()]
    str = input()
    B = [int(x) for x in input().split()]
    diff(A, B)