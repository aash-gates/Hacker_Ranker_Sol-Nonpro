




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


            expand_city(best_alt, best(best_alt))
          } else {
            results(closure_i) = best(best_alt) + tree(best_alt).cost
            options += best_alt
            best_alt = -1
          }
        }
      } 
    }

    return results
  }


  def main(args: Array[String]) {
    val iter = io.Source.stdin.getLines
    var params = iter.next.split(" ")
    val num_cities = params(0).toInt
    val num_edges = params(1).toInt
    val roads = new Array[(Int, Int, Int)](num_edges)
    /* entry of roads & closures enforce that the 
     * start number is less than the second */
    for (i <- 0 until num_edges) {
      val r = iter.next.split(" ").map(x => x.toInt)
      if (r(2) <= 0) {
         throw new IllegalArgumentException("weight must be positive")
      }
      if (r(0) < r(1)) {
        roads(i) = (r(0), r(1), r(2))
      } else {
        roads(i) = (r(1), r(0), r(2))
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
