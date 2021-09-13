object Assert {
	def check(e: Boolean) {
		if (!e) {
			throw new AssertionError();
