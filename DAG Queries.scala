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
