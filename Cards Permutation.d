import std.algorithm;
import std.array;
import std.conv;
import std.math;
import std.range;
import std.stdio;
import std.string;

class FenwickTree(T = int, alias op = (x, y) => x + y, T zero = T.init) {
  private:
  T [] a;
  size_t n;
  public:
  this (size_t _n) pure nothrow {
    n = _n;
    a = new int[n];
    static if (zero != T.init) a[] = zero;
  }
  void update (size_t x, T v) pure nothrow @nogc in {
    assert (x < n);
  } body {
    for (auto i = x; i < n; i |= i + 1) {
      a[i] = op (a[i], v);
    }
  }
  //returns sum[0..x+1]
  T reduce (size_t x) const pure nothrow @nogc in {
    assert (x < n);
  } body {
    T r = zero;
    for (auto i = x; i != size_t.max; i = (i & (i + 1)) - 1) {
      r = op (r, a[i]);
    }
    return r;
  }
}

struct IntM {
  enum q = 1_000_000_007;
  int v;
  this (int m) pure nothrow @nogc {
    v = m % q;
    if (v < 0) {
      v += q;
    }
  }
  IntM opAssign (int m) pure nothrow @nogc {
    v = m % q;
    if (v < 0) {
      v += q;
    }
    return this;
  }
  IntM opUnary (string op : "-")() const pure nothrow @nogc {
    return IntM ((q - v) % q);
  }
  ref IntM opUnary (string op : "++")() pure nothrow @nogc {
    if (++v >= q) {
      v -= q;
    }
    return this;
  }
  ref IntM opUnary (string op : "--")() pure nothrow @nogc {
    if (--v < 0) {
      v += q;
    }
    return this;
  }
  ref IntM opOpAssign (string op : "+")(in IntM rhs) pure nothrow @nogc {
    v += rhs.v;
    v %= q;
    return this;
  }
  ref IntM opOpAssign (string op : "-")(in IntM rhs) pure nothrow @nogc {
    v -= rhs.v;
    v %= q;
    return this;
  }
  ref IntM opOpAssign (string op : "*")(in IntM rhs) pure nothrow @nogc {
    v = ((v.to!(long)) * rhs.v.to!(long)) % q;
    return this;
  }
  IntM opBinary (string op : "+")(in IntM rhs) const pure nothrow @nogc {
    return IntM ( (v + rhs.v) % q);
  }
  IntM opBinary (string op : "-")(in IntM rhs) const pure nothrow @nogc {
    return IntM ( (v - rhs.v) % q);
  }
  IntM opBinary (string op : "*")(in IntM rhs) const pure nothrow @nogc {
    return IntM (((v.to!(long)) * rhs.v.to!(long)) % q);
  }
  IntM opBinary (string op : "^^")(in int rhs) const pure nothrow @nogc {
    IntM a = 1, b = this;
    int p = rhs;
    while (p > 0) {
      //a * (b ^ p) == x ^ rhs
      if (p & 1) {
        a *= b;
      }
      b *= b;
      p >>>= 1;
    }
    return a;
  }
  IntM opBinary (string op)(in int v) const pure nothrow @nogc if (op == "+" || op == "-" || op == "*") {
    mixin ("return this " ~ op ~ " IntM(v);");
  }
  int opCast(T : int)() const pure nothrow @nogc { return v; }
  int opCmp (const IntM rhs) const pure nothrow @nogc {
    if (v < rhs.v) {
      return -1;
    }
    if (v > rhs.v) {
      return 1;
    }
    return 0;
  }
  bool opEquals (const IntM rhs) const pure nothrow @nogc { return v == rhs.v; }
  string toString() const pure nothrow { return ((v < 0) ? v + q : v).text; }
}

enum inv2 = IntM(2) ^^ (IntM.q - 2);

int ri () {
  int x;
  readf!" %d" (x);
  return x;
}

void main() {
  immutable n = ri ();
  immutable p = generate! (ri)().take (n).array.idup;
  debug stderr.writeln (p);
  auto fact = recurrence!((a, n) => a[n-1] * IntM(n.to!int))(IntM(1)).take (n + 1).array.idup;
  debug stderr.writefln ("facts: %s", fact);
  immutable IntM sZeroToN = ((n.to!long * (n - 1)) >> 1) % IntM.q;
  IntM freeVarSumDigits = sZeroToN;
  immutable freeIdx = iota (0, n).filter! (i => p[i] == 0).array.idup;
  immutable busyIdx = iota (0, n).filter! (i => p[i] != 0).array.idup;
  immutable freeVars = freeIdx.length.to!int;
  auto c = new int[n];
  c[] = 1;
  IntM s1, s2, s3, s4;
  auto d = iota (0, n).map! ( i => i < n - 1 ? fact[n - i - 1] : IntM (0)).array.idup;
  foreach (i; busyIdx) {
    IntM x = p[i] - 1;
    s1 += d[i] * fact[freeVars] * x;
    freeVarSumDigits -= x;
    c[p[i]-1] = 0;
  }
  debug stderr.writefln ("freeVarSumDigits = %s", freeVarSumDigits);
  if (freeVars > 0) {
    foreach (i; freeIdx) {
      s2 += d[i] * freeVarSumDigits * fact[freeVars - 1];
    }
  }
  foreach (i; 1 .. n) {
    c[i] += c[i - 1];
  }
  immutable freeCount = c.idup;
  auto ft = new FenwickTree!int (n);
  int freeVarPos;
  long t;
  foreach (i; 0 .. n) {
    if (p[i] > 0) {
      int x = p[i] - 1;
      t += freeVars - freeCount[x];
      int y = x > 0 ? ft.reduce (x - 1) : 0;
      debug stderr.writefln ("i = %d, x = %s, y = %s", i, x, y);
      ft.update (x, 1);
      s3 += d[i] * fact[freeVars] * y;
      debug stderr.writefln ("[1] s3 = %s", s3);
      x = freeCount[x];
      debug stderr.writefln ("newx = %s", x);
      assert (x >= 0);
      if (x && freeVarPos) {
        s3 += (d[i] * fact[freeVars - 1] * x) * freeVarPos;
      }
      debug stderr.writefln ("[2] s3 = %s", s3);
    } else {
      s4 += d[i] * (IntM (t % IntM.q) * fact[freeVars - 1] + fact[freeVars] * inv2 * freeVarPos); 
      ++freeVarPos;
    }
  }
  IntM s5 = fact[freeVars];
  IntM s = s1 + s2 - (s3 + s4) + s5;
  debug stderr.writefln("%s %s %s %s %s", s1, s2, s3, s4, s5);
  writeln (s);
}
