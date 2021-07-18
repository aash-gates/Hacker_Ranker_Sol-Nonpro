using namespace std;

typedef long long ll;

const long long MOD = 1e9 + 7;

 struct mat{
    int f, c;
    unsigned long long arr[102][102];
    mat() {
    memset(arr, 0, sizeof(arr));
}

mat operator*(const mat& a) {
    mat sol;
    sol.f = f;
    sol.c = a.c;
    for (int i = 0; i < f; i++)
        for (int j = 0; j < a.c; j++)
            for (int k = 0; k < c; k++)
                sol.arr[i][j] = (sol.arr[i][j] + arr[i][k] * a.arr[k][j]) % MOD;
    return sol;
}
};

mat init, arr;
mat sol1, sol2, ident;

long long GCDext(long long a, long long b, long long &x, long long &y) {
    long long g = a;
    x = 1;
    y = 0;
    if (b != 0) {
        g = GCDext(b, a % b, y, x);
        y -= (a / b) * x;
    }
    return g;
}

long long invMod(long long a, long long m, long long &inv) {
    long long x, y;
    if (GCDext(a, m, x, y) != 1)
        return 0;
    inv = (x + m) % m;
    return 1;
}


mat POW(long long p) {
    if(p == 0LL)
        return ident;
    if (p == 1LL)
        return init;
    if (p & 1LL) {
        return POW(p - 1LL) * init;
    }
    mat k = POW(p / 2LL);
    return k * k;
}

long long C[101][202];
void InvMatMOD(int n) {
    long long m, inv;
    for (int i = 0; i < n - 1; i++) {
        int fil = i;

        for (int k = i + 1; k < n; k++) {
            if (C[k][i] > C[fil][i])
                fil = k;
        }

    if (fil > i) {
        for (int k = 0; k < 2 * n; k++)
            swap(C[fil][k], C[i][k]);
    }

    for (int k = i + 1; k < n; k++) {
        invMod(C[i][i], MOD, inv);
        m = (C[k][i] * inv) % MOD;
        for (int j = 0; j < 2 * n; j++)
            C[k][j] = (C[k][j] + MOD - (m * C[i][j]) % MOD) % MOD;
    }
}

sol2.f = n;
sol2.c = n;

for (int j = 0; j < n; j++) {
    int i = n;
    do {
        sol2.arr[i][j] = C[i][j + n];
        for (int k = i + 1; k < n; k++)
            sol2.arr[i][j] = (sol2.arr[i][j] + MOD - (C[i][k]
                    * sol2.arr[k][j]) % MOD) % MOD;
        invMod(C[i][i], MOD, m);
        sol2.arr[i][j] = (sol2.arr[i][j] * m) % MOD;
        i--;
    } while (i >= 0);
}
}

int f, c, n;
long long k;

int main() {
    scanf("%d%lld", &n, &k);

    ident.f = n;
    ident.c = n;
    for(int i = 0;i<n;i++)
        ident.arr[i][i] = 1;

    arr.f = 1;
    arr.c = n;

    for(int i = 0;i<n;i++)
        scanf("%lld", &arr.arr[0][i]);

    init.f = n;
    init.c = n;

    for(int i = 0;i<n;i++)
        scanf("%lld", &init.arr[i][0]);

    for(int i = 1;i<n;i++)
        init.arr[i-1][i] = 1LL;

    sol1 = POW(k - (long long) n + 1LL);

    for(int i = 0;i<n;i++) {
        for(int j = 0;j<n;j++)
            C[i][j] = sol1.arr[i][j];
        C[i][i+n] = 1;
    }

    InvMatMOD(n);

    sol1 = arr * sol2;

    for(int i = n-1;i>0;i--)
        printf("%lld ", sol1.arr[0][i]);

    printf("%lld ", sol1.arr[0][0]);
}