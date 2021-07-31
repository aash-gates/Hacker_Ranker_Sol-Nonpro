
object Solution
{
	val in = {
		val lines = scala.io.Source.stdin.getLines()
		lines map (_ split ' ') filter (_.nonEmpty) flatten
	}

	def nextInt = in.next.toInt
	
	def main(args: Array[String]): Unit = {

		val T = nextInt
		for (test <- 1 to T)
		{
		
			val N = nextInt
		
			val vals = Array.fill(N)(nextInt)
		
			val sums = vals.scanLeft(0)(_ + _)
		
			val totalSum = sums.last
		
			var ans = -1
			for (i <- 1 until sums.length)
				if (sums(i - 1) == totalSum - sums(i))
					ans = i
					
			println(if (ans < 0) "NO" else "YES")
		}	
	}
}