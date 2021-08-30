import scala.collection.mutable._

object Solution {
  val in = {
    val lines = scala.io.Source.stdin.getLines
    lines map (_ split ' ') filter (_.nonEmpty) flatten
  }
  def nextInt() = in.next().toInt
  def nextLong() = in.next().toLong

  var V, Q = 0
  var G = Array[ ArrayBuffer[Int] ]()
      
  
  def distanceFrom(from: Int): Array[Int] = {
    val Q = Queue[Int]()
    val dist = Array.fill(V)(-1)
    dist(from) = 0
    Q.enqueue(from)
    while (Q.nonEmpty) {
      val u = Q.dequeue()
      for (v <- G(u) if (dist(v) < 0))  {
        dist(v) = dist(u) + 1
        Q.enqueue(v)
      }
    }
    dist
  }

  def getFarthest(from: Int): Int = {
    val d = distanceFrom(from)
    d indexOf d.max
  }

  def main(args: Array[String]): Unit = {
    V = nextInt
    Q = nextInt

    G = Array.fill(V)(ArrayBuffer[Int]())

    for (_ <- 1 until V) {

      val u, v = nextInt() - 1

      G(u) += (v)
      G(v) += (u)

    }
    val d1 = getFarthest(0)
    val d2 = getFarthest(d1)
    val dist1 = distanceFrom(d1)
    val dist2 = distanceFrom(d2)

    val diam = dist1(d2).toLong

    for (_ <- 1 to Q) {
      val u = nextInt() - 1
      val k = nextLong() - 1
      println((dist1(u) max dist2(u)) + k * diam)
    }
  }
}