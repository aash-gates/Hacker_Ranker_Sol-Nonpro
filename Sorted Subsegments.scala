import java.util
import scala.collection.mutable

object Solution {

    def main(args: Array[String]) {
        val sc = new java.util.Scanner (System.in);
        val (n, q, k) = (sc.nextInt(), sc.nextInt(), sc.nextInt())
        val items = (0 until n).map(_ => sc.nextInt()).toArray
        val segments = (0 until q).map(_ => (sc.nextInt(), sc.nextInt()))

        def intersects(x: (Int, Int), y: (Int, Int)) = x._2 >= y._1 && x._1 <= y._2
        def union(x: (Int, Int), y: (Int, Int)) = (math.min(x._1, y._1), math.max(x._2, y._2))
        def contains(range: (Int, Int), testRange: (Int, Int)) = {
            testRange._1 >= range._1 && testRange._2 <= range._2
        }

        var unionRange, prevRange = (k, k)
        var filteredSegments = mutable.ArrayBuffer[(Int, Int)]()
        for (s <- segments.reverse) {
            if (intersects(s, unionRange) && !contains(prevRange, s)) {
                unionRange = union(s, unionRange)
                filteredSegments.append(s)
                prevRange = s
            }
        }

        filteredSegments = filteredSegments.reverse
        filteredSegments.foreach(r => util.Arrays.sort(items, r._1, r._2 + 1))
        println(items(k))
    }
}