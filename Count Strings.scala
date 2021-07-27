import collection.mutable.ArrayBuffer
import io.Source
import java.io.PrintWriter
import util.Random

object Solution {

  val modulo = 1000000007

  def mul(a: Array[Array[Int]], b: Array[Array[Int]]) = {
    val n = a.length
    val c = Array.fill(n, n)(0)
    for (i <- 0 until n; j <- 0 until n) {
      var sum = 0
      for (k <- 0 until n) {
        sum = ((sum + a(i)(k).toLong * b(k)(j)) % modulo).toInt
      }
      c(i)(j) = sum
    }
    c
  }

  def pow(a: Array[Array[Int]], p: Int): Array[Array[Int]] = {
    if (p == 1) {
      a
    } else {
      val aa = mul(a, a)
      val r = pow(aa, p / 2)
      if (p % 2 == 0) {
        r
      } else {
        mul(a, r)
      }
    }
  }

  class NDANode {
    var a, b: NDANode = null
    var eps = Set[NDANode]()

    def closure = closure_(Set())

    def closure_(s0: Set[NDANode]): Set[NDANode] = {
      var set = s0 + this
      for (e <- eps if !set.contains(e)) {
        set = e.closure_(set)
      }
      set
    }
  }

  class DFANode {
    var a, b: DFANode = null
    var terminal = false
  }

  trait Node {
    def buildAuto(root: NDANode, terminal: NDANode)

    def isMatch(s: String) = {
      isMatch_(s)
    }

    def isMatch_(s: String): Boolean
  }

  case class Leaf(c: Char) extends Node {
    def buildAuto(root: NDANode, terminal: NDANode) {
      if (c == 'a') {
        root.a = terminal
      } else if (c == 'b') {
        root.b = terminal
      } else {
        throw new AssertionError()
      }
    }

    def isMatch_(s: String) = s == "" + c

    override def toString = s"$c"
  }

  case class Or(u: Node, v: Node) extends Node {
    def buildAuto(root: NDANode, terminal: NDANode) {
      val l, r = new NDANode()
      root.eps ++= Iterator(l, r)
      u.buildAuto(l, terminal)
      v.buildAuto(r, terminal)
    }

    def isMatch_(s: String): Boolean = u.isMatch(s) || v.isMatch(s)

    override def toString = s"($u|$v)"
  }

  case class Concat(u: Node, v: Node) extends Node {
    def buildAuto(root: NDANode, terminal: NDANode) {
      val mid = new NDANode
      u.buildAuto(root, mid)
      v.buildAuto(mid, terminal)
    }

    def isMatch_(s: String): Boolean = {
      (0 to s.length).exists {i =>
        u.isMatch(s.substring(0, i)) && v.isMatch(s.substring(i))
      }
    }

    override def toString = s"($u$v)"
  }

  case class Star(u: Node) extends Node {
    def buildAuto(root: NDANode, terminal: NDANode) {
      val mid = new NDANode
      u.buildAuto(mid, mid)
      root.eps += mid
      mid.eps += terminal
    }

    def isMatch_(s: String): Boolean = {
      s.isEmpty ||
      (1 to s.length).exists {i =>
        u.isMatch(s.substring(0, i)) && isMatch(s.substring(i))
      }
    }

    override def toString = s"($u*)"
  }

  def close(set: Set[NDANode]) = set.map(_.closure).flatten

  def toDFA(root: NDANode, terminal: NDANode) = {
    val sets = collection.mutable.Map[Set[NDANode], DFANode]()
    def populate(set: Set[NDANode]): DFANode = {
      if (!sets.contains(set)) {
        val node = new DFANode
        sets(set) = node
        var seta, setb = Set[NDANode]()
        for (nda <- set) {
          if (nda.a != null) seta += nda.a
          if (nda.b != null) setb += nda.b
        }
        seta = close(seta)
        setb = close(setb)
        node.a = populate(seta)
        node.b = populate(setb)
        node.terminal = set(terminal)
      }
      sets(set)
    }
    populate(close(Set(root)))
  }

  def parse(it: BufferedIterator[Char]): Node = {
    val first = it.next()
    if (first == '(') {
      val u = parse(it)
      if (it.head == '*') {
        it.next()
        assert(it.next() == ')')
        Star(u)
      } else if (it.head == '|') {
        it.next()
        val v = parse(it)
        assert(it.next() == ')')
        Or(u, v)
      } else {
        val v = parse(it)
        assert(it.next() == ')')
        Concat(u, v)
      }
    } else if (first == 'a' || first == 'b') {
      Leaf(first)
    } else {
      throw new AssertionError()
    }
  }

  def solve(in: In, out: PrintWriter) {
    val regexp = parse(in().iterator.buffered)
    val len = in().toInt
    out.println(solve(regexp, len))
  }


  def solve(regexp: Solution.Node, len: Int): Int = {
    val root, terminal = new NDANode
    regexp.buildAuto(root, terminal)
    val dfa = toDFA(root, terminal)
    val num = collection.mutable.Map[DFANode, Int]()
    val term = ArrayBuffer[Boolean]()
    def enum(node: DFANode) {
      if (!num.contains(node)) {
        term.append(node.terminal)
        num(node) = num.size
        if (node.a != null) enum(node.a)
        if (node.b != null) enum(node.b)
      }
    }
    enum(dfa)
    val mat = Array.fill(num.size, num.size)(0)
    for ((node, i) <- num) {
      mat(i)(num(node.a)) += 1
      mat(i)(num(node.b)) += 1
    }
    val d = pow(mat, len)(0)
    var sum = 0
    for (i <- 0 until num.size if term(i)) {
      sum = (sum + d(i)) % modulo
    }
    sum
  }

  def gen(rnd: Random): Node = {
    rnd.nextInt(9) match {
      case 0 => Leaf('a')
      case 1 => Leaf('b')
      case 2 => Leaf('a')
      case 3 => Leaf('b')
      case 4 => Leaf('a')
      case 5 => Leaf('b')
      case 6 => Concat(gen(rnd), gen(rnd))
      case 7 => Or(gen(rnd), gen(rnd))
      case 8 => Star(gen(rnd))
    }
  }

  def main(args: Array[String]) {

    val in: In = new In(Source.fromInputStream(System.in))
    val out: PrintWriter = new PrintWriter(System.out)
    for (test <- 1 to in().toInt) {
      solve(in, out)
      out.flush()
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
