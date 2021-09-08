import io.Source
import java.io.PrintWriter
import scala.collection.mutable

object Solution {

  //->(nc,c0,c1); nc<=c0<=c1
  def dfs(i: Int, p: Int, es: Array[mutable.Stack[Int]]): (Int, Int, Int) = {
    var sumnc, sumc0 = 0
    var rc0, rc1 = 1000000000
    for (j <- es(i) if j != p) {
      val (nc, c0, c1) = dfs(j, i, es)
      val r1c0 = math.min(rc0 + nc, rc1 + c1 - 1)
      val r1c1 = math.min(math.min(sumnc, rc0) + c1, rc1 + nc)
//      System.err.println(j + " " + (nc, c0, c1) + " " + (r1c0, r1c1))
      sumnc += nc
      sumc0 += c0
      rc0 = r1c0
      rc1 = r1c1
    }
    if (rc1 == 0) {
      (0, 1, 1)
    } else {
      (math.min(sumc0, math.min(rc0, rc1)), math.min(sumnc + 1, math.min(rc0, rc1)), math.min(sumnc + 1, rc1))
    }
  }

  def solve(in: In, out: PrintWriter) {
    val n = in().toInt
    val es = Array.fill(n)(mutable.Stack[Int]())
    for (i <- 0 until n - 1) {
      val u, v = in().toInt
      es(u).push(v)
      es(v).push(u)
    }
    out.println {
      dfs(0, -1, es)._1
    }
  }

  def main(args: Array[String]) {
    val in: In = new In(Source.fromInputStream(System.in))
    val out: PrintWriter = new PrintWriter(System.out)
    for (test <- 0 until in().toInt) {
      solve(in, out)
    }
    out.close()
  }

  class TokenIterator(iter: BufferedIterator[Char], delims: String) extends Iterator[String] {
    private val sb = new StringBuilder

    def hasNext: Boolean = {
      skipDelims()
      iter.hasNext
    }

    def skipDelims() {
      while (iter.hasNext && delims.indexOf(iter.head) != -1) {
        iter.next()
      }
    }

    def next(): String = {
      skipDelims()
      while (iter.hasNext && delims.indexOf(iter.head) == -1) {
        sb.append(iter.next())
      }
      val ret = sb.toString()
      sb.clear()
      ret
    }
  }

  class In(source: Source) {
    val iter = source.buffered

    val tokenIterator = new TokenIterator(iter, " \r\n")

    val lineIterator = new TokenIterator(iter, "\r\n")

    def apply() = tokenIterator.next()

    def apply(n: Int) = tokenIterator.take(n)
  }
}