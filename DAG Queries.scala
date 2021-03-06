object Assert {
	def check(e: Boolean) {
		if (!e) {
			throw new AssertionError();
		}
	}
}

class Scanner(is: java.io.InputStream) {

	val buffer: Array[Byte] = new Array[Byte](1 << 16);

	var len: Int = 0;

	var pos: Int = 0;

	def nextChar(): Int = {
		if (pos == len) {
			val read: Int = is.read(buffer);
			if (read == -1) {
				return -1;
			}
			len = read;
			pos = 0;
		}
		Assert.check(pos < len);
		val value: Int = buffer(pos) & 0xFF;
		pos += 1;
		return value;
	}

	def nextInt(): Int = {
		var c: Int = nextChar();
		while (c == ' ' || c == '\n' || c == '\r' || c == '\t') {
			c = nextChar();
		}
		Assert.check('0' <= c && c <= '9');
		var value: Int = c - '0';
		c = nextChar();
		while ('0' <= c && c <= '9') {
			val digit: Int = c - '0';
			Assert.check(value < Int.MaxValue / 10 || value == Int.MaxValue / 10 && digit <= Int.MaxValue % 10);
			value = value * 10 + digit;
			c = nextChar();
		}
		return value;
	}
}

class IntArrayList {

	var a: Array[Int] = new Array[Int](4);

	var size: Int = 0;
	
	def add(x: Int): Unit = {
		if (size == a.length) {
			a = java.util.Arrays.copyOf(a, a.length * 2);
		}
		a(size) = x;
		size += 1;
	}
	
	def get(i: Int): Int = {
		Assert.check(i < size);
		return a(i);
	}
}

class Query(val typ: Int, val node: Int, val value: Int) {}

object Solution {

	def reorder(parents: Array[IntArrayList], queries: Array[Query]): Unit = {
		val nV: Int = parents.size;
		val startOrder: Array[Int] = new Array[Int](nV);
		{
			var i: Int = 0;
			while (i < nV) {
				startOrder(i) = i;
				i += 1;
			}
		}
		var rnd: java.util.Random = new java.util.Random(20161106);
		{
			var i: Int = nV - 1;
			while (i > 0) {
				val j: Int = rnd.nextInt(i + 1);
				val t: Int = startOrder(i);
				startOrder(i) = startOrder(j);
				startOrder(j) = t;
				i -= 1;
			}
		}
		val orderedId: Array[Int] = new Array[Int](nV);
		java.util.Arrays.fill(orderedId, -1);
		val stack: IntArrayList = new IntArrayList();
		val ip: IntArrayList = new IntArrayList();
		var nextId: Int = 0;
		{
			var i: Int = 0;
			while (i < nV) {
				if (orderedId(startOrder(i)) == -1) {
					stack.add(startOrder(i));
					ip.add(0);
					while (stack.size > 0) {
						val cur: Int = stack.a(stack.size - 1);
						if (ip.get(ip.size - 1) == parents(cur).size) {
							orderedId(cur) = nextId;
							nextId += 1;
							stack.size -= 1;
							ip.size -= 1;
						} else {
							val p: Int = parents(cur).get(ip.get(ip.size - 1));
							ip.a(ip.size - 1) += 1;
							if (orderedId(p) == -1) {
								stack.add(p);
								ip.add(0);
							}
						}
					}
				}
				i += 1;
			}
		}
		if (false) {
			print("new ids: ");
			var first: Boolean = true;
			{
				var i: Int = 0;
				while (i < nV) {
					if (first) {
						first = false;
					} else {
						print(", ");
					}
					print((i + 1) + " -> " + (orderedId(i) + 1));
					i += 1;
				}
			}
			println();
		}
		Assert.check(nextId == nV);
		{
			var i: Int = 0;
			while (i < orderedId.length) {
				Assert.check(orderedId(i) >= 0);
				i += 1;
			}
		}
		val orderedParents: Array[IntArrayList] = new Array[IntArrayList](nV);
		{
			var i: Int = 0;
			while (i < nV) {
				orderedParents(i) = new IntArrayList();
				i += 1;
			}
		}
		{
			var i: Int = 0;
			while (i < nV) {
				{
					var ip: Int = 0;
					while (ip < parents(i).size) {
						val p: Int = parents(i).get(ip);
						orderedParents(orderedId(i)).add(orderedId(p));
						ip += 1;
					}
				}
				i += 1;
			}
		}
		{
			var i: Int = 0;
			while (i < nV) {
				java.util.Arrays.sort(orderedParents(i).a, 0, orderedParents(i).size);
				parents(i) = orderedParents(i);
				i += 1;
			}
		}
		{
			var i: Int = 0;
			while (i < queries.length) {
				val typ: Int = queries(i).typ;
				val node: Int = queries(i).node;
				val value: Int = queries(i).value;
				Assert.check(0 <= node && node < nV);
				queries(i) = new Query(typ, orderedId(node), value);
				i += 1;
			}
		}
	}

