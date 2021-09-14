




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


    /* The closures are reprocessed to make the final calculations
     * as efficient as possible. All closures that are not in the
     * fastest route are ignored, and the ones that are are processed
     * in order of how close they are to the start. This allows for 
     * a reverse-bfs of sorts to be performed from the start. */

    val repath_ord = Ordering[Int].on[(Int,Int,Int)](x => tree(x._1).pre)
    val repath = PriorityQueue[(Int,Int,Int)]()(repath_ord)
    for (i <- 0 until closures.length) {
      val (c1, c2) = closures(i)
      var (cn1, cn2) = (tree(c1), tree(c2))
      results(i) = tree(start).cost
      if (cn1.parent == c2) {
        if ((c1 == start) || tree(start).child_of(cn1)) {
          repath += ((c1, c2, i))
          results(i) = 0
        }
      } else if (cn2.parent == c1) {
        if ((c2 == start) || tree(start).child_of(cn2)) {
          repath += ((c2, c1, i))
          results(i) = 0
        }
      } 
    }

    val best = new Array[Int](cities)
    val opt_ord = Ordering[Int].on[Int](x => -(best(x) + tree(x).cost))
    val options = PriorityQueue[Int]()(opt_ord)

    /* Expands routes around a given city */
    def expand_city (city: Int, 
                     cost: Int, 
                     exclude_parent: Boolean = false) {
      val c_node = tree(city)
      if ((cost < best(city)) || (best(city) == 0)) {
        best(city) = cost
        options += city
      }
      /* neighbor index, neighbor cost */
      for ((n_i, n_c) <- city_ref(city)) {
        if ( ( (n_i != c_node.parent) ||
               (!exclude_parent) )    &&
             ( (best(n_i) == 0)       ||
               (best(n_i) > (cost + n_c)) ) )  {
          best(n_i) = cost + n_c
          options += n_i
        }
      }
    }


    var current = start
    expand_city(current, 0, true)
    var cost_from_start = 0

    while (repath.length > 0) {
      val path = repath.dequeue()
      val (c1, c2, closure_i) = path
      val (cn1, cn2) = ((tree(c1), tree(c2)))
      while (current != c1) {
        if (current == end) System.exit(0)
        expand_city(current, cost_from_start)
        var parent = tree(current).parent
        cost_from_start += tree(current).cost - tree(parent).cost
        current = parent
      }
      expand_city(current, cost_from_start, true)
      var best_alt = 0 // a meaningless initial value
      while (best_alt >= 0) {
        if (options.length == 0) {
          best_alt = -1
        } else {
          best_alt = options.dequeue()

          if (best_alt == current) {
            // do nothing
          } else if (tree(best_alt).child_of(cn2)) {
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
