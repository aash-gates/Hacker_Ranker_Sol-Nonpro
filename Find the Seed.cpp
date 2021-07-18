MOD = 1000000007

def generalizedEuclidianAlgorithm(a, b):
    if b > a:
        return generalizedEuclidianAlgorithm(b,a);
    elif b == 0:
        return (1, 0);
    else:
        (x, y) = generalizedEuclidianAlgorithm(b, a % b);
        return (y, x - (a // b) * y)

def inversemodp(a, p):
    a = a % p
    if a == 0:
        return 0
    (x, y) = generalizedEuclidianAlgorithm(p, a % p);
    return y % p

def identitymatrix(n):
    return [[int(x == y) for x in range(0, n)] for y in range(0, n)]

def multiply_vector_scalar(vector, scalar, q):
    kq = []
    for i in range (0, len(vector)):
        kq.append(vector[i] * scalar % q)
    return kq

def minus_vector_scalar1(vector1, scalar, vector2, q):
    kq = []
    for i in range (0, len(vector1)):
        kq.append((vector1[i] - scalar * vector2[i]) % q)
    return kq

def inversematrix1(matrix, q):
    n = len(matrix)
    A =[]
    for j in range (0, n):
        temp = []
        for i in range (0, n):
            temp.append(matrix[j][i])
        A.append(temp)
    Ainv = identitymatrix(n)
    for i in range(0, n):
        factor = inversemodp(A[i][i], q)
        A[i] = multiply_vector_scalar(A[i], factor, q)
        Ainv[i] = multiply_vector_scalar(Ainv[i], factor, q)
        for j in range(0, n):
            if i != j:
                factor = A[j][i]
                A[j] = minus_vector_scalar1(A[j], factor, A[i], q)
                Ainv[j] = minus_vector_scalar1(Ainv[j], factor,Ainv[i], q)
    return Ainv

def mult(x, y):
    c = [[0 for _ in range(len(y[0]))] for _ in range(len(x))]
    for i in range(len(x)):
        for j in range(len(y[0])):
            for k in range(len(x)):
                c[i][j] += x[i][k] * y[k][j]
                c[i][j] = c[i][j] % MOD
    return c

def matpow(b, p):
    if p == 0: return identitymatrix(n)
    if p == 1: return b
    if p % 2 == 1:
        return mult(b, matpow(b, p - 1))
    ret = matpow(b, p // 2)
    return mult(ret, ret)

n, k = map(int, input().split())
arrk = list(map(int, input().split()))
arrc = list(map(int, input().split()))
left = [[x] for x in arrk];
middle = [[0 for _ in range(n)] for _ in range(n)]
middle[0] = list(arrc)
for i in range(1,n):
    middle[i][i-1] = 1
inv = inversematrix1(middle, MOD)
inv = [[int(x) for x in y] for y in inv]
ans = matpow(inv, k - n + 1)
ans = mult(ans, left)
print(' '.join(map(lambda x : str(x[0]), ans)))