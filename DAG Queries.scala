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
