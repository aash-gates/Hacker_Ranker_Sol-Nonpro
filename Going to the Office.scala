




import collection.mutable._
import util.Sorting._

import scala.compat.Platform.currentTime



object Solution {


  class TreeNode (numc:      Int,
                  parentc:   Int, 
                  costc:     Int) {
    
    val num = numc
    val parent = parentc