	def process(
		parents: Array[IntArrayList],
		queries: Array[Query],
		qFirst: Int,
		qAfter: Int,
		a: Array[Int],
		codes: Array[Long],
		add: Array[Int],
		min: Array[Int],
		result: IntArrayList
	): Unit = {
		val nV: Int = parents.length;
		val q12: IntArrayList = new IntArrayList();
		{
			var q = qFirst;
			while (q < qAfter) {
				if (queries(q).typ < 3) {
					q12.add(q);
				}
				q += 1;
			}
		}
		if (q12.size == 0) {
			var q: Int = qFirst;
			while (q < qAfter) {
				Assert.check(queries(q).typ == 3);
				val node: Int = queries(q).node;
				Assert.check(0 <= node && node < nV);
				result.add(a(node));
				q += 1;
			}
			return;
		}
		val n: Int = q12.size;
		Assert.check(n <= 8 * 14);
		Assert.check(nV <= 100000);
		java.util.Arrays.fill(codes, 0, nV * 2, 0);
		{
			var i: Int = 0;
			while (i < n) {
				val node: Int = queries(q12.get(i)).node;
				val word: Int = i / 56;
				val shift: Int = i % 56 / 14 * 16 + i % 14; // 14 used bits, 2 free
				codes(node * 2 + word) |= 1L << shift;
				i += 1;
			}
		}
		{
			var i: Int = 0;
			while (i < nV) {
				{
					val pari: IntArrayList = parents(i);
					var ip: Int = 0;
					while (ip < pari.size) {
						val p: Int = pari.get(ip);
						codes((i << 1) + 0) |= codes((p << 1) + 0);
						codes((i << 1) + 1) |= codes((p << 1) + 1);
						ip += 1;
					}
				}
				i += 1;
			}
		}
		var q: Int = qFirst;
		var part: Int = 0;
		while (part * 14 < n) {
			val begin: Int = part * 14;
			val end: Int = Math.min(n, begin + 14);
			val codesAdd: Int = part / 4;
			val codesShift: Int = part % 4 * 16;
			// a = Math.min(a + add, min)
			add(0) = 0;
			min(0) = 1000 * 1000 * 1000;
			var bit: Int = 0;
			while (bit < end - begin) {
				val qType: Int = queries(q12.get(begin + bit)).typ;
				val value: Int = queries(q12.get(begin + bit)).value;
				val extra: Int = 1 << bit;
				if (qType == 1) { // assign
					var code: Int = 0;
					while (code < extra) {
						add(code + extra) = 1000 * 1000 * 1000;
						min(code + extra) = value;
						code += 1;
					}
				} else {
					Assert.check(qType == 2); // min
					var code: Int = 0;
					while (code < extra) {
						add(code + extra) = add(code);
						min(code + extra) = Math.min(value, min(code));
						code += 1;
					}
				}
				bit += 1;
			}
			var mask = 0;
			while (end == n && q != qAfter || end != n && q != q12.get(end)) {
				if (queries(q).typ < 3) {
					mask <<= 1;
					mask |= 1;
				} else {
					Assert.check(queries(q).typ == 3);
					val node: Int = queries(q).node;
					val code: Int = ((codes((node << 1) + codesAdd) >> codesShift) & mask).toInt;
					val answer: Int = Math.min(a(node) + add(code), min(code));
					result.add(answer);
				}
				q += 1;
			}
			var i = 0;
			while (i < nV) {
				val code: Int = ((codes((i << 1) + codesAdd) >> codesShift) & 0xFFFF).toInt;
				a(i) = Math.min(a(i) + add(code), min(code));
				i += 1;
			}
			part += 1;
		}
	}

	def solveFast(parents: Array[IntArrayList], queries: Array[Query]): IntArrayList = {
		val nV: Int = parents.length;
		{
			var i: Int = 0;
			while (i < nV) {
				{
					var ip: Int = 0;
					while (ip < parents(i).size) {
						val p: Int = parents(i).get(ip);
						Assert.check(p < i); // parents before children
						ip += 1;
					}
				}
				i += 1;
			}
		}
		val a: Array[Int] = new Array[Int](nV);
		val codes: Array[Long] = new Array[Long](100000 * 2);
		val add: Array[Int] = new Array[Int](1 << 14);
		val min: Array[Int] = new Array[Int](1 << 14);
		val result: IntArrayList = new IntArrayList();
		val MAX12Q = 8 * 14;
		var first: Int = 0;
		var n12q: Int = 0;
		val nQ: Int = queries.length;
		{
			var i: Int = 0;
			while (i < nQ) {
				if (queries(i).typ < 3) {
					n12q += 1;
				}
				if (n12q == MAX12Q || i == nQ - 1) {
					process(parents, queries, first, i + 1, a, codes, add, min, result);
					first = i + 1;
					n12q = 0;
				}
				i += 1;
			}
		}
		return result;
	}

	def main(args: Array[String]): Unit = {
		val in: Scanner = new Scanner(System.in);
		val nV: Int = in.nextInt();
		val nE: Int = in.nextInt();
		val nQ: Int = in.nextInt();
		val parents: Array[IntArrayList] = new Array[IntArrayList](nV);
		{
			var i: Int = 0;
			while (i < nV) {
				parents(i) = new IntArrayList();
				i += 1;
			}
		}
		{
			var i: Int = 0;
			while (i < nE) {
				val parent: Int = in.nextInt() - 1;
				val child: Int = in.nextInt() - 1;
				parents(child).add(parent);
				i += 1;
			}
		}
		val queries: Array[Query] = new Array[Query](nQ);
		{
			var i: Int = 0;
			while (i < nQ) {
				val qType: Int = in.nextInt();
				if (qType == 1 || qType == 2) {
					val parent: Int = in.nextInt() - 1;
					val value: Int = in.nextInt();
					queries(i) = new Query(qType, parent, value);
				} else {
					Assert.check(qType == 3);
					val node: Int = in.nextInt() - 1;
					queries(i) = new Query(qType, node, -1);
				}
				i += 1;
			}
		}
		reorder(parents, queries);
		val result: IntArrayList = solveFast(parents, queries);
		{
			var i: Int = 0;
			while (i < result.size) {
				println(result.get(i));
				i += 1;
			}
		}
	}
}
