import java.util.Scanner

/**
 * Created by dimitar on 2/11/15.
 */
object Solution {

  def main(args: Array[String]) {
    val sc = new Scanner(System.in)

    (0 until sc.nextInt()).foreach{_ =>
      val n = sc.nextInt()
      val m = sc.nextInt()
      println(solve(n,m))
    }
  }

  def solve1(n: Int, k: Int): Int ={
    val g1 = n%k
    val g2 = k - g1
    val sz1 = n/k + 1
    val sz2 = n/k
    val ret = g1*sz1*g2*sz2 + g1*(g1-1)*sz1*sz1/2 + g2*(g2-1)*sz2*sz2/2
    return ret
  }

  def solve(n: Int, e: Int): Int = {
    var k = 1
    var low = 1
    var high = n + 1
    while(low + 1 < high) {
      val mid = low + (high - low)/2
      k = solve1(n,mid)
      if(k < e) low = mid
      else high = mid
    }
    return high
  }
}