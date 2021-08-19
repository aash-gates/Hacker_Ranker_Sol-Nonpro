void main() {
	import std.stdio, std.algorithm;
	int q;
	readf("%s ", &q);
	uint[] pa = new uint[100000];
	uint[] h = new uint[100000];
	uint[] sz = new uint[100000];
	uint find_root(uint x) {
		if (pa[x] == x)
			return x;
		pa[x] = find_root(pa[x]);
		return pa[x];
	}
	void merge(uint x, uint y) {
		uint px = find_root(x);
		uint py = find_root(y);
		if (px == py)
			return;
		if (h[px] > h[py]) {
			pa[py] = px;
			sz[px] += sz[py];
		} else {
			sz[py] += sz[px];
			pa[px] = py;
			if (h[px] == h[py])
				h[py]++;
		}
	}
	foreach(_; 0..q) {
		int n, m;
		readf("%s %s ", &n, &m);

		ulong ans = 0;
		h[] = 0;
		sz[] = 1;
		foreach(i; 0..n)
			pa[i] = i;
		ulong curr = 0;
		foreach(i; 0..m) {
			int x, y;
			readf("%s %s ", &x, &y);
			merge(x-1, y-1);
		}
		uint[] szs;
		foreach(i; 0..n) {
			uint px = find_root(i);
			if (px != i)
				continue;
			szs ~= sz[px];
		}
		sort!"a>b"(szs);
		debug writeln(szs);
		foreach(i; szs) {
			foreach(j; 1..i) {
				curr+=2*j;
				ans+=curr;
			}
			m -= i-1;
		}

		ans += curr*m;
		writeln(ans);
	}
}