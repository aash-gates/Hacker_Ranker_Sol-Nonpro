import collection.mutable.BitSet

class Board {
  val board = {
    val res = Array.fill(100)(new BitSet)
    for (i <- 1 to 99; j <- (i - 6).max(0) until i) res(i) += j
    res
  }

  def nextState(s: BitSet): BitSet = {
    val res = new BitSet
    var i = 0
    while (i < 100) {
      if (!(s & board(i)).isEmpty) res += i
      i += 1
    }
    res
  }

  def addTunnel(from: Int, to: Int) {
    board(to) ++= board(from)
    board(from).clear
  }
}

object Solution {
  def main(args: Array[String]): Unit = {
    for (_ <- 0 until readInt()) {
      readLine()
      val tunnels = readLine().split(" ") ++ readLine().split(" ")
      val b = new Board
      for (t <- tunnels) {
        val Array(from, to) = t.split(",").map(_.toInt - 1)
        b.addTunnel(from, to)
      }
      var state = BitSet(0)
      var i = 0
      while (!state.contains(99)) {
        i += 1
        state = b.nextState(state)
      }
      println(i)
    }
  }
}
