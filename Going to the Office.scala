




import collection.mutable._
import util.Sorting._

import scala.compat.Platform.currentTime



object Solution {


  class TreeNode (numc:      Int,
                  parentc:   Int, 
                  costc:     Int) {
    
    val num = numc
    val parent = parentc
    val cost = costc

    var children = List[Int]()

    def add_child(child: Int) {
      children ::= child
    }


    }
    params = iter.next.split(" ")
    val start = params(0).toInt
    val end = params(1).toInt
    val num_closures = iter.next.toInt
    val closures = new Array[(Int, Int)](num_closures)
    for (i <- 0 until num_closures) {
      val c = iter.next.split(" ").map(x => x.toInt)
      if (c(0) < c(1)) {
        closures(i) = (c(0), c(1))
      } else {
        closures(i) = (c(1), c(0))
      }
    }

    for (e <- get_fastest(start, end, num_cities, roads, closures)) {
      if (e > 0) {
        println(e) 
      } else {
        println("Infinity")
      }
    }
  }
}
