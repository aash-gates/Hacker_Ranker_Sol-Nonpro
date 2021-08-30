
import java.io.{File, FileInputStream}

import scala.collection.mutable
import scala.collection.mutable.ListBuffer
import scala.io.Source
import scala.util.control.Breaks._

/**
 * Created by daber on 02.05.15.
 */
object Solution {

  class Graph(val edgeList: Array[mutable.HashSet[Int]], val nodes: Int, val edges: Int) {
    val all = (0 until nodes).toSet

    def linked(node: Int): mutable.HashSet[Int] = {
      edgeList(node)
    }


    def distances(from: Int): Array[Int] = {
      val dist = Array.ofDim[Int](nodes)

      val levelList = new ListBuffer[Set[Int]]

      val not_found = new mutable.HashSet[Int]()
      not_found ++= all

      var currentLevelNotConnected = Set(from)
      while (not_found.nonEmpty) {

        not_found --= currentLevelNotConnected
        levelList += currentLevelNotConnected
        currentLevelNotConnected = notConnectedTo(currentLevelNotConnected, not_found)

      }


      var lvl = 0
      for (i <- levelList) {
        for (j <- i) {
          dist(j) = lvl
        }
        lvl += 1
      }

      dist
    }


    def notConnectedTo(nodes: Set[Int], not_found: mutable.HashSet[Int]): Set[Int] = {
      val union_edges = nodes.map(edgeList(_)).reduce((a, b) => a.intersect(b))
      (not_found -- union_edges).toSet
    }


  }


  def readGraph() = {

    val (n, e) = readPair()

    val edges = Array.ofDim[mutable.HashSet[Int]](n)

    for (i <- 0 until n) {
      edges(i) = new mutable.HashSet[Int].empty

    }


    for (i <- 1 to e) {
      var (start, end) = readPair()
      start -= 1
      end -= 1
      edges(start) += end
      edges(end) += start

    }
    val g = new Graph(edges, n, e)
    g

  }


  def main(args: Array[String]) {
    val cases = readInt()

    for (i <- 1 to cases) {
      val g = readGraph()
      val start = readInt() - 1

      println(g.distances(start).toList.filterNot(_ == 0).mkString(" "))

    }


  }


  def data: String = "data/rustandmruder.txt"

  val in = if (new File(data).exists()) {
    Source.fromInputStream(new FileInputStream(data)).bufferedReader()
  }
  else {
    Source.fromInputStream(System.in).bufferedReader()

  }

  def readPair(): (Int, Int) = {
    val Array(a, b) = in.readLine().split(" ").map(_.toInt)
    (a, b)
  }

  def readArray(): Array[Int] = {
    in.readLine().split(" ").map(_.toInt)
  }


  def readInt() = {
    in.readLine().toInt
  }

  def readLine() = {
    in.readLine()
  }

}

